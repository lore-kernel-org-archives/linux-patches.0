Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C43F1ADF;
	Wed, 20 May 2026 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296434; cv=none; b=UKz2dKELxNFJIcR74vhkwtLVIpUsAEN9FoY402sAnzuN1TOTxgGOAO7pBDFvMqN5RVTHxAf3Rr17ZmBeL6+D9Abqly6j2iW15vbH/eMKqu8SHzkp9jN3FrDAFyco86d9dtcH4kPPsUenPbXrjHSqO0iR6M1dy7MgPVGem+baIwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296434; c=relaxed/simple;
	bh=6SognTT0eA+W7XB/bE473SXVpUrGorb15OORx0OvGIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzAhtFaw6nqHdYetaIaceOLkBRAuSKWmZsD1dppa3T/JbIAxvktfHhAVKUV6EF55JZQYCf+SjnjyjPsXGzkIdUz9SbkgpcZHWPxDucGeOe2Ie6vuz+w7pBT9pasYpl/+RvQOeE2R/fpoqUe7yzohscUmWAQByYwPyAZh81kT68I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5EdMVwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5EdMVwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E686F1F00898;
	Wed, 20 May 2026 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296432;
	bh=8U4Ky/h+ruXl4JfzU9bJP68aMPnFuvSUfAbhmXvYH8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5EdMVwL91zNEynVR1d8oksZ3/+khLnfjnMoGPZvTRq9YthtLy6lT4HcGXZkOLZ59
	 cRLe34a+CATBjr1z2n02UKhHQeRji+5znw+N1Ybh96ZJ4HzlQP+YdXzTgYvox7TGdc
	 KH3A9J+35cLUIokiz7igxUncUMceh3u+Oy6lFohQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0797/1146] ice: fix PHY config on media change with link-down-on-close
Date: Wed, 20 May 2026 18:17:27 +0200
Message-ID: <20260520162206.262282368@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

[ Upstream commit 55e74f9ea7fea3d3da1cb6d5cacdaf8cf0fe3516 ]

Commit 1a3571b5938c ("ice: restore PHY settings on media insertion")
introduced separate flows for setting PHY configuration on media
present: ice_configure_phy() when link-down-on-close is disabled, and
ice_force_phys_link_state() when enabled. The latter incorrectly uses
the previous configuration even after module change, causing link
issues such as wrong speed or no link.

Unify PHY configuration into a single ice_phy_cfg() function with a
link_en parameter, ensuring PHY capabilities are always fetched fresh
from hardware.

Fixes: 1a3571b5938c ("ice: restore PHY settings on media insertion")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-5-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 121 +++++-----------------
 1 file changed, 27 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3c36e3641b9e9..ce3a0afe302d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1922,82 +1922,6 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	ice_print_vfs_mdd_events(pf);
 }
 
-/**
- * ice_force_phys_link_state - Force the physical link state
- * @vsi: VSI to force the physical link state to up/down
- * @link_up: true/false indicates to set the physical link to up/down
- *
- * Force the physical link state by getting the current PHY capabilities from
- * hardware and setting the PHY config based on the determined capabilities. If
- * link changes a link event will be triggered because both the Enable Automatic
- * Link Update and LESM Enable bits are set when setting the PHY capabilities.
- *
- * Returns 0 on success, negative on failure
- */
-static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
-{
-	struct ice_aqc_get_phy_caps_data *pcaps;
-	struct ice_aqc_set_phy_cfg_data *cfg;
-	struct ice_port_info *pi;
-	struct device *dev;
-	int retcode;
-
-	if (!vsi || !vsi->port_info || !vsi->back)
-		return -EINVAL;
-	if (vsi->type != ICE_VSI_PF)
-		return 0;
-
-	dev = ice_pf_to_dev(vsi->back);
-
-	pi = vsi->port_info;
-
-	pcaps = kzalloc_obj(*pcaps);
-	if (!pcaps)
-		return -ENOMEM;
-
-	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
-				      NULL);
-	if (retcode) {
-		dev_err(dev, "Failed to get phy capabilities, VSI %d error %d\n",
-			vsi->vsi_num, retcode);
-		retcode = -EIO;
-		goto out;
-	}
-
-	/* No change in link */
-	if (link_up == !!(pcaps->caps & ICE_AQC_PHY_EN_LINK) &&
-	    link_up == !!(pi->phy.link_info.link_info & ICE_AQ_LINK_UP))
-		goto out;
-
-	/* Use the current user PHY configuration. The current user PHY
-	 * configuration is initialized during probe from PHY capabilities
-	 * software mode, and updated on set PHY configuration.
-	 */
-	cfg = kmemdup(&pi->phy.curr_user_phy_cfg, sizeof(*cfg), GFP_KERNEL);
-	if (!cfg) {
-		retcode = -ENOMEM;
-		goto out;
-	}
-
-	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
-	if (link_up)
-		cfg->caps |= ICE_AQ_PHY_ENA_LINK;
-	else
-		cfg->caps &= ~ICE_AQ_PHY_ENA_LINK;
-
-	retcode = ice_aq_set_phy_cfg(&vsi->back->hw, pi, cfg, NULL);
-	if (retcode) {
-		dev_err(dev, "Failed to set phy config, VSI %d error %d\n",
-			vsi->vsi_num, retcode);
-		retcode = -EIO;
-	}
-
-	kfree(cfg);
-out:
-	kfree(pcaps);
-	return retcode;
-}
-
 /**
  * ice_init_nvm_phy_type - Initialize the NVM PHY type
  * @pi: port info structure
@@ -2066,7 +1990,7 @@ static void ice_init_link_dflt_override(struct ice_port_info *pi)
  * first time media is available. The ICE_LINK_DEFAULT_OVERRIDE_PENDING state
  * is used to indicate that the user PHY cfg default override is initialized
  * and the PHY has not been configured with the default override settings. The
- * state is set here, and cleared in ice_configure_phy the first time the PHY is
+ * state is set here, and cleared in ice_phy_cfg the first time the PHY is
  * configured.
  *
  * This function should be called only if the FW doesn't support default
@@ -2172,14 +2096,18 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 }
 
 /**
- * ice_configure_phy - configure PHY
+ * ice_phy_cfg - configure PHY
  * @vsi: VSI of PHY
+ * @link_en: true/false indicates to set link to enable/disable
  *
  * Set the PHY configuration. If the current PHY configuration is the same as
- * the curr_user_phy_cfg, then do nothing to avoid link flap. Otherwise
- * configure the based get PHY capabilities for topology with media.
+ * the curr_user_phy_cfg and link_en hasn't changed, then do nothing to avoid
+ * link flap. Otherwise configure the PHY based get PHY capabilities for
+ * topology with media and link_en.
+ *
+ * Return: 0 on success, negative on failure
  */
