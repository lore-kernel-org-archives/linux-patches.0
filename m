Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BAA2D73A0;
	Thu, 15 Jan 2026 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496609; cv=none; b=rQKRUH76dGUcgh/Cf8suYAHSTWY1uBiVIDK7wthNPc8og2+F6s6u/gx9bKWfp9YHSu6O4HareaJQmMbwdRKPExuecUBu/v0QW2pNohAIFx0OhHjuXx9RVpJLg0VI7PiUaa3HrQXqI92xFrGJ7rWCOFUm5ZT619VLaYrBQhLejaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496609; c=relaxed/simple;
	bh=gYiDYe8cSfBeCI/meXJthw+n/NQf4+S2pDAftkbTgB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuGuaKp8F6p6uX+1vMkaH8Iv8jreOppJr9mAhWGdyspV9AZunUZ0AmbmyXI7yawv5A2kABa9i1cbPitISmG0fXqGmU6pW+zLO5UZjB3OV19SO62nWarz60QPE2zhs38FuuBWLJvwyQBV4f4eZzLkzDb2bFjW8S976sw2HmTo7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkV+CJcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkV+CJcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C09C116D0;
	Thu, 15 Jan 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496609;
	bh=gYiDYe8cSfBeCI/meXJthw+n/NQf4+S2pDAftkbTgB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkV+CJcV2DNa/IJTZD9JqVRnEHpCKjMkSJY7qFLzKXZ4te6DSpeJl4nx0Fns+5tgD
	 9vmBHoK/WnDr/8kNBICrpoPWIpxgYq0jNto8Kw4ANCIt9In3K+SuluAVE1jmIe49jd
	 yQBfjw4EtzuUcDrohu05AGrbHqt5OO3LIaxAkc7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/119] bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress
Date: Thu, 15 Jan 2026 17:48:00 +0100
Message-ID: <20260115164154.301208098@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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



