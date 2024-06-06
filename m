Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69D01A186B;
	Thu,  6 Jun 2024 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683746; cv=none; b=k68ZJneVeJG78UnNoKTb7MXNpVQP42v5fqyUNWeDnkz5zfw9e1cPNCk5DEwK4SPW02fDLFWbJZsyu+Z0smp84cI4kw5yIXS/MxRo3TYLz2vZEx63RWUfrPqcpVl6/5p+pf6EIdqws0cOVozeuuPSazdmytSbQIColMJ3MUawqfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683746; c=relaxed/simple;
	bh=XzkJ02kTCGZKd3BEaq7FFDKvF2SYOPLYGyVwtfJXaDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOOi+pYAUYzomze97kGysmjU3YyH4lMDXLvoovgDg6plvN7Yz6khAaIoHiKvq7JFSiW/WFu/aO81y9tTkXmIPFy3hFMGSiNbJwhkfkN11Di++s3l+B4thbz9SHL3D8bYPV7gHD+l0ijUeOq5mWywKk6ZC7oWhfkxzUfe/Cyv478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzxXUGva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzxXUGva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFA0C2BD10;
	Thu,  6 Jun 2024 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683746;
	bh=XzkJ02kTCGZKd3BEaq7FFDKvF2SYOPLYGyVwtfJXaDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzxXUGvamiq9LZvKZA6JmfJy+ROJFf7vk5VdrCRKrq81M3twtG2hai2D+nBclViUk
	 ePK06jk4d7Szblnrnu3YKdbPgXZ9ohd6Pxk9jIaQJHa3C1nAJqWnyykz4XTaBiFHs0
	 b8OVJMo9ytKpiK98eszj/R8aZoi/+EzAJizlw6DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 712/744] netfilter: nft_payload: skbuff vlan metadata mangle support
Date: Thu,  6 Jun 2024 16:06:24 +0200
Message-ID: <20240606131755.312050163@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 33c563ebf8d3deed7d8addd20d77398ac737ef9a ]

Userspace assumes vlan header is present at a given offset, but vlan
offload allows to store this in metadata fields of the skbuff. Hence
mangling vlan results in a garbled packet. Handle this transparently by
adding a parser to the kernel.

If vlan metadata is present and payload offset is over 12 bytes (source
and destination mac address fields), then subtract vlan header present
in vlan metadata, otherwise mangle vlan metadata based on offset and
length, extracting data from the source register.

This is similar to:

  8cfd23e67401 ("netfilter: nft_payload: work around vlan header stripping")

to deal with vlan payload mangling.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 72 +++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a3cb5dbcb362c..0c43d748e23ae 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -145,12 +145,12 @@ int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
 	return pkt->inneroff;
 }
 
-static bool nft_payload_need_vlan_copy(const struct nft_payload *priv)
+static bool nft_payload_need_vlan_adjust(u32 offset, u32 len)
 {
-	unsigned int len = priv->offset + priv->len;
+	unsigned int boundary = offset + len;
 
 	/* data past ether src/dst requested, copy needed */
-	if (len > offsetof(struct ethhdr, h_proto))
+	if (boundary > offsetof(struct ethhdr, h_proto))
 		return true;
 
 	return false;
@@ -174,7 +174,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    nft_payload_need_vlan_copy(priv)) {
+		    nft_payload_need_vlan_adjust(priv->offset, priv->len)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
@@ -801,21 +801,79 @@ struct nft_payload_set {
 	u8			csum_flags;
 };
 
+/* This is not struct vlan_hdr. */
+struct nft_payload_vlan_hdr {
+	__be16			h_vlan_proto;
+	__be16			h_vlan_TCI;
+};
+
+static bool
+nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
+		     int *vlan_hlen)
+{
+	struct nft_payload_vlan_hdr *vlanh;
+	__be16 vlan_proto;
+	u16 vlan_tci;
+
+	if (offset >= offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)) {
+		*vlan_hlen = VLAN_HLEN;
+		return true;
+	}
+
+	switch (offset) {
+	case offsetof(struct vlan_ethhdr, h_vlan_proto):
+		if (len == 2) {
+			vlan_proto = nft_reg_load_be16(src);
+			skb->vlan_proto = vlan_proto;
+		} else if (len == 4) {
+			vlanh = (struct nft_payload_vlan_hdr *)src;
+			__vlan_hwaccel_put_tag(skb, vlanh->h_vlan_proto,
+					       ntohs(vlanh->h_vlan_TCI));
+		} else {
+			return false;
+		}
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
+		if (len != 2)
+			return false;
+
+		vlan_tci = ntohs(nft_reg_load_be16(src));
+		skb->vlan_tci = vlan_tci;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
 	const struct nft_payload_set *priv = nft_expr_priv(expr);
-	struct sk_buff *skb = pkt->skb;
 	const u32 *src = &regs->data[priv->sreg];
-	int offset, csum_offset;
+	int offset, csum_offset, vlan_hlen = 0;
+	struct sk_buff *skb = pkt->skb;
 	__wsum fsum, tsum;
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
 			goto err;
-		offset = skb_mac_header(skb) - skb->data;
+
+		if (skb_vlan_tag_present(skb) &&
+		    nft_payload_need_vlan_adjust(priv->offset, priv->len)) {
+			if (!nft_payload_set_vlan(src, skb,
+						  priv->offset, priv->len,
+						  &vlan_hlen))
+				goto err;
+
+			if (!vlan_hlen)
+				return;
+		}
+
+		offset = skb_mac_header(skb) - skb->data - vlan_hlen;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
 		offset = skb_network_offset(skb);
-- 
2.43.0



