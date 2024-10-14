Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3424B34;
	Mon, 14 Oct 2024 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916680; cv=none; b=fdlHMtp/Jn2sAbW5AmaRrTPETQQAqgEnpgKWQF4FBQbicTuPJCPPuzu68F0C7WvAIJIBB9wP2h42cW3cEZf+PZDag4xjqGsGzla1eOClLJTxhy5W8GHDr5M0kliVV9/mF8/5qm8kRbAFQrB8G3daEO2zmfoBMHNECAQpVbG+Ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916680; c=relaxed/simple;
	bh=zn5r3WEK8FoJqgupltgiz8DmItn62tUveXQ5jvZmjWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBiGjApv1ovFtdRpidqHngTxpImbaANeN84CKryLTzcfeVWPUjIrLc4e0hzy7vJD5103yzoq490lKClo6/Dlh24AFoNNqpbFfmsSaHPSbon8OidpWZJkKkPnmIVIpfmSPF/i3fcKBePryhO6itBRzEZQZxXjSIYL+WKL3rs6Ilg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIU0c8S9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIU0c8S9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71184C4CEC3;
	Mon, 14 Oct 2024 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916680;
	bh=zn5r3WEK8FoJqgupltgiz8DmItn62tUveXQ5jvZmjWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIU0c8S9WWDzg6XeVtB6seIjtS/RQIg+HQmVT+oiZDSCvVM1o5B7FnUtx6M13jYJ0
	 KzO57rjjsdCWGOGEUkV1t68dK03UZlINbWv/mrG0LGzYZhbaGMDvFt1eyx0ArzX5Gf
	 kfKtZboMMSAdvatPnHrdoDbeCiqHGPbtwcw6er6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/213] e1000e: move force SMBUS near the end of enable_ulp function
Date: Mon, 14 Oct 2024 16:19:00 +0200
Message-ID: <20241014141044.321909155@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit bfd546a552e140b0a4c8a21527c39d6d21addb28 ]

The commit 861e8086029e ("e1000e: move force SMBUS from enable ulp
function to avoid PHY loss issue") introduces a regression on
PCH_MTP_I219_LM18 (PCIID: 0x8086550A). Without the referred commit, the
ethernet works well after suspend and resume, but after applying the
commit, the ethernet couldn't work anymore after the resume and the
dmesg shows that the NIC link changes to 10Mbps (1000Mbps originally):

    [   43.305084] e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Up 10 Mbps Full Duplex, Flow Control: Rx/Tx

Without the commit, the force SMBUS code will not be executed if
"return 0" or "goto out" is executed in the enable_ulp(), and in my
case, the "goto out" is executed since FWSM_FW_VALID is set. But after
applying the commit, the force SMBUS code will be ran unconditionally.

Here move the force SMBUS code back to enable_ulp() and put it
immediately ahead of hw->phy.ops.release(hw), this could allow the
longest settling time as possible for interface in this function and
doesn't change the original code logic.

The issue was found on a Lenovo laptop with the ethernet hw as below:
00:1f.6 Ethernet controller [0200]: Intel Corporation Device [8086:550a]
(rev 20).

And this patch is verified (cable plug and unplug, system suspend
and resume) on Lenovo laptops with ethernet hw: [8086:550a],
[8086:550b], [8086:15bb], [8086:15be], [8086:1a1f], [8086:1a1c] and
[8086:0dc7].

Fixes: 861e8086029e ("e1000e: move force SMBUS from enable ulp function to avoid PHY loss issue")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Acked-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240528-net-2024-05-28-intel-net-fixes-v1-1-dc8593d2bbc6@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 22 +++++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 18 -----------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index f9e94be36e97f..2e98a2a0bead9 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1225,6 +1225,28 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	}
 
 release:
+	/* Switching PHY interface always returns MDI error
+	 * so disable retry mechanism to avoid wasting time
+	 */
+	e1000e_disable_phy_retry(hw);
+
+	/* Force SMBus mode in PHY */
+	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &phy_reg);
+	if (ret_val) {
+		e1000e_enable_phy_retry(hw);
+		hw->phy.ops.release(hw);
+		goto out;
+	}
+	phy_reg |= CV_SMB_CTRL_FORCE_SMBUS;
+	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
+
+	e1000e_enable_phy_retry(hw);
+
+	/* Force SMBus mode in MAC */
+	mac_reg = er32(CTRL_EXT);
+	mac_reg |= E1000_CTRL_EXT_FORCE_SMBUS;
+	ew32(CTRL_EXT, mac_reg);
+
 	hw->phy.ops.release(hw);
 out:
 	if (ret_val)
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d377a286c0e1b..06d109063c8d8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6623,7 +6623,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, ctrl_ext, rctl, status, wufc;
 	int retval = 0;
-	u16 smb_ctrl;
 
 	/* Runtime suspend should only enable wakeup for link changes */
 	if (runtime)
@@ -6701,23 +6700,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 				goto skip_phy_configurations;
 			}
 		}
-
-		/* Force SMBUS to allow WOL */
-		/* Switching PHY interface always returns MDI error
-		 * so disable retry mechanism to avoid wasting time
-		 */
-		e1000e_disable_phy_retry(hw);
-
-		e1e_rphy(hw, CV_SMB_CTRL, &smb_ctrl);
-		smb_ctrl |= CV_SMB_CTRL_FORCE_SMBUS;
-		e1e_wphy(hw, CV_SMB_CTRL, smb_ctrl);
-
-		e1000e_enable_phy_retry(hw);
-
-		/* Force SMBus mode in MAC */
-		ctrl_ext = er32(CTRL_EXT);
-		ctrl_ext |= E1000_CTRL_EXT_FORCE_SMBUS;
-		ew32(CTRL_EXT, ctrl_ext);
 	}
 
 	/* Ensure that the appropriate bits are set in LPI_CTRL
-- 
2.43.0



