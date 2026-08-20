Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775F547CA9C;
	Thu, 20 Aug 2026 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243924; cv=none; b=e3e3Rf8uEIpLWseHaOK1Uah4HXRIVPPBQlcUR8nC3vyq5/Uu7/ipl65l5wVudvp9h93YpyU25dcDu6wzakap4jZp59+FmdMISw2ktgZUpIFzcMWTNCJqXMvkyfACbdKyq5egFIl2RRHZA5HYcvtzKTHzRrVPn+6YZJNrgm+Quuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243924; c=relaxed/simple;
	bh=YKid0rx3nEUd7f0ozUvIo5gH64mRfd5/JmXHGzLFTDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ap5O3kB0iHOlZud5q+TvmZWymWCnsSAApX6P/aQjkXWyumHos6M8Aml6gRu+rY7Mp6oseuYlK9ueCHjgi949Ndh+CLasUj48FDlDyWKzY3WsAe7ZCqs7nBXHyfoZJfHMYQXiYAef6PD2I8Ar7lcq0EcvbYyfVBcskQwT2I0WKY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm9vf26v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm9vf26v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA37C1F000E9;
	Thu, 20 Aug 2026 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243923;
	bh=55EVNKxtw/QUQJo/nXvK81TOj3CAYS8M05V4WWTHprg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fm9vf26v1f6XGkLkZOw0J0dYgdOYknLaXH9/w6RaqKnDdGzYdXSiElcetuJ2Q2uTs
	 eIppjshlu0opyDAAMWYlw+2RVnjKQ2LK7lb3di1CKwtpt0XUIhCfa3Xe6Dz22o5JzQ
	 Oh2qgaO8eJMW0S7nHY688GonqVid47gFjRbUMC4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/272] net: packet: fix wrong transport_header when sending VLAN-tagged frame
Date: Thu, 20 Aug 2026 16:57:27 +0200
Message-ID: <20260820145239.523947012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
index 2c1a0c5e6df1f..d435aac03c3db 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1949,13 +1949,13 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
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



