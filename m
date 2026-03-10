Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29226388E65;
	Tue, 10 Mar 2026 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141282; cv=none; b=h8yHSGYNDqTfYSyD0mY+1K8gU0MZGNNNmG6RDNEc3EjycX02tD5WOHK86XsMca/yGBu8HXyH4S4c03fSUtHHdSgnmOPaJJ1GWCah3W7/3Htky+HMbgrvOCNvb8coc3rHrAoH7pPvNw9Xfp8yKA+jZtxNpgBZ89SYMlPkUsvL+fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141282; c=relaxed/simple;
	bh=uBUUPRmG7zA+16m+OuNlCgTrSSeaMWql2wRBlEhPZVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaJ+R13bFahq5CVOlTWkDBmCc3qfMERnD1YLSMrUPw4zbXKTcrbwvbOcqS1/FmXNuhQr0GGlNM9vWnYghtgjZtHRJJbj/MakoPPUEfZcle7gaW1fa5trQYUHcH6XwP+zfc08kvIiIGGyGd0jFmOZH2Q3NCvXj8sJDDeqwcgikpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=skHXb0Dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="skHXb0Dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43452C19423;
	Tue, 10 Mar 2026 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141281;
	bh=uBUUPRmG7zA+16m+OuNlCgTrSSeaMWql2wRBlEhPZVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skHXb0DlnfGnIJ+lrzcuw3W8ot53JzWbJee+HnoUJosQWfBenGRD+Gzd+INYBEy/A
	 5/Ef2yowgV0UmM8uTpEwplYwCi0jkuQPYQijYFHkOlTYTy91ot+w7ayan52ezoCKle
	 BuCAkjhEnYLhNZH9JXshqeRZj0Z0PGo0ZQEUXz5WZBiZ4lUOROnyfluvpE1Svkowpf
	 hIBNHcz7ZqeiozrUBXK81H7cY6ral1cBbbxkzK8M3QrKmp5Qx9xFpRSbAqbuMkTPav
	 +jrdKGknN83nFHJRqhJ5d0zgYPPA0FScyXhjroLac04/tIohkvpj5xJx4EmUOPZ1jb
	 Kfdj94gzNZRsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 285/311] net: stmmac: Defer VLAN HW configuration when interface is down
Date: Tue, 10 Mar 2026 07:05:32 -0400
Message-ID: <887c513aced09456e91d9b4fd2012c6f7c6402d7.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 4ffe151774037..01ede5148163e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6721,6 +6721,9 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
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

