Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283DC2C11EF;
	Thu, 15 Jan 2026 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496887; cv=none; b=ly/e0e2eFCX4fz/bGMpdto+Bqx4CuxHLNMFAsvY/PiE7fMN+gtKhRU5kQuaj0qiIRqscyO4ZEWvmaHxSXNhoek9jHbS33Z0o0Z5mmFiIu5AKZbiHZ5vg7/Q/qNRy1eG+DqD4xBOlw/Rb8NkWlcutmqIZiVjLDyKXCB836U8s9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496887; c=relaxed/simple;
	bh=0k1qOhWYbf2J12qbYoc/AqYHXPj3r1Nx6YCMYeq86fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmXqj0MEMdeBEB2gaFG4VqPFA8FObA+3vfLUrs6jKoaW/HxTC8fhittVsEPXUk0Nlm0/mUN/l4HWOoU2Id1L+NLlY//N9LXxSh99hY2pfo/QFJgb+tx2I65Z4wD7kVcP0zZio96yNpxkTyYahJdjM++WT1pDVKH27DZkgV0FN2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehBIR1M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehBIR1M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA761C116D0;
	Thu, 15 Jan 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496887;
	bh=0k1qOhWYbf2J12qbYoc/AqYHXPj3r1Nx6YCMYeq86fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehBIR1M+n4yZYZrysux63WesRPFzDChy8BbWwikzq49auaq0J/8BAprNdHe3gnTDF
	 SQ5/sLmKVAUh3yg1HHJccbTWfeM9RlMXD5gFsEa00LsNvPX5iXh8vhee25rNyOV+Dh
	 5rOCXLln9LWItrHOoo/yqyFjnQtn8Ap5qynNO2b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/88] bridge: fix C-VLAN preservation in 802.1ad vlan_tunnel egress
Date: Thu, 15 Jan 2026 17:48:34 +0100
Message-ID: <20260115164148.160308313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 81833ca7a2c77..b41494ce59438 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -187,7 +187,6 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 {
 	struct metadata_dst *tunnel_dst;
 	__be64 tunnel_id;
-	int err;
 
 	if (!vlan)
 		return 0;
@@ -197,9 +196,13 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
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
 		tunnel_dst = __ip_tun_set_dst(0, 0, 0, 0, 0, TUNNEL_KEY,
-- 
2.51.0



