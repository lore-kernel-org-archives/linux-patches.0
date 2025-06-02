Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F102224B1E;
	Mon,  2 Jun 2025 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877453; cv=none; b=HTZrQ9cFTteZDWkCR7VXszAcppvh1xxfY1gQlfzO4F/u273pYUdnKgbtBD0kx5kFGaTJor7CetWXT93DOFyB8iew6myLG/vBqehK9M0xZs4eGFdXIaDLlxtjphjQJmZdvz7+01LJLU3zzho/YZvtp3LiIl6u1+D8+CISMLzgP6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877453; c=relaxed/simple;
	bh=GPK0d7v8d53yJqBmorrsOs+GEM209cfDdcOud9lcwRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzHp0CVjMQQ7v25jUZCl6E8QzkqJLOBUxFr+AVK44OnBC6mof5wgoOEYyqxlE3ko+tVXeeF1skU4u5eY9D4i+H5iJSXmfraxvMsIoa/P1+dkGibMssxBOxAqNvH56/WdmRh1hltSnkwMKKr0FvRIOGLq+wQNxtGpp/QXx4rtDGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNhqjMqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNhqjMqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C27C4CEEB;
	Mon,  2 Jun 2025 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877453;
	bh=GPK0d7v8d53yJqBmorrsOs+GEM209cfDdcOud9lcwRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNhqjMqdzb52HqkXCndT56feK4N/1sR+D62ygpxWsllyapTY0uy2a/1bInbcXNJKw
	 Gdx7Vf6j7K8W6iZ/Mo2ZgiaUPA+iaoR/NfFM0XjdT8h+8fqur1F2CarP8cIQ9haTaK
	 WcPTmCb4o9LSkU8xTr01DGOY6tp6uAMYNQbGxlSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 283/325] af_unix: Run GC on only one CPU.
Date: Mon,  2 Jun 2025 15:49:19 +0200
Message-ID: <20250602134331.259458324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 8b90a9f819dc2a06baae4ec1a64d875e53b824ec upstream.

If more than 16000 inflight AF_UNIX sockets exist and the garbage
collector is not running, unix_(dgram|stream)_sendmsg() call unix_gc().
Also, they wait for unix_gc() to complete.

In unix_gc(), all inflight AF_UNIX sockets are traversed at least once,
and more if they are the GC candidate.  Thus, sendmsg() significantly
slows down with too many inflight AF_UNIX sockets.

There is a small window to invoke multiple unix_gc() instances, which
will then be blocked by the same spinlock except for one.

Let's convert unix_gc() to use struct work so that it will not consume
CPUs unnecessarily.

Note WRITE_ONCE(gc_in_progress, true) is moved before running GC.
If we leave the WRITE_ONCE() as is and use the following test to
call flush_work(), a process might not call it.

    CPU 0                                     CPU 1
    ---                                       ---
                                              start work and call __unix_gc()
    if (work_pending(&unix_gc_work) ||        <-- false
        READ_ONCE(gc_in_progress))            <-- false
            flush_work();                     <-- missed!
	                                      WRITE_ONCE(gc_in_progress, true)

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240123170856.41348-5-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |   54 ++++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -86,7 +86,6 @@
 /* Internal data structures and random procedures: */
 
 static LIST_HEAD(gc_candidates);
-static DECLARE_WAIT_QUEUE_HEAD(unix_gc_wait);
 
 static void scan_inflight(struct sock *x, void (*func)(struct unix_sock *),
 			  struct sk_buff_head *hitlist)
@@ -182,23 +181,8 @@ static void inc_inflight_move_tail(struc
 }
 
 static bool gc_in_progress;
-#define UNIX_INFLIGHT_TRIGGER_GC 16000
-
-void wait_for_unix_gc(void)
-{
-	/* If number of inflight sockets is insane,
-	 * force a garbage collect right now.
-	 * Paired with the WRITE_ONCE() in unix_inflight(),
-	 * unix_notinflight() and gc_in_progress().
-	 */
-	if (READ_ONCE(unix_tot_inflight) > UNIX_INFLIGHT_TRIGGER_GC &&
-	    !READ_ONCE(gc_in_progress))
-		unix_gc();
-	wait_event(unix_gc_wait, !READ_ONCE(gc_in_progress));
-}
 
-/* The external entry point: unix_gc() */
-void unix_gc(void)
+static void __unix_gc(struct work_struct *work)
 {
 	struct sk_buff *next_skb, *skb;
 	struct unix_sock *u;
@@ -209,13 +193,6 @@ void unix_gc(void)
 
 	spin_lock(&unix_gc_lock);
 
-	/* Avoid a recursive GC. */
-	if (gc_in_progress)
-		goto out;
-
-	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
-	WRITE_ONCE(gc_in_progress, true);
-
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones
 	 * which don't have any external reference.
@@ -346,8 +323,31 @@ void unix_gc(void)
 	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
 	WRITE_ONCE(gc_in_progress, false);
 
-	wake_up(&unix_gc_wait);
-
- out:
 	spin_unlock(&unix_gc_lock);
 }
+
+static DECLARE_WORK(unix_gc_work, __unix_gc);
+
+void unix_gc(void)
+{
+	WRITE_ONCE(gc_in_progress, true);
+	queue_work(system_unbound_wq, &unix_gc_work);
+}
+
+#define UNIX_INFLIGHT_TRIGGER_GC 16000
+
+void wait_for_unix_gc(void)
+{
+	/* If number of inflight sockets is insane,
+	 * force a garbage collect right now.
+	 *
+	 * Paired with the WRITE_ONCE() in unix_inflight(),
+	 * unix_notinflight(), and __unix_gc().
+	 */
+	if (READ_ONCE(unix_tot_inflight) > UNIX_INFLIGHT_TRIGGER_GC &&
+	    !READ_ONCE(gc_in_progress))
+		unix_gc();
+
+	if (READ_ONCE(gc_in_progress))
+		flush_work(&unix_gc_work);
+}


