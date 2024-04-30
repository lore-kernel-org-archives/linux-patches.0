Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D987464;
	Tue, 30 Apr 2024 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474723; cv=none; b=tmtMjTcaLJq9YPDIuQYJMQnCNlXld7BuP0UYyJfzEjCSxzQ86OY8b2bl0HLnXHIxZ8VqiRzZSQ1yy5l8uHKD9PqzcVnHEmFeGLp4p5x09hK7brB6hdvZev/0gYYngcctuUsdSo+euKBy2uANK2p3WC42MW8mWCkWmSHjQYZ259Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474723; c=relaxed/simple;
	bh=M5PqpFbdqhUY/5HjBpTnyKi/0ZsMaA0CjoZwcZx4s9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6WaUXZT9eDqPVkq+1kvRXmmogx352QSTPlizCqL0ouYqDOYOoJXFT4Hg0CBb5SR2W2FAL4t1fO0IzOSapQUAi+V81SFkP5pOIUM5H5+/7FS9F6cEnEVnU7EFF7o5yu3g3dW0LafMuGw9xJ58CYHuDTH8pmMyadv0IEqEqdmj0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO5C8rFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO5C8rFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD2C2BBFC;
	Tue, 30 Apr 2024 10:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474722;
	bh=M5PqpFbdqhUY/5HjBpTnyKi/0ZsMaA0CjoZwcZx4s9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gO5C8rFFU9NJHz7RtgqdufBda7n6A4LvyTIy6zHAx0gQU2tpR74HZRWsgTJzWlawg
	 aRqz4Kk+OT+cdvGOSHV8/5kNDODhxWo+7/JMQyN1sdDubD6ZmuNUffv37GebnLewFX
	 wSnUbb2sfdSKhbRjn4pSex7StpjTG+TQRLtK1uaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/138] af_unix: Do not use atomic ops for unix_sk(sk)->inflight.
Date: Tue, 30 Apr 2024 12:38:21 +0200
Message-ID: <20240430103049.904634713@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a6b6ce8b918b7..67eeca1013ade 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -56,7 +56,7 @@ struct unix_sock {
 	struct mutex		iolock, bindlock;
 	struct sock		*peer;
 	struct list_head	link;
-	atomic_long_t		inflight;
+	unsigned long		inflight;
 	spinlock_t		lock;
 	unsigned long		gc_flags;
 #define UNIX_GC_CANDIDATE	0
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b003d0597f4bd..224b1fdc82279 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -817,11 +817,11 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
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
index d1048b4c2baaf..4eff7da9f6f96 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -52,12 +52,13 @@ void unix_inflight(struct user_struct *user, struct file *fp)
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
@@ -74,10 +75,11 @@ void unix_notinflight(struct user_struct *user, struct file *fp)
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



