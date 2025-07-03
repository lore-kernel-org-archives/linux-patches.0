Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220FA2EF9DD;
	Thu,  3 Jul 2025 15:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556081; cv=none; b=Av9soT665n8B1FzWiYXvaTkap0CNYMeFIjGo0M9GZT+QlA+B3p6ZT9O/D4PCVLSVswJsY9n+9JOSWech43ub0dNLYrkVOR5Vt8F5kc7mZvcDNvAIHimd8yaR2Hpv+MJrE1ZKjrPj7yESTk4tLr5e6770S6GLCvXWYaI7MFSSAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556081; c=relaxed/simple;
	bh=m+rFs8uRVgMigpoF1LOEUCtCHQgizi1LVIeyOz/pBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP43tcqFSvKCC6W54xYx3Sc8yUvtjUOdhlAIVHTTC+IGDq+LkWr78wpMmqvtoy/C0pNI6RJy/UVxF6JURptrhR+xTd0rioXTObi6qu23FFQjx1ljs/YXtA5a+YrCDMAkM6WRqDtB0kN20/OB0Jc/6yNa6Xby3JSBKiEfwDXq/tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo25iyHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo25iyHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C84C4CEED;
	Thu,  3 Jul 2025 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556081;
	bh=m+rFs8uRVgMigpoF1LOEUCtCHQgizi1LVIeyOz/pBk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo25iyHfvvgzFRRLagwh0MkYgMT3RL73CqcVVjvFkJpmRxdK9MAYFIs8wqUyL5+g0
	 1EerW/spuKfBmcDhOP4wT6DzNas/G1L64fWRiDusilTYKclyM5yMquwE68y9WwW/aM
	 quqde0UcL793a+TgeSN8IYPvz4gQeWykaAANI2oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/132] af_unix: Dont call skb_get() for OOB skb.
Date: Thu,  3 Jul 2025 16:42:38 +0200
Message-ID: <20250703143942.130031306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

[ Upstream commit 8594d9b85c07f05e431bd07e895c2a3ad9b85d6f ]

Since introduced, OOB skb holds an additional reference count with no
special reason and caused many issues.

Also, kfree_skb() and consume_skb() are used to decrement the count,
which is confusing.

Let's drop the unnecessary skb_get() in queue_oob() and corresponding
kfree_skb(), consume_skb(), and skb_unref().

Now unix_sk(sk)->oob_skb is just a pointer to skb in the receive queue,
so special handing is no longer needed in GC.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240816233921.57800-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 32ca245464e1 ("af_unix: Don't leave consecutive consumed OOB skbs.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 27 +++++----------------------
 net/unix/garbage.c | 24 +++---------------------
 2 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 79b783a70c87d..9ef6011a055b1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -604,10 +604,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	unix_state_unlock(sk);
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		kfree_skb(u->oob_skb);
-		u->oob_skb = NULL;
-	}
+	u->oob_skb = NULL;
 #endif
 
 	wake_up_interruptible_all(&u->peer_wait);
@@ -2133,13 +2130,9 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	}
 
 	maybe_add_creds(skb, sock, other);
-	skb_get(skb);
-
 	scm_stat_add(other, skb);
 
 	spin_lock(&other->sk_receive_queue.lock);
-	if (ousk->oob_skb)
-		consume_skb(ousk->oob_skb);
 	WRITE_ONCE(ousk->oob_skb, skb);
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
@@ -2640,8 +2633,6 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 
 	if (!(state->flags & MSG_PEEK))
 		WRITE_ONCE(u->oob_skb, NULL);
-	else
-		skb_get(oob_skb);
 
 	spin_unlock(&sk->sk_receive_queue.lock);
 	unix_state_unlock(sk);
@@ -2651,8 +2642,6 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	if (!(state->flags & MSG_PEEK))
 		UNIXCB(oob_skb).consumed += 1;
 
-	consume_skb(oob_skb);
-
 	mutex_unlock(&u->iolock);
 
 	if (chunk < 0)
@@ -2680,12 +2669,10 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 			if (copied) {
 				skb = NULL;
 			} else if (!(flags & MSG_PEEK)) {
-				if (sock_flag(sk, SOCK_URGINLINE)) {
-					WRITE_ONCE(u->oob_skb, NULL);
-					consume_skb(skb);
-				} else {
+				WRITE_ONCE(u->oob_skb, NULL);
+
+				if (!sock_flag(sk, SOCK_URGINLINE)) {
 					__skb_unlink(skb, &sk->sk_receive_queue);
-					WRITE_ONCE(u->oob_skb, NULL);
 					unlinked_skb = skb;
 					skb = skb_peek(&sk->sk_receive_queue);
 				}
@@ -2696,10 +2683,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 		spin_unlock(&sk->sk_receive_queue.lock);
 
-		if (unlinked_skb) {
-			WARN_ON_ONCE(skb_unref(unlinked_skb));
-			kfree_skb(unlinked_skb);
-		}
+		kfree_skb(unlinked_skb);
 	}
 	return skb;
 }
@@ -2742,7 +2726,6 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		unix_state_unlock(sk);
 
 		if (drop) {
-			WARN_ON_ONCE(skb_unref(skb));
 			kfree_skb(skb);
 			return -EAGAIN;
 		}
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 23efb78fe9ef4..0068e758be4dd 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -337,23 +337,6 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 	return true;
 }
 
-enum unix_recv_queue_lock_class {
-	U_RECVQ_LOCK_NORMAL,
-	U_RECVQ_LOCK_EMBRYO,
-};
-
-static void unix_collect_queue(struct unix_sock *u, struct sk_buff_head *hitlist)
-{
-	skb_queue_splice_init(&u->sk.sk_receive_queue, hitlist);
-
-#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		WARN_ON_ONCE(skb_unref(u->oob_skb));
-		u->oob_skb = NULL;
-	}
-#endif
-}
-
 static void unix_collect_skb(struct list_head *scc, struct sk_buff_head *hitlist)
 {
 	struct unix_vertex *vertex;
@@ -375,13 +358,12 @@ static void unix_collect_skb(struct list_head *scc, struct sk_buff_head *hitlist
 			skb_queue_walk(queue, skb) {
 				struct sk_buff_head *embryo_queue = &skb->sk->sk_receive_queue;
 
-				/* listener -> embryo order, the inversion never happens. */
-				spin_lock_nested(&embryo_queue->lock, U_RECVQ_LOCK_EMBRYO);
-				unix_collect_queue(unix_sk(skb->sk), hitlist);
+				spin_lock(&embryo_queue->lock);
+				skb_queue_splice_init(embryo_queue, hitlist);
 				spin_unlock(&embryo_queue->lock);
 			}
 		} else {
-			unix_collect_queue(u, hitlist);
+			skb_queue_splice_init(queue, hitlist);
 		}
 
 		spin_unlock(&queue->lock);
-- 
2.39.5



