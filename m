Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE55A6E50;
	Mon, 31 Aug 2026 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184359; cv=none; b=oInZ5G7eJe9e8jVtqJZRzHYRVwdveQ+B+HgXsXf2VzHkmYUFEM+ZC4+ndHi2iXFMpcku1j6XdbE9NpuF6idPG+pl64TQLd5nELlodWYigFczH86cq4Wt35dwFUOSjp3CydvhejzPregp/QyEgyaRBLc+0Pd0WNC0nx48TPiKsTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184359; c=relaxed/simple;
	bh=H0MHDKg5nx0Et6yYXpc3jevHI+rVg3atUUJB/My48NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwRHiam41OkEVrWxI/fWoUHfK1DKaABe2QCBZKRK540VUXCzhLIG9e18gkyv2K43e5jILHDE7+cxv7LrE6/Jf/PzJ6gHRqMdoa29bHWRk+oUMp00A1zkuhvnDgreARrhU0ipii7HyD3ME6nSZBsZaD0C+KvKc97roW9CmMG4JqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y60GaGg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y60GaGg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57E71F00A3F;
	Mon, 31 Aug 2026 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184357;
	bh=irShOyeg22ueTBrq7LTRb8iPkj7Rklcrs4iziryxRB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y60GaGg3Z7mNYu8f1EWwxCTlsHQwGDnON06RodkKEzmHjoBjwYk9utofifh9ZLWUw
	 5DVcIo03dl7on1ACo/v68KUintdmlf58XiUzYsGTOnbf2aD3PMKXu7SM+AJppBF3qr
	 Ez3BN1IvByqNUnsRPM12qRgPEWSc2ieL3rauXRnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Sven Eckelmann <sven@narfation.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 79/99] batman-adv: reject unrepresentable multicast TVLV offsets
Date: Mon, 31 Aug 2026 15:34:48 +0200
Message-ID: <20260831133403.845394340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3055,6 +3055,30 @@ static inline void skb_set_transport_hea
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


