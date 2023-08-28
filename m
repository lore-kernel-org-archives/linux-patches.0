Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222811C97
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C2C433CB;
	Mon, 28 Aug 2023 10:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218676;
	bh=RY9xrpw1lXKOrVLELhsPD1CmWm2NkC8/svWpS/JgbqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKrggZH7LOhs+yKjnMoMLtp6B1PGgqWPQhINJC3Jn/TW9goMQubd/G4Ta2Bi4++6F
	 6dBAMBbwiNknhv8FA8L7Fetu5q6I+127f2dR2/78uXvnnlmbRg1LQmulEuC+jn/6H+
	 UZA2XzoUD5RufgCJsLsLcCvHTuuqjH99ose6Ozvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/122] Revert "ice: Fix ice VF reset during iavf initialization"
Date: Mon, 28 Aug 2023 12:12:38 +0200
Message-ID: <20230828101157.833614863@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 0ecff05e6c59dd82dbcb9706db911f7fd9f40fb8 ]

This reverts commit 7255355a0636b4eff08d5e8139c77d98f151c4fc.

After this commit we are not able to attach VF to VM:
virsh attach-interface v0 hostdev --managed 0000:41:01.0 --mac 52:52:52:52:52:52
error: Failed to attach interface
error: Cannot set interface MAC to 52:52:52:52:52:52 for ifname enp65s0f0np0 vf 0: Resource temporarily unavailable

ice_check_vf_ready_for_cfg() already contain waiting for reset.
New condition in ice_check_vf_ready_for_reset() causing only problems.

Fixes: 7255355a0636 ("ice: Fix ice VF reset during iavf initialization")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 -------------------
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 -
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 -
 4 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index b8c31bf721ad1..b719e9a771e36 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1240,7 +1240,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_reset(vf);
+	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1355,7 +1355,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto out_put_vf;
 	}
 
-	ret = ice_check_vf_ready_for_reset(vf);
+	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1409,7 +1409,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return -EOPNOTSUPP;
 	}
 
-	ret = ice_check_vf_ready_for_reset(vf);
+	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1722,7 +1722,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_reset(vf);
+	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		goto out_put_vf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 71047fc341392..86abbcb480d9d 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -185,25 +185,6 @@ int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 	return 0;
 }
 
-/**
- * ice_check_vf_ready_for_reset - check if VF is ready to be reset
- * @vf: VF to check if it's ready to be reset
- *
- * The purpose of this function is to ensure that the VF is not in reset,
- * disabled, and is both initialized and active, thus enabling us to safely
- * initialize another reset.
- */
-int ice_check_vf_ready_for_reset(struct ice_vf *vf)
-{
-	int ret;
-
-	ret = ice_check_vf_ready_for_cfg(vf);
-	if (!ret && !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
-		ret = -EAGAIN;
-
-	return ret;
-}
-
 /**
  * ice_trigger_vf_reset - Reset a VF on HW
  * @vf: pointer to the VF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index e5bed85724622..9f7fcd8e5714b 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -214,7 +214,6 @@ u16 ice_get_num_vfs(struct ice_pf *pf);
 struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf);
 bool ice_is_vf_disabled(struct ice_vf *vf);
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
-int ice_check_vf_ready_for_reset(struct ice_vf *vf);
 void ice_set_vf_state_dis(struct ice_vf *vf);
 bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index ef3c709d6a750..2b4c791b6cbad 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3722,7 +3722,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
-		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 		ops->reset_vf(vf);
 		break;
 	case VIRTCHNL_OP_ADD_ETH_ADDR:
-- 
2.40.1



