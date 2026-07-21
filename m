Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED4143C7DA;
	Tue, 21 Jul 2026 22:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674077; cv=none; b=aElZ8Yltz5b70fHURqNp2XPs+QaXIC1vL12hC19yFdZRm6SZ1LR6lQhyD+J4XpZuy6cPEgRp8x/KlHZxOD+mT+mXKve1zMLXwSKmedPgUJ214/zNtp3ITKPSS5nmfEw5ubfJVL11inAOB2Y4gg0XO2tdIbcanK9O08RJXpolNEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674077; c=relaxed/simple;
	bh=6rf0j371FLqn4DoAnRKou3fp54AlIp8IjMieVThnnFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/Nsu2SfBLhNwAnLgAE6ZkwT2RgOwTFY1LRWww1jodMA2mZjmVFDyXLUaXoKcdGPJfFzHbqMoTqmUPmqN5SeQcP/dcVJg3E1bbpKpHXN1xn3N++vuL2hbBsh2V22yfTtnXI+ZPTnEsHs/5Ilhv4mB54bDHLfLPAL4qCjeYO+dd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDfR8r4W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDfR8r4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0838B1F000E9;
	Tue, 21 Jul 2026 22:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674072;
	bh=F8L8zSy6LrkP3BxTxSljp/G3KWo+6vLfWH3h4xawHos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDfR8r4WXf53YIIFGQadKHtYRRde97hajh3uzDtiWeAkA7K77COJ+arFiAERb2Xzc
	 zCtbsvExKB/H9VTcDGP1exRu5lZhld35Xb7yt5Z12NzzRTWBFUhQcpETLXQNDhM9RA
	 uhlMuBJHzaZIlzNcGWhylplstXCRIvyDAuLIxtpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharath Chandra Vurukala <sharathv@codeaurora.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/699] net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
Date: Tue, 21 Jul 2026 17:22:40 +0200
Message-ID: <20260721152404.742524707@linuxfoundation.org>
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

From: Sharath Chandra Vurukala <sharathv@codeaurora.org>

[ Upstream commit e1d9a90a9bfdb0735062d3adb16b07314b4b7b01 ]

Adding support for processing of MAPv5 downlink packets.
It involves parsing the Mapv5 packet and checking the csum header
to know whether the hardware has validated the checksum and is
valid or not.

Based on the checksum valid bit the corresponding stats are
incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
or left as CHEKSUM_NONE to let network stack revalidate the checksum
and update the respective snmp stats.

Current MAPV1 header has been modified, the reserved field in the
Mapv1 header is now used for next header indication.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f0f1887a9e30 ("net: qualcomm: rmnet: validate MAP frame length before ingress parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 17 ++++--
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  3 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 57 ++++++++++++++++++-
 include/linux/if_rmnet.h                      | 30 +++++++++-
 include/uapi/linux/if_link.h                  |  1 +
 5 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 1103f9e873b7d8..f50112f75d5077 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data ingress/egress handler
  */
@@ -82,11 +82,16 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 
 	skb->dev = ep->egress_dev;
 
-	/* Subtract MAP header */
-	skb_pull(skb, sizeof(struct rmnet_map_header));
-	rmnet_set_skb_proto(skb);
-
-	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+	if ((port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) &&
+	    (map_header->flags & MAP_NEXT_HEADER_FLAG)) {
+		if (rmnet_map_process_next_hdr_packet(skb, len))
+			goto free_skb;
+		skb_pull(skb, sizeof(*map_header));
+		rmnet_set_skb_proto(skb);
+	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+		/* Subtract MAP header */
+		skb_pull(skb, sizeof(*map_header));
+		rmnet_set_skb_proto(skb);
 		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 2aea153f42473a..1a399bfa07d254 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  */
 
 #ifndef _RMNET_MAP_H_
@@ -48,5 +48,6 @@ void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
 int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
 void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 				      struct net_device *orig_dev);
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 4ee59034f8fb2b..a8326f23736c2b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data MAP protocol
  */
@@ -8,6 +8,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
+#include <linux/bitfield.h>
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
@@ -300,8 +301,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 				      struct rmnet_port *port)
 {
+	struct rmnet_map_v5_csum_header *next_hdr = NULL;
 	struct rmnet_map_header *maph;
+	void *data = skb->data;
 	struct sk_buff *skbn;
+	u8 nexthdr_type;
 	u32 packet_len;
 
 	if (skb->len == 0)
@@ -310,8 +314,18 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	maph = (struct rmnet_map_header *)skb->data;
 	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
 
-	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
+	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
+		if (!(maph->flags & MAP_CMD_FLAG)) {
+			packet_len += sizeof(*next_hdr);
+			if (maph->flags & MAP_NEXT_HEADER_FLAG)
+				next_hdr = data + sizeof(*maph);
+			else
+				/* Mapv5 data pkt without csum hdr is invalid */
+				return NULL;
+		}
+	}
 
 	if (((int)skb->len - (int)packet_len) < 0)
 		return NULL;
