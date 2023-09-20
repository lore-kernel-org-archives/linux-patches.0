Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894B18658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEB5C433CA;
	Wed, 20 Sep 2023 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210652;
	bh=fynoGi+yC/8/EvXwM4C73jpsbYDbZslyGIcSbDJHpO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Asm/bIm2XOOO6bQ9qA5HVmsDU1+zYyMKNzwdI4KvMf1u7gxhfIAxBOKHOKTTfTTZd
	 iCIFXfZe0o6yOC2P61FVUZZzE8VjwewIU6QtPYLyipy9yN1p6863nn2EXtpR2nU+NP
	 xfpaD8cPuv4KnTyGmqG3AQYYa8JjdZ2CPCwxHhxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 128/211] printk: Reduce console_unblank() usage in unsafe scenarios
Date: Wed, 20 Sep 2023 13:29:32 +0200
Message-ID: <20230920112849.781543688@linuxfoundation.org>
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

[ Upstream commit 7b23a66db55ed0a55b020e913f0d6f6d52a1ad2c ]

A semaphore is not NMI-safe, even when using down_trylock(). Both
down_trylock() and up() are using internal spinlocks and up()
might even call wake_up_process().

In the panic() code path it gets even worse because the internal
spinlocks of the semaphore may have been taken by a CPU that has
been stopped.

To reduce the risk of deadlocks caused by the console semaphore in
the panic path, make the following changes:

- First check if any consoles have implemented the unblank()
  callback. If not, then there is no reason to take the console
  semaphore anyway. (This check is also useful for the non-panic
  path since the locking/unlocking of the console lock can be
  quite expensive due to console printing.)

- If the panic path is in NMI context, bail out without attempting
  to take the console semaphore or calling any unblank() callbacks.
  Bailing out is acceptable because console_unblank() would already
  bail out if the console semaphore is contended. The alternative of
  ignoring the console semaphore and calling the unblank() callbacks
  anyway is a bad idea because these callbacks are also not NMI-safe.

If consoles with unblank() callbacks exist and console_unblank() is
called from a non-NMI panic context, it will still attempt a
down_trylock(). This could still result in a deadlock if one of the
stopped CPUs is holding the semaphore internal spinlock. But this
is a risk that the kernel has been (and continues to be) willing
to take.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230717194607.145135-3-john.ogness@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 357a4d18f6387..7d3f30eb35862 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3045,9 +3045,27 @@ EXPORT_SYMBOL(console_conditional_schedule);
 
 void console_unblank(void)
 {
+	bool found_unblank = false;
 	struct console *c;
 	int cookie;
 
+	/*
+	 * First check if there are any consoles implementing the unblank()
+	 * callback. If not, there is no reason to continue and take the
+	 * console lock, which in particular can be dangerous if
+	 * @oops_in_progress is set.
+	 */
+	cookie = console_srcu_read_lock();
+	for_each_console_srcu(c) {
+		if ((console_srcu_read_flags(c) & CON_ENABLED) && c->unblank) {
+			found_unblank = true;
+			break;
+		}
+	}
+	console_srcu_read_unlock(cookie);
+	if (!found_unblank)
+		return;
+
 	/*
 	 * Stop console printing because the unblank() callback may
 	 * assume the console is not within its write() callback.
@@ -3056,6 +3074,16 @@ void console_unblank(void)
 	 * In that case, attempt a trylock as best-effort.
 	 */
 	if (oops_in_progress) {
+		/* Semaphores are not NMI-safe. */
+		if (in_nmi())
+			return;
+
+		/*
+		 * Attempting to trylock the console lock can deadlock
+		 * if another CPU was stopped while modifying the
+		 * semaphore. "Hope and pray" that this is not the
+		 * current situation.
+		 */
 		if (down_trylock_console_sem() != 0)
 			return;
 	} else
-- 
2.40.1



