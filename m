Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477EB18DB01;
	Tue, 26 Aug 2025 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213867; cv=none; b=rEBDK+apoyvbXBIEPX1YZ9a7f8b4dE66OjtdhKi9MJrZpEfnS8uRqeoCifxFAjFW27zkMbhZ7qN3g59smBWZ5/KIU65T+jxtdpQpYVJ2wo7ElwYawxPVgWciG+OZl7lLeC9cWLbFOeBElE+cjvPVISif6WhrSE98UVRURmWb/NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213867; c=relaxed/simple;
	bh=cPbmyBhzTWVzE3SX389CWsGl0eL4kT975pwbXro78YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRr15ehsZaCqV3LoXFSi7j5B3Q96YhsQ4d8kjHI0Cz+hgjEPgSqPSNt+YLWIUtJiY8X4NguP667Mfud5+eHc+0NKpSXxphZP7Fb+TVEloFEI5XPShYObd3cRi7m2gVR8om5wCgzS80g3/2TTEuohM0/ie5Cb+LiKUS15SFXuj8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7oFTyox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7oFTyox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0956C4CEF1;
	Tue, 26 Aug 2025 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213867;
	bh=cPbmyBhzTWVzE3SX389CWsGl0eL4kT975pwbXro78YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7oFTyoxImIuyTy8im2SmIJ9FVNyJN8M6qmqBnfveMjTVH83PhorL4BaMIjdQeBN0
	 FuN6eJwALB6gWn8m7oGfGrpVB3kbZ5lWhjfMfSiGRM6ut0LVgLgg5lyksq0yZSlE6c
	 9gbb3hXh796wDXZI8YSPjlWFr2Xb55fL+Ho2gSdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 508/587] mmc: sdhci-pci-gli: Use PCI AER definitions, not hard-coded values
Date: Tue, 26 Aug 2025 13:10:57 +0200
Message-ID: <20250826111005.911907431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 951b7ccc54591ba48755b5e0c7fc8b9623a64640 ]

015c9cbcf0ad ("mmc: sdhci-pci-gli: GL9750: Mask the replay timer timeout of
AER") added PCI_GLI_9750_CORRERR_MASK, the offset of the AER Capability in
config space, and PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT, the
Replay Timer Timeout bit in the AER Correctable Error Status register.

Use pci_find_ext_capability() to locate the AER Capability and use the
existing PCI_ERR_COR_REP_TIMER definition to mask the bit.

This removes a little bit of unnecessarily device-specific code and makes
AER-related things more greppable.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20240327214831.1544595-2-helgaas@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: dec8b38be4b3 ("mmc: sdhci-pci-gli: Add a new function to simplify the code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -28,9 +28,6 @@
 #define PCI_GLI_9750_PM_CTRL	0xFC
 #define   PCI_GLI_9750_PM_STATE	  GENMASK(1, 0)
 
-#define PCI_GLI_9750_CORRERR_MASK				0x214
-#define   PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
-
 #define SDHCI_GLI_9750_CFG2          0x848
 #define   SDHCI_GLI_9750_CFG2_L1DLY    GENMASK(28, 24)
 #define   GLI_9750_CFG2_L1DLY_VALUE    0x1F
@@ -155,9 +152,6 @@
 #define PCI_GLI_9755_PM_CTRL     0xFC
 #define   PCI_GLI_9755_PM_STATE    GENMASK(1, 0)
 
-#define PCI_GLI_9755_CORRERR_MASK				0x214
-#define   PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT	  BIT(12)
-
 #define SDHCI_GLI_9767_GM_BURST_SIZE			0x510
 #define   SDHCI_GLI_9767_GM_BURST_SIZE_AXI_ALWAYS_SET	  BIT(8)
 
@@ -547,6 +541,7 @@ static void gl9750_hw_setting(struct sdh
 {
 	struct sdhci_pci_slot *slot = sdhci_priv(host);
 	struct pci_dev *pdev;
+	int aer;
 	u32 value;
 
 	pdev = slot->chip->pdev;
@@ -568,9 +563,12 @@ static void gl9750_hw_setting(struct sdh
 	pci_write_config_dword(pdev, PCI_GLI_9750_PM_CTRL, value);
 
 	/* mask the replay timer timeout of AER */
-	pci_read_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, &value);
-	value |= PCI_GLI_9750_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
-	pci_write_config_dword(pdev, PCI_GLI_9750_CORRERR_MASK, value);
+	aer = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (aer) {
+		pci_read_config_dword(pdev, aer + PCI_ERR_COR_MASK, &value);
+		value |= PCI_ERR_COR_REP_TIMER;
+		pci_write_config_dword(pdev, aer + PCI_ERR_COR_MASK, value);
+	}
 
 	gl9750_wt_off(host);
 }
@@ -745,6 +743,7 @@ static void sdhci_gl9755_set_clock(struc
 static void gl9755_hw_setting(struct sdhci_pci_slot *slot)
 {
 	struct pci_dev *pdev = slot->chip->pdev;
+	int aer;
 	u32 value;
 
 	gl9755_wt_on(pdev);
@@ -782,9 +781,12 @@ static void gl9755_hw_setting(struct sdh
 	pci_write_config_dword(pdev, PCI_GLI_9755_PM_CTRL, value);
 
 	/* mask the replay timer timeout of AER */
-	pci_read_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, &value);
-	value |= PCI_GLI_9755_CORRERR_MASK_REPLAY_TIMER_TIMEOUT;
-	pci_write_config_dword(pdev, PCI_GLI_9755_CORRERR_MASK, value);
+	aer = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (aer) {
+		pci_read_config_dword(pdev, aer + PCI_ERR_COR_MASK, &value);
+		value |= PCI_ERR_COR_REP_TIMER;
+		pci_write_config_dword(pdev, aer + PCI_ERR_COR_MASK, value);
+	}
 
 	gl9755_wt_off(pdev);
 }


