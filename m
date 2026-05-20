Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F391C3BFC;
	Wed, 20 May 2026 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299089; cv=none; b=PHGFzhCKIL7kV5WjZvhQ/f0S2RvoE9WmW6g9BO/3iqOg6D9wcPVevIZ9xnXowIJKGjI2xSiUU2qV4tSUyHtNR+MOIqQR7jJzT6GWL6wixS1KCvkInNShb17YIUtAdatTVCp1KeQ313YaKWCe1TVvPxK/G48fg8cQnLrb/YszNRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299089; c=relaxed/simple;
	bh=izHDFFXT9eArpBO7JORJDP6XdMrEa666SFSJAMlUFlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrBQcYaz60erhlpulCyBeXb1IfHZmYMWDYTYyvLv3Lxbei3VCeDW2rUXa3uXDcOFdAf+XqOV+AE8p4cXAOh8fIrMZoUAxqNQDVBz1rcfmBeQQz1QR8vXEip0e2pEFFnKXsh8zm6WkakJBqmmauYSW24sUNO3gDz0UIvNNLMvqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZxwowGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZxwowGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED791F000E9;
	Wed, 20 May 2026 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299088;
	bh=D5aZGY6fyIK0yqooXj3FCM2D31dhDeNi39WLNNLuTx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZxwowGp1U8K/oH/wRyACs0zSOJby295Ep5iDcqQPBKcDIzzUKm7XCv/QadFw2TTa
	 xaEvTbWL7fVu4YyYoubeMuF6JOlUlt3JfmVzGQwOmGiEILf2aCvF1TCwXIM4uhm9TT
	 JJQ88H8tsD63I5S4PVrZ7Rl0jjh5L+eoht0EibGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 656/957] pppoe: drop PFC frames
Date: Wed, 20 May 2026 18:18:59 +0200
Message-ID: <20260520162148.758807104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 7ad6c241c3295..507d216256c0d 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2240,7 +2240,7 @@ ppp_do_recv(struct ppp *ppp, struct sk_buff *skb, struct channel *pch)
  */
 static void __ppp_decompress_proto(struct sk_buff *skb)
 {
-	if (skb->data[0] & 0x01)
+	if (ppp_skb_is_compressed_proto(skb))
 		*(u8 *)skb_push(skb, 1) = 0x00;
 }
 
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 4ac6afce267b9..dc6d139432387 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -424,7 +424,7 @@ static int pppoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb_mac_header_len(skb) < ETH_HLEN)
 		goto drop;
 
-	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
+	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
 		goto drop;
 
 	ph = pppoe_hdr(skb);
@@ -434,6 +434,12 @@ static int pppoe_rcv(struct sk_buff *skb, struct net_device *dev,
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



