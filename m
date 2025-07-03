Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254FF228CA3;
	Thu,  3 Jul 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555715; cv=none; b=sH4KJWQObaKMz/Q/dZA0DTf7JUHu2z7Snbn1rManurMreWDBhFFsK5xwDVNIsIOBx52porrk8y6CbDsJ5bQhXQf2+l/tn2ioJgCXMtrlsprjcGZVxlyJyHXCnPY0brovF8zrGAZeBlzNpnQTTOGfa8hvEgjKzAINAfwxEtZn+Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555715; c=relaxed/simple;
	bh=o18t9vGCABLkp6EG9AQMEnTgjOwJdMfzGphJx4fnt9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN8HmcdHEk/39vd76H3jHCagLUZLC2Jk2/lD4FC04TBDF1F6h5ccIFdXniJNP5eNmxzlANBQBQk653wcP1Bf1XpFy4wBN+8/VfYhlpAr5+QgkD1zosqTo2IrohCzpghAVvV08Nz4GVMYu5d1G56f/qKJYCZ9w11e+WJ4AJpv+dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW7cx+M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW7cx+M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4FBC4CEFA;
	Thu,  3 Jul 2025 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555715;
	bh=o18t9vGCABLkp6EG9AQMEnTgjOwJdMfzGphJx4fnt9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW7cx+M9aYUN+WSVuRgeYvwaub3I8AT6n1U9yzKEseRu6uY4Ux48omhHjlCpw1A/R
	 ptxZCSGi20MPve8Brnu/d67LtlamMcZYGg9Td5j6dxIsiOfNwac2IQV0VDRw2s0fPk
	 CHbGTGBnMMMI8RCPtMmHnUzqhEEMfZWUUjAmFYxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/139] af_unix: Define locking order for U_RECVQ_LOCK_EMBRYO in unix_collect_skb().
Date: Thu,  3 Jul 2025 16:42:11 +0200
Message-ID: <20250703143943.824865247@linuxfoundation.org>
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

[ Upstream commit 8647ece4814f3bfdb5f7a8e19f882c9b89299a07 ]

While GC is cleaning up cyclic references by SCM_RIGHTS,
unix_collect_skb() collects skb in the socket's recvq.

If the socket is TCP_LISTEN, we need to collect skb in the
embryo's queue.  Then, both the listener's recvq lock and
the embroy's one are held.

The locking is always done in the listener -> embryo order.

Let's define it as unix_recvq_lock_cmp_fn() instead of using
spin_lock_nested().

Note that the reverse order is defined for consistency.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32ca245464e1 ("af_unix: Don't leave consecutive consumed OOB skbs.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 21 +++++++++++++++++++++
 net/unix/garbage.c |  8 +-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a6f0cc635f4dd..7546654f8273a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -145,6 +145,25 @@ static int unix_state_lock_cmp_fn(const struct lockdep_map *_a,
 	/* unix_state_double_lock(): ascending address order. */
 	return cmp_ptr(a, b);
 }
+
+static int unix_recvq_lock_cmp_fn(const struct lockdep_map *_a,
+				  const struct lockdep_map *_b)
+{
+	const struct sock *a, *b;
+
+	a = container_of(_a, struct sock, sk_receive_queue.lock.dep_map);
+	b = container_of(_b, struct sock, sk_receive_queue.lock.dep_map);
+
+	/* unix_collect_skb(): listener -> embryo order. */
+	if (a->sk_state == TCP_LISTEN && unix_sk(b)->listener == a)
+		return -1;
+
+	/* Should never happen.  Just to be symmetric. */
+	if (b->sk_state == TCP_LISTEN && unix_sk(a)->listener == b)
+		return 1;
+
+	return 0;
+}
 #endif
 
 static unsigned int unix_unbound_hash(struct sock *sk)
@@ -998,6 +1017,8 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	sk->sk_write_space	= unix_write_space;
 	sk->sk_max_ack_backlog	= READ_ONCE(net->unx.sysctl_max_dgram_qlen);
 	sk->sk_destruct		= unix_sock_destructor;
+	lock_set_cmp_fn(&sk->sk_receive_queue.lock, unix_recvq_lock_cmp_fn, NULL);
+
 	u = unix_sk(sk);
 	u->listener = NULL;
 	u->vertex = NULL;
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 23efb78fe9ef4..06d94ad999e99 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -337,11 +337,6 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 	return true;
 }
 
-enum unix_recv_queue_lock_class {
-	U_RECVQ_LOCK_NORMAL,
-	U_RECVQ_LOCK_EMBRYO,
-};
-
 static void unix_collect_queue(struct unix_sock *u, struct sk_buff_head *hitlist)
 {
 	skb_queue_splice_init(&u->sk.sk_receive_queue, hitlist);
@@ -375,8 +370,7 @@ static void unix_collect_skb(struct list_head *scc, struct sk_buff_head *hitlist
 			skb_queue_walk(queue, skb) {
 				struct sk_buff_head *embryo_queue = &skb->sk->sk_receive_queue;
 
-				/* listener -> embryo order, the inversion never happens. */
-				spin_lock_nested(&embryo_queue->lock, U_RECVQ_LOCK_EMBRYO);
+				spin_lock(&embryo_queue->lock);
 				unix_collect_queue(unix_sk(skb->sk), hitlist);
 				spin_unlock(&embryo_queue->lock);
 			}
-- 
2.39.5



