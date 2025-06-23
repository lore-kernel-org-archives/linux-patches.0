Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A6B70838;
	Mon, 23 Jun 2025 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713059; cv=none; b=JnQZHtKkJi7hk+QOloeNHqixYpnf4jJbwMTZYHkFPMNEL38HeIt1PddpG/FEY3yX/jWLakk2QdBBUMtZ9koGgi0x81chkNLdtYb8yygTKfUChpmXU41la9FAxrE5WVVfSeFkLcYM7Tbn6KdkLWh00+3Ks2NyuhPZ4QjCeY6MHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713059; c=relaxed/simple;
	bh=Co5T8OF3vBfSULil1PZ9InU3aD4X0izpKdI6ZWgOi2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frzOOEXNqiGhXfM3sNWutO4nlbm0CO+2xhIRLI1t5d/iYlEdcQ/jeLHGMfdRkkOBckIlr1t/0CgMJ5O9ZmVuTKNzb92w6/hlZ+VsqiRYuf5COYzEgzN2BYdVX0Jmn0zCq//TmqYl11/Br7rsCLYLfLayyi1UBO0KhCJp1iDlzMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/i9XJXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/i9XJXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22958C4CEEA;
	Mon, 23 Jun 2025 21:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713059;
	bh=Co5T8OF3vBfSULil1PZ9InU3aD4X0izpKdI6ZWgOi2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/i9XJXEl3lxQXOSL+AJ2/CxKwbZ5zaDTewoPRo/co7l939uVtmhXgcoKGJ2isjtm
	 iZgmzoaqBJG4nb5Pq5g7qfKQT9dLHZhwAjOzFKq170N9h0r3cYa624YjRSQBaQxR6w
	 lUOQYNWUoTUuEyV5/ZPAcd95m7gdLo/90ItzBJaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Guolin Yang <guolin.yang@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/411] vmxnet3: correctly report gso type for UDP tunnels
Date: Mon, 23 Jun 2025 15:04:26 +0200
Message-ID: <20250623130636.626152964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Ronak Doshi <ronak.doshi@broadcom.com>

[ Upstream commit 982d30c30eaa2ec723df42e3bf526c014c1dbb88 ]

Commit 3d010c8031e3 ("udp: do not accept non-tunnel GSO skbs landing
in a tunnel") added checks in linux stack to not accept non-tunnel
GRO packets landing in a tunnel. This exposed an issue in vmxnet3
which was not correctly reporting GRO packets for tunnel packets.

This patch fixes this issue by setting correct GSO type for the
tunnel packets.

Currently, vmxnet3 does not support reporting inner fields for LRO
tunnel packets. The issue is not seen for egress drivers that do not
use skb inner fields. The workaround is to enable tnl-segmentation
offload on the egress interfaces if the driver supports it. This
problem pre-exists this patch fix and can be addressed as a separate
future patch.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <ronak.doshi@broadcom.com>
Acked-by: Guolin Yang <guolin.yang@broadcom.com>
Link: https://patch.msgid.link/20250530152701.70354-1-ronak.doshi@broadcom.com
[pabeni@redhat.com: dropped the changelog]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index b88092a6bc851..78d8c04b00a7f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1361,6 +1361,30 @@ vmxnet3_get_hdr_len(struct vmxnet3_adapter *adapter, struct sk_buff *skb,
 	return (hlen + (hdr.tcp->doff << 2));
 }
 
+static void
+vmxnet3_lro_tunnel(struct sk_buff *skb, __be16 ip_proto)
+{
+	struct udphdr *uh = NULL;
+
+	if (ip_proto == htons(ETH_P_IP)) {
+		struct iphdr *iph = (struct iphdr *)skb->data;
+
+		if (iph->protocol == IPPROTO_UDP)
+			uh = (struct udphdr *)(iph + 1);
+	} else {
+		struct ipv6hdr *iph = (struct ipv6hdr *)skb->data;
+
+		if (iph->nexthdr == IPPROTO_UDP)
+			uh = (struct udphdr *)(iph + 1);
+	}
+	if (uh) {
+		if (uh->check)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL;
+	}
+}
+
 static int
 vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		       struct vmxnet3_adapter *adapter, int quota)
@@ -1615,6 +1639,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (segCnt != 0 && mss != 0) {
 				skb_shinfo(skb)->gso_type = rcd->v4 ?
 					SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
+				if (encap_lro)
+					vmxnet3_lro_tunnel(skb, skb->protocol);
 				skb_shinfo(skb)->gso_size = mss;
 				skb_shinfo(skb)->gso_segs = segCnt;
 			} else if ((segCnt != 0 || skb->len > mtu) && !encap_lro) {
-- 
2.39.5



