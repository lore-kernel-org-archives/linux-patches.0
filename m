Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624E565116;
	Wed, 30 Sep 2026 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790459; cv=none; b=T7cWVNkrJR/O8Y3Gr62QSF1mb06zIIHRD2JRv1KZXLRZHXn7TCD1VsbH0H8u+TYdfVy7AQ2GQt/0uydmmufCDqW33n1lAowpqdGK7/V5Kr7xT18RYQ6uz0ULWtVVEw4juocaiT23o7bQ+O82XHqOSlZE7HmyUeHtHtAU2g4exuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790459; c=relaxed/simple;
	bh=47CvjR4N8BR3cMKxNJN8whzVpTNelNRvLLl6QUz5L6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbAJVI7BU3KejI94g4SyZq2tJR7UlY3MmexQdij70rZifgsUYyPXjZKN8EymgHsIK2eq0MctBEf5hlsHdMZfIjp236qm3h2SmZQfadx+xzUnKJ6hrI45ersth8mSu6Wcs/ywmAnp/3+J/0lJMsQZdqllpa/MZRvSRtd4TF4Ub94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR+dsc3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR+dsc3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601E51F000FF;
	Wed, 30 Sep 2026 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790457;
	bh=TyX/rELUX3+WLb32i+iDPTLf2GgaZTrYcNGNfzHqHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GR+dsc3XEwNEWYAlTq7OPuCp1vFFN4eAI4fZPNGHOOY+cbd+Xity73WMrqJeaDl/B
	 +Q/Tqsti4HtNuunhR6YGNW4ijARO6iJuHY7xM28Vjx2gqV3W7XTXM4TjqkPwyFHTrp
	 u2+IR7CqB6//EQPmcsXTpXFgs9hFXHxOmm+mltME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Katherine Leaver <kleaver@janestreet.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 837/877] packet: use ubuf_info completion for TX_RING packets
Date: Wed, 30 Sep 2026 17:29:08 +0200
Message-ID: <20260930152432.798163789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 9518405613863d0bf0700927a21367f5942cf058 ]

tpacket_snd sends skbs with frags pointing into its ring slots. Slots
are released when skb->destructor is called.

A call to skb_orphan calls skb->destructor before the skb is freed.
This can cause the slot to be reused while still linked into the skb.

Switch to standard zerocopy completion (ubuf_info) so the slot is only
released once all references to the payload are freed or copied.
Restore skb->destructor to standard sock_wfree.

The ubuf_info completion callback can be called with a NULL skb, but
only from net_zcopy_put and related API, used by zerocopy implementations
that hold their own reference on the uarg, such as MSG_ZEROCOPY. This
uarg is only ever completed from skb_zcopy_clear, so skb is always set.

To prevent userspace from aliasing in-flight state on shared ring
slots, allocate tpacket_uarg per packet, rather than per slot. This
adds a small allocation to the transmit path. Use standard kmalloc to
allow backporting to stable kernels.

The uarg holds an sk_wmem_alloc reference, rather than an sk_refcnt
reference. packet_free_tx_ring waits on sk_wmem_alloc before freeing
the ring pages. Always allocate vec->deferred for tx_ring so page-backed
rings also wait on sk_wmem_alloc when skb_copy_ubufs drops page refs
before calling tpacket_ubuf_complete.

Drop the tx_ring.pg_vec test that tpacket_destruct_skb performed before
accessing the slot. The sk_wmem_alloc reference now guarantees that the
slot is valid. The test is also not sufficient by itself, as it reads
pg_vec without pg_vec_lock, so it can race with packet_set_ring.

As a result a slot is released when its payload is copied, which can
be before transmission (e.g., in skb_orphan_frags_rx). If copied
before skb_tx_timestamp() is called, no slot timestamp is recorded,
similar to when skb_orphan() was called early in the datapath before
this patch.

Revert the now unused previous skb_zcopy_.._nouarg infra.

