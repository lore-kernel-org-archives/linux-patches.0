Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A57042188E;
	Wed,  4 Feb 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218581; cv=none; b=SMryazuns/UZbAkRFRrhIjwRq0MhrYL8QWOTUYcVsq4JhL+FVY40eVRdSfAzbCaPCHD5F3GWWwSF7oO8ccmRKNpC7rz4euyjJYzwTXdLFmAeEpiWU5e90D2LZU8vEB3iljfLHDbBHdN6v92Ytu5WIDf7Au2Q3ULUt8qcwlT+hOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218581; c=relaxed/simple;
	bh=3ztzBiwU5wUE3pbaXmAb77q+03JxqlA4l2ZKbuXMrcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfUpr0On4pskLxyaGV0W9tT3+XrD1S6oNZ7PhSlo8SvLiJ2J5UzA/0fbmEqzG6mtKjBSDQFBQZr1S0soCws63QakR56aY4z6U/MVosWyOFgq0M7cWLkEnEnX64gSzgu8EGTcyZdjm45U2lH9WHXwXU05vgtbzKzSJXBmOySgsuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5NtcPCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5NtcPCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7E9C4CEF7;
	Wed,  4 Feb 2026 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218580;
	bh=3ztzBiwU5wUE3pbaXmAb77q+03JxqlA4l2ZKbuXMrcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5NtcPCRM2LQayb9Ms6vst/UKEWFMrScpbR4u/vZVeJlLjUvuIE/mttfxYgGbpSO6
	 WbnO8c2RL40/01hh65BQoNkhmTp5GNuRQUP9iKc5ikdH80gMtKy3Z2LbKWQUkxy35X
	 7H+awN75WBjYpkg88q1fxFgXxIIttqVD6yTjf8Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.6 71/72] Revert "net: Remove conditional threaded-NAPI wakeup based on task state."
Date: Wed,  4 Feb 2026 15:41:14 +0100
Message-ID: <20260204143848.216983148@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 03765d5c18084eab40351fda09bc6fc1a343cd07 which is
commit 56364c910691f6d10ba88c964c9041b9ab777bd6 upstream.

It is only for issues around PREEMPT_RT, which is not in the 6.6.y tree,
so revert this for now.

Link: https://lore.kernel.org/r/20260120103833.4kssDD1Y@linutronix.de
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4539,7 +4539,13 @@ static inline void ____napi_schedule(str
 		 */
 		thread = READ_ONCE(napi->thread);
 		if (thread) {
-			set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
+			/* Avoid doing set_bit() if the thread is in
+			 * INTERRUPTIBLE state, cause napi_thread_wait()
+			 * makes sure to proceed with napi polling
+			 * if the thread is explicitly woken from here.
+			 */
+			if (READ_ONCE(thread->__state) != TASK_INTERRUPTIBLE)
+				set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;
 		}
@@ -6695,6 +6701,8 @@ static int napi_poll(struct napi_struct
 
 static int napi_thread_wait(struct napi_struct *napi)
 {
+	bool woken = false;
+
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
@@ -6703,13 +6711,15 @@ static int napi_thread_wait(struct napi_
 		 * Testing SCHED bit is not enough because SCHED bit might be
 		 * set by some other busy poll thread or by napi_disable().
 		 */
-		if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state)) {
+		if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
 			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
 
 		schedule();
+		/* woken being true indicates this thread owns this napi. */
+		woken = true;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);


