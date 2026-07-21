Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6267D3C73F6;
	Tue, 21 Jul 2026 22:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674075; cv=none; b=hJrrzhc0EmpEr0oZ5Cz97RyZjV2JX2vQaC697aDW3uf9Wh9d5o27/If2PCwHkfty0+FRBkMHy/5h1YM1+2dft5CRULKb3k4WspyreDgQ+MsCCkMPiX1pmMWFHBmKSvNAjHa6/5Z5vqH89Gk/ns/Vs/J93N5EZncFM5xseB4IRZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674075; c=relaxed/simple;
	bh=L6gGe9hmw8KsObn8j1jKS+43f5NZOnljMsTv0ZiuVAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3Qp7YI3WMHfJ3JVRVMFUVEgfKFj+/21pSuXDXvYl6aTUFuZLHpVMggc6SuMA2nuQ2E+XfQvNBf77NhIMaMA6H7zAb7wrSxW+VDfpXBd55Q5N/6Pi2Y7iP0s27LlVSsbzriCgWWE2dkxnCMBN4yRDKyquKfYhyP1S98gI25uR/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7Ik/m/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7Ik/m/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612BD1F00A3D;
	Tue, 21 Jul 2026 22:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674069;
	bh=tPcx2/qX1K1I4CmrlB3Xx5wAJcuLIdfXwBa1mbWSFaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7Ik/m/SJzOvhncls3AhWDXbmO5hDnrVf6CVbG4jwMWX7BYP2+5OrzI/S2qVjWIDE
	 FuOShIvI0ooXNNv7GFxvMFrDxP7NgjuENFaP/5i2zUUL7AG9WMfx0t2sGR/bvYN3b2
	 z4P54PkfrELggjLTXY6P9AWunqoweJBMWWEUl3Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/699] net: qualcomm: rmnet: dont use C bit-fields in rmnet checksum header
Date: Tue, 21 Jul 2026 17:22:39 +0200
Message-ID: <20260721152404.720551427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@linaro.org>

[ Upstream commit 86ca860e12ec0feab7d721d3b05e60fb86613540 ]

Replace the use of C bit-fields in the rmnet_map_ul_csum_header
structure with a single two-byte (big endian) structure member,
and use masks to encode or get values within it.  The content of
these fields can be accessed using simple bitwise AND and OR
operations on the (host byte order) value of the new structure
member.

Previously rmnet_map_ipv4_ul_csum_header() would update C bit-field
values in host byte order, then forcibly fix their byte order using
a combination of byte swap operations and types.

Instead, just compute the value that needs to go into the new
structure member and save it with a simple byte-order conversion.

Make similar simplifications in rmnet_map_ipv6_ul_csum_header().

Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
zeroes every field in the upload checksum header.  Replace that with
a single memset() operation.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f0f1887a9e30 ("net: qualcomm: rmnet: validate MAP frame length before ingress parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 38 +++++++------------
 include/linux/if_rmnet.h                      | 21 +++++-----
 2 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index e7d0394cb29791..4ee59034f8fb2b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,20 +197,16 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct iphdr *ip4h = iphdr;
+	u16 val;
 
-	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -237,21 +233,16 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct ipv6hdr *ip6h = ip6hdr;
+	u16 val;
 
-	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
-
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip6h->nexthdr == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -419,10 +410,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	}
 
 sw_csum:
-	ul_header->csum_start_offset = 0;
-	ul_header->csum_insert_offset = 0;
-	ul_header->csum_enabled = 0;
-	ul_header->udp_ind = 0;
+	memset(ul_header, 0, sizeof(*ul_header));
 
 	priv->stats.csum_sw++;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index eb4099eae84b26..484c1ccfd87d5f 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -36,17 +36,16 @@ struct rmnet_map_dl_csum_trailer {
 
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u16 csum_insert_offset:14;
-	u16 udp_ind:1;
-	u16 csum_enabled:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u16 csum_enabled:1;
-	u16 udp_ind:1;
-	u16 csum_insert_offset:14;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
+	__be16 csum_info;		/* MAP_CSUM_UL_* */
 } __aligned(1);
 
+/* csum_info field:
+ *  OFFSET:	where (offset in bytes) to insert computed checksum
+ *  UDP:	1 = UDP checksum (zero checkum means no checksum)
+ *  ENABLED:	1 = checksum computation requested
+ */
+#define MAP_CSUM_UL_OFFSET_MASK		GENMASK(13, 0)
+#define MAP_CSUM_UL_UDP_FLAG		BIT(14)
+#define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
+
 #endif /* !(_LINUX_IF_RMNET_H_) */
-- 
2.53.0



