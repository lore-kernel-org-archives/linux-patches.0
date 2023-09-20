Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC15208BB
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A101C433C7;
	Wed, 20 Sep 2023 11:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210657;
	bh=gOxpGLnG32PWxUlCxpi2LUFMKCB/Hwr/eFA2xLhC5Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xScsexcayIx+y9mI5xmKoenTB3QxHQ3PxEJCKnwtJlVmU1sH3Tk2FFn7igQYC1gQ9
	 948+bwHNatFJKbBiB0pXw48Gk6ugnTZMkplHzh1r+bohaLdH8IjM0CdQIGKTIGSC7p
	 fwfpFkZSj0J5gOBruXuCCy7NP25OYOiJu9QMZFeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 130/211] printk: Do not take console lock for console_flush_on_panic()
Date: Wed, 20 Sep 2023 13:29:34 +0200
Message-ID: <20230920112849.844643021@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit eacb04ff3c5b8662a65f380ae450250698448cff ]

Currently console_flush_on_panic() will attempt to acquire the
console lock when flushing the buffer on panic. If it fails to
acquire the lock, it continues anyway because this is the last
chance to get any pending records printed.

The reason why the console lock was attempted at all was to
prevent any other CPUs from acquiring the console lock for
printing while the panic CPU was printing. But as of the
previous commit, non-panic CPUs will no longer attempt to
acquire the console lock in a panic situation. Therefore it is
no longer strictly necessary for a panic CPU to acquire the
console lock.

Avoiding taking the console lock when flushing in panic has
the additional benefit of avoiding possible deadlocks due to
semaphore usage in NMI context (semaphores are not NMI-safe)
and avoiding possible deadlocks if another CPU accesses the
semaphore and is stopped while holding one of the semaphore's
internal spinlocks.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230717194607.145135-5-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 591c11888200d..88770561c4350 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3120,14 +3120,24 @@ void console_unblank(void)
  */
 void console_flush_on_panic(enum con_flush_mode mode)
 {
+	bool handover;
+	u64 next_seq;
+
 	/*
-	 * If someone else is holding the console lock, trylock will fail
-	 * and may_schedule may be set.  Ignore and proceed to unlock so
-	 * that messages are flushed out.  As this can be called from any
-	 * context and we don't want to get preempted while flushing,
-	 * ensure may_schedule is cleared.
+	 * Ignore the console lock and flush out the messages. Attempting a
+	 * trylock would not be useful because:
+	 *
+	 *   - if it is contended, it must be ignored anyway
+	 *   - console_lock() and console_trylock() block and fail
+	 *     respectively in panic for non-panic CPUs
+	 *   - semaphores are not NMI-safe
+	 */
+
+	/*
+	 * If another context is holding the console lock,
+	 * @console_may_schedule might be set. Clear it so that
+	 * this context does not call cond_resched() while flushing.
 	 */
-	console_trylock();
 	console_may_schedule = 0;
 
 	if (mode == CONSOLE_REPLAY_ALL) {
@@ -3140,15 +3150,15 @@ void console_flush_on_panic(enum con_flush_mode mode)
 		cookie = console_srcu_read_lock();
 		for_each_console_srcu(c) {
 			/*
-			 * If the above console_trylock() failed, this is an
-			 * unsynchronized assignment. But in that case, the
+			 * This is an unsynchronized assignment, but the
 			 * kernel is in "hope and pray" mode anyway.
 			 */
 			c->seq = seq;
 		}
 		console_srcu_read_unlock(cookie);
 	}
-	console_unlock();
+
+	console_flush_all(false, &next_seq, &handover);
 }
 
 /*
-- 
2.40.1



