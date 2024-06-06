Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CB4196C77;
	Thu,  6 Jun 2024 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683032; cv=none; b=ioXXP8vZFKJSE094JZEO0YdiIkZovNa9gbYscDwiiv71D9NSUvyEjpmbdzkVBOsj9iS102IcJJv7CmQf4EvfVCQlelvmD1dFHzNkj7Has2MqZexriXQGeeTa1jzhWY8hoaJkXzjDpHw3Czb4U4xivAQzbRGiQ/bioa0AQZLhBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683032; c=relaxed/simple;
	bh=2zv7yFwwgyhMLoKVMraab1YWsNbfGsBLqKrZNw8fk0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD5AkEDevMyhPTAREebr9IErQpBDMsbvlkNLXLd2aCOTFyxGRxVFu6oVDSWv4Iy+LXrKCf6oWE8hcJcnGvWdHP2oBUWTXRo54qMjWg0i4Ukq48OIaJr4MjMOf3LOwL979g4lTVqFAthyhsnrxf5iHl4k+0sHtf+c3jA/Ilg+lkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/dGItai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/dGItai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E7BC2BD10;
	Thu,  6 Jun 2024 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683031;
	bh=2zv7yFwwgyhMLoKVMraab1YWsNbfGsBLqKrZNw8fk0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/dGItair5dU+OnAO0lU135Ro+yEU157RyZwo8tyX8+Ak+XKyP4loLeYOpQIA5DaS
	 TG6c1rJ9f5Mwmmpq/28ehiXmpWvvaWW8MvnzfxiukMD31Lgi/Hspbi1WWkrUzLiMpm
	 7TwAp/lj/heS4XaZo0adejGvOu9GOmtyzCzD+fbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaime Caamano <jcaamano@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 255/374] openvswitch: Set the skbuff pkt_type for proper pmtud support.
Date: Thu,  6 Jun 2024 16:03:54 +0200
Message-ID: <20240606131700.388787516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit 30a92c9e3d6b073932762bef2ac66f4ee784c657 ]

Open vSwitch is originally intended to switch at layer 2, only dealing with
Ethernet frames.  With the introduction of l3 tunnels support, it crossed
into the realm of needing to care a bit about some routing details when
making forwarding decisions.  If an oversized packet would need to be
fragmented during this forwarding decision, there is a chance for pmtu
to get involved and generate a routing exception.  This is gated by the
skbuff->pkt_type field.

When a flow is already loaded into the openvswitch module this field is
set up and transitioned properly as a packet moves from one port to
another.  In the case that a packet execute is invoked after a flow is
newly installed this field is not properly initialized.  This causes the
pmtud mechanism to omit sending the required exception messages across
the tunnel boundary and a second attempt needs to be made to make sure
that the routing exception is properly setup.  To fix this, we set the
outgoing packet's pkt_type to PACKET_OUTGOING, since it can only get
to the openvswitch module via a port device or packet command.

Even for bridge ports as users, the pkt_type needs to be reset when
doing the transmit as the packet is truly outgoing and routing needs
to get involved post packet transformations, in the case of
VXLAN/GENEVE/udp-tunnel packets.  In general, the pkt_type on output
gets ignored, since we go straight to the driver, but in the case of
tunnel ports they go through IP routing layer.

This issue is periodically encountered in complex setups, such as large
openshift deployments, where multiple sets of tunnel traversal occurs.
A way to recreate this is with the ovn-heater project that can setup
a networking environment which mimics such large deployments.  We need
larger environments for this because we need to ensure that flow
misses occur.  In these environment, without this patch, we can see:

  ./ovn_cluster.sh start
  podman exec ovn-chassis-1 ip r a 170.168.0.5/32 dev eth1 mtu 1200
  podman exec ovn-chassis-1 ip netns exec sw01p1 ip r flush cache
  podman exec ovn-chassis-1 ip netns exec sw01p1 \
         ping 21.0.0.3 -M do -s 1300 -c2
  PING 21.0.0.3 (21.0.0.3) 1300(1328) bytes of data.
  From 21.0.0.3 icmp_seq=2 Frag needed and DF set (mtu = 1142)

  --- 21.0.0.3 ping statistics ---
  ...

Using tcpdump, we can also see the expected ICMP FRAG_NEEDED message is not
sent into the server.

With this patch, setting the pkt_type, we see the following:

  podman exec ovn-chassis-1 ip netns exec sw01p1 \
         ping 21.0.0.3 -M do -s 1300 -c2
  PING 21.0.0.3 (21.0.0.3) 1300(1328) bytes of data.
  From 21.0.0.3 icmp_seq=1 Frag needed and DF set (mtu = 1222)
  ping: local error: message too long, mtu=1222

  --- 21.0.0.3 ping statistics ---
  ...

In this case, the first ping request receives the FRAG_NEEDED message and
a local routing exception is created.

Tested-by: Jaime Caamano <jcaamano@redhat.com>
Reported-at: https://issues.redhat.com/browse/FDP-164
Fixes: 58264848a5a7 ("openvswitch: Add vxlan tunneling support.")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20240516200941.16152-1-aconole@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 6fcd7e2ca81fe..9642255808247 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -936,6 +936,12 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
 				pskb_trim(skb, ovs_mac_header_len(key));
 		}
 
+		/* Need to set the pkt_type to involve the routing layer.  The
+		 * packet movement through the OVS datapath doesn't generally
+		 * use routing, but this is needed for tunnel cases.
+		 */
+		skb->pkt_type = PACKET_OUTGOING;
+
 		if (likely(!mru ||
 		           (skb->len <= mru + vport->dev->hard_header_len))) {
 			ovs_vport_send(vport, skb, ovs_key_mac_proto(key));
-- 
2.43.0



