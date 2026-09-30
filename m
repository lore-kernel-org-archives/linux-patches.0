Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227954594E;
	Wed, 30 Sep 2026 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793247; cv=none; b=U9WXeWI7Rt9uIVK7+CQ9B5UYb4vWCpO6anh6L8EYni+NKHgNZEHvWP5rXZO5LUyBeRGHVZyxaBaGji1rm+KaLk4mtqzD74clmWYmSv2SuJn4Ggx/of2NVCg0TWnumpVYHBdQP9vLl3VIi88NknHu8UJ2DhS1Z7qkCRFnYS0To7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793247; c=relaxed/simple;
	bh=348ggYrctlNeczVizJ59h3f8D36vuUYM8urwbEXJ87E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ovd/Dh4DvDFbz3NeEtxNMD0it/fWzQJIo9qkHEobh02O8qeCPoQRwIYBTOtx0Cy9CN6CQyAd6EldjvBe653bQY5hpmZwi8phugPdYnrpxRejEpSRjBFO9a7RiX9WAnfsRwgOqSbW+iT09jxTHs+tCFw1gmaLIN+shzfj6ronaHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7ccNGpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7ccNGpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9C51F00898;
	Wed, 30 Sep 2026 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793246;
	bh=jN/vQvK6wmFmQOmGvNtUU5ti3Y1J/za98o6VHGkVi84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7ccNGpl+jLmffl2g68upxlfEfCRtMYN291x6e5xN+T5B8RihlAjEUQ0Vb/2JOzmb
	 1HdOp5BM71CIVC6OWaWXyMnL9IaowKPiqDtErqyYkYvG4w0ZeIZnXkOvLRN8bJSnHa
	 61mYAFJ85RteucjK7DAqKaErW7EH2yBK0aKzoY0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/395] gve: add support for UDP GSO for DQO format
Date: Wed, 30 Sep 2026 17:27:30 +0200
Message-ID: <20260930152344.729391134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit 014c607f86abc903d7bf46e13373d89392e371fe ]

Enable support for UDP GSO when using DQO format. Advertise the feature
flag during device initialization and enable offload by default.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260306224816.3391551-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3b430ea62340 ("gve: fix TX drop when GSO MSS is too small for hw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c |  8 +++--
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 33 ++++++++++++++------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 926833b2424fa..367a9f0e89b5c 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -1123,10 +1123,12 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 
 	gve_set_default_rss_sizes(priv);
 
-	/* DQO supports HW-GRO. */
+	/* DQO supports HW-GRO and UDP_GSO */
 	if (gve_is_dqo(priv)) {
-		priv->dev->hw_features |= NETIF_F_GRO_HW;
-		priv->dev->features |= NETIF_F_GRO_HW;
+		u64 additional_features = NETIF_F_GRO_HW | NETIF_F_GSO_UDP_L4;
+
+		priv->dev->hw_features |= additional_features;
+		priv->dev->features |= additional_features;
 	}
 
 	priv->max_registered_pages =
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 5fbee184f0e7a..9c5f03ac3c35f 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -575,9 +575,11 @@ static void gve_tx_fill_pkt_desc_dqo(struct gve_tx_ring *tx, u32 *desc_idx,
  */
 static int gve_prep_tso(struct sk_buff *skb)
 {
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	u32 paylen, l4_start;
 	struct tcphdr *tcp;
+	struct udphdr *udp;
 	int header_len;
-	u32 paylen;
 	int err;
 
 	/* Note: HW requires MSS (gso_size) to be <= 9728 and the total length
@@ -588,21 +590,34 @@ static int gve_prep_tso(struct sk_buff *skb)
 	 * - Kernel will not produce a TSO larger than 64k
 	 */
 
-	if (unlikely(skb_shinfo(skb)->gso_size < GVE_TX_MIN_TSO_MSS_DQO))
+	if (unlikely(shinfo->gso_size < GVE_TX_MIN_TSO_MSS_DQO))
 		return -1;
 
-	if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
-		return -EINVAL;
-
 	/* Needed because we will modify header. */
 	err = skb_cow_head(skb, 0);
 	if (err < 0)
 		return err;
 
-	tcp = tcp_hdr(skb);
-	paylen = skb->len - skb_transport_offset(skb);
-	csum_replace_by_diff(&tcp->check, (__force __wsum)htonl(paylen));
-	header_len = skb_tcp_all_headers(skb);
+	l4_start = skb_transport_offset(skb);
+	paylen = skb->len - l4_start;
+
+	switch (shinfo->gso_type) {
+	case SKB_GSO_TCPV4:
+	case SKB_GSO_TCPV6:
+		tcp = tcp_hdr(skb);
+		csum_replace_by_diff(&tcp->check,
+				     (__force __wsum)htonl(paylen));
+		header_len = skb_tcp_all_headers(skb);
+		break;
+	case SKB_GSO_UDP_L4:
+		udp = udp_hdr(skb);
+		csum_replace_by_diff(&udp->check,
+				     (__force __wsum)htonl(paylen));
+		header_len = sizeof(struct udphdr) + l4_start;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	if (unlikely(header_len > GVE_TX_MAX_HDR_SIZE_DQO))
 		return -EINVAL;
-- 
2.53.0



