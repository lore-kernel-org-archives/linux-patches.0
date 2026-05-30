Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54A1344DA4;
	Sat, 30 May 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161989; cv=none; b=cAVq6Pre2alIashBf7/AX4C5tCJeQPNaUE9T1Re2cB9QQr2RVqRKd0ThMX+L+bAC0QdctRoy/VWcFU4oStddFirEm9B56bRzwhlqSvgt7183Eo6v8kRxjiTyWqFNvV703o0iBKnRJn5Fy3HuJa8BNxsqi+y0x/PWktCItzYTIlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161989; c=relaxed/simple;
	bh=2CB1fHA4VlLpqA8fLPcax/topshBCOouG87iQSEwBqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI1Z8zs8jphh69MVhDOmwZAIDSTyVWJwpreOLPMUNOJKE3Y6g78I5UFQYs3+DkIVgHFN4cQ2fNpGTbpKt3MEDqnbNOT1HpRRmrXbE9gjqKe7zvfvNaJrPb2nq+3BlanXIYh0AB6VkG/X0Y4PsNah7uq08qWUo9K+sEE5X1B0r9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQh6q6ng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQh6q6ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91C71F00893;
	Sat, 30 May 2026 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161988;
	bh=Lfvdxzg26D0mzMSptymcqWX5noTznT8FwQRDCRRUJKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQh6q6ng16KsAiq+fxJpjFDBry0jTdlKfdOdgOC+kiQp/2i76ZUkTawFh00C1t5hX
	 yFPkBavD/1mOYwxuG/5w4UK5h96k6BKufivYvZCwyK88PilsGVJJ3iRzD93gcKK6ig
	 rHvK87Hoql/RacDJ3lXEl3Bkdrm+SOuNVCVebME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Marek Szlosek <marek.szlosek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 787/969] ice: Pull common tasks into ice_vf_post_vsi_rebuild
Date: Sat, 30 May 2026 18:05:11 +0200
Message-ID: <20260530160322.336427103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit aeead3d04fa050a94ed314cc5de97125a957dc9f ]

The Single Root IOV implementation of .post_vsi_rebuild performs some tasks
that will ultimately need to be shared with the Scalable IOV implementation
such as rebuilding the host configuration.

Refactor by introducing a new wrapper function, ice_vf_post_vsi_rebuild
which performs the tasks that will be shared between SR-IOV and Scalable
IOV. Move the ice_vf_rebuild_host_cfg and ice_vf_set_initialized calls into
this wrapper. Then call the implementation specific post_vsi_rebuild
handler afterwards.

This ensures that we will properly re-initialize filters and expected
settings for both SR-IOV and Scalable IOV.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 54ef02487914 ("ice: fix NULL pointer dereference in ice_reset_all_vfs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c  |  2 --
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 19 +++++++++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index b719e9a771e36..148712037bcbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -841,8 +841,6 @@ static int ice_sriov_vsi_rebuild(struct ice_vf *vf)
  */
 static void ice_sriov_post_vsi_rebuild(struct ice_vf *vf)
 {
-	ice_vf_rebuild_host_cfg(vf);
-	ice_vf_set_initialized(vf);
 	ice_ena_vf_mappings(vf);
 	wr32(&vf->pf->hw, VFGEN_RSTAT(vf->vf_id), VIRTCHNL_VFR_VFACTIVE);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 9dbe6e9bb1f79..d146259c7b82f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -270,6 +270,21 @@ static int ice_vf_rebuild_vsi(struct ice_vf *vf)
 	return 0;
 }
 
+/**
+ * ice_vf_post_vsi_rebuild - Reset tasks that occur after VSI rebuild
+ * @vf: the VF being reset
+ *
+ * Perform reset tasks which must occur after the VSI has been re-created or
+ * rebuilt during a VF reset.
+ */
+static void ice_vf_post_vsi_rebuild(struct ice_vf *vf)
+{
+	ice_vf_rebuild_host_cfg(vf);
+	ice_vf_set_initialized(vf);
+
+	vf->vf_ops->post_vsi_rebuild(vf);
+}
+
 /**
  * ice_is_any_vf_in_unicast_promisc - check if any VF(s)
  * are in unicast promiscuous mode
@@ -495,7 +510,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
-		vf->vf_ops->post_vsi_rebuild(vf);
+		ice_vf_post_vsi_rebuild(vf);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
@@ -647,7 +662,7 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 		goto out_unlock;
 	}
 
-	vf->vf_ops->post_vsi_rebuild(vf);
+	ice_vf_post_vsi_rebuild(vf);
 	vsi = ice_get_vf_vsi(vf);
 	if (WARN_ON(!vsi)) {
 		err = -EINVAL;
-- 
2.53.0



