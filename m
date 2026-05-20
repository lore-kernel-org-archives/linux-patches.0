Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A5336D4E1;
	Wed, 20 May 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299790; cv=none; b=C7aU7JxWsmrelmjOYXd4AXtnNF1x6/blc4O3YP7jxqmY691KsnIWb+g1XUkvokEMi9BUEhlDkPuwx1GKFXw3siW1LOBfmdhe7Y1MxYkItjNXOxv3+teChgIhDQQdsHKDLTp31HupO/9p9miZlyqWFVTdfAGtj0XDRtR7JbkgpSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299790; c=relaxed/simple;
	bh=0omiqpyEbO7Btk9C/OWYDkZV+rw7sRhjhB7bDINWP3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKgS68KXkU9OVYTxUAiXC5a9vVK+99AG0GG6e/ay7XWdS5RtnfVsp1jdfD+2xuwS6zIDIkp4M5N8hrCdImfms/3Hf1Lgx26GfVdRamkQdEGaFsSJ+9UOpiE6FwSEQWm7sk8vMVLC8BK1ZLCjoftddjNLxbHfIR2YOZ7jv343H7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xRbJ0Wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xRbJ0Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4DC1F000E9;
	Wed, 20 May 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299789;
	bh=HJZ+BnqhF8pR8Yyqu90xNFBwUh75Jqk97fB7Hp26mdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xRbJ0WxyVa3zbGHtOVOhgAjvjo6JIPb9k20UKSyxdiGe6PUdpOCh30DrIc7Q+XE3
	 juyZqSk0ucXRyMGFoV1VNyd0nMPgsriDVJ7ihmYTnweEUpTDrf5gXkN4G6PuH7p/VV
	 WYV3pQiK/Hdd4D4k2bbuf8/eN829WvA8E9oqzVSQ=
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
Subject: [PATCH 6.18 846/957] ice: fix infinite recursion in ice_cfg_tx_topo via ice_init_dev_hw
Date: Wed, 20 May 2026 18:22:09 +0200
Message-ID: <20260520162152.911050295@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 862ff1cdd46d6..839b7bfa19359 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -1243,6 +1243,8 @@ static int ice_devlink_reinit_up(struct ice_pf *pf)
 		return err;
 	}
 
+	ice_init_dev_hw(pf);
+
 	/* load MSI-X values */
 	ice_set_min_max_msix(pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c23a31ec3c413..4dcc3b41800b3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1162,8 +1162,6 @@ int ice_init_hw(struct ice_hw *hw)
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
 
-	ice_init_dev_hw(hw->back);
-
 	mutex_init(&hw->tnl_lock);
 	ice_init_chk_recipe_reuse_support(hw);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a4ae032f2161b..c064c3653c540 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5321,6 +5321,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
+	ice_init_dev_hw(pf);
+
 	adapter = ice_adapter_get(pdev);
 	if (IS_ERR(adapter)) {
 		err = PTR_ERR(adapter);
-- 
2.53.0



