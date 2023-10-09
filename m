Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67D32E63E
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vx0s6zBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B526C433C7;
	Mon,  9 Oct 2023 13:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858201;
	bh=oTfduTifHlBwFzZAkw2B/ZYIms1NhV0gqgyxRNAOzT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vx0s6zBULzrxxvHG0RF+yQi4expui7PXtvQXtkSt7ruhItyxAK9nqZRwR0qyDNO72
	 /gwNHRkSmdDA0rFd7CcEoL5PryLgZSrbKsy9QPcAsjgQpYisk+MC26bxuhm+fe/xaG
	 6Ii4rHqQgT1UZa6UMIcZ7sv1RkJBny6A+2wyQ1oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
	Karen Sornek <karen.sornek@intel.com>,
	Tony Brelinski <tony.brelinski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/131] i40e: Fix warning message and call stack during rmmod i40e driver
Date: Mon,  9 Oct 2023 15:01:01 +0200
Message-ID: <20231009130116.961176550@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karen Sornek <karen.sornek@intel.com>

[ Upstream commit 3a3b311e3881172fc8e019b6508f04bc40c92d9d ]

Restore part of reset functionality used when reset is called
from the VF to reset itself. Without this fix warning message
is displayed when VF is being removed via sysfs.

Fix the crash of the VF during reset by ensuring
that the PF receives the reset message successfully.
Refactor code to use one function instead of two.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: d0d362ffa33d ("i40e: Fix VF VLAN offloading when port VLAN is configured")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 53 ++++++++-----------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 590469c4a1b00..7a52be82d05a2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -130,17 +130,18 @@ void i40e_vc_notify_vf_reset(struct i40e_vf *vf)
 /***********************misc routines*****************************/
 
 /**
- * i40e_vc_disable_vf
+ * i40e_vc_reset_vf
  * @vf: pointer to the VF info
- *
- * Disable the VF through a SW reset.
+ * @notify_vf: notify vf about reset or not
+ * Reset VF handler.
  **/
-static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
+static void i40e_vc_reset_vf(struct i40e_vf *vf, bool notify_vf)
 {
 	struct i40e_pf *pf = vf->pf;
 	int i;
 
-	i40e_vc_notify_vf_reset(vf);
+	if (notify_vf)
+		i40e_vc_notify_vf_reset(vf);
 
 	/* We want to ensure that an actual reset occurs initiated after this
 	 * function was called. However, we do not want to wait forever, so
@@ -158,9 +159,14 @@ static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 		usleep_range(10000, 20000);
 	}
 
-	dev_warn(&vf->pf->pdev->dev,
-		 "Failed to initiate reset for VF %d after 200 milliseconds\n",
-		 vf->vf_id);
+	if (notify_vf)
+		dev_warn(&vf->pf->pdev->dev,
+			 "Failed to initiate reset for VF %d after 200 milliseconds\n",
+			 vf->vf_id);
+	else
+		dev_dbg(&vf->pf->pdev->dev,
+			"Failed to initiate reset for VF %d after 200 milliseconds\n",
+			vf->vf_id);
 }
 
 /**
@@ -2097,20 +2103,6 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 	return ret;
 }
 
-/**
- * i40e_vc_reset_vf_msg
- * @vf: pointer to the VF info
- *
- * called from the VF to reset itself,
- * unlike other virtchnl messages, PF driver
- * doesn't send the response back to the VF
- **/
-static void i40e_vc_reset_vf_msg(struct i40e_vf *vf)
-{
-	if (test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
-		i40e_reset_vf(vf, false);
-}
-
 /**
  * i40e_vc_config_promiscuous_mode_msg
  * @vf: pointer to the VF info
@@ -2664,8 +2656,7 @@ static int i40e_vc_request_queues_msg(struct i40e_vf *vf, u8 *msg)
 	} else {
 		/* successful request */
 		vf->num_req_queues = req_pairs;
-		i40e_vc_notify_vf_reset(vf);
-		i40e_reset_vf(vf, false);
+		i40e_vc_reset_vf(vf, true);
 		return 0;
 	}
 
@@ -3857,8 +3848,7 @@ static int i40e_vc_add_qch_msg(struct i40e_vf *vf, u8 *msg)
 	vf->adq_enabled = true;
 
 	/* reset the VF in order to allocate resources */
-	i40e_vc_notify_vf_reset(vf);
-	i40e_reset_vf(vf, false);
+	i40e_vc_reset_vf(vf, true);
 
 	return I40E_SUCCESS;
 
@@ -3898,8 +3888,7 @@ static int i40e_vc_del_qch_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	/* reset the VF in order to allocate resources */
-	i40e_vc_notify_vf_reset(vf);
-	i40e_reset_vf(vf, false);
+	i40e_vc_reset_vf(vf, true);
 
 	return I40E_SUCCESS;
 
@@ -3961,7 +3950,7 @@ int i40e_vc_process_vf_msg(struct i40e_pf *pf, s16 vf_id, u32 v_opcode,
 		i40e_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
-		i40e_vc_reset_vf_msg(vf);
+		i40e_vc_reset_vf(vf, false);
 		ret = 0;
 		break;
 	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
@@ -4215,7 +4204,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* Force the VF interface down so it has to bring up with new MAC
 	 * address
 	 */
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	dev_info(&pf->pdev->dev, "Bring down and up the VF interface to make this change effective.\n");
 
 error_param:
@@ -4279,7 +4268,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		/* duplicate request, so just return success */
 		goto error_pvid;
 
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	/* During reset the VF got a new VSI, so refresh a pointer. */
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	/* Locked once because multiple functions below iterate list */
@@ -4662,7 +4651,7 @@ int i40e_ndo_set_vf_trust(struct net_device *netdev, int vf_id, bool setting)
 		goto out;
 
 	vf->trusted = setting;
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
 		 vf_id, setting ? "" : "un");
 
-- 
2.40.1



