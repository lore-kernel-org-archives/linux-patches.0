Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00629377A89;
	Thu, 20 Aug 2026 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239221; cv=none; b=DgXGJtI/y45LAalEEUwgz4TM++Q19Yyo7dTcWsoXFDzbZfc+1C1EudMKSXF2qm+rI5cX0QNdOObVn8gOvor8R3641ggsaQTKdbZGGwNbPqglSnHulQcFU8QF3mqyOI5ut8e8dQYiDKuz4/QlOkA1Jf0eWn1DK53ALTZJsXwtZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239221; c=relaxed/simple;
	bh=B7Zc9veYVuXDwkNEdBwwm60/ysCyC0cXht9us20wPjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikSQkaK4HhNFpg0GE97cLSvXDj0pwDoSFzAN0k3tAfjottYPO8UPAt3nuLNK58CxkKEE4/7JfupjQGuOAf+3H5VcOsb9BnQSNRfLPrPpTwtvmRD1WDTWHxLUeW4h5qzOJFJEm1ZUwSPW+oBtT9fCySF+DncCZVGUJ/FmvFryarQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrnPvngR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrnPvngR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A42A1F00A3A;
	Thu, 20 Aug 2026 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239219;
	bh=Hc+RZdF0ehM+HQ7fIGpg08jn05lgZvqnwpS2cPZegFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrnPvngR1M/WD+nMkQk4FqoRuEds0zAy+vTlBB3V+kU/lXmZzT2EtVUQAa+jJBWBd
	 vpyirVuQy6hs9CTmZ5b7o4ki9VbszPAgpTMBWScMRa0V7wZV+TK4CDJJxDiEMUO5dI
	 GF69pylTTriLRlCe36TFZGp1kL5mI0u05nrat5nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/217] net: packet: fix wrong transport_header when sending VLAN-tagged frame
Date: Thu, 20 Aug 2026 16:55:58 +0200
Message-ID: <20260820145243.434532482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index a557f4dd2ebbd..10b373ab5f35b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1942,13 +1942,13 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
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



