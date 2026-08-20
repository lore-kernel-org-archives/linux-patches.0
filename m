Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F1380FE3;
	Thu, 20 Aug 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239225; cv=none; b=HU+iGxqG2xHA4W5dpbA2BzYHa1S4kIStWI4Dm9JlP4tl9C4kog4a0eO3V0CpUvuBJjqIUNAnIiCvz+GgYhVpNzlqxvyMu1cZ21sZfHjL6Nf7ujSDy0OXngIlsk7D51KCqJfKSObsqBISTNqTC2QiQA7QIBzodkP3qYwnOZGnoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239225; c=relaxed/simple;
	bh=Ku7UF0U6S7Bsy/y37Fe6dBxCtmqjhIKoV4PioZvecuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWPHF6RgxMtKVTCIHJcp4TURDpWYTfodo2y42Q4eVC+ztXRlEjJy83VBlB0fVApZgrRcOudDYg6GBaAStG5hzLhB3H6a5dGs6I+89BPOVNeR39fStffCKnEn0u18p7ZyxlA5c6auw/nm1XjJlKxu59pcz4CpHJGVOO3Qfa3P4X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW9Y+fAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW9Y+fAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393E51F000E9;
	Thu, 20 Aug 2026 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239222;
	bh=nAe41SW7oPsz9VpcUHGyA8tgBGChkIAcwoGJIF7e7V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dW9Y+fASv6kXQzLChKASvalQk5DEsqWWhni5ze8exavIdLG2p5NmHDWXe6EjNrEic
	 7FxXXKhBITOaI3TNxBRNBtQhOSwQmsSBTFJp9QiOSNp+GIJ1JA3h3CsRHB/UX95rTd
	 XTp3qR7CFhidB7b4qf8xy7ceuJs5TFxOS8Y0wbS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/217] net: tap: fix wrong transport_header when sending VLAN-tagged frame
Date: Thu, 20 Aug 2026 16:55:59 +0200
Message-ID: <20260820145243.465076628@linuxfoundation.org>
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

[ Upstream commit cbb35cbe8db268fefe34c23df15348cf99025298 ]

In tap_get_user_xdp(), when processing a VLAN-tagged frame (e.g.
ETH_P_8021Q), skb_set_network_header() is called first to advance
network_header past the VLAN tag to the inner protocol header.
skb_probe_transport_header() is then called with skb->protocol still
set to ETH_P_8021Q, while nhoff (derived from skb_network_offset())
already points past the VLAN tag to the inner protocol header.

In __skb_flow_dissect(), proto is initialized to ETH_P_8021Q and nhoff
points past the VLAN tag. When the dissector hits case ETH_P_8021Q, it
reads a struct vlan_hdr at the current nhoff via __skb_header_pointer(),
but that offset contains the inner protocol header (e.g. an IP header).
The bytes are misinterpreted as a VLAN header, yielding a garbage
encapsulated EtherType that matches no known protocol. The dissector
returns false, so skb_probe_transport_header() never calls
skb_set_transport_header(), leaving transport_header at its uninitialized
sentinel value (~0U).

Move skb_set_network_header() to after skb_probe_transport_header(). At
the time skb_probe_transport_header() is called, network_header still
points to the VLAN header (offset ETH_HLEN), so nhoff is correct and the
flow dissector can parse the VLAN header, extract the inner EtherType,
and advance nhoff to the inner protocol header, allowing transport_header
to be set correctly.

Fixes: 8c76e77f9069 ("tap: call skb_probe_transport_header after setting skb->dev")
Assisted-by: WChat:claude-opus-4-8
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260807063405.688780-3-wei.fang@oss.nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index bb62faad5b5c3..1aeaecd4030fa 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1091,12 +1091,13 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 		}
 	}
 
+	skb_probe_transport_header(skb);
+
 	/* Move network header to the right position for VLAN tagged packets */
 	if (eth_type_vlan(skb->protocol) &&
 	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	skb_probe_transport_header(skb);
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
 
-- 
2.53.0



