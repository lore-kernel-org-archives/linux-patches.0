Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0652842EEDD;
	Mon, 17 Aug 2026 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978675; cv=none; b=bu03JCd+f113Gpy5kNPUFpTqO9J7TIP4I7Vm9qPury8p6II4qgaHihSheR4o6V+egagTdVUlH+u2FAlBbQeL04bOmtKK8w1zuHgXJGNZ2CA8cBeM+OCfVHAeFgoPOMhk/Qv8J+X0l5Y/Aljuauu0Ks0D5N+FJRU16t0Yd+f/wc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978675; c=relaxed/simple;
	bh=xbiXhD/IWv7sBOxX8VF+9f8E8wseHjmdzcE2dFIQjTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcBhRP0DUsAeRkBoE83rB4WEpSXvSr/LykP00wNNWTfkBDdycWJIpUInDiRjjrwyGMq0GVC6w44eJRoKqniXuxNmx+iJv7VWkjukqabQ0/qi3M0Pl3HitCX3qN4nRj0rHLhdccprg6tz1OP/h8deP7PZ7T2f4prsaOkZAwLVjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUOzlaZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUOzlaZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602371F000E9;
	Mon, 17 Aug 2026 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978673;
	bh=BGZYa+g/OdKQ8jVEZ+tbg6fsiP5f67FEFrTPR15e7js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUOzlaZAMaJaV0rMHE6CmcNgsKbLZeguRbfObRDSjCzHHbujUfAgu8byDf63kxzHW
	 trIeCiKLbhpeOKmdBraxGYvX37WYWgPsVMgac/W5ETzyyzfPOp9lbnC6jZh7ksn1Sg
	 wH6JBavTaHRkc5poqe68KZM3f+k51y4qkzypzwzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 081/156] net/packet: reset the MAC header on the packet-socket transmit path
Date: Mon, 17 Aug 2026 15:33:35 +0200
Message-ID: <20260817132537.770205084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit c2707480cfbf19c7619acc9c089d17f20869821f upstream.

packet_parse_headers() resets the MAC header only for a SOCK_RAW frame
whose socket did not bind a protocol. A protocol-bound SOCK_RAW socket,
any SOCK_DGRAM frame, and the legacy SOCK_PACKET path therefore leave
skb->mac_header unset here.

For frames sent via __dev_queue_xmit() this is harmless: it resets the
MAC header unconditionally. But the packet-socket PACKET_QDISC_BYPASS
path uses dev_direct_xmit(), which does not, so the frame reaches
ndo_start_xmit() with the MAC header unset. A driver that reads
eth_hdr(skb) on transmit then dereferences skb->head + (u16)~0, an
out-of-bounds access ~64 KiB past the head -- the same class fixed for
one consumer in commit f5089008f90c ("macsec: do not read an unset MAC
header in macsec_encrypt()").

packet_parse_headers() runs only on the transmit path, where skb->data
points at the start of the L2 header for every packet-socket type
regardless of its length: SOCK_RAW and SOCK_PACKET carry a user-supplied
header and SOCK_DGRAM has one built by dev_hard_header(). Reset the MAC
header unconditionally, mirroring __dev_queue_xmit(), so the frame is
anchored on the bypass path too.

Found by 0sec (https://0sec.ai) using automated source analysis;
verified against source and matched to the macsec KASAN report in
f5089008f90c. Compile-tested.

Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided by user")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260724144015.63219-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1976,11 +1976,12 @@ static void packet_parse_headers(struct
 {
 	int depth;
 
+	/* On TX skb->data is the L2 header; anchor it for all socket types. */
+	skb_reset_mac_header(skb);
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
-	    sock->type == SOCK_RAW) {
-		skb_reset_mac_header(skb);
+	    sock->type == SOCK_RAW)
 		skb->protocol = dev_parse_header_protocol(skb);
-	}
 
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&


