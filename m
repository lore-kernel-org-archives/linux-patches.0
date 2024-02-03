Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D94F5EB;
	Sat,  3 Feb 2024 04:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933834; cv=none; b=VbQEyZ/AJ8eaALUIiGrSgwzTOkJrF5VFOl+aaiiBoF5K2/XGUka0796fCThiCZoawXEEPsi6lReM3YxjujF53uN0IBniTrDSk+gt7l8B9LLgpToxoZmTLkVoXUOp/kvAFbGk+JDCta5zi5CXcs3AarRBpUINvEyudl9nsqfspfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933834; c=relaxed/simple;
	bh=Mv6BlLe87Cf738bnBJ5C7poHF+T63bXgvMAbLknBLOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwO6IIoguRD7jLI+36m2rJ0u3yz/md0+aP/EXt2MiZQZHaKSf8y+QHkMSarj+nzB1aSVh2MnMABnsXD53agdxATr1yyiDQKYBAqTyMuXNTBo3Khzsx8qqq1NnI0DdvWHEMmzN81ipHwjxYAocCPqlCiK9c3Lwbq88TL5qhiXlZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imYJ2+kF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imYJ2+kF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D6C43394;
	Sat,  3 Feb 2024 04:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933834;
	bh=Mv6BlLe87Cf738bnBJ5C7poHF+T63bXgvMAbLknBLOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imYJ2+kFBFNXzplAJyzkilTXdjHzvNT0j4PUOqQhMgvRHXafMBXbHD5yzOEUl3izJ
	 3tCcrebe21SBqrfQf3qRHin1Bd1hBpu8MHBzB7Bztnaj1ZRzsW9bUFVyqDTuNh9DPB
	 Yi02yxrfMC5m6nxRwutHThUVkCuP685Spf4LIGgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 141/353] ice: fix pre-shifted bit usage
Date: Fri,  2 Feb 2024 20:04:19 -0800
Message-ID: <20240203035408.160327479@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 7173be21ae29ef50ada42fd4464056a9d3f55bb3 ]

While converting to FIELD_PREP() and FIELD_GET(), it was noticed that
some of the RSS defines had *included* the shift in their definitions.
This is completely outside of normal, such that a developer could easily
make a mistake and shift at the usage site (like when using
FIELD_PREP()).

Rename the defines and set them to the "pre-shifted values" so they
match the template the driver normally uses for masks and the member
bits of the mask, which also allows the driver to use FIELD_PREP
correctly with these values. Use GENMASK() for this changed MASK value.

Do the same for the VLAN EMODE defines as well.

Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_lib.c         |  3 ++-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c    | 16 +++++++++++-----
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 812a35d79b95..b8437c36ff38 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -421,10 +421,10 @@ struct ice_aqc_vsi_props {
 #define ICE_AQ_VSI_INNER_VLAN_INSERT_PVID	BIT(2)
 #define ICE_AQ_VSI_INNER_VLAN_EMODE_S		3
 #define ICE_AQ_VSI_INNER_VLAN_EMODE_M		(0x3 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
-#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH	(0x0 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
-#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_UP	(0x1 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
-#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR		(0x2 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
-#define ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING	(0x3 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH	0x0U
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_UP	0x1U
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR		0x2U
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING	0x3U
 	u8 inner_vlan_reserved2[3];
 	/* ingress egress up sections */
 	__le32 ingress_table; /* bitmap, 3 bits per up */
@@ -490,7 +490,7 @@ struct ice_aqc_vsi_props {
 #define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S		2
 #define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M		(0xF << ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S)
 #define ICE_AQ_VSI_Q_OPT_RSS_HASH_S		6
-#define ICE_AQ_VSI_Q_OPT_RSS_HASH_M		(0x3 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_HASH_M		GENMASK(7, 6)
 #define ICE_AQ_VSI_Q_OPT_RSS_HASH_TPLZ		0x0U
 #define ICE_AQ_VSI_Q_OPT_RSS_HASH_SYM_TPLZ	0x1U
 #define ICE_AQ_VSI_Q_OPT_RSS_HASH_XOR		0x2U
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 24f95880a2ed..c01950de44ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -979,7 +979,8 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
 	 */
 	if (ice_is_dvm_ena(hw)) {
 		ctxt->info.inner_vlan_flags |=
-			ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING;
+			FIELD_PREP(ICE_AQ_VSI_INNER_VLAN_EMODE_M,
+				   ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING);
 		ctxt->info.outer_vlan_flags =
 			(ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ALL <<
 			 ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S) &
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 76266e709a39..8307902115ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -131,6 +131,7 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 {
 	struct ice_hw *hw = &vsi->back->hw;
 	struct ice_vsi_ctx *ctxt;
+	u8 *ivf;
 	int err;
 
 	/* do not allow modifying VLAN stripping when a port VLAN is configured
@@ -143,19 +144,24 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 	if (!ctxt)
 		return -ENOMEM;
 
+	ivf = &ctxt->info.inner_vlan_flags;
+
 	/* Here we are configuring what the VSI should do with the VLAN tag in
 	 * the Rx packet. We can either leave the tag in the packet or put it in
 	 * the Rx descriptor.
 	 */
-	if (ena)
+	if (ena) {
 		/* Strip VLAN tag from Rx packet and put it in the desc */
-		ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH;
-	else
+		*ivf = FIELD_PREP(ICE_AQ_VSI_INNER_VLAN_EMODE_M,
+				  ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH);
+	} else {
 		/* Disable stripping. Leave tag in packet */
-		ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING;
+		*ivf = FIELD_PREP(ICE_AQ_VSI_INNER_VLAN_EMODE_M,
+				  ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING);
+	}
 
 	/* Allow all packets untagged/tagged */
-	ctxt->info.inner_vlan_flags |= ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL;
+	*ivf |= ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL;
 
 	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID);
 
-- 
2.43.0



