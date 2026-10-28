Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215882;
	b=nbentSuJsvXH18FxoK4Tqf39PAXzwiCFafZM6NVqa1KjiJmsuYZ6dyqv3CqC2C2zquw9
	 Kd/Ig1L6AVNuP/P97/G83QviEhPjmMeoQrgHDWkHI0XTdBC2eu5yFekPrHjoYVBazuETh
	 b4ybeiYDK2Z/dEI6tyrnsaFLW43lWIqBDBHuwqZmFlquhV1LHczda/rX3eKlxrl1PBxxs
	 ZLVNLbYjjApEGQmGtnLk0prm/knF3NGPg8EUjHOffaWcAGLy/giMh3QaBPBAequ6T1Uj0
	 pOEtlGb8FsFwhKaa7fkqJlFmwskwSSChxzP9GBUwsGUiXKjT1geZq8H93mEvAOuyTpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gka5R0wryM7l/h40EpqavES41eqxnd6EQfQt51Gwyas=;
	b=yYgHtRtepRuG6WiOLLawRaMR/16ALuUh8HFCm805CCFjmF9J4P8vCb79En1uEp3WOypV
	 s1om2GnEXfEbA7L8rvpr3fTAZb2b+p9x4COi+Av1UncZrWJDCWayPeNW94OwGJkpU/AUO
	 vqrXqjwyHVbaCJ+ASNliamyPnEWPWnxqnKZKvD/O2zVGYUzBUSIGtd0YtfW1k1GkTMx4i
	 0JfjK7KSAPthaUI0ztTIvMNDbe0y4rvlMOdPPZJsd8+d8esFyP0ne++LoM2XjaeU7gFkS
	 nz739VEeQi49/eA/Lde8XE99m/2iwAJ4bC7E65cW69syLZuH6TKY3JmgBYWKfY3QFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g04W09sX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F21606A31A;
	Wed, 28 Oct 2026 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g04W09sX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEF71F01828;
	Wed, 28 Oct 2026 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215881;
	bh=Gka5R0wryM7l/h40EpqavES41eqxnd6EQfQt51Gwyas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g04W09sXv33feS6VZ3jJAmyDzDAkIoVpJmGSLewhGNjEyxeCnoYL9YR4u+BsHqeIh
	 9dsllPkW074kZOFEe0vCSs9z4+DCOb7KZbDn//z4Ccw3OKAfrP95UW4UVJMQQoH006
	 P+Tz6u+x+5MhFqkSmnkR0/qCYNmT8djhzCZ6kFFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1363/1887] net: tap: fix wrong transport_header when sending VLAN-tagged frame
Date: Wed, 28 Oct 2026 17:57:39 +0100
Message-ID: <20261028170530.461469956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb48096850b0a..5454b242a8f95 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1188,12 +1188,13 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
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



