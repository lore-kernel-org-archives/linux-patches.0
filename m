Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038621A6186;
	Tue, 30 Jul 2024 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356696; cv=none; b=mPaXwOVmcwZAaujPpkXaibqA6gtltFkDOWdJf6SEOwFivgrYHXotn6MoLNpy2K0xbGglQ+6SDsdNlyYuoNr1e2i4YeuInLroVc3lrhudOwv/0AdzbZCzD6EArKY4McOSDRMmYsxP8Y8ZpTDCS/OGXXnKKCjA0gzaYgkGcLkdIII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356696; c=relaxed/simple;
	bh=zFipFErlequwiuGZfqOVDPnVyEBVg0wHPOfEx6VPFfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suaXGSHYJC7NJNA1tgy0gxqeasagkCEAb/GNWNH42E5PZSUiJDEoWXG6naowFttF2Nhs01fiY0AomRiIDgF5o7CaZj2Zu4p2u89irLod7i+kJ/nAxzueZEoGyprNjO8B4igaWo5rOz3GYFXJiKTY7kUlMubFnXaBho1vBK8eVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLheFBN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLheFBN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1916AC32782;
	Tue, 30 Jul 2024 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356695;
	bh=zFipFErlequwiuGZfqOVDPnVyEBVg0wHPOfEx6VPFfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLheFBN7Yom6teep1GWf6KrssohvXLqVqEXXjPX0iHAHR2WndUBMbVLPAYWTuExbB
	 wS4KLqBvAeTkcd4TMD0CfN0sP9P/eKUmJD/BFXjPuGwAeyvEp0v+TikfMZ+JuCnE2y
	 o0La0BnR0lPlBDgpSaweW9haY94UpYk5J3GAJdgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/568] net: bridge: mst: Check vlan state for egress decision
Date: Tue, 30 Jul 2024 17:44:41 +0200
Message-ID: <20240730151646.682975564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>

[ Upstream commit 0a1868b93fad5938dbcca77286b25bf211c49f7a ]

If a port is blocking in the common instance but forwarding in an MST
instance, traffic egressing the bridge will be dropped because the
state of the common instance is overriding that of the MST instance.

Fix this by skipping the port state check in MST mode to allow
checking the vlan state via br_allowed_egress(). This is similar to
what happens in br_handle_frame_finish() when checking ingress
traffic, which was introduced in the change below.

Fixes: ec7328b59176 ("net: bridge: mst: Multiple Spanning Tree (MST) mode")
Signed-off-by: Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index d97064d460dc7..e19b583ff2c6d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -25,8 +25,8 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 	vg = nbp_vlan_group_rcu(p);
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
-		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
-		nbp_switchdev_allowed_egress(p, skb) &&
+		(br_mst_is_enabled(p->br) || p->state == BR_STATE_FORWARDING) &&
+		br_allowed_egress(vg, skb) && nbp_switchdev_allowed_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
 
-- 
2.43.0



