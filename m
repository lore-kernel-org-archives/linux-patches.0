Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD42431A6E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FECC433B7;
	Wed, 20 Sep 2023 12:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213035;
	bh=mfM5XcqYS1tpqqOCTkWwLah4RgNRItbgFpaQmcCE6XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ixi0H1RSW4SA5FYHsZipV+YbD/drBC83pY+y8Ey3CluZL5cOF95CXFCx/yda7xmLC
	 4R4dPXeS/YRVZPlvAeerJOGKtcA/8lHF9gdCY0sXn8dXXONTkCstlPJ7Oaw7jtlKsF
	 ZD8chUvK4XpfQ+p+LKXDa3zZbJS3p9lOnDv6ZEfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@fredlawl.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/367] drm/amdgpu: Prefer pcie_capability_read_word()
Date: Wed, 20 Sep 2023 13:28:34 +0200
Message-ID: <20230920112902.238418266@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

From: Frederick Lawler <fred@fredlawl.com>

[ Upstream commit 88027c89ea146e32485251f1c2dddcde43c8d04e ]

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

[bhelgaas: fix a couple remaining instances in cik.c]
Link: https://lore.kernel.org/r/20191118003513.10852-1-fred@fredlawl.com
Signed-off-by: Frederick Lawler <fred@fredlawl.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ce7d88110b9e ("drm/amdgpu: Use RMW accessors for changing LNKCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 71 ++++++++++++++++++++------------
 drivers/gpu/drm/amd/amdgpu/si.c  | 71 ++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index 3067bb874032f..38b06ae6357a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1384,7 +1384,6 @@ static int cik_set_vce_clocks(struct amdgpu_device *adev, u32 evclk, u32 ecclk)
 static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 {
 	struct pci_dev *root = adev->pdev->bus->self;
-	int bridge_pos, gpu_pos;
 	u32 speed_cntl, current_data_rate;
 	int i;
 	u16 tmp16;
@@ -1419,12 +1418,7 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 		DRM_INFO("enabling PCIE gen 2 link speeds, disable with amdgpu.pcie_gen2=0\n");
 	}
 
-	bridge_pos = pci_pcie_cap(root);
-	if (!bridge_pos)
-		return;
-
-	gpu_pos = pci_pcie_cap(adev->pdev);
-	if (!gpu_pos)
+	if (!pci_is_pcie(root) || !pci_is_pcie(adev->pdev))
 		return;
 
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3) {
@@ -1434,14 +1428,17 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 			u16 bridge_cfg2, gpu_cfg2;
 			u32 max_lw, current_lw, tmp;
 
-			pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-			pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+			pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+						  &bridge_cfg);
+			pcie_capability_read_word(adev->pdev, PCI_EXP_LNKCTL,
+						  &gpu_cfg);
 
 			tmp16 = bridge_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(root, PCI_EXP_LNKCTL, tmp16);
 
 			tmp16 = gpu_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(adev->pdev, PCI_EXP_LNKCTL,
+						   tmp16);
 
 			tmp = RREG32_PCIE(ixPCIE_LC_STATUS1);
 			max_lw = (tmp & PCIE_LC_STATUS1__LC_DETECTED_LINK_WIDTH_MASK) >>
@@ -1465,15 +1462,23 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 
 			for (i = 0; i < 10; i++) {
 				/* check status */
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_DEVSTA, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_DEVSTA,
+							  &tmp16);
 				if (tmp16 & PCI_EXP_DEVSTA_TRPND)
 					break;
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &bridge_cfg);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &gpu_cfg);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &bridge_cfg2);
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &gpu_cfg2);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &bridge_cfg2);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &gpu_cfg2);
 
 				tmp = RREG32_PCIE(ixPCIE_LC_CNTL4);
 				tmp |= PCIE_LC_CNTL4__LC_SET_QUIESCE_MASK;
