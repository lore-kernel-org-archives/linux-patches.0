Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CEB56458;
	Thu, 13 Jun 2024 12:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281471; cv=none; b=MrElf8eAoh+QeRuPLYfL5U+N4M0McTT3/xchyFdmeimEB9TXgUkpevvki+tUEKsCqcb1SeQGrbgI1MRd4rO8Rw+76ySfCecc7WBg5lKYgb8AlyIHVGWM674KVmX4mcVJJyCBsm+I9nuumHgN9eEZGpW03MKe4Z1wywpUHcdlhqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281471; c=relaxed/simple;
	bh=KvK8GrrDAcYnXosg7n+O23xzZTre1nVmuY8UITX+pgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4ia8M5rDfGeIcbFlTAeMDA4bjd96GWlHa0pDf8YWN4Fz0WpzOzSrBD36Q7eFei3X+SfUbA/xeuZ9LNONWsp4MyEpJEmW/PLpkJ7lUGs7gGQFI0Fl5YwPA2tLdzGG7/9YWUrpOlCsx60OR/shyRwOeLZFo4vpVnFxRz0X3TQGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDRkQWWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDRkQWWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB93C2BBFC;
	Thu, 13 Jun 2024 12:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281471;
	bh=KvK8GrrDAcYnXosg7n+O23xzZTre1nVmuY8UITX+pgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDRkQWWfRZtiJl80vRVC9ZqW6EKvvk6rVvV5vJUxwXqUrJwbNdBF2AI6UlnKsGzY4
	 xRH2oOxmYANTPleQ6MGHr6U//BUaIbo/pQXN+KZzYKSGuXtdyRf+b1RXOOO/5dK37d
	 +DeZOMUYoL5SS3I1iYhaXNqz1VmzCAY8ymTwJ/z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaime Caamano <jcaamano@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/317] openvswitch: Set the skbuff pkt_type for proper pmtud support.
Date: Thu, 13 Jun 2024 13:34:13 +0200
Message-ID: <20240613113256.640956969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 80fee9d118eec..4095456f413df 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -923,6 +923,12 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
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



