Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F41A1879;
	Thu,  6 Jun 2024 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683716; cv=none; b=BI2nKhh0+nG478+V1kTWYC34kKwQe078+cuh+EbqoOgBnfyuG7vDLrNQfMSQQnLLa7/Y6y/jLgZ8nAVx4ructWvZKXNcCb86Gc21zbsNgVfU661qa9uCsWBL8JMdArNPkfV+58rwFkrVlCyzwIC5Lq670H5d8GLulbgvz/YSAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683716; c=relaxed/simple;
	bh=18Q8GoxtAXksMGjpvA04eV3XWqLBsU7K8P2etbPZwGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW3xIRIHqrIZf4sLkwE+MOZ3pfMN6Wp1DSpp94DxjeRK8A5800krv2XHo7k1w9V/wa8878JHXj5Dme+T5tri9xrG4FPhyHesvxRUvT8CAAyRUAgOuvNxpWvXhobg9FwQzYTX+5Ri8XPxVOMuo5kaw1hoD5iK0p+sjz3Lt5vNiO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6pf4oYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6pf4oYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BA3C2BD10;
	Thu,  6 Jun 2024 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683716;
	bh=18Q8GoxtAXksMGjpvA04eV3XWqLBsU7K8P2etbPZwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6pf4oYH3vQrX8ZPtL9Ugv3uDMPg8c98OSySL29NhpU3vUedQc467NAC40Eab9bu8
	 YXDH2NfoimkV6woRe3gVF36s/JGz67TIcmuXG7zDCgNhLk+JZ9/oNkp2E1G+ekJoad
	 OjpzFhqfNTYsl9/1irO5cjB0AFF8rMEC44+k3ylg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaime Caamano <jcaamano@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 650/744] openvswitch: Set the skbuff pkt_type for proper pmtud support.
Date: Thu,  6 Jun 2024 16:05:22 +0200
Message-ID: <20240606131753.316840422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fd66014d8a76a..4f5cbcaa38386 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -929,6 +929,12 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
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



