Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9696757FC;
	Tue, 30 Jul 2024 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357575; cv=none; b=pPO4DM3BSmTZ63zwfMM2GSB2IlLIWbjaPWwmNsm71iGuoRxI8MOv1eTPWp6LHp+s2Rsdlm6LQTcwqvezRyM+k/1NAtAyXAusug2g5AZO0P3IYg30/pQvNt/JB0fOEa+zwvqwyQT8K15bwvo70It1BfNLKk3EYpD8d9+WzL+eo58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357575; c=relaxed/simple;
	bh=jXunQIRuMulQDKw4kSWklYT4pnECJqj2bVtifJ1yULY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX2eqgLshkUay70ln4Gvr7Go+wt/HDUODAr+Kp0vUYVamErvn+3x5lybZ4hHilX2MKyftaQePW9f6sfhxzwLycAf4yTEiKzqo5sk/az4Cdr8e3Y0BWt5tvWRX9OD78fFEm7s5/d57TRqOgbVLiXcsDo6d1/VYlvoMH8Pr8IMEUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAACiqCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAACiqCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64126C4AF0C;
	Tue, 30 Jul 2024 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357574;
	bh=jXunQIRuMulQDKw4kSWklYT4pnECJqj2bVtifJ1yULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAACiqCPBVrbZ+6Tk0Krh1qD8aPS0EzuQq9t7frhw4QSLKpmWiTWi40nARmrEeniy
	 7Rk3U2ekq1PJrv16UHENQLXP2laH7qPosSh+v60VQnjqfXBEQMNk8BnX8MqVH5lEyM
	 RjCwnyeIFq9EaswG7eeEM17Cy/HNwCD8Bl2dacgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Ayrey <elliot.ayrey@alliedtelesis.co.nz>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 262/809] net: bridge: mst: Check vlan state for egress decision
Date: Tue, 30 Jul 2024 17:42:18 +0200
Message-ID: <20240730151734.941441473@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



