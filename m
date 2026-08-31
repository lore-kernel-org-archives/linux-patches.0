Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6DA5616A8;
	Mon, 31 Aug 2026 13:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184061; cv=none; b=SHHgp1W9CX0x/zJ4oCgffopNr2JBuUhiCGsN0xVq9E6hQmiU1U9kmcTKYBfezCIEvbG6m970jhjQEqVTEj5lsCSUvLQ0s9jlxavm5R4f7WNnikdinpDwPLEoFAo+pLe0OuUigxNNVivUR9Ag82nR+gK1xdou9ath5mcBPY7SmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184061; c=relaxed/simple;
	bh=tZOq31rH6usR92JVapKVRltw/zm+JPhfwEqzvjXPa8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bc/C3Vgz6T/UQSyVbUUS8/Bn/EQ7BMVG+6RlzKXAHKqiiU4R2OET/6E0rzayq/kJd0ABvhtw1XDPidOKjgMjDUMaZQKgI2K16Wn701T/ESdvtiR0eoa83AfhPZEVJiGeVHKtBvpZRhfOba77OZv2Kn63zwWG1RveEBoIvAFopug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Soy/h+0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Soy/h+0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89B71F00ADB;
	Mon, 31 Aug 2026 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184059;
	bh=xRvIvbw/5XiW6KoQUi1+p+ZVM3ENbzlq32RjDWdcH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Soy/h+0cghHeVzMPoauwqI/Gklaa3VcLaVNG57cWLi1x/RTJfGdL3DQYj7fdCk4VI
	 WMOCc6i3/iHrAfgqfkywsVn9iFgmDEeU/qMM/kbIBilowr9yOMuV5xQXnJf9eWq2S6
	 NLLtpXDgs4rD72n5+vUwJrOV8ONQWhJv7SlJiz+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Sven Eckelmann <sven@narfation.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 59/83] batman-adv: reject unrepresentable multicast TVLV offsets
Date: Mon, 31 Aug 2026 15:34:35 +0200
Message-ID: <20260831133402.535133129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit f12c2de4f542e3220e17e0606f492110064f04cb upstream.

The network and transport header fields in struct sk_buff are 16-bit
offsets from skb->head, and U16_MAX is reserved as the unset transport
header value. batadv_tvlv_call_handler() sets both fields from a received
multicast TVLV without checking whether the TVLV end is representable.

If the end offset exceeds the field's range, skb_set_transport_header()
truncates it so that the transport header precedes the network header.
The negative difference is then returned by skb_network_header_len() as
a large u32. batadv_mcast_forw_packet() consequently accepts an oversized
multicast tracker and accesses memory beyond the skb data.

Add skb_set_transport_header_careful(), an offset-aware counterpart to
skb_reset_transport_header_careful(), which validates the final
head-relative offset before assigning it. Use the new helper in
batadv_tvlv_call_handler() and reject unrepresentable TVLVs before
setting the network header.

Fixes: 07afe1ba288c ("batman-adv: mcast: implement multicast packet reception and forwarding")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Sven Eckelmann <sven@narfation.org>
Link: https://patch.msgid.link/20260817084955.944189-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   24 ++++++++++++++++++++++++
 net/batman-adv/tvlv.c  |    5 ++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3110,6 +3110,30 @@ static inline void skb_set_transport_hea
 	skb->transport_header += offset;
 }
 
+/**
+ * skb_set_transport_header_careful - conditionally set transport header
+ * @skb: buffer to alter
+ * @offset: offset to add to skb->data
+ *
+ * Hardened version of skb_set_transport_header().
+ *
+ * Returns: true if the operation was a success.
+ */
+static inline bool __must_check
+skb_set_transport_header_careful(struct sk_buff *skb, const int offset)
+{
+	long thoff = skb->data - skb->head + offset;
+
+	if (unlikely(thoff != (typeof(skb->transport_header))thoff))
+		return false;
+
+	if (unlikely(thoff == (typeof(skb->transport_header))~0U))
+		return false;
+
+	skb->transport_header = thoff;
+	return true;
+}
+
 static inline unsigned char *skb_network_header(const struct sk_buff *skb)
 {
 	return skb->head + skb->network_header;
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -420,8 +420,11 @@ static int batadv_tvlv_call_handler(stru
 			return NET_RX_SUCCESS;
 
 		tvlv_offset = (unsigned char *)tvlv_value - skb->data;
+		if (!skb_set_transport_header_careful(skb,
+						      tvlv_offset + tvlv_value_len))
+			return -EINVAL;
+
 		skb_set_network_header(skb, tvlv_offset);
-		skb_set_transport_header(skb, tvlv_offset + tvlv_value_len);
 
 		return tvlv_handler->mcast_handler(bat_priv, skb);
 	}


