Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCC71FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D296C433C8;
	Tue,  1 Aug 2023 09:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882980;
	bh=WepVXSoxEHwOq1k/iuQFNIkkAekakXuAJCqRbWQLX8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjhL/3yTmPww3bZ44DlCP7kW4xcgaLVJp26OuPu3Yp49Mg7703BkMmTN/QxXmIvgA
	 bSmDdnCeqANZC6LN0uVwwvSts6+CSksEFF3nsOliCuaqeTWmMfEMKjRVaXaYxC0tj0
	 ToAJ1pY7Xa7OUQGqwDC9ayzmvPq1pZUIJMxHyae4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Benc <jbenc@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 072/239] vxlan: fix GRO with VXLAN-GPE
Date: Tue,  1 Aug 2023 11:18:56 +0200
Message-ID: <20230801091928.289689040@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit b0b672c4d0957e5897685667fc848132b8bd2d71 ]

In VXLAN-GPE, there may not be an Ethernet header following the VXLAN
header. But in GRO, the vxlan driver calls eth_gro_receive
unconditionally, which means the following header is incorrectly parsed
as Ethernet.

Introduce GPE specific GRO handling.

For better performance, do not check for GPE during GRO but rather
install a different set of functions at setup time.

Fixes: e1e5314de08ba ("vxlan: implement GPE")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 84 ++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index cb2d82785d900..7532cac2154c5 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -675,26 +675,24 @@ static struct vxlanhdr *vxlan_gro_remcsum(struct sk_buff *skb,
 	return vh;
 }
 
-static struct sk_buff *vxlan_gro_receive(struct sock *sk,
-					 struct list_head *head,
-					 struct sk_buff *skb)
+static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
+						  struct list_head *head,
+						  struct sk_buff *skb,
+						  struct gro_remcsum *grc)
 {
-	struct sk_buff *pp = NULL;
 	struct sk_buff *p;
 	struct vxlanhdr *vh, *vh2;
 	unsigned int hlen, off_vx;
-	int flush = 1;
 	struct vxlan_sock *vs = rcu_dereference_sk_user_data(sk);
 	__be32 flags;
-	struct gro_remcsum grc;
 
-	skb_gro_remcsum_init(&grc);
+	skb_gro_remcsum_init(grc);
 
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
 	vh = skb_gro_header(skb, hlen, off_vx);
 	if (unlikely(!vh))
-		goto out;
+		return NULL;
 
 	skb_gro_postpull_rcsum(skb, vh, sizeof(struct vxlanhdr));
 
@@ -702,12 +700,12 @@ static struct sk_buff *vxlan_gro_receive(struct sock *sk,
 
 	if ((flags & VXLAN_HF_RCO) && (vs->flags & VXLAN_F_REMCSUM_RX)) {
 		vh = vxlan_gro_remcsum(skb, off_vx, vh, sizeof(struct vxlanhdr),
-				       vh->vx_vni, &grc,
+				       vh->vx_vni, grc,
 				       !!(vs->flags &
 					  VXLAN_F_REMCSUM_NOPARTIAL));
 
 		if (!vh)
-			goto out;
+			return NULL;
 	}
 
 	skb_gro_pull(skb, sizeof(struct vxlanhdr)); /* pull vxlan header */
@@ -724,12 +722,48 @@ static struct sk_buff *vxlan_gro_receive(struct sock *sk,
 		}
 	}
 
-	pp = call_gro_receive(eth_gro_receive, head, skb);
-	flush = 0;
+	return vh;
+}
+
+static struct sk_buff *vxlan_gro_receive(struct sock *sk,
+					 struct list_head *head,
+					 struct sk_buff *skb)
+{
+	struct sk_buff *pp = NULL;
+	struct gro_remcsum grc;
+	int flush = 1;
 
-out:
+	if (vxlan_gro_prepare_receive(sk, head, skb, &grc)) {
+		pp = call_gro_receive(eth_gro_receive, head, skb);
+		flush = 0;
+	}
 	skb_gro_flush_final_remcsum(skb, pp, flush, &grc);
+	return pp;
+}
 
+static struct sk_buff *vxlan_gpe_gro_receive(struct sock *sk,
+					     struct list_head *head,
+					     struct sk_buff *skb)
+{
+	const struct packet_offload *ptype;
+	struct sk_buff *pp = NULL;
+	struct gro_remcsum grc;
+	struct vxlanhdr *vh;
+	__be16 protocol;
+	int flush = 1;
+
+	vh = vxlan_gro_prepare_receive(sk, head, skb, &grc);
+	if (vh) {
+		if (!vxlan_parse_gpe_proto(vh, &protocol))
+			goto out;
+		ptype = gro_find_receive_by_type(protocol);
+		if (!ptype)
+			goto out;
+		pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
+		flush = 0;
+	}
+out:
+	skb_gro_flush_final_remcsum(skb, pp, flush, &grc);
 	return pp;
 }
 
@@ -741,6 +775,21 @@ static int vxlan_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 	return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
 }
 
+static int vxlan_gpe_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
+{
+	struct vxlanhdr *vh = (struct vxlanhdr *)(skb->data + nhoff);
+	const struct packet_offload *ptype;
+	int err = -ENOSYS;
+	__be16 protocol;
+
+	if (!vxlan_parse_gpe_proto(vh, &protocol))
+		return err;
+	ptype = gro_find_complete_by_type(protocol);
+	if (ptype)
+		err = ptype->callbacks.gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
+	return err;
+}
+
 static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan, const u8 *mac,
 					 __u16 state, __be32 src_vni,
 					 __u16 ndm_flags)
@@ -3373,8 +3422,13 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 	tunnel_cfg.encap_rcv = vxlan_rcv;
 	tunnel_cfg.encap_err_lookup = vxlan_err_lookup;
 	tunnel_cfg.encap_destroy = NULL;
-	tunnel_cfg.gro_receive = vxlan_gro_receive;
-	tunnel_cfg.gro_complete = vxlan_gro_complete;
+	if (vs->flags & VXLAN_F_GPE) {
+		tunnel_cfg.gro_receive = vxlan_gpe_gro_receive;
+		tunnel_cfg.gro_complete = vxlan_gpe_gro_complete;
+	} else {
+		tunnel_cfg.gro_receive = vxlan_gro_receive;
+		tunnel_cfg.gro_complete = vxlan_gro_complete;
+	}
 
 	setup_udp_tunnel_sock(net, sock, &tunnel_cfg);
 
-- 
2.39.2



