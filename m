Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E575F19AD42;
	Thu,  6 Jun 2024 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683038; cv=none; b=XS6DM0MItx9Y4Rh3ms1sba75beJsRuUX+J/l2JFHm/N04lUfXwPVy+ozpk04j6CX+c6gmmC3544k0e8I7fNgOAqHDPlWa2Vl4rxf+dTew1zeOchm+TdPAgGQfEpNSOZEZFgHMrThmv6jPRqwNNtqTS+TllOpj9TVtesqMAw6Y7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683038; c=relaxed/simple;
	bh=iOJc6w3dShWCfh3AdGchQ8rMmVQ2BV3JYyDKMVfjq9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crEDcmiWsJoy36XT1Y++eoeT+TiSveJAycX5o8ihQN+088azKqV6gZvT04G8zZEl7A+BLaT6uQ+743sfwRucuiaP+aQhpbP5Nw1fXNoHF7iKuu0WNNhZuo26U66iuuMlQfjetHa2QSKSHvdorCYVGjhZLqHQ9hwSXuGjlMnrBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U48Eds4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U48Eds4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD057C4AF66;
	Thu,  6 Jun 2024 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683037;
	bh=iOJc6w3dShWCfh3AdGchQ8rMmVQ2BV3JYyDKMVfjq9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U48Eds4Q4uX7PNOHVitK/JT/iiDcnQI01wA+XeQUX22tLyBwZeYqa0TndaSfiEjT2
	 uO7Nvop1bl+LRaxf4fNJlp2hRGCt5p3A4D/QD5DhP68hw7MgdDdyYrhrTUbo+qOFnh
	 DjX00gdmqkZsK9fnZna9Z648MB0JkctAxHsb9vE4=
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
Subject: [PATCH 6.9 266/374] Revert "ixgbe: Manual AN-37 for troublesome link partners for X550 SFI"
Date: Thu,  6 Jun 2024 16:04:05 +0200
Message-ID: <20240606131700.810949117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ed440dd0c4f9f..84fb6b8de2a12 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3676,9 +3676,7 @@ struct ixgbe_info {
 #define IXGBE_KRM_LINK_S1(P)		((P) ? 0x8200 : 0x4200)
 #define IXGBE_KRM_LINK_CTRL_1(P)	((P) ? 0x820C : 0x420C)
 #define IXGBE_KRM_AN_CNTL_1(P)		((P) ? 0x822C : 0x422C)
-#define IXGBE_KRM_AN_CNTL_4(P)		((P) ? 0x8238 : 0x4238)
 #define IXGBE_KRM_AN_CNTL_8(P)		((P) ? 0x8248 : 0x4248)
-#define IXGBE_KRM_PCS_KX_AN(P)		((P) ? 0x9918 : 0x5918)
 #define IXGBE_KRM_SGMII_CTRL(P)		((P) ? 0x82A0 : 0x42A0)
 #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)	((P) ? 0x836C : 0x436C)
 #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)	((P) ? 0x8634 : 0x4634)
@@ -3688,7 +3686,6 @@ struct ixgbe_info {
 #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)	((P) ? 0x9054 : 0x5054)
 #define IXGBE_KRM_TX_COEFF_CTRL_1(P)	((P) ? 0x9520 : 0x5520)
 #define IXGBE_KRM_RX_ANA_CTL(P)		((P) ? 0x9A00 : 0x5A00)
-#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)	((P) ? 0x9180 : 0x5180)
 
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA		~(0x3 << 20)
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR		BIT(20)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 2decb0710b6e3..a5f6449344450 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1722,59 +1722,9 @@ static int ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
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



