Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215856;
	b=gtaGggAiVy1tf4bEbJwmNWhOFHb8kqkCQPGaonRGPOxcB7aji88ml8Xd6MHW+oVbc8nX
	 +MeRtmqKZKDLq6qbN4jlClx6TN8VGsQVZSqWIUFMRGSduuSCXhSDALCvzjzjTBFY+U0qU
	 KSrpqAezODhOS961iUpm+qKh8Mt0LAEwr3DOKFWLWDYD8K3hzzLjHOUJAvYd4QLeOPfmO
	 5/RD/IId6KWZ/wi75MVXjYEjShThltPHGX8Vdo90ZycxOSiMPS7jM5ddTNpo0xXbWcvCr
	 p5rfKZ3LtXrqmXT9NqWuuh1r0PoY94KAycilKrJl3Op0n7xKkE6fwrrzrGD3Ys6ok/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RLTuwWLUPLh4QZ9TibXB5tTe9wI/wCgJWUllUxVUAAE=;
	b=wBqn//egrdaNiCMgGsAPMiCMyUHL/50T1d8fPgR7OcrazhZVDY7/EYBOr+xDyvxbRvaX
	 h8y7X2sMjUjr8bUPLw6wJOzdLfZ7bs/dlQzqX52Hx4ytXol0by24F4ufK6Hd14QBOJ03w
	 uMTrn4SWwVxOexHg5Ed2Xr6yn8J9dRl1izYLgyPQ0Czpa/DPU7PhL5Pf7GIhe8qsS9hoR
	 I78tdW+zg3jxa9wXMiPBSmw+YxvOLZCQtvJCG5mSkD5ExWu+aFX8ulwgsiG6r3aANv23i
	 e4sRwe8Ncv+va0DuuViEgajtDAWwz51xWoExtelwrD7qaWrD67bl5LqCJnavoNdwPlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7MVXFm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CCF606A321;
	Wed, 28 Oct 2026 19:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7MVXFm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480501F01825;
	Wed, 28 Oct 2026 19:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215855;
	bh=RLTuwWLUPLh4QZ9TibXB5tTe9wI/wCgJWUllUxVUAAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7MVXFm1URdVE55rW7+6rVGaNPldWTeAcWw1kco/u69Xz8TBqnjCZLWF/5943qGEB
	 aoxcLEAP1ZgIdADG0mThpCYAuCqFHsDuERrrx+egg1Rk5Zz7nG3sRXjZMtgpfBlXTT
	 JT2IWLvwGwtSkJEDrNRJe5zOxYegvVCJIw5Y4/l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1355/1887] net/packet: defer vmalloc TX_RING free until skbs finish
Date: Wed, 28 Oct 2026 17:57:31 +0100
Message-ID: <20261028170530.276693235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 992cc9f94ca924089a506ba9b327caa9af797529 ]

AF_PACKET TX_RING skbs keep a raw pointer to their ring frame. The skb
page references preserve page-backed ring blocks after pg_vec is freed,
but they do not preserve a vmalloc mapping.

tpacket_destruct_skb() currently drops the pending reference before
writing the timestamp and TP_STATUS_AVAILABLE to the frame. Move the
decrement after those stores. The smp_wmb() in __packet_set_status()
orders the frame stores before the decrement.

Also recheck pending TX frames under pg_vec_lock before non-closing
ring replacement, so a racing send cannot add a pending skb between
the initial check and the ring swap.

Ring allocation can produce a mixture of page-backed and vmalloc-backed
blocks. Allocate deferred-work storage during TX ring setup when the
first vmalloc-backed block is encountered, and keep its pointer in the
pg_vec allocation header. If allocation fails, return -ENOMEM from ring
setup. On socket close, a non-NULL pointer identifies a vmalloc-backed
vector without a scan. If TX skbs remain, defer the whole vector to
system_long_wq.

