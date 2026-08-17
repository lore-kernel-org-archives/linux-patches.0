Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BEF44781B;
	Mon, 17 Aug 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974964; cv=none; b=rysEEFV6saUOnrZLZxUHzzJZeegdW/LMWUHj8GR9MIcEeFJiWsBDZ/NAxo7uyPXZmrKFgStMbHvXiME+8ZcWnTCeqMAmGe7Gc36nP9KCFzVGQ93jknFAleSrVw+wciGWy+uwAYMrh2tSpMaD562aS1FN2SoUKxGTDIIU8eVZlFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974964; c=relaxed/simple;
	bh=t6nQ/cYAL+gFVACinj1V6Fp9Al/YaRl3DeTrnIEykyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHg4GnbGGmIO9/LC+7uP+zRYsGY/7cxpFSVj4fS1hdRv8c1/82gBouZliC/Q9h0fEcXlPmpKBXqN/KKbBCKMd0Qp7UAQP3zCb3E+BUqX+xygEGarUn0caCJSp301xTlKutDDwMtsuaAb/ETvFksqjUEPiPi8Im6IVizQuXk9QwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McbCnS++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McbCnS++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C825D1F000E9;
	Mon, 17 Aug 2026 13:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974961;
	bh=ulema7CkOsO/gtCooTlpsfjP5vM4cbkZq1Kf2u7vtvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McbCnS++8h+Ma7WRulWdgDcJRAzYC7kljDwS5UtN81bR66FbZd4amViI0ZSYyEX2y
	 lLSgt+ApeqLs0o/wAQbra/Q4uQh+NfnnORLwg4eeVJPquotpaXhBp+m4ATiSOsrcVk
	 UDxIfybvbVB704S6SQqg8D7zU06ZSSmdmq0jpVj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Eelco Chaudron <echaudro@redhat.com>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/250] net/openvswitch: check Ethernet header length in key_extract()
Date: Mon, 17 Aug 2026 15:30:36 +0200
Message-ID: <20260817132539.507613640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit cf6f8b29befb92173659bcef6a441d274947bfae ]

When a packet arrives on an ARPHRD_NONE device (e.g. TUN),
ovs_flow_key_extract() trusts the user-provided skb->protocol field: if
it is ETH_P_TEB, the packet is classified as MAC_PROTO_ETHERNET and
key_extract() is called without ensuring the skb has ETH_HLEN (14) bytes
of linear data. key_extract() unconditionally pulls 2 * ETH_ALEN bytes
for MAC addresses and parse_ethertype() pulls 2 more, either of which
triggers a kernel BUG in __skb_pull() when the linear area is too small.

  kernel BUG at include/linux/skbuff.h:2848!
  RIP: 0010:key_extract+0xa7e/0xd90 net/openvswitch/flow.c:933
  ovs_flow_key_extract+0x419/0xa70
  ovs_vport_receive+0x222/0x390
  netdev_frame_hook+0x3e0/0x630
  tun_get_user+0x2d0c/0x38e0

Fixed by calling check_header() in key_extract() before accessing the
Ethernet header.

Fixes: 217ac77a3c25 ("openvswitch: allow L3 netdev ports")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260730222006.118652-1-blbllhy@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 66366982f6044..46c1d66aad8c3 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -889,8 +889,6 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  * Ethernet header
  * @key: output flow key
  *
- * The caller must ensure that skb->len >= ETH_HLEN.
- *
  * Initializes @skb header fields as follows:
  *
  *    - skb->mac_header: the L2 header.
@@ -910,8 +908,6 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  */
 static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	struct ethhdr *eth;
-
 	/* Flags are always used as part of stats */
 	key->tp.flags = 0;
 
@@ -926,6 +922,13 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 		skb_reset_network_header(skb);
 		key->eth.type = skb->protocol;
 	} else {
+		struct ethhdr *eth;
+		int err;
+
+		err = check_header(skb, ETH_HLEN);
+		if (unlikely(err))
+			return err;
+
 		eth = eth_hdr(skb);
 		ether_addr_copy(key->eth.src, eth->h_source);
 		ether_addr_copy(key->eth.dst, eth->h_dest);
-- 
2.53.0