Depends on commit 992cc9f94ca9 ("net/packet: defer vmalloc TX_RING
free until skbs finish").

Reported-by: Katherine Leaver <kleaver@janestreet.com>
Reported-by: Bjoern Doebel <doebel@amazon.de>
Closes: https://lore.kernel.org/netdev/20260909085542.3370986-1-doebel@amazon.de/
Fixes: 5cd8d46ea156 ("packet: copy user buffers before orphan or clone")
Cc: stable@vger.kernel.org
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260919004748.1463985-3-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Retained sockc->tsflags instead of sockc in skb_setup_tx_timestamp() for the older helper signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   19 ---------
 net/packet/af_packet.c |  102 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 65 insertions(+), 56 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1807,22 +1807,6 @@ static inline void skb_zcopy_set(struct
 	}
 }
 
-static inline void skb_zcopy_set_nouarg(struct sk_buff *skb, void *val)
-{
-	skb_shinfo(skb)->destructor_arg = (void *)((uintptr_t) val | 0x1UL);
-	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_FRAG;
-}
-
-static inline bool skb_zcopy_is_nouarg(struct sk_buff *skb)
-{
-	return (uintptr_t) skb_shinfo(skb)->destructor_arg & 0x1UL;
-}
-
-static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
-{
-	return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
-}
-
 static inline void net_zcopy_put(struct ubuf_info *uarg)
 {
 	if (uarg)
@@ -1845,8 +1829,7 @@ static inline void skb_zcopy_clear(struc
 	struct ubuf_info *uarg = skb_zcopy(skb);
 
 	if (uarg) {
-		if (!skb_zcopy_is_nouarg(skb))
-			uarg->ops->complete(skb, uarg, zerocopy_success);
+		uarg->ops->complete(skb, uarg, zerocopy_success);
 
 		skb_shinfo(skb)->flags &= ~SKBFL_ALL_ZEROCOPY;
 	}
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2582,26 +2582,6 @@ drop_n_account:
 	goto drop_n_restore;
 }
 
-static void tpacket_destruct_skb(struct sk_buff *skb)
-{
-	struct packet_sock *po = pkt_sk(skb->sk);
-
-	if (likely(po->tx_ring.pg_vec)) {
-		void *ph;
-		__u32 ts;
-
-		ph = skb_zcopy_get_nouarg(skb);
-
-		ts = __packet_set_timestamp(po, ph, skb);
-		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
-
-		packet_dec_pending(&po->tx_ring);
-		complete(&po->skb_completion);
-	}
-
-	sock_wfree(skb);
-}
-
 static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
 {
 	if ((vnet_hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
@@ -2641,27 +2621,56 @@ static int packet_snd_vnet_parse(struct
 	return 0;
 }
 
+struct tpacket_uarg {
+	struct ubuf_info	ubuf;
+	struct packet_sock	*po;
+	void			*ph;
+};
+
+static void tpacket_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
+				  bool success)
+{
+	struct tpacket_uarg *tu = container_of(uarg, struct tpacket_uarg, ubuf);
+	struct packet_sock *po = tu->po;
+	void *ph = tu->ph;
+	__u32 ts;
+
+	DEBUG_NET_WARN_ON_ONCE(!skb);
+
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+
+	ts = __packet_set_timestamp(po, ph, skb);
+	__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
+
+	packet_dec_pending(&po->tx_ring);
+	complete(&po->skb_completion);
+
+	kfree(tu);
+	sk_free(&po->sk);
+}
+
+static const struct ubuf_info_ops tpacket_ubuf_ops = {
+	.complete = tpacket_ubuf_complete,
+};
+
 static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
-		void *frame, struct net_device *dev, void *data, int tp_len,
+		struct net_device *dev, void *data, int tp_len,
 		__be16 proto, unsigned char *addr, int hlen, int copylen,
 		int hard_header_len,
 		const struct sockcm_cookie *sockc)
 {
-	union tpacket_uhdr ph;
 	int to_write, offset, len, nr_frags, len_max;
 	struct socket *sock = po->sk.sk_socket;
 	struct page *page;
 	int err;
 
-	ph.raw = frame;
-
 	skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = READ_ONCE(po->sk.sk_priority);
 	skb->mark = READ_ONCE(po->sk.sk_mark);
 	skb_set_delivery_type_by_clockid(skb, sockc->transmit_time, po->sk.sk_clockid);
 	skb_setup_tx_timestamp(skb, sockc->tsflags);
-	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
@@ -2801,6 +2810,7 @@ static int tpacket_snd(struct packet_soc
 	struct virtio_net_hdr vnet_hdr;
 	bool has_vnet_hdr = false;
 	struct sockcm_cookie sockc;
+	struct tpacket_uarg *uarg;
 	__be16 proto;
 	int err, reserve = 0;
 	void *ph;
@@ -2928,7 +2938,7 @@ static int tpacket_snd(struct packet_soc
 				err = len_sum;
 			goto out_status;
 		}
-		tp_len = tpacket_fill_skb(po, skb, ph, dev, data, tp_len, proto,
+		tp_len = tpacket_fill_skb(po, skb, dev, data, tp_len, proto,
 					  addr, hlen, copylen, hard_header_len,
 					  &sockc);
 		if (likely(tp_len >= 0) &&
@@ -2960,7 +2970,24 @@ tpacket_error:
 			virtio_net_hdr_set_proto(skb, &vnet_hdr);
 		}
 
-		skb->destructor = tpacket_destruct_skb;
+		uarg = kmalloc(sizeof(*uarg), GFP_KERNEL);
+		if (unlikely(!uarg)) {
+			if (likely(len_sum > 0))
+				err = len_sum;
+			else
+				err = -ENOMEM;
+			goto out_status;
+		}
+		uarg->po = po;
+		uarg->ph = ph;
+		uarg->ubuf.ops = &tpacket_ubuf_ops;
+		uarg->ubuf.flags = SKBFL_ZEROCOPY_FRAG;
+		refcount_set(&uarg->ubuf.refcnt, 1);
+
+		/* Hold a sk_wmem_alloc reference until completion */
+		refcount_inc(&po->sk.sk_wmem_alloc);
+		skb_zcopy_init(skb, &uarg->ubuf);
+
 		__packet_set_status(po, ph, TP_STATUS_SENDING);
 		packet_inc_pending(&po->tx_ring);
 
@@ -4529,21 +4556,20 @@ static struct pgv *alloc_pg_vec(struct t
 	vec->len = block_nr;
 	pg_vec = vec->pg_vec;
 
+	if (tx_ring) {
+		vec->deferred = kzalloc_obj(*vec->deferred,
+					    GFP_KERNEL | __GFP_NOWARN);
+		if (!vec->deferred)
+			goto out_free_pgvec;
+		vec->deferred->vec = vec;
+		INIT_DELAYED_WORK(&vec->deferred->work,
+				  packet_free_pg_vec_work);
+	}
+
 	for (i = 0; i < block_nr; i++) {
 		pg_vec[i].buffer = alloc_one_pg_vec_page(order);
 		if (unlikely(!pg_vec[i].buffer))
 			goto out_free_pgvec;
-
-		if (tx_ring && !vec->deferred &&
-		    is_vmalloc_addr(pg_vec[i].buffer)) {
-			vec->deferred = kzalloc_obj(*vec->deferred,
-						    GFP_KERNEL | __GFP_NOWARN);
-			if (!vec->deferred)
-				goto out_free_pgvec;
-			vec->deferred->vec = vec;
-			INIT_DELAYED_WORK(&vec->deferred->work,
-					  packet_free_pg_vec_work);
-		}
 	}
 
 out:


