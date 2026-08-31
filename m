Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB7519924;
	Mon, 31 Aug 2026 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183816; cv=none; b=NNedx0jfooD2p89xKjE6Gk6bpL9jCnRa6Ae0WvB3Ped6VYmnWXwszbxpu81fo+WmIY5PuHbcpKe7ui1nQfBHxxXyb4zUdLwk3/3IJpm24BRPJq4RhqjHXLKvpkZVxyIQswL68Mfk124+I/I0+HHZZzkAfHVKRa7jRZIqVADnsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183816; c=relaxed/simple;
	bh=gsapj6Cgiu0zQAEz+nI1jxrDGJS7S0kS/SBpjA3Os/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqvOykT6IKGLCzFn8mfd6cJdTPEEQkGXcTet0Fz74XC9P/fsqaqAfT2Fjd5p3uZBiGjGTb6b31B3sWK0dLICY6EJTm66AHr2JgYZkZWRikskaZo/AP/qYdXbbpXSNtGUQHE+4i+3Ma3vczy9AcB+IEpSVM4BKyuABzb6xUnAJnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXXXL7jZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXXXL7jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2161A1F00ACA;
	Mon, 31 Aug 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183813;
	bh=sEEEVjgic5nsCPtZxEJBSo+KQPj/jH2bK5iFfOIS7jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXXXL7jZUs2a97XMTuzMwRw7CNw9t+emXTm64gP7aV3sC7xEEHTFf7XlN3B2wbbtL
	 CDEwPU6+LOFWHYn+4o36KyxM6dpuvqveJv1zjZ1UqMcY373ZDIBWoBC77q4DFIU1eI
	 Nnp3UWlhvcEbZXyXu7rSdQ1CN15B/moqqzcJmlvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Sven Eckelmann <sven@narfation.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 50/76] batman-adv: reject unrepresentable multicast TVLV offsets
Date: Mon, 31 Aug 2026 15:34:22 +0200
Message-ID: <20260831133402.022344580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3127,6 +3127,30 @@ static inline void skb_set_transport_hea
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


