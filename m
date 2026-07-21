Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A9044AB91;
	Tue, 21 Jul 2026 22:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674214; cv=none; b=nHpOp+m1rKHDEG8/NQuqeMKA/7RfshZni37+dsr2HSADWJlFmgPT3l9tA3c+WQ8IDEOoSN/RhQA7k/bt9hEKN/UErbfRIz5HrSquAba3ULCc8ZFzYDxMeaeHDgVnMYx/CqM3g1rJlNl8yEGRh3pChXivtInchIK73CgKktdF3/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674214; c=relaxed/simple;
	bh=l2L48tAGfVluZCtrq6IACEz5gN0V5sTAuxGB2ozYg9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBMhrr3EinsGePlqa2qRT9UP/fZ06q8rbBSJEtpiy2/17Ci4TI0+YLZd08guWa64FwUHlgEroEZ6f4TOgSptKIstk2MZ/6wPwp1bg64uhQqE661995R4muzrY5AqDj5pDab1FEyg5SeuFS5t6v+zKP3HJ6n8FHZxgHQsrrmbcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NexUW2ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NexUW2ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F091F00A3A;
	Tue, 21 Jul 2026 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674213;
	bh=Ji9BZYCAcJbwHYzG9q9/j/Yn0wdWQiKeVr6WIHEC+sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NexUW2roXaKcPttPK98Snt7gXLrcApBy+q1IrvLpb3aeUA63ZedDl01LkRynIude2
	 6i21OLYnp4bmZXgFTxwUC1BHz2rqetaidaP20QeKH4BSKdxGYxiVtsJ86ppDceUBVb
	 ynvltnQIXBhxNZ0woVrqbrl4ygLF86RpnlWlIUEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/699] net: qualcomm: rmnet: validate MAP frame length before ingress parsing
Date: Tue, 21 Jul 2026 17:22:42 +0200
Message-ID: <20260721152404.786668682@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit f0f1887a9e30712a1df03e152dce6fb91344b1f3 ]

When ingress deaggregation is disabled, rmnet_map_ingress_handler() passes
the skb straight to __rmnet_map_ingress_handler(), skipping the length
validation that rmnet_map_deaggregate() performs on the aggregated path.
The parser then dereferences the MAP header and csum header/trailer based on
the on-wire pkt_len without checking skb->len, so a short frame is read out
of bounds:

  BUG: KASAN: slab-out-of-bounds in rmnet_map_checksum_downlink_packet
  Read of size 1 at addr ffff88801118ed00 by task exploit/147
  Call Trace:
   ...
   rmnet_map_checksum_downlink_packet (drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:413)
   __rmnet_map_ingress_handler (drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:96)
   rmnet_rx_handler (drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:129)
   __netif_receive_skb_core.constprop.0 (net/core/dev.c:6089)
   netif_receive_skb (net/core/dev.c:6460)
   tun_get_user (drivers/net/tun.c:1955)
   tun_chr_write_iter (drivers/net/tun.c:2001)
   vfs_write (fs/read_write.c:688)
   ksys_write (fs/read_write.c:740)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   ...

Factor that validation out of rmnet_map_deaggregate() into
rmnet_map_validate_packet_len() and run it on the no-aggregation path too.
The MAP header is bounds-checked first, since this path can receive a frame
shorter than the header.

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Suggested-by: Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Subash Abhinov Kasiviswanathan <subash.a.kasiviswanathan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260630174110.2003121-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  5 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  1 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 72 ++++++++++---------
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 9fec50a1969f14..8e5be431acaeb4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -125,7 +125,10 @@ rmnet_map_ingress_handler(struct sk_buff *skb,
 
 		consume_skb(skb);
 	} else {
-		__rmnet_map_ingress_handler(skb, port);
+		if (rmnet_map_validate_packet_len(skb, port))
+			__rmnet_map_ingress_handler(skb, port);
+		else
+			kfree_skb(skb);
 	}
 }
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 7a2718b7e359db..dbbec14dff5cf7 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -55,5 +55,6 @@ void rmnet_map_tx_aggregate_init(struct rmnet_port *port);
 void rmnet_map_tx_aggregate_exit(struct rmnet_port *port);
 void rmnet_map_update_ul_agg_config(struct rmnet_port *port, u32 size,
 				    u32 count, u32 time);
+u32 rmnet_map_validate_packet_len(struct sk_buff *skb, struct rmnet_port *port);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index d82af25f51cc2e..a655bb8d5c57bc 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -293,54 +293,62 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 	return map_header;
 }
 
-/* Deaggregates a single packet
- * A whole new buffer is allocated for each portion of an aggregated frame.
- * Caller should keep calling deaggregate() on the source skb until 0 is
- * returned, indicating that there are no more packets to deaggregate. Caller
- * is responsible for freeing the original skb.
- */
-struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
-				      struct rmnet_port *port)
+u32 rmnet_map_validate_packet_len(struct sk_buff *skb, struct rmnet_port *port)
 {
 	struct rmnet_map_v5_csum_header *next_hdr = NULL;
 	struct rmnet_map_header *maph;
 	void *data = skb->data;
-	struct sk_buff *skbn;
-	u8 nexthdr_type;
 	u32 packet_len;
 
-	if (skb->len == 0)
-		return NULL;
+	if (skb->len < sizeof(*maph))
+		return 0;
 
 	maph = (struct rmnet_map_header *)skb->data;
+
+	/* Some hardware can send us empty frames. Catch them */
+	if (!maph->pkt_len)
+		return 0;
+
 	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
-	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
-		if (!(maph->flags & MAP_CMD_FLAG)) {
-			packet_len += sizeof(*next_hdr);
-			if (maph->flags & MAP_NEXT_HEADER_FLAG)
-				next_hdr = data + sizeof(*maph);
-			else
-				/* Mapv5 data pkt without csum hdr is invalid */
-				return NULL;
-		}
+	} else if ((port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) &&
+		   !(maph->flags & MAP_CMD_FLAG)) {
+		/* Mapv5 data pkt without csum hdr is invalid */
+		if (!(maph->flags & MAP_NEXT_HEADER_FLAG))
+			return 0;
+
+		packet_len += sizeof(*next_hdr);
+		next_hdr = data + sizeof(*maph);
 	}
 
-	if (((int)skb->len - (int)packet_len) < 0)
-		return NULL;
+	if (skb->len < packet_len)
+		return 0;
 
-	/* Some hardware can send us empty frames. Catch them */
-	if (!maph->pkt_len)
-		return NULL;
+	if (next_hdr &&
+	    u8_get_bits(next_hdr->header_info, MAPV5_HDRINFO_HDR_TYPE_FMASK) !=
+	    RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
+		return 0;
 
-	if (next_hdr) {
-		nexthdr_type = u8_get_bits(next_hdr->header_info,
-					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
-		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
-			return NULL;
-	}
+	return packet_len;
+}
+
+/* Deaggregates a single packet
+ * A whole new buffer is allocated for each portion of an aggregated frame.
+ * Caller should keep calling deaggregate() on the source skb until 0 is
+ * returned, indicating that there are no more packets to deaggregate. Caller
+ * is responsible for freeing the original skb.
+ */
+struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
+				      struct rmnet_port *port)
+{
+	struct sk_buff *skbn;
+	u32 packet_len;
+
+	packet_len = rmnet_map_validate_packet_len(skb, port);
+	if (!packet_len)
+		return NULL;
 
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
 	if (!skbn)
-- 
2.53.0



