Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E7025B08A;
	Sat, 30 May 2026 18:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166662; cv=none; b=MoLVBf+g2yROCt7nEyg/CUlqw8ly+MVdnDw2j3iRzrykgr5sNDIOKfpi6dqmxwJZDgDqELaG+O9ToPM7MQ0X+KhMFJ8GLys346TAFtkZMsAn+Dl58mL6dWmNoqxkaezLgLc0VgnI43+deZucdvhAi1++BFLPAWi/PCIHPQQJcnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166662; c=relaxed/simple;
	bh=ToYk+MnYRTX1F6ZhnYDigdVoGUjnwUd5YyV3YMxRHQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV2VZallK5zeq003QOS/LGx+dKThy3FswOd7t+1g1/DpuV8gws3E1uW7MzdFFr8d6mNXP7QbmSCRFkzyNZhWd/sFK+JxSVgAH7QO61jdOgg5HszzQiXiPJx5j2O8ZDCGUlmyCs9887eg5wnevA6Fp9YXR0OXZe91M9HWav2587g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrj3mjkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrj3mjkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0911F00893;
	Sat, 30 May 2026 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166660;
	bh=PNcpHB8b7a7pEl60EwV+UvwwP+sK6BlYS6HC8W02G+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zrj3mjkHF1oufdNqGcu2eyJ0m44tf+1uOkMBUjv3q1QFY4iI8gIlxvc6Zmmm/cyg5
	 W4BC5mBerlWt040aId3OaaOsPeeEZMXY09vMSER4ElKxn9VPoaX6t6cDdMd/R2j0r2
	 kuGddU+aAcoRrNAAxojKBWs8x7ArZK9o8zi+oPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/589] pppoe: drop PFC frames
Date: Sat, 30 May 2026 18:05:12 +0200
Message-ID: <20260530160236.046475783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit cc1ff87bce1ccd38410ab10960f576dcd17db679 ]

RFC 2516 Section 7 states that Protocol Field Compression (PFC) is NOT
RECOMMENDED for PPPoE. In practice, pppd does not support negotiating
PFC for PPPoE sessions, and the current PPPoE driver assumes an
uncompressed (2-byte) protocol field. However, the generic PPP layer
function ppp_input() is not aware of the negotiation result, and still
accepts PFC frames.

If a peer with a broken implementation or an attacker sends a frame with
a compressed (1-byte) protocol field, the subsequent PPP payload is
shifted by one byte. This causes the network header to be 4-byte
misaligned, which may trigger unaligned access exceptions on some
architectures.

To reduce the attack surface, drop PPPoE PFC frames. Introduce
ppp_skb_is_compressed_proto() helper function to be used in both
ppp_generic.c and pppoe.c to avoid open-coding.

Fixes: 7fb1b8ca8fa1 ("ppp: Move PFC decompression to PPP generic layer")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260415022456.141758-2-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c |  2 +-
 drivers/net/ppp/pppoe.c       |  8 +++++++-
 include/linux/ppp_defs.h      | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index a15b3eebb6d62..262d9be4f449e 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2108,7 +2108,7 @@ ppp_do_recv(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
  */
 static void __ppp_decompress_proto(struct sk_buff *skb)
 {
-	if (skb->data[0] & 0x01)
+	if (ppp_skb_is_compressed_proto(skb))
 		*(u8 *)skb_push(skb, 1) = 0x00;
 }
 
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index d7f50b835050d..75114c630b1a7 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -425,7 +425,7 @@ static int pppoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb_mac_header_len(skb) < ETH_HLEN)
 		goto drop;
 
-	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
+	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
 		goto drop;
 
 	ph = pppoe_hdr(skb);
@@ -435,6 +435,12 @@ static int pppoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->len < len)
 		goto drop;
 
+	/* skb->data points to the PPP protocol header after skb_pull_rcsum.
+	 * Drop PFC frames.
+	 */
+	if (ppp_skb_is_compressed_proto(skb))
+		goto drop;
+
 	if (pskb_trim_rcsum(skb, len))
 		goto drop;
 
diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index b7e57fdbd4139..b1d1f46d7d3be 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -8,6 +8,7 @@
 #define _PPP_DEFS_H_
 
 #include <linux/crc-ccitt.h>
+#include <linux/skbuff.h>
 #include <uapi/linux/ppp_defs.h>
 
 #define PPP_FCS(fcs, c) crc_ccitt_byte(fcs, c)
@@ -25,4 +26,19 @@ static inline bool ppp_proto_is_valid(u16 proto)
 	return !!((proto & 0x0101) == 0x0001);
 }
 
+/**
+ * ppp_skb_is_compressed_proto - checks if PPP protocol in a skb is compressed
+ * @skb: skb to check
+ *
+ * Check if the PPP protocol field is compressed (the least significant
+ * bit of the most significant octet is 1). skb->data must point to the PPP
+ * protocol header.
+ *
+ * Return: Whether the PPP protocol field is compressed.
+ */
+static inline bool ppp_skb_is_compressed_proto(const struct sk_buff *skb)
+{
+	return unlikely(skb->data[0] & 0x01);
+}
+
 #endif /* _PPP_DEFS_H_ */
-- 
2.53.0



