Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E86221DB3;
	Mon,  2 Jun 2025 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874217; cv=none; b=q77Ndey7wGY5uF/Yh/q8xeGUzWZRbTBS8wm7quXQe6OGTqNm/33dD/hlYlyviVoQdnPDrq8dn7JTgMjRq3e5kvc1Ml4GYDJnmbjpwQXovosQn2JAz2RtOr7Mn+Kqwe8oTgpgyVJ20aHT09EJm1sO1CciJIME5ZWNRG2911jWQHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874217; c=relaxed/simple;
	bh=rx+tEqhynd0RH7acv9zZZ3nTyUf18t23jjX5fNgEhM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOPKKq3HHlbrXhKGgVYdFcKb7ZBHWWQCs/jz+pmJAxkc2a1KLYVL3EzzfABTQJsDdbeM717CqC/c2FFUPDUQzWC0sxT31HTEvXRJlAPQxHdbplg6jExFR6Od7reZ8B9aa6+QWM79eZO1xY5KTNeFvcM4zTXZ/optoEtILUSc+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiJ74v4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiJ74v4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8551C4CEF3;
	Mon,  2 Jun 2025 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874217;
	bh=rx+tEqhynd0RH7acv9zZZ3nTyUf18t23jjX5fNgEhM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiJ74v4mbr2OPsBFQcUtckvMmPkeyE0C4W7V5q8G09pdnC10tElPgdrctuNSaKUZe
	 99fs0GydWdpCe5BP/CjQVchd9ckxQbLv4c5yzKDUJT7TLUyNDbVjWyQimEelrgboVs
	 rkMgNQWo0iefvT286tDmRzMfgIY8xMRZRE2PopQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 396/444] af_unix: Run GC on only one CPU.
Date: Mon,  2 Jun 2025 15:47:40 +0200
Message-ID: <20250602134356.981064506@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


