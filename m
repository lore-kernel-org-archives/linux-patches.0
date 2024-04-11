Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BFA143C76;
	Thu, 11 Apr 2024 10:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831199; cv=none; b=nNjnjdU3Us78uPJBigD6eJNkSJcAyMrH45cTIcqHHXnNEJpvX02OPbFgz30t5mjVq/MxDuiM8cTF0cG0VxqloeHpMxWwAw9G77y3DY8P7KvoC3MBLolgXswsEg883lD5AO4gGsXwuvArfXfBuvN72oVGrghqBMG4BfYz/zibj8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831199; c=relaxed/simple;
	bh=JFGmwpt53lHTtYoxmJzmlrk0r56AjltdxgDshWeGAdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqnVV+cLa3+ZcZ6l5YJuA8jxW1jVlmMAWP1pTxQygRcndU6SXnGj6G0L2WzlzfLwpbTwN7qqHKVT+cN20PS6bGwPERqwXU7M+G6Rx8ChLxtJlFhK5hUaHwRduzYSuvD8wVKx9RZLO7Xqg6J4xW5nW+rYXW9cq4oCG4HW+Wd/7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j76dyjMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j76dyjMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA703C433F1;
	Thu, 11 Apr 2024 10:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831199;
	bh=JFGmwpt53lHTtYoxmJzmlrk0r56AjltdxgDshWeGAdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j76dyjMVpYTqs2/A2/1zjMnCXWAWtwgZtOCjWSh1aPlGgNYfdsHIq4HRmDUCnHqEf
	 dVW3n+qLNHHmOQVHddapLoD56BWUAA/nwD9jBsVct6Fn5dNZHaSqnso9WU1WdO2fzx
	 SkGTpNPA+iPR690eISWyAWRGmGaT8UgIQQuAzbn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/114] ice: use relative VSI index for VFs instead of PF VSI number
Date: Thu, 11 Apr 2024 11:56:08 +0200
Message-ID: <20240411095418.121278212@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 11fbb1bfb5bc8c98b2d7db9da332b5e568f4aaab ]

When initializing over virtchnl, the PF is required to pass a VSI ID to the
VF as part of its capabilities exchange. The VF driver reports this value
back to the PF in a variety of commands. The PF driver validates that this
value matches the value it sent to the VF.

Some hardware families such as the E700 series could use this value when
reading RSS registers or communicating directly with firmware over the
Admin Queue.

However, E800 series hardware does not support any of these interfaces and
the VF's only use for this value is to report it back to the PF. Thus,
there is no requirement that this value be an actual VSI ID value of any
kind.

The PF driver already does not trust that the VF sends it a real VSI ID.
The VSI structure is always looked up from the VF structure. The PF does
validate that the VSI ID provided matches a VSI associated with the VF, but
otherwise does not use the VSI ID for any purpose.

Instead of reporting the VSI number relative to the PF space, report a
fixed value of 1. When communicating with the VF over virtchnl, validate
that the VSI number is returned appropriately.

This avoids leaking information about the firmware of the PF state.
Currently the ice driver only supplies a VF with a single VSI. However, it
appears that virtchnl has some support for allowing multiple VSIs. I did
not attempt to implement this. However, space is left open to allow further
relative indexes if additional VSIs are provided in future feature
development. For this reason, keep the ice_vc_isvalid_vsi_id function in
place to allow extending it for multiple VSIs in the future.

This change will also simplify handling of live migration in a future
series. Since we no longer will provide a real VSI number to the VF, there
will be no need to keep track of this number when migrating to a new host.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 9 ++-------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h | 9 +++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 3a28210be3c23..d8509e86214ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -496,7 +496,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->rss_lut_size = ICE_LUT_VSI_SIZE;
 	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
 
-	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
+	vfres->vsi_res[0].vsi_id = ICE_VF_VSI_ID;
 	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
 	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
 	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
@@ -542,12 +542,7 @@ static void ice_vc_reset_vf_msg(struct ice_vf *vf)
  */
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id)
 {
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-
-	vsi = ice_find_vsi(pf, vsi_id);
-
-	return (vsi && (vsi->vf == vf));
+	return vsi_id == ICE_VF_VSI_ID;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
index cd747718de738..a0d03f350dfc7 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
@@ -19,6 +19,15 @@
 #define ICE_MAX_MACADDR_PER_VF		18
 #define ICE_FLEX_DESC_RXDID_MAX_NUM	64
 
+/* VFs only get a single VSI. For ice hardware, the VF does not need to know
+ * its VSI index. However, the virtchnl interface requires a VSI number,
+ * mainly due to legacy hardware.
+ *
+ * Since the VF doesn't need this information, report a static value to the VF
+ * instead of leaking any information about the PF or hardware setup.
+ */
+#define ICE_VF_VSI_ID	1
+
 struct ice_virtchnl_ops {
 	int (*get_ver_msg)(struct ice_vf *vf, u8 *msg);
 	int (*get_vf_res_msg)(struct ice_vf *vf, u8 *msg);
-- 
2.43.0



