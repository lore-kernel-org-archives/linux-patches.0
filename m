Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E6387598;
	Tue, 10 Mar 2026 11:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142199; cv=none; b=VXyaukcoZ5NUCwQHdeXcKPKb2eS46fPn0XJqav3W02bsxWFaDg64lErAGqLMKj1cbYF/oIcOMFLhNifxL9yYdwKs4ZXhNdfeGtJdaWkctI9yHOOUg/x/aj7b3nfhJBiG9iOeIwuNMi0OwnPR/ids7cQfUKH2/ahQQmuqxWzfVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142199; c=relaxed/simple;
	bh=3U7by8jfY3tSBchfSKYcCwv5UpmQLtOP51s4W9SfCh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWtM/ZVi/+VTgqtNf2TSy4dSZj3nlWJ3ayXGRfSeRPn97mVTQ6bhsdHXZG8/9/Dtrb7K8AcdBGKrC8PC/MDJsN/fVRUAf9iHCMePgbHQ0Ua6xv33GSdkdj2eCB4lMWbFqoqSEekUFnGPJSm/PF0sywm7uLDHBjmWNyPZ2e/dhyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNENN+59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNENN+59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA0DC2BC9E;
	Tue, 10 Mar 2026 11:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142199;
	bh=3U7by8jfY3tSBchfSKYcCwv5UpmQLtOP51s4W9SfCh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNENN+59rhkNm9CfhLgSu0h/UcuRL+DJPfxWof25ajAV8uiI+OeJm6NB1+2uXWp/M
	 SKidsT8h/rWn12bf9WNEnhkCwQ3O19qjPc6LiwNfyBsgbrWMCicH+8i6PUr9uwy0Q3
	 WAq81GJBA4X7TyZxt+zCLfTFgQ5vofrI3t8x2Odtvd0ruzgmYQOvEm2oMxefo1IBDJ
	 mo2f+0joGrUqE6Dzw7BBmrHmRSmPHms+A7ydcTFHnPuV7UvBdm+/ec/yibPce6loO9
	 l3RkcAoQravq/0IiTDU5yJvLw4tDuQx/XpJ5JWeOIekKW+Q1XWSUj3khNyBsUMUbdz
	 C+ikNA6H5/KeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/314] net: stmmac: Improve double VLAN handling
Date: Tue, 10 Mar 2026 07:19:08 -0400
Message-ID: <960cbcd1823bdd467e89407abd4d561ad01b15ee.1773141556.git.sashal@kernel.org>
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

[ Upstream commit e38200e361cbe331806dc454c76c11c7cd95e1b9 ]

The double VLAN bits (EDVLP, ESVL, DOVLTC) are handled inconsistently
between the two vlan_update_hash() implementations:

- dwxgmac2_update_vlan_hash() explicitly clears the double VLAN bits when
is_double is false, meaning that adding a 802.1Q VLAN will disable
double VLAN mode:

  $ ip link add link eth0 name eth0.200 type vlan id 200 protocol 802.1ad
  $ ip link add link eth0 name eth0.100 type vlan id 100
  # Double VLAN bits no longer set

- vlan_update_hash() sets these bits and only clears them when the last
VLAN has been removed, so double VLAN mode remains enabled even after all
802.1AD VLANs are removed.

Address both issues by tracking the number of active 802.1AD VLANs in
priv->num_double_vlans. Pass this count to stmmac_vlan_update() so both
implementations correctly set the double VLAN bits when any 802.1AD
VLAN is active, and clear them only when none remain.

Also update vlan_update_hash() to explicitly clear the double VLAN bits
when is_double is false, matching the dwxgmac2 behavior.

Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Link: https://patch.msgid.link/20260303145828.7845-3-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2cd70e3968f5 ("net: stmmac: Defer VLAN HW configuration when interface is down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h     |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_vlan.c    |  8 ++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index c42cead28de98..865531d6cd3b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -316,6 +316,7 @@ struct stmmac_priv {
 	void __iomem *ptpaddr;
 	void __iomem *estaddr;
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	unsigned int num_double_vlans;
 	int sfty_irq;
 	int sfty_ce_irq;
 	int sfty_ue_irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 85f436dff4629..8f61d0f81a948 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6584,6 +6584,7 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	unsigned int num_double_vlans;
 	bool is_double = false;
 	int ret;
 
@@ -6595,7 +6596,8 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 		is_double = true;
 
 	set_bit(vid, priv->active_vlans);
-	ret = stmmac_vlan_update(priv, is_double);
+	num_double_vlans = priv->num_double_vlans + is_double;
+	ret = stmmac_vlan_update(priv, num_double_vlans);
 	if (ret) {
 		clear_bit(vid, priv->active_vlans);
 		goto err_pm_put;
@@ -6605,11 +6607,13 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret) {
 			clear_bit(vid, priv->active_vlans);
-			stmmac_vlan_update(priv, is_double);
+			stmmac_vlan_update(priv, priv->num_double_vlans);
 			goto err_pm_put;
 		}
 	}
 
+	priv->num_double_vlans = num_double_vlans;
+
 err_pm_put:
 	pm_runtime_put(priv->device);
 
@@ -6622,6 +6626,7 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	unsigned int num_double_vlans;
 	bool is_double = false;
 	int ret;
 
@@ -6633,7 +6638,8 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 		is_double = true;
 
 	clear_bit(vid, priv->active_vlans);
-	ret = stmmac_vlan_update(priv, is_double);
+	num_double_vlans = priv->num_double_vlans - is_double;
+	ret = stmmac_vlan_update(priv, num_double_vlans);
 	if (ret) {
 		set_bit(vid, priv->active_vlans);
 		goto del_vlan_error;
@@ -6643,11 +6649,13 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret) {
 			set_bit(vid, priv->active_vlans);
-			stmmac_vlan_update(priv, is_double);
+			stmmac_vlan_update(priv, priv->num_double_vlans);
 			goto del_vlan_error;
 		}
 	}
 
+	priv->num_double_vlans = num_double_vlans;
+
 del_vlan_error:
 	pm_runtime_put(priv->device);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
index b18404dd5a8be..de1a70e1c86ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
@@ -183,6 +183,10 @@ static void vlan_update_hash(struct mac_device_info *hw, u32 hash,
 			value |= VLAN_EDVLP;
 			value |= VLAN_ESVL;
 			value |= VLAN_DOVLTC;
+		} else {
+			value &= ~VLAN_EDVLP;
+			value &= ~VLAN_ESVL;
+			value &= ~VLAN_DOVLTC;
 		}
 
 		writel(value, ioaddr + VLAN_TAG);
@@ -193,6 +197,10 @@ static void vlan_update_hash(struct mac_device_info *hw, u32 hash,
 			value |= VLAN_EDVLP;
 			value |= VLAN_ESVL;
 			value |= VLAN_DOVLTC;
+		} else {
+			value &= ~VLAN_EDVLP;
+			value &= ~VLAN_ESVL;
+			value &= ~VLAN_DOVLTC;
 		}
 
 		writel(value | perfect_match, ioaddr + VLAN_TAG);
-- 
2.51.0

