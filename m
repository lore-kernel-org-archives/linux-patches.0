Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DBE3B9D80;
	Sat, 30 May 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164488; cv=none; b=snlCozVKLSkLmobxr8PR8Ck68C9PYOumcWxmaQFF8nZM4Oy3VZObZHxP0KiteycXjD6NGbjHynyu9qXMA23/YeVKdlMA9uM7hyYXQGzxq5xL8nkICg/tlO+oJH6m9HGo5+LDRlow6Q/MKcHmAHHP34Pd/60k1xpX45JwfQNC39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164488; c=relaxed/simple;
	bh=fuikr8N8v1vN6eDah3grtOPET1VEV44Fl/r2vxs0xdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K70RuFXWgWC2HLPyx7zWooft90fWoIOqPQDY3xRLekzaUOmSWzTzwa7vUuNfvvbxMqh21P9ZWaR/++5tu7ZXzuZ2ugQSl/lLQjOm4JPaNtvVGz19bFdrmBkH1sPdLxPDKfdJF8APDVP7SmUlsE5AW4PBOEQlfIx6x19SHnfMYOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqeu9RIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqeu9RIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473911F00893;
	Sat, 30 May 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164486;
	bh=SNFKFQ38kl55XjVPJl4JqsEfMtC3IZCyUav6Tj3nauA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqeu9RIaAuB1bCQqJRvg0YFNrSQ2RxuHKmng1SpijMHi0NbiCvUnZDh8s4AVipVE5
	 dLzvNR22OW5UcyALSuzBXt5cya3uzYmVm6jiyDAYR82/fOCCzMeaMBRB1LydzueSEP
	 x6/9Vq3o7p1UUOmy13EaMjImKSFmsnoeOivaGBkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 570/776] pppoe: drop PFC frames
Date: Sat, 30 May 2026 18:04:44 +0200
Message-ID: <20260530160254.842964923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bf75bc6954459..2b76a8695fdbe 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2244,7 +2244,7 @@ ppp_do_recv(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
  */
 static void __ppp_decompress_proto(struct sk_buff *skb)
 {
-	if (skb->data[0] & 0x01)
+	if (ppp_skb_is_compressed_proto(skb))
 		*(u8 *)skb_push(skb, 1) = 0x00;
 }
 
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index e172743948ed7..6ce4265d84f20 100644
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