@@ -1486,32 +1491,45 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 				msleep(100);
 
 				/* linkctl */
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (bridge_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(root, PCI_EXP_LNKCTL,
+							   tmp16);
 
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (gpu_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(adev->pdev,
+							   PCI_EXP_LNKCTL,
+							   tmp16);
 
 				/* linkctl2 */
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (bridge_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(root,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (gpu_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(adev->pdev,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
 				tmp = RREG32_PCIE(ixPCIE_LC_CNTL4);
 				tmp &= ~PCIE_LC_CNTL4__LC_SET_QUIESCE_MASK;
@@ -1526,15 +1544,16 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 	speed_cntl &= ~PCIE_LC_SPEED_CNTL__LC_FORCE_DIS_SW_SPEED_CHANGE_MASK;
 	WREG32_PCIE(ixPCIE_LC_SPEED_CNTL, speed_cntl);
 
-	pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+	pcie_capability_read_word(adev->pdev, PCI_EXP_LNKCTL2, &tmp16);
 	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
+
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
 	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
-	pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+	pcie_capability_write_word(adev->pdev, PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE(ixPCIE_LC_SPEED_CNTL);
 	speed_cntl |= PCIE_LC_SPEED_CNTL__LC_INITIATE_LINK_SPEED_CHANGE_MASK;
diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index a7dcb0d0f039c..9f82be879224a 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1633,7 +1633,6 @@ static void si_init_golden_registers(struct amdgpu_device *adev)
 static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 {
 	struct pci_dev *root = adev->pdev->bus->self;
-	int bridge_pos, gpu_pos;
 	u32 speed_cntl, current_data_rate;
 	int i;
 	u16 tmp16;
@@ -1668,12 +1667,7 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 		DRM_INFO("enabling PCIE gen 2 link speeds, disable with amdgpu.pcie_gen2=0\n");
 	}
 
-	bridge_pos = pci_pcie_cap(root);
-	if (!bridge_pos)
-		return;
-
-	gpu_pos = pci_pcie_cap(adev->pdev);
-	if (!gpu_pos)
+	if (!pci_is_pcie(root) || !pci_is_pcie(adev->pdev))
 		return;
 
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3) {
@@ -1682,14 +1676,17 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 			u16 bridge_cfg2, gpu_cfg2;
 			u32 max_lw, current_lw, tmp;
 
-			pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-			pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+			pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+						  &bridge_cfg);
+			pcie_capability_read_word(adev->pdev, PCI_EXP_LNKCTL,
+						  &gpu_cfg);
 
 			tmp16 = bridge_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(root, PCI_EXP_LNKCTL, tmp16);
 
 			tmp16 = gpu_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(adev->pdev, PCI_EXP_LNKCTL,
+						   tmp16);
 
 			tmp = RREG32_PCIE(PCIE_LC_STATUS1);
 			max_lw = (tmp & LC_DETECTED_LINK_WIDTH_MASK) >> LC_DETECTED_LINK_WIDTH_SHIFT;
@@ -1706,15 +1703,23 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 			}
 
 			for (i = 0; i < 10; i++) {
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_DEVSTA, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_DEVSTA,
+							  &tmp16);
 				if (tmp16 & PCI_EXP_DEVSTA_TRPND)
 					break;
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &bridge_cfg);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &gpu_cfg);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &bridge_cfg2);
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &gpu_cfg2);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &bridge_cfg2);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &gpu_cfg2);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp |= LC_SET_QUIESCE;
@@ -1726,31 +1731,44 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 
 				mdelay(100);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (bridge_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(root, PCI_EXP_LNKCTL,
+							   tmp16);
 
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (gpu_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(adev->pdev,
+							   PCI_EXP_LNKCTL,
+							   tmp16);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (bridge_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(root,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
-				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(adev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (gpu_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(adev->pdev,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp &= ~LC_SET_QUIESCE;
@@ -1763,15 +1781,16 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 	speed_cntl &= ~LC_FORCE_DIS_SW_SPEED_CHANGE;
 	WREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL, speed_cntl);
 
-	pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+	pcie_capability_read_word(adev->pdev, PCI_EXP_LNKCTL2, &tmp16);
 	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
+
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
 	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
-	pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+	pcie_capability_write_word(adev->pdev, PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL);
 	speed_cntl |= LC_INITIATE_LINK_SPEED_CHANGE;
-- 
2.40.1



