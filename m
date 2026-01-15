Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607693624C4;
	Thu, 15 Jan 2026 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496154; cv=none; b=V+ebS1y5WysaXmLD8FcopgjrIJ3DqveOFt3GsqQa83e8nm3pJJ6hf54dZBIZ0S88sAddAXlMgLVFzSDTEuz5mPgfhAAj2fJifug5lI0lhhNcHE2COfCSjotYD1yn3JTAjkIbUnCql6C+r2jwaOQ9z+46C4TLE3y/0gwH+LVAcds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496154; c=relaxed/simple;
	bh=dNwM6t2hJHl2TfwsC+SAcR0E346e0thgF4jd4KXaQ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfnFhfdXz7U++oLGrrz7d+Yoi5rnCmn9S7cHFRLISQ3AGTKtTpnIgQSvgZLLZMR6xw+a2yDuVuS8lHu7abBE2Maj9Dg8zrhj+IPnxg/3vPHracQw4WoRRIjhnqbKFt2ErcuO5tZ/Hh7dU5McuW8erZ1cYUuvghNbcsroc6XQTdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qeq6Fjtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qeq6Fjtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AA7C116D0;
	Thu, 15 Jan 2026 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496154;
	bh=dNwM6t2hJHl2TfwsC+SAcR0E346e0thgF4jd4KXaQ4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qeq6Fjtl+cd4/NdB3bfq5+68soVIMcWkRLP2cFy3gKlolhx5rgPjnsvov9s7tKePq
	 /Cz7O9R1Lag9IfvPVxaye3FB0j6l0UpB8N4FXzKvBxxZTMXhdZp7ioql+SjxOfXbaU
	 OIeanSnkNfpY8WC9xBLK9VG7osRaecCCXKYq7CYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/181] bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress
Date: Thu, 15 Jan 2026 17:47:13 +0100
Message-ID: <20260115164205.787089620@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Alexandre Knecht <knecht.alexandre@gmail.com>

[ Upstream commit 3128df6be147768fe536986fbb85db1d37806a9f ]

When using an 802.1ad bridge with vlan_tunnel, the C-VLAN tag is
incorrectly stripped from frames during egress processing.

br_handle_egress_vlan_tunnel() uses skb_vlan_pop() to remove the S-VLAN
from hwaccel before VXLAN encapsulation. However, skb_vlan_pop() also
moves any "next" VLAN from the payload into hwaccel:

    /* move next vlan tag to hw accel tag */
    __skb_vlan_pop(skb, &vlan_tci);
    __vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);

For QinQ frames where the C-VLAN sits in the payload, this moves it to
hwaccel where it gets lost during VXLAN encapsulation.

Fix by calling __vlan_hwaccel_clear_tag() directly, which clears only
the hwaccel S-VLAN and leaves the payload untouched.

This path is only taken when vlan_tunnel is enabled and tunnel_info
is configured, so 802.1Q bridges are unaffected.

Tested with 802.1ad bridge + VXLAN vlan_tunnel, verified C-VLAN
preserved in VXLAN payload via tcpdump.

Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20251228020057.2788865-1-knecht.alexandre@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan_tunnel.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index a966a6ec82634..257cae9f15698 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -189,7 +189,6 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 	IP_TUNNEL_DECLARE_FLAGS(flags) = { };
 	struct metadata_dst *tunnel_dst;
 	__be64 tunnel_id;
-	int err;
 
 	if (!vlan)
 		return 0;
@@ -199,9 +198,13 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 		return 0;
 
 	skb_dst_drop(skb);
-	err = skb_vlan_pop(skb);
-	if (err)
-		return err;
+	/* For 802.1ad (QinQ), skb_vlan_pop() incorrectly moves the C-VLAN
+	 * from payload to hwaccel after clearing S-VLAN. We only need to
+	 * clear the hwaccel S-VLAN; the C-VLAN must stay in payload for
+	 * correct VXLAN encapsulation. This is also correct for 802.1Q
+	 * where no C-VLAN exists in payload.
+	 */
+	__vlan_hwaccel_clear_tag(skb);
 
 	if (BR_INPUT_SKB_CB(skb)->backup_nhid) {
 		__set_bit(IP_TUNNEL_KEY_BIT, flags);
-- 
2.51.0



