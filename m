Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DD137F00C;
	Thu, 20 Aug 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247259; cv=none; b=lUPbtIdRvudqQB7Ay/sJgEfiM71uW+jDNpz7qDmouGcIk9ZaWoKsJhid22E7xWQjZzuVmFk4YHFA09dXjsMOqcKWI3KZ6aAmfFINf4w+Zb19d+fq3Tos5RDV9/bBzXVKOg+Dwbrsg8Z8JRBdHcG/07MgcXJ6YuPY57ueVTlnJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247259; c=relaxed/simple;
	bh=188MXP88bf/AYQLdL2x9xhE1Khuc2lDvuH3NiTMHOC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGANSsyaKsUcI7ZDrCqpqiS5/9PU6ZPXN6+UEXTmyyNnTXjAdBKjcrNS7klOeJcaf76n8Mh+6wPXny3JUDRdf1GjglnnHsy1fApoDVFb5qU1MiqMWRKwTRJ0tf7FDv5q7QyTh7aTSk2Czwm6E4LGMFdhD0Fmis0KbafLQTF5s/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h61v9uDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h61v9uDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27B41F000E9;
	Thu, 20 Aug 2026 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247258;
	bh=JvJ7bNUCuVW0/+QlzSfLt/hZhtU+V/ZTIAwnsm6undc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h61v9uDKWscZJxop4ioKXZlwuF5NO1vWs3bXE3MFJyVhbXlGtR9VWpo6WBaISGrlS
	 kCZncpWY4ZRiybUR/hGyefnu3WwabWnzdWzorV7VDzLBgqj6wntJ916LP2ugzmn1/1
	 F14fhuQyOEMy4l9VqwRVL3cTVTJlo3mf1CO1p/sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/220] net: packet: fix wrong transport_header when sending VLAN-tagged frame
Date: Thu, 20 Aug 2026 16:56:34 +0200
Message-ID: <20260820145229.643947845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 01fdecc0480d916c799dbee584833a4a37e94d06 ]

In packet_parse_headers(), when processing a VLAN-tagged frame,
skb_set_network_header() is called to advance network_header past the
VLAN tag to the inner protocol header. skb_probe_transport_header() is
then called with skb->protocol still set to the outer VLAN EtherType
(e.g. ETH_P_8021Q), while nhoff (derived from skb_network_offset())
already points past the VLAN tag to the inner protocol header.

In __skb_flow_dissect(), proto is initialized to ETH_P_8021Q and nhoff
points past the VLAN tag. When the dissector hits case ETH_P_8021Q, it
reads a struct vlan_hdr at nhoff via __skb_header_pointer(), but that
offset contains the inner protocol header (e.g. an IP header). The bytes
are misinterpreted as a VLAN header, yielding a garbage encapsulated
EtherType that matches no known protocol. The dissector returns false,
so skb_probe_transport_header() never calls skb_set_transport_header(),
leaving transport_header at its uninitialized sentinel value (~0U).

Move skb_probe_transport_header() to before skb_set_network_header(). At
the time skb_probe_transport_header() is called, network_header still
points to the VLAN header, so nhoff correctly points to the VLAN header.
The flow dissector can then parse the VLAN header, extract the inner
EtherType, and advance nhoff to the inner protocol header, allowing
transport_header to be set correctly.

Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
Assisted-by: WChat:claude-opus-4-8
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260807063405.688780-2-wei.fang@oss.nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 102055a8c1d65..6a12d9c704a91 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1995,13 +1995,13 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 	    sock->type == SOCK_RAW)
 		skb->protocol = dev_parse_header_protocol(skb);
 
+	skb_probe_transport_header(skb);
+
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&
 	    eth_type_vlan(skb->protocol) &&
 	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
-
-	skb_probe_transport_header(skb);
 }
 
 /*
-- 
2.53.0



