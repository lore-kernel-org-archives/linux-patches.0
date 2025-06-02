Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F31225768;
	Mon,  2 Jun 2025 14:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874229; cv=none; b=vGNXrQZ0IImy9HyuSmncAI+M3gkV10emTe24a60C+BX/qXeoRqGWv+ZARSnRJKyvNCYMIfMGqlb3wpXD60/CBIto9n31MIiLRmupUAXNirhLz8d0lpQC789FsN5SvH6sk5jqHWJnA1ZJkWDE5e+6//alF89OLhMN7xAw+wc5nyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874229; c=relaxed/simple;
	bh=ZxSqaOGs15IzFn9hI/R+GsH8/p/Ug9DfswV3/vTvqt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGc9uZxDMJft3cZdOXblY3VK9mTsyRkqJ38c+ubmZWFGswYqCDYrwwPF56H8A5IQ9139+sNDKZU5WtOOe6YZ598pKYiJDAG8jk0y4bcKs3eOpOg7ZteYeWLx4VCUTrZTvpPm+b40m47gDxtO554o9YJ/SBsFfQU6vQ+tKsBzJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNtGwrma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNtGwrma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2391BC4CEEB;
	Mon,  2 Jun 2025 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874229;
	bh=ZxSqaOGs15IzFn9hI/R+GsH8/p/Ug9DfswV3/vTvqt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNtGwrmaGafTGfiFMyyMgGzmTQLwwz0q8nLcnd4WJB6KLfnTe3SapcwGiw9Jeideq
	 oW5WolfcSK/iAn+OjFLmDGmDsRhv+wT8HI6AOk6ZGojnP9ZT6nKrLJHlnMG4PK/7QL
	 hRBmwi/GbEWuq7BWFH/NmHF5rAsKfRhRxh9XWeUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 399/444] af_unix: Remove io_uring code for GC.
Date: Mon,  2 Jun 2025 15:47:43 +0200
Message-ID: <20250602134357.102793740@linuxfoundation.org>
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

commit 11498715f266a3fb4caabba9dd575636cbcaa8f1 upstream.

Since commit 705318a99a13 ("io_uring/af_unix: disable sending
io_uring over sockets"), io_uring's unix socket cannot be passed
via SCM_RIGHTS, so it does not contribute to cyclic reference and
no longer be candidate for garbage collection.

Also, commit 6e5e6d274956 ("io_uring: drop any code related to
SCM_RIGHTS") cleaned up SCM_RIGHTS code in io_uring.

Let's do it in AF_UNIX as well by reverting commit 0091bfc81741
("io_uring/af_unix: defer registered files gc to io_uring release")
and commit 10369080454d ("net: reclaim skb->scm_io_uring bit").

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20240129190435.57228-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_unix.h |    1 -
 net/unix/garbage.c    |   25 ++-----------------------
 net/unix/scm.c        |    6 ------
 3 files changed, 2 insertions(+), 30 deletions(-)

--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -20,7 +20,6 @@ static inline struct unix_sock *unix_get
 void unix_inflight(struct user_struct *user, struct file *fp);
 void unix_notinflight(struct user_struct *user, struct file *fp);
 void unix_destruct_scm(struct sk_buff *skb);
-void io_uring_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(struct scm_fp_list *fpl);
 struct sock *unix_peer_get(struct sock *sk);
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -184,12 +184,10 @@ static bool gc_in_progress;
 
 static void __unix_gc(struct work_struct *work)
 {
-	struct sk_buff *next_skb, *skb;
-	struct unix_sock *u;
-	struct unix_sock *next;
 	struct sk_buff_head hitlist;
-	struct list_head cursor;
+	struct unix_sock *u, *next;
 	LIST_HEAD(not_cycle_list);
+	struct list_head cursor;
 
 	spin_lock(&unix_gc_lock);
 
@@ -293,30 +291,11 @@ static void __unix_gc(struct work_struct
 
 	spin_unlock(&unix_gc_lock);
 
-	/* We need io_uring to clean its registered files, ignore all io_uring
-	 * originated skbs. It's fine as io_uring doesn't keep references to
-	 * other io_uring instances and so killing all other files in the cycle
-	 * will put all io_uring references forcing it to go through normal
-	 * release.path eventually putting registered files.
-	 */
-	skb_queue_walk_safe(&hitlist, skb, next_skb) {
-		if (skb->destructor == io_uring_destruct_scm) {
-			__skb_unlink(skb, &hitlist);
-			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
-		}
-	}
-
 	/* Here we are. Hitlist is filled. Die. */
 	__skb_queue_purge(&hitlist);
 
 	spin_lock(&unix_gc_lock);
 
-	/* There could be io_uring registered files, just push them back to
-	 * the inflight list
-	 */
-	list_for_each_entry_safe(u, next, &gc_candidates, link)
-		list_move_tail(&u->link, &gc_inflight_list);
-
 	/* All candidates should have been detached by now. */
 	WARN_ON_ONCE(!list_empty(&gc_candidates));
 
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -148,9 +148,3 @@ void unix_destruct_scm(struct sk_buff *s
 	sock_wfree(skb);
 }
 EXPORT_SYMBOL(unix_destruct_scm);
-
-void io_uring_destruct_scm(struct sk_buff *skb)
-{
-	unix_destruct_scm(skb);
-}
-EXPORT_SYMBOL(io_uring_destruct_scm);


