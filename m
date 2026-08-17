Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219073ACEFE;
	Mon, 17 Aug 2026 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978043; cv=none; b=iFXd6azJNSftcPwk7SZiHTdXvLAGAbUUXTEtPdQ7aTSJkzTzsVb5wmRJVp6ULT6NLWxuROyowCZDS4XXwWY9vtdFt9glOGd3xiFGgGYb4aP6ygvr3Zz446Ufik8mIjXN4oEXvSyb5z/H+VdS+4JZfJ4Dmq+N3L4aLYeZKy2QYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978043; c=relaxed/simple;
	bh=2ajiivdCCLv1FzznFXuf3+xxN16dUZPsZCbhofIEutI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdrTQGs3H5Q/72m4KyY+jkWULiW+hDm23fPFh44smxwDcigbecEefYBwveyS3BHgT2m3hOJbYlZA6GXGEWCGJlUBrxgmZtZ9lYjnGPEAHTc7f4mfYKzIaqV41LbSPWzyZunChZ5/CbGXZaemzbawdCRL8uW23Osiq73Rxv4i+1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZywwTL5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZywwTL5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8062E1F000E9;
	Mon, 17 Aug 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978042;
	bh=em/RqDuETmlRTWSNHyRyaZCoWDJmkRk8inJ9xRSR4QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZywwTL5WholteKCcrKSpAwwPR7RhcnU4uulb7D76dOJMpFluJOxnNin3mOUxd9yxa
	 YqY3Kgji7+8+OA1vnIAhJYiWoMoV0AZVcGSxiXXKbsdUdapc3ZBnC5TZBnF6mkVgVb
	 iuf7ekHUdzxU/8AHMUIqmnC1KdmitLOXPW2t7c38=
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
Subject: [PATCH 6.12 042/181] net/openvswitch: check Ethernet header length in key_extract()
Date: Mon, 17 Aug 2026 15:32:16 +0200
Message-ID: <20260817132537.050195537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
index b80bd3a907739..52e261ce91e8e 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -893,8 +893,6 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  * Ethernet header
  * @key: output flow key
  *
- * The caller must ensure that skb->len >= ETH_HLEN.
- *
  * Initializes @skb header fields as follows:
  *
  *    - skb->mac_header: the L2 header.
@@ -914,8 +912,6 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
  */
 static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	struct ethhdr *eth;
-
 	/* Flags are always used as part of stats */
 	key->tp.flags = 0;
 
@@ -930,6 +926,13 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
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



