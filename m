Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468484446F1;
	Tue, 21 Jul 2026 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667592; cv=none; b=IfxttDbnh6CwioVVAMM7JiiPZkog4Rytsg7j/Y8Ua9q7pV2DjuZgvFqcd/ifwsq78UMWu82JvGrbD4jGAdCL820jtHDjAMaie0qK4m7wnwtzj8UFV9jO8r2nS6xlN1LnMMCpv3GIngxXcmL2sRtP5NqL9Z6fTFQ42alJg65tHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667592; c=relaxed/simple;
	bh=f++HFQs+MfAwPRMQqqJ4Ow0HCYpijjH5325SN00q+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFR7MWB1vfb3KM6KrxG2BTcuBBuwgO8ZXgfNIYPC6iPPHRAsyKxhbnSQrRzEPYpYimo13vYycQAbwzHOoIVbuQ8QO8zvyrS2CZzFZYqVZGs6Gdu3CaprC9iVwpv74RksxnpsWeVhD2dM/rvRPZRqbhQepTX5CSxdiAQx+y1GF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UX9N4XvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UX9N4XvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC1B1F000E9;
	Tue, 21 Jul 2026 20:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667591;
	bh=tnOY8BxXrDLpE5xPWSly1AZlVrSuT/VxxG7ie4Lbmro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UX9N4XvFt104leLvpSam7epU7IZxDg+z/k7csOLa4cY+zOg3tEw37moLWnSsS+aJp
	 8DHFS9/ttBdZNSIKdOiLTs4M9qdmB1MbNzTRNB9Prtlz22jtKtH9aq5fUOLPLzn2sI
	 eg7EnVPd6c6oY2xF0lEJxNH14LputijokSno/Rr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1120/1266] macsec: dont read an unset MAC header in macsec_encrypt()
Date: Tue, 21 Jul 2026 17:25:57 +0200
Message-ID: <20260721152506.862686474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit f5089008f90c0a7c5520dff3934e0af00adf322d upstream.

macsec_encrypt() reads the Ethernet header via eth_hdr(skb)
(skb->head + skb->mac_header) to memmove() the 12 source/destination MAC
bytes forward and make room for the SecTAG.

On the AF_PACKET SOCK_RAW + PACKET_QDISC_BYPASS transmit path the skb
reaches the macsec ndo_start_xmit() with the MAC header unset, so
eth_hdr(skb) resolves to skb->head + (u16)~0 and the read is out of
bounds: a 12-byte heap over-read that is also emitted on the wire as the
frame's outer source/destination MAC. KASAN reports a slab-out-of-bounds
read in macsec_start_xmit() on 6.0; on current mainline a CONFIG_DEBUG_NET
build flags it as an unset mac header in skb_mac_header().

On the TX path the L2 header is at skb->data, so use skb_eth_hdr(), added
by commit 96cc4b69581d ("macvlan: do not assume mac_header is set in
macvlan_broadcast()") for exactly this purpose.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260703083634.2035145-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -638,7 +638,7 @@ static struct sk_buff *macsec_encrypt(st
 	}
 
 	unprotected_len = skb->len;
-	eth = eth_hdr(skb);
+	eth = skb_eth_hdr(skb);
 	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);


