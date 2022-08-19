Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD246BC
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7164DC433B5
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933040;
	bh=VAc5rUMDXidZCwrFpceyOsq21QUhnvYsht2nzziH0uc=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=QLf9+rECjgV2Rd4SzQHrnbKoWjodkqpPHGKKaBpn5fPWGdjrWJd0UuW+z2R7CRxct
	 8uVBqGSHx3Hf/16hnNl+ntOgPdPnbGaI/e0DgW1Ap3VTa9+fJ9Z9p7cZNxBViTjC7V
	 MP4wUG9DsDIyjlfD3wxFhKQCdu0dI1TuzGOpm1bT8r3dWXvdtYDZ5MQdJ7AdEvVZfA
	 wFuZa1Caapldr7DF5HkgJIwwaWalVHCwXgj4nLsrC81xCMW1/iydNs59Ac5qwOjAXY
	 xF0Ktzcx8ugO/PapLO8fK+RjnGV7pulBU0XWl6JW8+iVPjReVHqFfHFfLhHVjhBQ4F
	 J6E3iwlF6SZvA==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:17 -0400
Subject: [PATCH v1 3/9] dentry: Use preempt_[dis|en]able_nested()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-3-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1547;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=UyAcewBo21ZQvhH2z6Hpp/c5SsfZuHTV6n0NFXm7KKk=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X1575lbX+eut6XGNvo/CLELjrCI4BEMdGDh/dcSHaQTG
 f/rZUcrCIMbFICumyFK2L3ZTUOFDD7n0HlOYOaxMIEMYuDgFYCIPbRj+J+n0/7gzS5lz9eeb/rLxmw
 WiPOrOvfrkIr5W7FF2W76wMCPDrZ7/avFz5e9c0roprvjwxrk/O+bYzLmav3VSwHGmUyZmzAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

Replace the open coded CONFIG_PREEMPT_RT conditional
preempt_disable/enable() with the new helper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/fs/dcache.c b/fs/dcache.c
index c5dc32a59c76..e633b20623d0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2571,15 +2571,7 @@ EXPORT_SYMBOL(d_rehash);
 
 static inline unsigned start_dir_add(struct inode *dir)
 {
-	/*
-	 * The caller holds a spinlock (dentry::d_lock). On !PREEMPT_RT
-	 * kernels spin_lock() implicitly disables preemption, but not on
-	 * PREEMPT_RT.  So for RT it has to be done explicitly to protect
-	 * the sequence count write side critical section against a reader
-	 * or another writer preempting, which would result in a live lock.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 	for (;;) {
 		unsigned n = dir->i_dir_seq;
 		if (!(n & 1) && cmpxchg(&dir->i_dir_seq, n, n + 1) == n)
@@ -2592,8 +2584,7 @@ static inline void end_dir_add(struct inode *dir, unsigned int n,
 			       wait_queue_head_t *d_wait)
 {
 	smp_store_release(&dir->i_dir_seq, n + 2);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 	wake_up_all(d_wait);
 }
 

-- 
b4 0.10.0-dev-c53d8

