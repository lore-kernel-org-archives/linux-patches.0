Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2358801;
	Tue, 30 Apr 2024 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476024; cv=none; b=c8WlLJT8x2GYwEvzX4ox6im0HGH4HVGShFaMwr67vldr+d8RjP5rLZa+/MVTxe0cdvmtrewnzVeZGo6+W2D02JN/2EOGap6rPFopgfCQjAg1gldVFXXVnjjgzJrgBdFhB4ca2olYqUFb58Vo4zoI9mCwhx0XC/A3/Vj/5XxbbpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476024; c=relaxed/simple;
	bh=web7C9gLN+n9mO/7QxKKWxy6wR3RmwWIcAyewFiXAm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yopc+k5cTweBMTHfTPMP1Hy+zMCDAyF2doEm4J1wuLyzpk0PAwhSR2kN20EFM89TEyeTdp4kkjuhL5V86KTyv7i//j78Mw+p3B0w/dwNoLRdE/6ndKFzuO+G8/pmAlsz7TXyLfkF+kXcKRt2gk3iW25wqqJyWSovwJIV+QrscNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iahUgBqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iahUgBqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0464EC2BBFC;
	Tue, 30 Apr 2024 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476024;
	bh=web7C9gLN+n9mO/7QxKKWxy6wR3RmwWIcAyewFiXAm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iahUgBqf7L0ze79o2Skb+G0wnsj4MkKv5v0DNqEjpBuf9wJG6XYiVvLuCkjv1HVVC
	 zosPP6Kgj1TtC64FAT4/R/T5qsp71/McHQ4RSL3/Xwp2e4NWDjg9moRUmZJqqAXwGL
	 NejsnOovYOZxzPP8KRggeNA8jg90TMnFc0kS/ogA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/107] af_unix: Do not use atomic ops for unix_sk(sk)->inflight.
Date: Tue, 30 Apr 2024 12:39:31 +0200
Message-ID: <20240430103044.994221432@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 97af84a6bba2ab2b9c704c08e67de3b5ea551bb2 ]

When touching unix_sk(sk)->inflight, we are always under
spin_lock(&unix_gc_lock).

Let's convert unix_sk(sk)->inflight to the normal unsigned long.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240123170856.41348-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 47d8ac011fe1 ("af_unix: Fix garbage collector racing against connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_unix.h |  2 +-
 net/unix/af_unix.c    |  4 ++--
 net/unix/garbage.c    | 17 ++++++++---------
 net/unix/scm.c        |  8 +++++---
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 6cb5026cf7272..e7612295b2626 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -52,7 +52,7 @@ struct unix_sock {
 	struct mutex		iolock, bindlock;
 	struct sock		*peer;
 	struct list_head	link;
-	atomic_long_t		inflight;
+	unsigned long		inflight;
 	spinlock_t		lock;
 	unsigned long		gc_flags;
 #define UNIX_GC_CANDIDATE	0
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9b1dd845bca19..53335989a6f0c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -809,11 +809,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 	sk->sk_write_space	= unix_write_space;
 	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
 	sk->sk_destruct		= unix_sock_destructor;
-	u	  = unix_sk(sk);
+	u = unix_sk(sk);
+	u->inflight = 0;
 	u->path.dentry = NULL;
 	u->path.mnt = NULL;
 	spin_lock_init(&u->lock);
-	atomic_long_set(&u->inflight, 0);
 	INIT_LIST_HEAD(&u->link);
 	mutex_init(&u->iolock); /* single task reading lock */
 	mutex_init(&u->bindlock); /* single task binding lock */
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 9121a4d5436d5..675fbe594dbb3 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -166,17 +166,18 @@ static void scan_children(struct sock *x, void (*func)(struct unix_sock *),
 
 static void dec_inflight(struct unix_sock *usk)
 {
-	atomic_long_dec(&usk->inflight);
+	usk->inflight--;
 }
 
 static void inc_inflight(struct unix_sock *usk)
 {
-	atomic_long_inc(&usk->inflight);
+	usk->inflight++;
 }
 
 static void inc_inflight_move_tail(struct unix_sock *u)
 {
-	atomic_long_inc(&u->inflight);
+	u->inflight++;
+
 	/* If this still might be part of a cycle, move it to the end
 	 * of the list, so that it's checked even if it was already
 	 * passed over
@@ -237,14 +238,12 @@ void unix_gc(void)
 	 */
 	list_for_each_entry_safe(u, next, &gc_inflight_list, link) {
 		long total_refs;
-		long inflight_refs;
 
 		total_refs = file_count(u->sk.sk_socket->file);
-		inflight_refs = atomic_long_read(&u->inflight);
 
-		BUG_ON(inflight_refs < 1);
-		BUG_ON(total_refs < inflight_refs);
-		if (total_refs == inflight_refs) {
+		BUG_ON(!u->inflight);
+		BUG_ON(total_refs < u->inflight);
+		if (total_refs == u->inflight) {
 			list_move_tail(&u->link, &gc_candidates);
 			__set_bit(UNIX_GC_CANDIDATE, &u->gc_flags);
 			__set_bit(UNIX_GC_MAYBE_CYCLE, &u->gc_flags);
@@ -271,7 +270,7 @@ void unix_gc(void)
 		/* Move cursor to after the current position. */
 		list_move(&cursor, &u->link);
 
-		if (atomic_long_read(&u->inflight) > 0) {
+		if (u->inflight) {
 			list_move_tail(&u->link, &not_cycle_list);
 			__clear_bit(UNIX_GC_MAYBE_CYCLE, &u->gc_flags);
 			scan_children(&u->sk, inc_inflight_move_tail, NULL);
diff --git a/net/unix/scm.c b/net/unix/scm.c
index 51b623de3be5f..785e8c4669e23 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -51,12 +51,13 @@ void unix_inflight(struct user_struct *user, struct file *fp)
 	if (s) {
 		struct unix_sock *u = unix_sk(s);
 
-		if (atomic_long_inc_return(&u->inflight) == 1) {
+		if (!u->inflight) {
 			BUG_ON(!list_empty(&u->link));
 			list_add_tail(&u->link, &gc_inflight_list);
 		} else {
 			BUG_ON(list_empty(&u->link));
 		}
+		u->inflight++;
 		/* Paired with READ_ONCE() in wait_for_unix_gc() */
 		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
@@ -73,10 +74,11 @@ void unix_notinflight(struct user_struct *user, struct file *fp)
 	if (s) {
 		struct unix_sock *u = unix_sk(s);
 
-		BUG_ON(!atomic_long_read(&u->inflight));
+		BUG_ON(!u->inflight);
 		BUG_ON(list_empty(&u->link));
 
-		if (atomic_long_dec_and_test(&u->inflight))
+		u->inflight--;
+		if (!u->inflight)
 			list_del_init(&u->link);
 		/* Paired with READ_ONCE() in wait_for_unix_gc() */
 		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
-- 
2.43.0



