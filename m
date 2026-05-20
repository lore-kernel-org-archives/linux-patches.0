Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5203F44D0;
	Wed, 20 May 2026 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297034; cv=none; b=jF05VY21Jtj0NL8g1DdH3nC3S1R8i6leMuvYPVTyLJUYvdCDoqurVkhd+BqRNP+dB+WGh9/XHSdDu697HhOQkogHNhAuObzPgxGvc0uJuZuh44Ru2Dmz7oSJ/6BVN0ZDdNvmUOP+sWye01k6Z0zAz4X18WMVaIaXoXcfSCAt4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297034; c=relaxed/simple;
	bh=1dcyuBDWAgkH60ONtql2+TOA1Ock+feNL1OE91RiXzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNFrbHvfdO0pRMVfA2Y5PSf7zviIGdrNtt24oIj5g41atdau4VQwFehPh0OQ3/u9p+oheKIlnpmMAYk+7GGsmC7mfldXjvVCe2PdgUu+GTWJWOBCgJWSmPoj1h5NUputHDdQFkXKTjYbmNMFryOfHS31FCVeC8lTUdeyMWhA8eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOZG8Jjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOZG8Jjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB5F1F000E9;
	Wed, 20 May 2026 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297033;
	bh=s8MPOW5TWZ1eXP4QVZNPZBCBAOz7eykI/tgBxQYsVpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOZG8Jjsvd2XNHlpX6J8fBg2NXCWeSTwZvjrA6TZ7lVA5awV+gzvlnrR6n7mfgYd9
	 FIsU9J2aD1M31Apc3yIJ9zVselu68rj2TJOAK3BMwuJXtTr3IiaT85OJDZJ3AzLxwa
	 0QlJybKueg1esjMshWmFfnCwJvTFM1OANZ+yoOfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1025/1146] ice: fix infinite recursion in ice_cfg_tx_topo via ice_init_dev_hw
Date: Wed, 20 May 2026 18:21:15 +0200
Message-ID: <20260520162211.426484459@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit 70ad216411e030f67b1743774e245601194aee6a ]

On certain E810 configurations where firmware supports Tx scheduler
topology switching (tx_sched_topo_comp_mode_en), ice_cfg_tx_topo()
may need to apply a new 5-layer or 9-layer topology from the DDP
package. If the AQ command to set the topology fails (e.g. due to
invalid DDP data or firmware limitations), the global configuration
lock must still be cleared via a CORER reset.

Commit 86aae43f21cf ("ice: don't leave device non-functional if Tx
scheduler config fails") correctly fixed this by refactoring
ice_cfg_tx_topo() to always trigger CORER after acquiring the global
lock and re-initialize hardware via ice_init_hw() afterwards.

However, commit 8a37f9e2ff40 ("ice: move ice_deinit_dev() to the end
of deinit paths") later moved ice_init_dev_hw() into ice_init_hw(),
breaking the reinit path introduced by 86aae43f21cf. This creates an
infinite recursive call chain:

  ice_init_hw()
    ice_init_dev_hw()
      ice_cfg_tx_topo()         # topology change needed
        ice_deinit_hw()
        ice_init_hw()           # reinit after CORER
          ice_init_dev_hw()     # recurse
            ice_cfg_tx_topo()
              ...               # stack overflow

Fix by moving ice_init_dev_hw() back out of ice_init_hw() and calling
it explicitly from ice_probe() and ice_devlink_reinit_up(). The third
caller, ice_cfg_tx_topo(), intentionally does not need ice_init_dev_hw()
during its reinit, it only needs the core HW reinitialization. This
breaks the recursion cleanly without adding flags or guards.

The deinit ordering changes from commit 8a37f9e2ff40 ("ice: move
ice_deinit_dev() to the end of deinit paths") which fixed slow rmmod
are preserved, only the init-side placement of ice_init_dev_hw() is
reverted.

Fixes: 8a37f9e2ff40 ("ice: move ice_deinit_dev() to the end of deinit paths")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-6-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_common.c      | 2 --
 drivers/net/ethernet/intel/ice/ice_main.c        | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink.c b/drivers/net/ethernet/intel/ice/devlink/devlink.c
index 6144cee8034d7..641d6e289d5ce 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -1245,6 +1245,8 @@ static int ice_devlink_reinit_up(struct ice_pf *pf)
 		return err;
 	}
 
+	ice_init_dev_hw(pf);
+
 	/* load MSI-X values */
 	ice_set_min_max_msix(pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ce11fea122d03..b617a6bff8913 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1126,8 +1126,6 @@ int ice_init_hw(struct ice_hw *hw)
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
 
-	ice_init_dev_hw(hw->back);
-
 	mutex_init(&hw->tnl_lock);
 	ice_init_chk_recipe_reuse_support(hw);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ce3a0afe302d2..055968485af6c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5245,6 +5245,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
+	ice_init_dev_hw(pf);
+
 	adapter = ice_adapter_get(pdev);
 	if (IS_ERR(adapter)) {
 		err = PTR_ERR(adapter);
-- 
2.53.0



