Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544AE171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44D1C433D2;
	Mon, 22 May 2023 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784967;
	bh=HptRQFeY9D7ErN7SyC7hV4Of2ITb+zyC4rmhmx/ASas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZU/VowOGrliqZq7VW9EvvN3CtXnssjNQr0Kb0PCwkeahFiRloNbUnBqjQ5rDVcc7
	 KwR7JSXeZtTST/fHBx+RquhtF0EE+efv0Qwj4pp3LyteM2mDJDHAKW7syeiPgH4Z4j
	 4E2BbMrGoQa4EaQrFEIAxrIZ36/ax2i6rDZ/+wUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Wesierski <dawidx.wesierski@intel.com>,
	Kamil Maziarz <kamil.maziarz@intel.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 264/364] ice: Fix ice VF reset during iavf initialization
Date: Mon, 22 May 2023 20:09:29 +0100
Message-Id: <20230522190419.317047753@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dawid Wesierski <dawidx.wesierski@intel.com>

[ Upstream commit 7255355a0636b4eff08d5e8139c77d98f151c4fc ]

Fix the current implementation that causes ice_trigger_vf_reset()
to start resetting the VF even when the VF-NIC is still initializing.

When we reset NIC with ice driver it can interfere with
iavf-vf initialization e.g. during consecutive resets induced by ice

iavf                ice
  |                  |
  |<-----------------|
  |            ice resets vf
 iavf                |
 reset               |
 start               |
  |<-----------------|
  |             ice resets vf
  |             causing iavf
  |             initialization
  |             error
  |                  |
 iavf
 reset
 end

This leads to a series of -53 errors
(failed to init adminq) from the IAVF.

Change the state of the vf_state field to be not active when the IAVF
is still initializing. Make sure to wait until receiving the message on
the message box to ensure that the vf is ready and initializded.

In simple terms we use the ACTIVE flag to make sure that the ice
driver knows if the iavf is ready for another reset

  iavf                  ice
    |                    |
    |                    |
    |<------------- ice resets vf
  iavf           vf_state != ACTIVE
  reset                  |
  start                  |
    |                    |
    |                    |
  iavf                   |
  reset-------> vf_state == ACTIVE
  end              ice resets vf
    |                    |
    |                    |

Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")
Signed-off-by: Dawid Wesierski <dawidx.wesierski@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Acked-by: Jacob Keller <Jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 0cc05e54a7815..d4206db7d6d54 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1181,7 +1181,7 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1296,7 +1296,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto out_put_vf;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1350,7 +1350,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return -EOPNOTSUPP;
 	}
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
@@ -1663,7 +1663,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (!vf)
 		return -EINVAL;
 
-	ret = ice_check_vf_ready_for_cfg(vf);
+	ret = ice_check_vf_ready_for_reset(vf);
 	if (ret)
 		goto out_put_vf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 0e57bd1b85fd4..59524a7c88c5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -185,6 +185,25 @@ int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 	return 0;
 }
 
+/**
+ * ice_check_vf_ready_for_reset - check if VF is ready to be reset
+ * @vf: VF to check if it's ready to be reset
+ *
+ * The purpose of this function is to ensure that the VF is not in reset,
+ * disabled, and is both initialized and active, thus enabling us to safely
+ * initialize another reset.
+ */
+int ice_check_vf_ready_for_reset(struct ice_vf *vf)
+{
+	int ret;
+
+	ret = ice_check_vf_ready_for_cfg(vf);
+	if (!ret && !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+		ret = -EAGAIN;
+
+	return ret;
+}
+
 /**
  * ice_trigger_vf_reset - Reset a VF on HW
  * @vf: pointer to the VF structure
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
index ef30f05b5d02e..3fc6a0a8d9554 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
@@ -215,6 +215,7 @@ u16 ice_get_num_vfs(struct ice_pf *pf);
 struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf);
 bool ice_is_vf_disabled(struct ice_vf *vf);
 int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
+int ice_check_vf_ready_for_reset(struct ice_vf *vf);
 void ice_set_vf_state_dis(struct ice_vf *vf);
 bool ice_is_any_vf_in_unicast_promisc(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index e24e3f5017ca6..d8c66baf4eb41 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3908,6 +3908,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
+		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 		ops->reset_vf(vf);
 		break;
 	case VIRTCHNL_OP_ADD_ETH_ADDR:
-- 
2.39.2



