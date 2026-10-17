Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F337404E;
	Sat, 17 Oct 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254831; cv=none; b=HeD45+bR59dbiedayPFcSkoEOiJgiCZcA2dyiJRweEHZuwzosJdYj+5x/xAMVqkQ8C2ytBxedQhYSefU/iwEXzzwZaUer5rCy7l5ged2lh34BDpcvbvYHLeFrpcxkL4/TJTd+r2ME7AfFbynzhhxjuYu3Umx6xA3tW1XVhIF3VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254831; c=relaxed/simple;
	bh=BYfjwRPGGQHumeNPDHpaRe9BYb0oKH2Or43nFOcyvao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u52NDrtxWP3VBKUm31SqJ0j4OHFISDh4hQvJblevnrWfzWU9F5h/9oOL699/X9ihRvDxGWG3g8FyPUtndeTAW9cUBETIS9rXe3nrPd5XhBnN5ATHxv5Y0m8mWE0yV90nRwuhZmzZY9SR4A9e6IXrmr8N3+HykGDeKSSOLbJSkGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L72Gh0Os; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L72Gh0Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1C31F000C4;
	Sat, 17 Oct 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254830;
	bh=NlHfTbj8+iZYWCERJPPvf8z66oLk1IMqpHfm1Zs+I7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L72Gh0OsGKTCz16JPEcIHlQQ2mArV4RHD2EQobBt39tywqDc58PKRyMuBHowJhr19
	 3qG8dR+MYjan8/k1655LbKbnvdf9UPYDmf3unoSNdRoSIAj/c8ZCzvOpoxta7pKVkl
	 yIqEumVJXZzNQrZ1JlE+fWAagcaDuDBo47l2oaZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/869] net: tap: fix wrong transport_header when sending VLAN-tagged frame
Date: Sat, 17 Oct 2026 17:56:40 +0200
Message-ID: <20261017160051.412277255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index d5a1ab9b2a37d..fcc9d135c5fc2 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1208,12 +1208,13 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
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