After pg_vec is detached, a late destructor can skip the pending
decrement. Use socket write-memory accounting as the deferred lifetime
gate instead: an skb remains charged through its final sock_wfree(),
after all ring-frame accesses. The delayed work retains a socket
reference and reschedules itself until no TX skbs remain.

Move pending_refcnt release to packet_sock_destruct() so late skb
destructors and deferred cleanup can safely use it after
packet_release(). Page-backed teardown remains synchronous, and no lock
is added to the TX completion hot path.

Fixes: b013840810c2 ("packet: use percpu mmap tx frame pending refcount")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260721015824.45829-1-kylebot@openai.com/
Suggested-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260816235646.76500-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 97 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 9 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ebdcf42e44ff0..73663db442cce 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -87,6 +87,7 @@
 #include <linux/errqueue.h>
 #include <linux/net_tstamp.h>
 #include <linux/percpu.h>
+#include <linux/workqueue.h>
 #ifdef CONFIG_INET
 #include <net/inet_common.h>
 #endif
@@ -1396,6 +1397,8 @@ static void packet_sock_destruct(struct sock *sk)
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
 	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 
+	packet_free_pending(pkt_sk(sk));
+
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_err("Attempt to release alive packet socket: %p\n", sk);
 		return;
@@ -2598,11 +2601,11 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		__u32 ts;
 
 		ph = skb_zcopy_get_nouarg(skb);
-		packet_dec_pending(&po->tx_ring);
 
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
+		packet_dec_pending(&po->tx_ring);
 		complete(&po->skb_completion);
 	}
 
@@ -3266,7 +3269,6 @@ static int packet_release(struct socket *sock)
 	/* Purge queues */
 
 	skb_queue_purge(&sk->sk_receive_queue);
-	packet_free_pending(po);
 	sk_refcnt_debug_release(sk);
 
 	sock_put(sk);
@@ -4402,11 +4404,26 @@ static const struct vm_operations_struct packet_mmap_ops = {
 	.close	=	packet_mm_close,
 };
 
+struct packet_pg_vec {
+	struct packet_pg_vec_free *deferred;
+	unsigned int order;
+	unsigned int len;
+	struct pgv pg_vec[];
+};
+
+struct packet_pg_vec_free {
+	struct delayed_work work;
+	struct sock *sk;
+	struct packet_pg_vec *vec;
+};
+
 static void free_pg_vec(struct pgv *pg_vec, unsigned int order,
 			unsigned int len)
 {
+	struct packet_pg_vec *vec;
 	int i;
 
+	vec = container_of_const(pg_vec, struct packet_pg_vec, pg_vec[0]);
 	for (i = 0; i < len; i++) {
 		if (likely(pg_vec[i].buffer)) {
 			if (is_vmalloc_addr(pg_vec[i].buffer))
@@ -4417,7 +4434,46 @@ static void free_pg_vec(struct pgv *pg_vec, unsigned int order,
 			pg_vec[i].buffer = NULL;
 		}
 	}
-	kfree(pg_vec);
+	kfree(vec->deferred);
+	kfree(vec);
+}
+
+static void packet_free_pg_vec_work(struct work_struct *work)
+{
+	struct packet_pg_vec_free *deferred;
+	struct packet_pg_vec *vec;
+	struct sock *sk;
+
+	deferred = container_of_const(to_delayed_work(work),
+				      struct packet_pg_vec_free, work);
+	vec = deferred->vec;
+	sk = deferred->sk;
+	if (sk_wmem_alloc_get(sk)) {
+		queue_delayed_work(system_long_wq, &deferred->work, 1);
+		return;
+	}
+
+	free_pg_vec(vec->pg_vec, vec->order, vec->len);
+	sock_put(sk);
+}
+
+static void packet_free_tx_ring(struct sock *sk, struct pgv *pg_vec,
+				unsigned int order, unsigned int len)
+{
+	struct packet_pg_vec_free *deferred;
+	struct packet_pg_vec *vec;
+
+	vec = container_of_const(pg_vec, struct packet_pg_vec, pg_vec[0]);
+	deferred = vec->deferred;
+	if (!deferred || !sk_wmem_alloc_get(sk)) {
+		free_pg_vec(pg_vec, order, len);
+		return;
+	}
+
+	/* A detached ring's pending count can miss late skb destructors. */
+	deferred->sk = sk;
+	sock_hold(sk);
+	queue_delayed_work(system_long_wq, &deferred->work, 0);
 }
 
 static char *alloc_one_pg_vec_page(unsigned long order)
@@ -4445,20 +4501,36 @@ static char *alloc_one_pg_vec_page(unsigned long order)
 	return NULL;
 }
 
