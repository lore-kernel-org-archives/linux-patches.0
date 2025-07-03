Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DD122B8AB;
	Thu,  3 Jul 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555719; cv=none; b=Nxp7f3CBJpAQ5jWXr01eVFSkooFiN0cD4ch/BajEyCuKRIuHYVoA77SbTNEel9huk056ockaqNelKwOFVRDpYQEesjpp8FCeueUIyN4tH5c07Q2++GMEuHBps+ewGVTmoEOzyCnHThtkOB7vhJduNPw/UkXzWT59nnGb9nZ79aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555719; c=relaxed/simple;
	bh=st7w9kOOg7CwcLTqDdMlkSt5k81LeLwZDNJaAZrd0es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ/t4kyIGxDZzjdc7FwM2iqDAXB+6jndNeT5jfNnGiOmUhjIA+e/QiQPn/GTaYyUiTkRiIH9WpGEuB6liytbWebNqTWBzQwo0Vpa9G2zVez6J5i5kTtuxfDIpflswwXCnPNMvoyCQrFfCM/aF08omuHcv4W502MWL2tYImBgi30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLmK7RCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLmK7RCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82171C4CEE3;
	Thu,  3 Jul 2025 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555718;
	bh=st7w9kOOg7CwcLTqDdMlkSt5k81LeLwZDNJaAZrd0es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLmK7RCsQOJSecWoKDhhk9L7bOZm/fq2JvNf/f34BBHdwyzz3ipHZfBdJ5id/68FG
	 heVZXS9wASdDJeOddhdD37j8Ma2cXJl3YdKk3wyLEZC2wSXOy3lNoqF86z5eIKUusd
	 xsxkZKZrd8mvg4/jaRf3DmUM8WvXlFVYMbKCG1QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/139] af_unix: Dont call skb_get() for OOB skb.
Date: Thu,  3 Jul 2025 16:42:12 +0200
Message-ID: <20250703143943.862635050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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
 net/unix/garbage.c | 16 ++--------------
 2 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 7546654f8273a..3cfc781214227 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -657,10 +657,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	unix_state_unlock(sk);
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-	if (u->oob_skb) {
-		kfree_skb(u->oob_skb);
-		u->oob_skb = NULL;
-	}
+	u->oob_skb = NULL;
 #endif
 
 	wake_up_interruptible_all(&u->peer_wait);
@@ -2189,13 +2186,9 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
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
@@ -2599,8 +2592,6 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 
 	if (!(state->flags & MSG_PEEK))
 		WRITE_ONCE(u->oob_skb, NULL);
-	else
-		skb_get(oob_skb);
 
 	spin_unlock(&sk->sk_receive_queue.lock);
 	unix_state_unlock(sk);
@@ -2610,8 +2601,6 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	if (!(state->flags & MSG_PEEK))
 		UNIXCB(oob_skb).consumed += 1;
 
-	consume_skb(oob_skb);
-
 	mutex_unlock(&u->iolock);
 
 	if (chunk < 0)
@@ -2639,12 +2628,10 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
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
@@ -2655,10 +2642,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 		spin_unlock(&sk->sk_receive_queue.lock);
 
-		if (unlinked_skb) {
-			WARN_ON_ONCE(skb_unref(unlinked_skb));
-			kfree_skb(unlinked_skb);
-		}
+		kfree_skb(unlinked_skb);
 	}
 	return skb;
 }
@@ -2701,7 +2685,6 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		unix_state_unlock(sk);
 
 		if (drop) {
-			WARN_ON_ONCE(skb_unref(skb));
 			kfree_skb(skb);
 			return -EAGAIN;
 		}
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 06d94ad999e99..0068e758be4dd 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -337,18 +337,6 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 	return true;
 }
 
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
@@ -371,11 +359,11 @@ static void unix_collect_skb(struct list_head *scc, struct sk_buff_head *hitlist
 				struct sk_buff_head *embryo_queue = &skb->sk->sk_receive_queue;
 
 				spin_lock(&embryo_queue->lock);
-				unix_collect_queue(unix_sk(skb->sk), hitlist);
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



