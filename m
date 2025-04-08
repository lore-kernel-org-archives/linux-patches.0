Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222702641CC;
	Tue,  8 Apr 2025 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112924; cv=none; b=dI0KMNt8ik/Cj8SEPfV6z4t0jKy78Solfpj+S+xQW9RyoU4pijNC72sifzHW/p5gsSAfss84Xm7TCGrcNUHNWFL4fjXjEiKzkCEm7x7Ewsp/LkI4g62pNhFaNndrXererQBZ3hdrvMbKhyqATDuRcttacrS1pr1wZk8+WqAwAPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112924; c=relaxed/simple;
	bh=Za4Gw0CXgDYs2+kqkHifSNx5EAx2fCQokiyeb6Qs58w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfE6ZfE3S9rE2fJVYAmQd3uP9NWGzobuXxRfs8DECtQiUinxsY385F7E9kqnqqsvNegyoJqxmx44dMzRrU9WV3TeLjG5nGdLDnPaAI+pqlAG62nFYQb8w0r+GEiEpmGyB56iKxGLsQtbmRFNT7ATJqQ93nIvy9U5k6yRUnKQpMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yk0k+Lea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yk0k+Lea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAFAC4CEE5;
	Tue,  8 Apr 2025 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112924;
	bh=Za4Gw0CXgDYs2+kqkHifSNx5EAx2fCQokiyeb6Qs58w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yk0k+Lea14TZFe3YOzdKesw3Y5y/5XLtrRiOyW5sXnWC9/tX9XKCkP3ZkTtdA8L2n
	 KMinbPJWrvuQ+sur7Exe2cqCeFoO9oimJElTlSxCFHWPHJ/qzKn5su1Fcm3ZXQi5Dr
	 p/8tJhaTBKerwVXD2fqNMNNnnp7QWKyA445FW7Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/279] tunnels: Accept PACKET_HOST in skb_tunnel_check_pmtu().
Date: Tue,  8 Apr 2025 12:50:29 +0200
Message-ID: <20250408104833.028877427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 8930424777e43257f5bf6f0f0f53defd0d30415c ]

Because skb_tunnel_check_pmtu() doesn't handle PACKET_HOST packets,
commit 30a92c9e3d6b ("openvswitch: Set the skbuff pkt_type for proper
pmtud support.") forced skb->pkt_type to PACKET_OUTGOING for
openvswitch packets that are sent using the OVS_ACTION_ATTR_OUTPUT
action. This allowed such packets to invoke the
iptunnel_pmtud_check_icmp() or iptunnel_pmtud_check_icmpv6() helpers
and thus trigger PMTU update on the input device.

However, this also broke other parts of PMTU discovery. Since these
packets don't have the PACKET_HOST type anymore, they won't trigger the
sending of ICMP Fragmentation Needed or Packet Too Big messages to
remote hosts when oversized (see the skb_in->pkt_type condition in
__icmp_send() for example).

These two skb->pkt_type checks are therefore incompatible as one
requires skb->pkt_type to be PACKET_HOST, while the other requires it
to be anything but PACKET_HOST.

It makes sense to not trigger ICMP messages for non-PACKET_HOST packets
as these messages should be generated only for incoming l2-unicast
packets. However there doesn't seem to be any reason for
skb_tunnel_check_pmtu() to ignore PACKET_HOST packets.

Allow both cases to work by allowing skb_tunnel_check_pmtu() to work on
PACKET_HOST packets and not overriding skb->pkt_type in openvswitch
anymore.

Fixes: 30a92c9e3d6b ("openvswitch: Set the skbuff pkt_type for proper pmtud support.")
Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Tested-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/eac941652b86fddf8909df9b3bf0d97bc9444793.1743208264.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 2 +-
 net/openvswitch/actions.c | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 50ddbd7021f0e..51dd2b36c49d4 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -415,7 +415,7 @@ int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
 
 	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
-	if (!reply || skb->pkt_type == PACKET_HOST)
+	if (!reply)
 		return 0;
 
 	if (skb->protocol == htons(ETH_P_IP))
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 85af0e9e0ac6d..aca6e2b599c86 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -924,12 +924,6 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
 				pskb_trim(skb, ovs_mac_header_len(key));
 		}
 
-		/* Need to set the pkt_type to involve the routing layer.  The
-		 * packet movement through the OVS datapath doesn't generally
-		 * use routing, but this is needed for tunnel cases.
-		 */
-		skb->pkt_type = PACKET_OUTGOING;
-
 		if (likely(!mru ||
 		           (skb->len <= mru + vport->dev->hard_header_len))) {
 			ovs_vport_send(vport, skb, ovs_key_mac_proto(key));
-- 
2.39.5



