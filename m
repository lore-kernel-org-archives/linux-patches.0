Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B53130A5C;
	Mon,  8 Apr 2024 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583048; cv=none; b=Y/RzsgRNNXZVJ46YUjsulaFH0X3ruYey+v8dVJxUH+hBufPHBzsxwKske+huCFZZO5xRf/c27kEDcMl4DAS6phW8od2FaetcMXNv3ktvxcTlcoBbRM2fXKF+nrxQisYeIBFv+o3Vb8AH/I/CB+XATvKe2ZBhqJ8pRNVUyhlrrGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583048; c=relaxed/simple;
	bh=E06cRZtZjF8aW4faUtdf7bhGBZy/r6+MMG8JVOmELoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsEEV50w+7DVsHwJcZAd3NGdT8xnhaT/6UNkZX9S2eY4enMLg+4wNIynxBbN//Sd/8EIS81JpIJ7ahGJpm9wl69AW4N7SKfUuilyUdWww5zCXbuyMNqB2Mk/D1/aJhirsI45XkttxDWO0u1kWdCpYnRBhUGnEp2TPWuwOSONmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqE8V111; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqE8V111"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204B4C433C7;
	Mon,  8 Apr 2024 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583047;
	bh=E06cRZtZjF8aW4faUtdf7bhGBZy/r6+MMG8JVOmELoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqE8V1111pmo1e8Z8KnM8GqcfaWQiAic4yeclgpUjZ0bBx5ievDEeidtUri4gkocv
	 jZ4uYPK6vng8U5YTrOTfs3YgI95kMjvjVks/FqpPT2xFMFrnGo0VXwZUadruOnJ2Fl
	 E3nl5D6BTQSsI9s0zu+vRITFEhkDV0n07NFp+wcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 134/273] e1000e: move force SMBUS from enable ulp function to avoid PHY loss issue
Date: Mon,  8 Apr 2024 14:56:49 +0200
Message-ID: <20240408125313.456523306@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 861e8086029e003305750b4126ecd6617465f5c7 ]

Forcing SMBUS inside the ULP enabling flow leads to sporadic PHY loss on
some systems. It is suspected to be caused by initiating PHY transactions
before the interface settles.

Separating this configuration from the ULP enabling flow and moving it to
the shutdown function allows enough time for the interface to settle and
avoids adding a delay.

Fixes: 6607c99e7034 ("e1000e: i219 - fix to enable both ULP and EEE in Sx state")
Co-developed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 19 -------------------
 drivers/net/ethernet/intel/e1000e/netdev.c  | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index d8e97669f31b0..f9e94be36e97f 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1165,25 +1165,6 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	if (ret_val)
 		goto out;
 
-	/* Switching PHY interface always returns MDI error
-	 * so disable retry mechanism to avoid wasting time
-	 */
-	e1000e_disable_phy_retry(hw);
-
-	/* Force SMBus mode in PHY */
-	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &phy_reg);
-	if (ret_val)
-		goto release;
-	phy_reg |= CV_SMB_CTRL_FORCE_SMBUS;
-	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
-
-	e1000e_enable_phy_retry(hw);
-
-	/* Force SMBus mode in MAC */
-	mac_reg = er32(CTRL_EXT);
-	mac_reg |= E1000_CTRL_EXT_FORCE_SMBUS;
-	ew32(CTRL_EXT, mac_reg);
-
 	/* Si workaround for ULP entry flow on i127/rev6 h/w.  Enable
 	 * LPLU and disable Gig speed when entering ULP
 	 */
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index cc8c531ec3dff..3692fce201959 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6623,6 +6623,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, ctrl_ext, rctl, status, wufc;
 	int retval = 0;
+	u16 smb_ctrl;
 
 	/* Runtime suspend should only enable wakeup for link changes */
 	if (runtime)
@@ -6696,6 +6697,23 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 			if (retval)
 				return retval;
 		}
+
+		/* Force SMBUS to allow WOL */
+		/* Switching PHY interface always returns MDI error
+		 * so disable retry mechanism to avoid wasting time
+		 */
+		e1000e_disable_phy_retry(hw);
+
+		e1e_rphy(hw, CV_SMB_CTRL, &smb_ctrl);
+		smb_ctrl |= CV_SMB_CTRL_FORCE_SMBUS;
+		e1e_wphy(hw, CV_SMB_CTRL, smb_ctrl);
+
+		e1000e_enable_phy_retry(hw);
+
+		/* Force SMBus mode in MAC */
+		ctrl_ext = er32(CTRL_EXT);
+		ctrl_ext |= E1000_CTRL_EXT_FORCE_SMBUS;
+		ew32(CTRL_EXT, ctrl_ext);
 	}
 
 	/* Ensure that the appropriate bits are set in LPI_CTRL
-- 
2.43.0