-static int ice_configure_phy(struct ice_vsi *vsi)
+static int ice_phy_cfg(struct ice_vsi *vsi, bool link_en)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct ice_port_info *pi = vsi->port_info;
@@ -2199,9 +2127,6 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	    phy->link_info.topo_media_conflict == ICE_AQ_LINK_TOPO_UNSUPP_MEDIA)
 		return -EPERM;
 
-	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags))
-		return ice_force_phys_link_state(vsi, true);
-
 	pcaps = kzalloc_obj(*pcaps);
 	if (!pcaps)
 		return -ENOMEM;
@@ -2215,10 +2140,8 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 		goto done;
 	}
 
-	/* If PHY enable link is configured and configuration has not changed,
-	 * there's nothing to do
-	 */
-	if (pcaps->caps & ICE_AQC_PHY_EN_LINK &&
+	/* Configuration has not changed. There's nothing to do. */
+	if (link_en == !!(pcaps->caps & ICE_AQC_PHY_EN_LINK) &&
 	    ice_phy_caps_equals_cfg(pcaps, &phy->curr_user_phy_cfg))
 		goto done;
 
@@ -2282,8 +2205,12 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	 */
 	ice_cfg_phy_fc(pi, cfg, phy->curr_user_fc_req);
 
-	/* Enable link and link update */
-	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT | ICE_AQ_PHY_ENA_LINK;
+	/* Enable/Disable link and link update */
+	cfg->caps |= ICE_AQ_PHY_ENA_AUTO_LINK_UPDT;
+	if (link_en)
+		cfg->caps |= ICE_AQ_PHY_ENA_LINK;
+	else
+		cfg->caps &= ~ICE_AQ_PHY_ENA_LINK;
 
 	err = ice_aq_set_phy_cfg(&pf->hw, pi, cfg, NULL);
 	if (err)
@@ -2336,7 +2263,7 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 		    test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags))
 			return;
 
-		err = ice_configure_phy(vsi);
+		err = ice_phy_cfg(vsi, true);
 		if (!err)
 			clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 
@@ -4892,9 +4819,15 @@ static int ice_init_link(struct ice_pf *pf)
 
 		if (!test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags)) {
 			struct ice_vsi *vsi = ice_get_main_vsi(pf);
+			struct ice_link_default_override_tlv *ldo;
+			bool link_en;
+
+			ldo = &pf->link_dflt_override;
+			link_en = !(ldo->options &
+				    ICE_LINK_OVERRIDE_AUTO_LINK_DIS);
 
 			if (vsi)
-				ice_configure_phy(vsi);
+				ice_phy_cfg(vsi, link_en);
 		}
 	} else {
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
@@ -9707,7 +9640,7 @@ int ice_open_internal(struct net_device *netdev)
 			}
 		}
 
-		err = ice_configure_phy(vsi);
+		err = ice_phy_cfg(vsi, true);
 		if (err) {
 			netdev_err(netdev, "Failed to set physical link up, error %d\n",
 				   err);
@@ -9748,7 +9681,7 @@ int ice_stop(struct net_device *netdev)
 	}
 
 	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
-		int link_err = ice_force_phys_link_state(vsi, false);
+		int link_err = ice_phy_cfg(vsi, false);
 
 		if (link_err) {
 			if (link_err == -ENOMEDIUM)
-- 
2.53.0



