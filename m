Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405B41B85EB;
	Mon, 14 Oct 2024 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917125; cv=none; b=MdLDSUMBedNONF/9qtKQesF9d425awAzC8zGYQkKwGySxCt9yAfX+Y9XgmWQ/YOCfiCw/pXYe69k2cDXKY/uY7xnHOvRLCYNYyy8eV3xerEZuOvbu39gr4HZx/1BD5veA8WwjL6VQGKY8iOBPRaSeHtRL0kpqnSyw70VDKpCxic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917125; c=relaxed/simple;
	bh=7ohZmGulB9gkaH1SyF9xtWeoKxEKXu3WApNAGLJkSJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrMpOUCs5t0O32soduEZId11eJF/uvkmTryTqxLNX2BkDdXvW+QE0pmSiY8A+FSpF2KT0X11wOWwjJELxaxevPbPRN0MvNtrFs9348OjW5uAur/kyY/2wduDS8MahMr5h528unCBiM5hig2U5oQRmFWademYI6XreRvcDAbxl1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxgCIkT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxgCIkT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624F4C4CECF;
	Mon, 14 Oct 2024 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917124;
	bh=7ohZmGulB9gkaH1SyF9xtWeoKxEKXu3WApNAGLJkSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxgCIkT5GLukM4aDNozdB3Tu8q3RviXaj31eEato5mI8wiW70lnzHNVCMNqel1gll
	 CJGgve8+Qll6wgp8qpkAq6J5X6NZ/y+NhlJjVaPbIaDNv9zn99PlmuWuHtxTOH6g2y
	 dH+RoP4fnTWY4s5+Gfb1gup2u9bTkpkigDMI0SDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/213] ice: Flush FDB entries before reset
Date: Mon, 14 Oct 2024 16:20:47 +0200
Message-ID: <20241014141048.472709457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit fbcb968a98ac0b71f5a2bda2751d7a32d201f90d ]

Triggering the reset while in switchdev mode causes
errors[1]. Rules are already removed by this time
because switch content is flushed in case of the reset.
This means that rules were deleted from HW but SW
still thinks they exist so when we get
SWITCHDEV_FDB_DEL_TO_DEVICE notification we try to
delete not existing rule.

We can avoid these errors by clearing the rules
early in the reset flow before they are removed from HW.
Switchdev API will get notified that the rule was removed
so we won't get SWITCHDEV_FDB_DEL_TO_DEVICE notification.
Remove unnecessary ice_clear_sw_switch_recipes.

[1]
ice 0000:01:00.0: Failed to delete FDB forward rule, err: -2
ice 0000:01:00.0: Failed to delete FDB guard rule, err: -2

Fixes: 7c945a1a8e5f ("ice: Switchdev FDB events support")
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   |  5 +++-
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 24 +++----------------
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 8944f01e7a0b0..4750198d0c0ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -582,10 +582,13 @@ ice_eswitch_br_switchdev_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void ice_eswitch_br_fdb_flush(struct ice_esw_br *bridge)
+void ice_eswitch_br_fdb_flush(struct ice_esw_br *bridge)
 {
 	struct ice_esw_br_fdb_entry *entry, *tmp;
 
+	if (!bridge)
+		return;
+
 	list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list)
 		ice_eswitch_br_fdb_entry_notify_and_cleanup(bridge, entry);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index 85a8fadb2928e..3920e50611914 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -116,5 +116,6 @@ void
 ice_eswitch_br_offloads_deinit(struct ice_pf *pf);
 int
 ice_eswitch_br_offloads_init(struct ice_pf *pf);
+void ice_eswitch_br_fdb_flush(struct ice_esw_br *bridge);
 
 #endif /* _ICE_ESWITCH_BR_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 511064ab3fe3b..9f12c9a0fe296 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -518,25 +518,6 @@ static void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked)
 		pf->vf_agg_node[node].num_vsis = 0;
 }
 
-/**
- * ice_clear_sw_switch_recipes - clear switch recipes
- * @pf: board private structure
- *
- * Mark switch recipes as not created in sw structures. There are cases where
- * rules (especially advanced rules) need to be restored, either re-read from
- * hardware or added again. For example after the reset. 'recp_created' flag
- * prevents from doing that and need to be cleared upfront.
- */
-static void ice_clear_sw_switch_recipes(struct ice_pf *pf)
-{
-	struct ice_sw_recipe *recp;
-	u8 i;
-
-	recp = pf->hw.switch_info->recp_list;
-	for (i = 0; i < ICE_MAX_NUM_RECIPES; i++)
-		recp[i].recp_created = false;
-}
-
 /**
  * ice_prepare_for_reset - prep for reset
  * @pf: board private structure
@@ -573,8 +554,9 @@ ice_prepare_for_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	mutex_unlock(&pf->vfs.table_lock);
 
 	if (ice_is_eswitch_mode_switchdev(pf)) {
-		if (reset_type != ICE_RESET_PFR)
-			ice_clear_sw_switch_recipes(pf);
+		rtnl_lock();
+		ice_eswitch_br_fdb_flush(pf->eswitch.br_offloads->bridge);
+		rtnl_unlock();
 	}
 
 	/* release ADQ specific HW and SW resources */
-- 
2.43.0