-static struct pgv *alloc_pg_vec(struct tpacket_req *req, int order)
+static struct pgv *alloc_pg_vec(struct tpacket_req *req, int order, bool tx_ring)
 {
 	unsigned int block_nr = req->tp_block_nr;
+	struct packet_pg_vec *vec;
 	struct pgv *pg_vec;
 	int i;
 
-	pg_vec = kcalloc(block_nr, sizeof(struct pgv), GFP_KERNEL | __GFP_NOWARN);
-	if (unlikely(!pg_vec))
-		goto out;
+	vec = kzalloc(struct_size(vec, pg_vec, block_nr),
+		      GFP_KERNEL | __GFP_NOWARN);
+	if (unlikely(!vec))
+		return NULL;
+	vec->order = order;
+	vec->len = block_nr;
+	pg_vec = vec->pg_vec;
 
 	for (i = 0; i < block_nr; i++) {
 		pg_vec[i].buffer = alloc_one_pg_vec_page(order);
 		if (unlikely(!pg_vec[i].buffer))
 			goto out_free_pgvec;
+
+		if (tx_ring && !vec->deferred &&
+		    is_vmalloc_addr(pg_vec[i].buffer)) {
+			vec->deferred = kzalloc(sizeof(*vec->deferred),
+						GFP_KERNEL | __GFP_NOWARN);
+			if (!vec->deferred)
+				goto out_free_pgvec;
+			vec->deferred->vec = vec;
+			INIT_DELAYED_WORK(&vec->deferred->work,
+					  packet_free_pg_vec_work);
+		}
 	}
 
 out:
@@ -4541,7 +4613,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 		err = -ENOMEM;
 		order = get_order(req->tp_block_size);
-		pg_vec = alloc_pg_vec(req, order);
+		pg_vec = alloc_pg_vec(req, order, tx_ring);
 		if (unlikely(!pg_vec))
 			goto out;
 		switch (po->tp_version) {
@@ -4593,6 +4665,9 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	err = -EBUSY;
 	mutex_lock(&po->pg_vec_lock);
 	if (closing || atomic_long_read(&po->mapped) == 0) {
+		if (tx_ring && !closing && packet_read_pending(rb))
+			goto out_unlock;
+
 		err = 0;
 		spin_lock_bh(&rb_queue->lock);
 		swap(rb->pg_vec, pg_vec);
@@ -4614,6 +4689,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 			pr_err("packet_mmap: vma is busy: %ld\n",
 			       atomic_long_read(&po->mapped));
 	}
+out_unlock:
 	mutex_unlock(&po->pg_vec_lock);
 
 	spin_lock(&po->bind_lock);
@@ -4635,7 +4711,10 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 out_free_pg_vec:
 	if (pg_vec) {
 		bitmap_free(rx_owner_map);
-		free_pg_vec(pg_vec, order, req->tp_block_nr);
+		if (tx_ring && closing)
+			packet_free_tx_ring(sk, pg_vec, order, req->tp_block_nr);
+		else
+			free_pg_vec(pg_vec, order, req->tp_block_nr);
 	}
 out:
 	return err;
-- 
2.53.0



