Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C31BE22F;
	Thu,  6 Jun 2024 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683530; cv=none; b=l4GZc/uq9IlZHZiFjEqtY0OlDvtI5CRUpiDbeSr7iiwB2Zll8khQzLEE+guDvxMWj9aWO2f15f3DtP71woDqSRavW1ohn/5CC3sxvF5YHK+7/G61FSR82gyiw4kTYOkIVEsDWyPOTUYlo3OwYEbR+eyKFQ8L9xxELItbBFVOQg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683530; c=relaxed/simple;
	bh=Kf3oAt2YW7lNQDVNfxnXs9yPHHYGFFT9PuwbovhSXKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy+21QnnatN3I08f0Psw73D1Bh2XOU0KndP4WyoMig/xFarS2Ko0r+pGwEljX5HJW9HdhCFsTuVYkzL5ORra9d2oB+DMPbhrdlEXywWZS4fUIMACq3eKpMa4zRCRArkYLfxghK1A7BgrKTjgZ9iMyQGTvpCFSADSmztVLEa3aiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3ql6oQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3ql6oQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64389C2BD10;
	Thu,  6 Jun 2024 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683530;
	bh=Kf3oAt2YW7lNQDVNfxnXs9yPHHYGFFT9PuwbovhSXKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3ql6oQeH7kjYY84ETPARAhmcr4ebs7IoLWv3Avqe0rjKodNMiAgI5Ou/mZIqiLUo
	 eJ2ri5GbhdZNwHiMxmdDSaADoDNPyjbeJvVhlBiGF++yUJdo2bwnvebXhLZtDckIWO
	 KpVQGnlIanaOjtilmBXSHlFUSfwH91aphy5EMHLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jeff Daly <jeffd@silicom-usa.com>,
	kernel.org-fo5k2w@ycharbi.fr,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 421/473] Revert "ixgbe: Manual AN-37 for troublesome link partners for X550 SFI"
Date: Thu,  6 Jun 2024 16:05:50 +0200
Message-ID: <20240606131713.687492324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit b35b1c0b4e166a427395deaf61e3140495dfcb89 ]

This reverts commit 565736048bd5f9888990569993c6b6bfdf6dcb6d.

According to the commit, it implements a manual AN-37 for some
"troublesome" Juniper MX5 switches. This appears to be a workaround for a
particular switch.

It has been reported that this causes a severe breakage for other switches,
including a Cisco 3560CX-12PD-S.

The code appears to be a workaround for a specific switch which fails to
link in SFI mode. It expects to see AN-37 auto negotiation in order to
link. The Cisco switch is not expecting AN-37 auto negotiation. When the
device starts the manual AN-37, the Cisco switch decides that the port is
confused and stops attempting to link with it. This persists until a power
cycle. A simple driver unload and reload does not resolve the issue, even
if loading with a version of the driver which lacks this workaround.

The authors of the workaround commit have not responded with
clarifications, and the result of the workaround is complete failure to
connect with other switches.

This appears to be a case where the driver can either "correctly" link with
the Juniper MX5 switch, at the cost of bricking the link with the Cisco
switch, or it can behave properly for the Cisco switch, but fail to link
with the Junipir MX5 switch. I do not know enough about the standards
involved to clearly determine whether either switch is at fault or behaving
incorrectly. Nor do I know whether there exists some alternative fix which
corrects behavior with both switches.

Revert the workaround for the Juniper switch.

Fixes: 565736048bd5 ("ixgbe: Manual AN-37 for troublesome link partners for X550 SFI")
Link: https://lore.kernel.org/netdev/cbe874db-9ac9-42b8-afa0-88ea910e1e99@intel.com/T/
Link: https://forum.proxmox.com/threads/intel-x553-sfp-ixgbe-no-go-on-pve8.135129/#post-612291
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jeff Daly <jeffd@silicom-usa.com>
Cc: kernel.org-fo5k2w@ycharbi.fr
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240520-net-2024-05-20-revert-silicom-switch-workaround-v1-1-50f80f261c94@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 56 +------------------
 2 files changed, 3 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 61b9774b3d31e..c24a72d1e2737 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3673,9 +3673,7 @@ struct ixgbe_info {
 #define IXGBE_KRM_LINK_S1(P)		((P) ? 0x8200 : 0x4200)
 #define IXGBE_KRM_LINK_CTRL_1(P)	((P) ? 0x820C : 0x420C)
 #define IXGBE_KRM_AN_CNTL_1(P)		((P) ? 0x822C : 0x422C)
-#define IXGBE_KRM_AN_CNTL_4(P)		((P) ? 0x8238 : 0x4238)
 #define IXGBE_KRM_AN_CNTL_8(P)		((P) ? 0x8248 : 0x4248)
-#define IXGBE_KRM_PCS_KX_AN(P)		((P) ? 0x9918 : 0x5918)
 #define IXGBE_KRM_SGMII_CTRL(P)		((P) ? 0x82A0 : 0x42A0)
 #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)	((P) ? 0x836C : 0x436C)
 #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)	((P) ? 0x8634 : 0x4634)
@@ -3685,7 +3683,6 @@ struct ixgbe_info {
 #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)	((P) ? 0x9054 : 0x5054)
 #define IXGBE_KRM_TX_COEFF_CTRL_1(P)	((P) ? 0x9520 : 0x5520)
 #define IXGBE_KRM_RX_ANA_CTL(P)		((P) ? 0x9A00 : 0x5A00)
-#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)	((P) ? 0x9180 : 0x5180)
 
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA		~(0x3 << 20)
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR		BIT(20)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index cdc912bba8089..f1b63937c552c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1724,59 +1724,9 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
 		return -EINVAL;
 	}
 
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
-
-	/* change mode enforcement rules to hybrid */
-	(void)mac->ops.read_iosf_sb_reg(hw,
-			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
-	reg_val |= 0x0400;
-
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
-
-	/* manually control the config */
-	(void)mac->ops.read_iosf_sb_reg(hw,
-			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
-	reg_val |= 0x20002240;
-
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
-
-	/* move the AN base page values */
-	(void)mac->ops.read_iosf_sb_reg(hw,
-			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
-	reg_val |= 0x1;
-
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
-
-	/* set the AN37 over CB mode */
-	(void)mac->ops.read_iosf_sb_reg(hw,
-			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
-	reg_val |= 0x20000000;
-
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
-
-	/* restart AN manually */
-	(void)mac->ops.read_iosf_sb_reg(hw,
-			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
-	reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
-
-	(void)mac->ops.write_iosf_sb_reg(hw,
-			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
-			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
 
 	/* Toggle port SW reset by AN reset. */
 	status = ixgbe_restart_an_internal_phy_x550em(hw);
-- 
2.43.0



