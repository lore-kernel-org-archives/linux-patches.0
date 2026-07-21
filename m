Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54350404BE9;
	Tue, 21 Jul 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655162; cv=none; b=vFcOpLKAQuMxE4FQi/paPlEsyHNtwb2UDEfhY5WKZWTtHoRVER2sO9XVSWGlpzesTflm+jepAyxj4MIUfQmhK2LjE55sH8+8eUpGUsZnmoi4qXkbPbJwi3ytiJ6BFBH3K2l2p9emn8eTtn2r+aVG++eUECfQVML1EgTwnYQ5nB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655162; c=relaxed/simple;
	bh=CoHughVHonWU/yTywyIKxMoe+iJWrs4qVz4kQVDFo4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH/5wLhHx2eCMjUIdEkgaUlAEilYE8D95+5bLY2MoSTHjUtsQuC7anApPw47nZY3uKGu/mmWuy+8/FP7c722qXh3szvECzW2QQ5apeXRGPKXLdp52ZKhOsweCOYDo0uzTfxM6A6LtvEjCsiuDOBTSvlMCGmwC6fKMLiaYJzve/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUcr/Iqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUcr/Iqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2321F000E9;
	Tue, 21 Jul 2026 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655161;
	bh=199XOfMXtlEgky+3kQrCKsZfsQTR6/qTTOn2RbYblwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUcr/IqcTgSzSfa19LOu/vTTFeUcvsO8VDPSZ96pqIB7aA2PhviRgxDCeTkfUlU9b
	 +D+R4J9Pq1ywHcAK0izyLygyeL8lqVArf675a+NnikxVqNciop0oI/OvQN2FgiOo4V
	 IF8Md0iuVC8f36BuVK45kFqvfg9xBmxTNFQpAbQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1977/2077] macsec: dont read an unset MAC header in macsec_encrypt()
Date: Tue, 21 Jul 2026 17:27:30 +0200
Message-ID: <20260721152639.338350550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -646,7 +646,7 @@ static struct sk_buff *macsec_encrypt(st
 	}
 
 	unprotected_len = skb->len;
-	eth = eth_hdr(skb);
+	eth = skb_eth_hdr(skb);
 	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);


