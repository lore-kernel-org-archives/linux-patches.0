Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF3F44AB6A;
	Tue, 21 Jul 2026 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674072; cv=none; b=RFq8sde2UP6NUDdOIB1BEjo/3g7Oj+UJG4hN1IanrS3RPqhZyVegPkRmyZcBn8joVhOQmqd0JWB/WavL5LDEsjuEcxxcBR+BF45wZK3rQbk3TtrPbZ7rYoHMOvgDkxATJ1/thTvQrKl2JnSf273SvHN/U/oN8/xOf35F5kjWSMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674072; c=relaxed/simple;
	bh=gDu4jNpSBtJBVOnrKPgV9ZrLpGBMJvvMP7BrCaeNcsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjwiuUXQDglBNT2qgfVb7y8jnRchkMgkRAKBuo2g13nzLisGpEQ8xYlaWylk/zqjkG+06me60jANV7WNQDV3JOkHx/PYRqZBbPpO0f8GeZMBEsC2l/Fd+VH/5SPC+yXk+fsUpoFSY9RkS9POOunIotdVMIFlC4ZnjPVuEZQq100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMqqiZDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMqqiZDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79361F00A3A;
	Tue, 21 Jul 2026 22:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674067;
	bh=Iy8X26MTvzQ0EX45CWdj4/199fAV6Nzdep5quYLCokg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMqqiZDakMGA17l5Ft4ORjsdUmf4Ru8GFy3m+OWgEEUxkDPIGRnljoefd0Z9gkOit
	 tGlOsH3q8NZ+IUi9ryjQnbX1h/ub8sd38G8WVrETZwlljcz/qkstFwQiW6+Gs3jN5A
	 0TEMsxp5aX0gDrQNcj/Dus7TLZOgHh8foqLb6hP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/699] net: qualcomm: rmnet: use masks instead of C bit-fields
Date: Tue, 21 Jul 2026 17:22:38 +0200
Message-ID: <20260721152404.698216315@linuxfoundation.org>
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

[ Upstream commit 16653c16d282e768763b2e8cc78f75df8fd53992 ]

The actual layout of bits defined in C bit-fields (e.g. int foo : 3)
is implementation-defined.  Structures defined in <linux/if_rmnet.h>
address this by specifying all bit-fields twice, to cover two
possible layouts.

I think this pattern is repetitive and noisy, and I find the whole
notion of compiler "bitfield endianness" to be non-intuitive.

Stop using C bit-fields for the command/data flag and the pad length
fields in the rmnet_map structure, and define a single-byte flags
field instead.  Define a mask for the single-bit "command" flag,
and another mask for the encoded pad length.  The content of both
fields can be accessed using a simple bitwise AND operation.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f0f1887a9e30 ("net: qualcomm: rmnet: validate MAP frame length before ingress parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  4 ++--
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +++-
 include/linux/if_rmnet.h                      | 23 ++++++++-----------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index df924f7a1f4c72..1103f9e873b7d8 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -61,7 +61,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	u16 len, pad;
 	u8 mux_id;
 
-	if (map_header->cd_bit) {
+	if (map_header->flags & MAP_CMD_FLAG) {
 		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
@@ -70,7 +70,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	}
 
 	mux_id = map_header->mux_id;
-	pad = map_header->pad_len;
+	pad = map_header->flags & MAP_PAD_LEN_MASK;
 	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3af68368fc3155..e7d0394cb29791 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -280,6 +280,7 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 		return map_header;
 	}
 
+	BUILD_BUG_ON(MAP_PAD_LEN_MASK < 3);
 	padding = ALIGN(map_datalen, 4) - map_datalen;
 
 	if (padding == 0)
@@ -293,7 +294,8 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-	map_header->pad_len = padding & 0x3F;
+	/* This is a data packet, so the CMD bit is 0 */
+	map_header->flags = padding & MAP_PAD_LEN_MASK;
 
 	return map_header;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 9661416a9bb473..eb4099eae84b26 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -6,21 +6,18 @@
 #define _LINUX_IF_RMNET_H_
 
 struct rmnet_map_header {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u8  pad_len:6;
-	u8  reserved_bit:1;
-	u8  cd_bit:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u8  cd_bit:1;
-	u8  reserved_bit:1;
-	u8  pad_len:6;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
-	u8  mux_id;
-	__be16 pkt_len;
+	u8 flags;			/* MAP_CMD_FLAG, MAP_PAD_LEN_MASK */
+	u8 mux_id;
+	__be16 pkt_len;			/* Length of packet, including pad */
 }  __aligned(1);
 
+/* rmnet_map_header flags field:
+ *  PAD_LEN:	number of pad bytes following packet data
+ *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ */
+#define MAP_PAD_LEN_MASK		GENMASK(5, 0)
+#define MAP_CMD_FLAG			BIT(7)
+
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.53.0



