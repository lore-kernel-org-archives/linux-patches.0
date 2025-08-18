Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF73335BA6;
	Mon, 18 Aug 2025 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523646; cv=none; b=RavC4NiRkRYOHX0u13WoawXnsAGfA/4/PC6f5SLZeWThDp4r37L7b2Pp5nd8UsYJ0pnma1LIoYfTjOln95/rcQFBhvMU1mb2+I7XuBN2SMs5PAswHA3421V3dbEOmjI3nGkzriwC+40PywITgVhejMbilcP+scD7jGj1sdGGr3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523646; c=relaxed/simple;
	bh=nYOmTq9t6nruEje1gBnMFcmPjBMMIwiXj5/A2hUmwBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UT+ih9BTObVZ2HUNx0wNhWycSuXn/L/pSjermE1pnYReeWaqgcCWvI29VDrdgiL5bgmf4Aa7NUFljZkI90D35PPAfIG31EUSqapMnjGvai2jYfGME3YE4qXN1a+DAFlt+ilqOzvyeQo0Xjhb1O3/Fo1xuAwc3hkOavbGNaC1Q1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRY5gH5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRY5gH5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA689C4CEF1;
	Mon, 18 Aug 2025 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523646;
	bh=nYOmTq9t6nruEje1gBnMFcmPjBMMIwiXj5/A2hUmwBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRY5gH5ijGwYDS/MK/zSPW/QmH5Fd+LaoLgID1ha/FxfKSe5qF4FKOz9oJaLoSxBA
	 BxAV4ewtwQRsHMUeUYWjZmcGtAdZXgT6HeUQmkQK0UYB7qEUbcUyh1nAI3iUCQJB1w
	 d0ozf2tTP3bwF0uEsHyRoUGKYKNKQlv05eO4nIfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 236/515] um: Re-evaluate thread flags repeatedly
Date: Mon, 18 Aug 2025 14:43:42 +0200
Message-ID: <20250818124507.466876177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9e2f2246eb2b5617d53af7b5e4e1b8c916f26a8 ]

The thread flags may change during their processing.
For example a task_work can queue a new signal to be sent.
This signal should be delivered before returning to usespace again.

Evaluate the flags repeatedly similar to other architectures.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20250704-uml-thread_flags-v1-1-0e293fd8d627@linutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/thread_info.h |  4 ++++
 arch/um/kernel/process.c          | 20 ++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index f9ad06fcc991..eb9b3a6d99e8 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -50,7 +50,11 @@ struct thread_info {
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL | \
+				 _TIF_NOTIFY_RESUME)
+
 #endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 0cd6fad3d908..1be644de9e41 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -82,14 +82,18 @@ struct task_struct *__switch_to(struct task_struct *from, struct task_struct *to
 void interrupt_end(void)
 {
 	struct pt_regs *regs = &current->thread.regs;
-
-	if (need_resched())
-		schedule();
-	if (test_thread_flag(TIF_SIGPENDING) ||
-	    test_thread_flag(TIF_NOTIFY_SIGNAL))
-		do_signal(regs);
-	if (test_thread_flag(TIF_NOTIFY_RESUME))
-		resume_user_mode_work(regs);
+	unsigned long thread_flags;
+
+	thread_flags = read_thread_flags();
+	while (thread_flags & _TIF_WORK_MASK) {
+		if (thread_flags & _TIF_NEED_RESCHED)
+			schedule();
+		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
+			do_signal(regs);
+		if (thread_flags & _TIF_NOTIFY_RESUME)
+			resume_user_mode_work(regs);
+		thread_flags = read_thread_flags();
+	}
 }
 
 int get_current_pid(void)
-- 
2.39.5