@@ -320,6 +334,13 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (!maph->pkt_len)
 		return NULL;
 
+	if (next_hdr) {
+		nexthdr_type = u8_get_bits(next_hdr->header_info,
+					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
+		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
+			return NULL;
+	}
+
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
 	if (!skbn)
 		return NULL;
@@ -414,3 +435,35 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 	priv->stats.csum_sw++;
 }
+
+/* Process a MAPv5 packet header */
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
+				      u16 len)
+{
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+	struct rmnet_map_v5_csum_header *next_hdr;
+	u8 nexthdr_type;
+
+	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
+			sizeof(struct rmnet_map_header));
+
+	nexthdr_type = u8_get_bits(next_hdr->header_info,
+				   MAPV5_HDRINFO_HDR_TYPE_FMASK);
+
+	if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
+		return -EINVAL;
+
+	if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+		priv->stats.csum_sw++;
+	} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
+		priv->stats.csum_ok++;
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	} else {
+		priv->stats.csum_valid_unset++;
+	}
+
+	/* Pull csum v5 header */
+	skb_pull(skb, sizeof(*next_hdr));
+
+	return 0;
+}
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 484c1ccfd87d5f..b5ce32bda82613 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only
- * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
  */
 
 #ifndef _LINUX_IF_RMNET_H_
@@ -12,10 +12,12 @@ struct rmnet_map_header {
 }  __aligned(1);
 
 /* rmnet_map_header flags field:
- *  PAD_LEN:	number of pad bytes following packet data
- *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ *  PAD_LEN:	  number of pad bytes following packet data
+ *  CMD:	  1 = packet contains a MAP command; 0 = packet contains data
+ *  NEXT_HEADER: 1 = packet contains V5 CSUM header 0 = no V5 CSUM header
  */
 #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
+#define MAP_NEXT_HEADER_FLAG		BIT(6)
 #define MAP_CMD_FLAG			BIT(7)
 
 struct rmnet_map_dl_csum_trailer {
@@ -48,4 +50,26 @@ struct rmnet_map_ul_csum_header {
 #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
 #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
 
+/* MAP CSUM headers */
+struct rmnet_map_v5_csum_header {
+	u8 header_info;
+	u8 csum_info;
+	__be16 reserved;
+} __aligned(1);
+
+/* v5 header_info field
+ * NEXT_HEADER: represents whether there is any next header
+ * HEADER_TYPE: represents the type of this header
+ *
+ * csum_info field
+ * CSUM_VALID_OR_REQ:
+ * 1 = for UL, checksum computation is requested.
+ * 1 = for DL, validated the checksum and has found it valid
+ */
+
+#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
+#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, 1)
+#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
+
+#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
 #endif /* !(_LINUX_IF_RMNET_H_) */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 33c3b684f6de46..c0190ac8a37093 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1232,6 +1232,7 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
2.53.0



