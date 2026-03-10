Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EA43D5240;
	Tue, 10 Mar 2026 11:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142202; cv=none; b=HdY83G31M8A6cqwjmegKqymB8yLhlC1rw1mydzm+0jUFa716++/t0fZkUnW3EfiIzJISrf6mtAPlu17WlVZLTYQzycF+pcI20X/pMMdV3b/r1RqR1Oma19uXmkGEJQymUYyFdBk3EcDgY/HIV19/OGmTsdWjZ1Yq+0Rg4lrTHJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142202; c=relaxed/simple;
	bh=APo2FdM/v858d2ZRvFX3u6JdiBe/I37uYqpRlVUUiXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzbgVFkxq843UlT5vrWjSC8tqqQqJ6socL2cU/cHkdfVAIRD9aLqGUCANiEwhPpPjorhkCclgVrXIO+/3tGxPPhBmL338rD8Koq0PZHC3f1lO7skCZbY2OALDctbhvLGOaEjpqX6OV6rUCU2r9OYW4jJBdzzKRZWWGhSwZ675FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ll8Qu/Y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ll8Qu/Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9618C2BC86;
	Tue, 10 Mar 2026 11:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142201;
	bh=APo2FdM/v858d2ZRvFX3u6JdiBe/I37uYqpRlVUUiXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ll8Qu/Y9DLpOxblZ4xY8PPWGra1uWCy9zKdHmrAS4YJz869SwFyoC1/Sh7shxxrs+
	 0DdDGIPr0DOvERNA+ug7RUWrRBIR5vmU0hFdCM5pv3WwWK1wzfzyqh1qKqPd8KgGLw
	 JN+tqOe3HF2Je8kMjckOm5OtrphYUPm7zNIJRlVhK7JH7tj/5IPM/fE7QwBLZZdo8j
	 lb4Bf+oslvilQ1hezGqNFWWzYbVbTkT8GE8KEyOoMQlliBaXud45mRLRFZCOWG+ox2
	 UD4AfMpgJAj6dG7cbYgm1MV+EjvCWij0vyNRotf8klfFk8rqRg+6fuuXrEdID5H6tN
	 n/l9PR6rpLgKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/314] net: stmmac: Defer VLAN HW configuration when interface is down
Date: Tue, 10 Mar 2026 07:19:10 -0400
Message-ID: <2b2400d1e7e74c71970e2c5cfec29b4488829946.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 2cd70e3968f505996d5fefdf7ca684f0f4575734 ]

VLAN register accesses on the MAC side require the PHY RX clock to be
active. When the network interface is down, the PHY is suspended and
the RX clock is unavailable, causing VLAN operations to fail with
timeouts.

The VLAN core automatically removes VID 0 after the interface goes down
and re-adds it when it comes back up, so these timeouts happen during
normal interface down/up:

    # ip link set end1 down
    renesas-gbeth 15c40000.ethernet end1: Timeout accessing MAC_VLAN_Tag_Filter
    renesas-gbeth 15c40000.ethernet end1: failed to kill vid 0081/0

Adding VLANs while the interface is down also fails:

    # ip link add link end1 name end1.10 type vlan id 10
    renesas-gbeth 15c40000.ethernet end1: Timeout accessing MAC_VLAN_Tag_Filter
    RTNETLINK answers: Device or resource busy

To fix this, check if the interface is up before accessing VLAN registers.
The software state is always kept up to date regardless of interface state.

When the interface is brought up, stmmac_vlan_restore() is called
to write the VLAN state to hardware.

Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260303145828.7845-5-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++
 .../net/ethernet/stmicro/stmmac/stmmac_vlan.c | 42 ++++++++++---------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 112d0cbdf6237..eeeb9f50c265c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6578,6 +6578,9 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 		hash = 0;
 	}
 
+	if (!netif_running(priv->dev))
+		return 0;
+
 	return stmmac_update_vlan_hash(priv, priv->hw, hash, pmatch, is_double);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
index fcc34867405ed..e24efe3bfedbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
@@ -76,7 +76,9 @@ static int vlan_add_hw_rx_fltr(struct net_device *dev,
 		}
 
 		hw->vlan_filter[0] = vid;
-		vlan_write_single(dev, vid);
+
+		if (netif_running(dev))
+			vlan_write_single(dev, vid);
 
 		return 0;
 	}
@@ -97,12 +99,15 @@ static int vlan_add_hw_rx_fltr(struct net_device *dev,
 		return -EPERM;
 	}
 
-	ret = vlan_write_filter(dev, hw, index, val);
+	if (netif_running(dev)) {
+		ret = vlan_write_filter(dev, hw, index, val);
+		if (ret)
+			return ret;
+	}
 
-	if (!ret)
-		hw->vlan_filter[index] = val;
+	hw->vlan_filter[index] = val;
 
-	return ret;
+	return 0;
 }
 
 static int vlan_del_hw_rx_fltr(struct net_device *dev,
@@ -115,7 +120,9 @@ static int vlan_del_hw_rx_fltr(struct net_device *dev,
 	if (hw->num_vlan == 1) {
 		if ((hw->vlan_filter[0] & VLAN_TAG_VID) == vid) {
 			hw->vlan_filter[0] = 0;
-			vlan_write_single(dev, 0);
+
+			if (netif_running(dev))
+				vlan_write_single(dev, 0);
 		}
 		return 0;
 	}
@@ -124,22 +131,23 @@ static int vlan_del_hw_rx_fltr(struct net_device *dev,
 	for (i = 0; i < hw->num_vlan; i++) {
 		if ((hw->vlan_filter[i] & VLAN_TAG_DATA_VEN) &&
 		    ((hw->vlan_filter[i] & VLAN_TAG_DATA_VID) == vid)) {
-			ret = vlan_write_filter(dev, hw, i, 0);
 
-			if (!ret)
-				hw->vlan_filter[i] = 0;
-			else
-				return ret;
+			if (netif_running(dev)) {
+				ret = vlan_write_filter(dev, hw, i, 0);
+				if (ret)
+					return ret;
+			}
+
+			hw->vlan_filter[i] = 0;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static void vlan_restore_hw_rx_fltr(struct net_device *dev,
 				    struct mac_device_info *hw)
 {
-	u32 val;
 	int i;
 
 	/* Single Rx VLAN Filter */
@@ -149,12 +157,8 @@ static void vlan_restore_hw_rx_fltr(struct net_device *dev,
 	}
 
 	/* Extended Rx VLAN Filter Enable */
-	for (i = 0; i < hw->num_vlan; i++) {
-		if (hw->vlan_filter[i] & VLAN_TAG_DATA_VEN) {
-			val = hw->vlan_filter[i];
-			vlan_write_filter(dev, hw, i, val);
-		}
-	}
+	for (i = 0; i < hw->num_vlan; i++)
+		vlan_write_filter(dev, hw, i, hw->vlan_filter[i]);
 }
 
 static void vlan_update_hash(struct mac_device_info *hw, u32 hash,
-- 
2.51.0

