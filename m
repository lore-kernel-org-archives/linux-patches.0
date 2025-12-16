Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B2B2BD5A2;
	Tue, 16 Dec 2025 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887136; cv=none; b=RkHSiSRtdgEiQQZ4EIl15xUpGJtYuitEMtdzmTYhz52Hv0o30beu9H3yJK8IDY8pG2pJM7h8ZzhhjyKbcxj7cpdyivP4YZeeails4ZYMSrGMGTcyMCSvx8Mj0pWKk/qAsgcmAo2QAsxgBnzqNnPaoLl9lJqgveDIn6pUjRjV/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887136; c=relaxed/simple;
	bh=5V8ZXz4zq5oi9CJ2KxSVvbvibJVOZEgsJ5f2zL5J1iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmcYrWjAsWPf/BZORqJAD+jayACuBZQN/uf8nr6DuAF/K8tvLYBqUy3IeJLwHExxjwgjCgk2sn3M3O1F3oYF71D2DST1cZ1fdFYYsy1oGoI7CyHVR19itSwrbfF7byod6inM0f1J15LENuIqscVs5MZz3saoVjS9tcUhHY0iQmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaapz3a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaapz3a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20979C4CEF1;
	Tue, 16 Dec 2025 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887135;
	bh=5V8ZXz4zq5oi9CJ2KxSVvbvibJVOZEgsJ5f2zL5J1iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaapz3a2ziS6TPcZ0wiYfIwNiHpcVRde62WFpGwV5eHQJowKVgYDQ9L0GeD53drc5
	 8+43DVw7s4PZ9uao2kCBHZzzl6AbuM34tqnKZSTWutdtSoKNNEDj9jBkZTyQ/RHkuI
	 DN+rz64SF0HW5frEtJqW1YUIFxvaD94yolMbKkA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 104/614] ice: move ice_deinit_dev() to the end of deinit paths
Date: Tue, 16 Dec 2025 12:07:51 +0100
Message-ID: <20251216111405.101888516@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 8a37f9e2ff40f4a4fa8def22febefe4daf58e573 ]

ice_deinit_dev() takes care of turning off adminq processing, which is
much needed during driver teardown (remove, reset, error path). Move it
to the very end where applicable.
For example, ice_deinit_hw() called after adminq deinit slows rmmod on
my two-card setup by about 60 seconds.

ice_init_dev() and ice_deinit_dev() scopes were reduced by previous
commits of the series, with a final touch of extracting ice_init_dev_hw()
out now (there is no deinit counterpart).

Note that removed ice_service_task_stop() call from ice_remove() is placed
in the ice_deinit_dev() (and stopping twice makes no sense).

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/devlink/devlink.c  |  5 +++-
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  3 +++
 drivers/net/ethernet/intel/ice/ice_main.c     | 23 ++++++++++++-------
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink.c b/drivers/net/ethernet/intel/ice/devlink/devlink.c
index c354a03c950cd..938914abbe066 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -1233,6 +1233,7 @@ static int ice_devlink_reinit_up(struct ice_pf *pf)
 {
 	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 	struct device *dev = ice_pf_to_dev(pf);
+	bool need_dev_deinit = false;
 	int err;
 
 	err = ice_init_hw(&pf->hw);
@@ -1276,9 +1277,11 @@ static int ice_devlink_reinit_up(struct ice_pf *pf)
 unroll_pf_init:
 	ice_deinit_pf(pf);
 unroll_dev_init:
-	ice_deinit_dev(pf);
+	need_dev_deinit = true;
 unroll_hw_init:
 	ice_deinit_hw(&pf->hw);
+	if (need_dev_deinit)
+		ice_deinit_dev(pf);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9a1abd4573372..9ee596773f34e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -1033,6 +1033,7 @@ void ice_start_service_task(struct ice_pf *pf);
 int ice_load(struct ice_pf *pf);
 void ice_unload(struct ice_pf *pf);
 void ice_adv_lnk_speed_maps_init(void);
+void ice_init_dev_hw(struct ice_pf *pf);
 int ice_init_dev(struct ice_pf *pf);
 void ice_deinit_dev(struct ice_pf *pf);
 int ice_init_pf(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2532b6f82e971..6edeb06b4dce2 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1161,6 +1161,9 @@ int ice_init_hw(struct ice_hw *hw)
 	status = ice_init_hw_tbls(hw);
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
+
+	ice_init_dev_hw(hw->back);
+
 	mutex_init(&hw->tnl_lock);
 	ice_init_chk_recipe_reuse_support(hw);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a12dcc733e041..f1ebdb7dbdc73 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4742,9 +4742,8 @@ static void ice_decfg_netdev(struct ice_vsi *vsi)
 	vsi->netdev = NULL;
 }
 
-int ice_init_dev(struct ice_pf *pf)
+void ice_init_dev_hw(struct ice_pf *pf)
 {
-	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	int err;
 
@@ -4764,6 +4763,12 @@ int ice_init_dev(struct ice_pf *pf)
 		 */
 		ice_set_safe_mode_caps(hw);
 	}
+}
+
+int ice_init_dev(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
 
 	ice_set_pf_caps(pf);
 	err = ice_init_interrupt_scheme(pf);
@@ -5220,6 +5225,7 @@ static int
 ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 {
 	struct device *dev = &pdev->dev;
+	bool need_dev_deinit = false;
 	struct ice_adapter *adapter;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
@@ -5342,11 +5348,13 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	devl_unlock(priv_to_devlink(pf));
 	ice_deinit(pf);
 unroll_dev_init:
-	ice_deinit_dev(pf);
+	need_dev_deinit = true;
 unroll_adapter:
 	ice_adapter_put(pdev);
 unroll_hw_init:
 	ice_deinit_hw(hw);
+	if (need_dev_deinit)
+		ice_deinit_dev(pf);
 	return err;
 }
 
@@ -5441,10 +5449,6 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_hwmon_exit(pf);
 
-	ice_service_task_stop(pf);
-	ice_aq_cancel_waiting_tasks(pf);
-	set_bit(ICE_DOWN, pf->state);
-
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
 
@@ -5456,13 +5460,16 @@ static void ice_remove(struct pci_dev *pdev)
 	devl_unlock(priv_to_devlink(pf));
 
 	ice_deinit(pf);
-	ice_deinit_dev(pf);
 	ice_vsi_release_all(pf);
 
 	ice_setup_mc_magic_wake(pf);
 	ice_set_wake(pf);
 
 	ice_adapter_put(pdev);
+
+	ice_deinit_dev(pf);
+	ice_aq_cancel_waiting_tasks(pf);
+	set_bit(ICE_DOWN, pf->state);
 }
 
 /**
-- 
2.51.0



