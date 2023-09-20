Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D933AC0F
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94BFC433C8;
	Wed, 20 Sep 2023 12:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213046;
	bh=VEYrYnCl5l4CSkD+YxSp35nEGmTLVYLUI3Cak+JiOpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ/93z9jHHc/ICWraqe25JkppP7lK0hnFERL6j0eOh9lP9GuESQ07BeBG7ci+XOq9
	 l8vlyFblu2I+2EFBkZqJCH8XVS721HcjkNIm9nACHf10hVqOShw3X1YA1dxmQAnxlU
	 8R8SCAsSCFEW21/KJQEnr0cy6naJUer2xlZ4by1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@fredlawl.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/367] drm/radeon: Prefer pcie_capability_read_word()
Date: Wed, 20 Sep 2023 13:28:38 +0200
Message-ID: <20230920112902.334912277@linuxfoundation.org>
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

[ Upstream commit 3d581b11e34a92350983e5d3ecf469b5c677e295 ]

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

Link: https://lore.kernel.org/r/20191118003513.10852-1-fred@fredlawl.com
Signed-off-by: Frederick Lawler <fred@fredlawl.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 7189576e8a82 ("drm/radeon: Use RMW accessors for changing LNKCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/cik.c | 70 +++++++++++++++++++++-------------
 drivers/gpu/drm/radeon/si.c  | 73 +++++++++++++++++++++++-------------
 2 files changed, 90 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 816976f44fffb..6476f901b63e6 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -9504,7 +9504,6 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 {
 	struct pci_dev *root = rdev->pdev->bus->self;
 	enum pci_bus_speed speed_cap;
-	int bridge_pos, gpu_pos;
 	u32 speed_cntl, current_data_rate;
 	int i;
 	u16 tmp16;
@@ -9546,12 +9545,7 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 		DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
 	}
 
-	bridge_pos = pci_pcie_cap(root);
-	if (!bridge_pos)
-		return;
-
-	gpu_pos = pci_pcie_cap(rdev->pdev);
-	if (!gpu_pos)
+	if (!pci_is_pcie(root) || !pci_is_pcie(rdev->pdev))
 		return;
 
 	if (speed_cap == PCIE_SPEED_8_0GT) {
@@ -9561,14 +9555,17 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 			u16 bridge_cfg2, gpu_cfg2;
 			u32 max_lw, current_lw, tmp;
 
-			pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-			pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+			pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+						  &bridge_cfg);
+			pcie_capability_read_word(rdev->pdev, PCI_EXP_LNKCTL,
+						  &gpu_cfg);
 
 			tmp16 = bridge_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(root, PCI_EXP_LNKCTL, tmp16);
 
 			tmp16 = gpu_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(rdev->pdev, PCI_EXP_LNKCTL,
+						   tmp16);
 
 			tmp = RREG32_PCIE_PORT(PCIE_LC_STATUS1);
 			max_lw = (tmp & LC_DETECTED_LINK_WIDTH_MASK) >> LC_DETECTED_LINK_WIDTH_SHIFT;
@@ -9586,15 +9583,23 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 
 			for (i = 0; i < 10; i++) {
 				/* check status */
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_DEVSTA, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_DEVSTA,
+							  &tmp16);
 				if (tmp16 & PCI_EXP_DEVSTA_TRPND)
 					break;
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &bridge_cfg);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &gpu_cfg);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &bridge_cfg2);
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &gpu_cfg2);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &bridge_cfg2);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &gpu_cfg2);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp |= LC_SET_QUIESCE;
@@ -9607,32 +9612,45 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
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
 
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (gpu_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(rdev->pdev,
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
 
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (gpu_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(rdev->pdev,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp &= ~LC_SET_QUIESCE;
@@ -9646,7 +9664,7 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 	speed_cntl &= ~LC_FORCE_DIS_SW_SPEED_CHANGE;
 	WREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL, speed_cntl);
 
-	pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+	pcie_capability_read_word(rdev->pdev, PCI_EXP_LNKCTL2, &tmp16);
 	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
 	if (speed_cap == PCIE_SPEED_8_0GT)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
@@ -9654,7 +9672,7 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
-	pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+	pcie_capability_write_word(rdev->pdev, PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL);
 	speed_cntl |= LC_INITIATE_LINK_SPEED_CHANGE;
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 21ac174e21f50..d7eea75b2c277 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3257,7 +3257,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 		/* XXX what about 12? */
 		rdev->config.si.tile_config |= (3 << 0);
 		break;
-	}	
+	}
 	switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
 	case 0: /* four banks */
 		rdev->config.si.tile_config |= 0 << 4;
@@ -7087,7 +7087,6 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 {
 	struct pci_dev *root = rdev->pdev->bus->self;
 	enum pci_bus_speed speed_cap;
-	int bridge_pos, gpu_pos;
 	u32 speed_cntl, current_data_rate;
 	int i;
 	u16 tmp16;
@@ -7129,12 +7128,7 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 		DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
 	}
 
-	bridge_pos = pci_pcie_cap(root);
-	if (!bridge_pos)
-		return;
-
-	gpu_pos = pci_pcie_cap(rdev->pdev);
-	if (!gpu_pos)
+	if (!pci_is_pcie(root) || !pci_is_pcie(rdev->pdev))
 		return;
 
 	if (speed_cap == PCIE_SPEED_8_0GT) {
@@ -7144,14 +7138,17 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 			u16 bridge_cfg2, gpu_cfg2;
 			u32 max_lw, current_lw, tmp;
 
-			pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-			pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+			pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+						  &bridge_cfg);
+			pcie_capability_read_word(rdev->pdev, PCI_EXP_LNKCTL,
+						  &gpu_cfg);
 
 			tmp16 = bridge_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(root, PCI_EXP_LNKCTL, tmp16);
 
 			tmp16 = gpu_cfg | PCI_EXP_LNKCTL_HAWD;
-			pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+			pcie_capability_write_word(rdev->pdev, PCI_EXP_LNKCTL,
+						   tmp16);
 
 			tmp = RREG32_PCIE(PCIE_LC_STATUS1);
 			max_lw = (tmp & LC_DETECTED_LINK_WIDTH_MASK) >> LC_DETECTED_LINK_WIDTH_SHIFT;
@@ -7169,15 +7166,23 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 
 			for (i = 0; i < 10; i++) {
 				/* check status */
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_DEVSTA, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_DEVSTA,
+							  &tmp16);
 				if (tmp16 & PCI_EXP_DEVSTA_TRPND)
 					break;
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &bridge_cfg);
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &gpu_cfg);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &bridge_cfg);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &gpu_cfg);
 
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &bridge_cfg2);
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &gpu_cfg2);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL2,
+							  &bridge_cfg2);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &gpu_cfg2);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp |= LC_SET_QUIESCE;
@@ -7190,32 +7195,46 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 				msleep(100);
 
 				/* linkctl */
-				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(root, PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (bridge_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(root,
+							   PCI_EXP_LNKCTL,
+							   tmp16);
 
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL,
+							  &tmp16);
 				tmp16 &= ~PCI_EXP_LNKCTL_HAWD;
 				tmp16 |= (gpu_cfg & PCI_EXP_LNKCTL_HAWD);
-				pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
+				pcie_capability_write_word(rdev->pdev,
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
 
-				pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+				pcie_capability_read_word(rdev->pdev,
+							  PCI_EXP_LNKCTL2,
+							  &tmp16);
 				tmp16 &= ~(PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN);
 				tmp16 |= (gpu_cfg2 &
 					  (PCI_EXP_LNKCTL2_ENTER_COMP |
 					   PCI_EXP_LNKCTL2_TX_MARGIN));
-				pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+				pcie_capability_write_word(rdev->pdev,
+							   PCI_EXP_LNKCTL2,
+							   tmp16);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
 				tmp &= ~LC_SET_QUIESCE;
@@ -7229,7 +7248,7 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 	speed_cntl &= ~LC_FORCE_DIS_SW_SPEED_CHANGE;
 	WREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL, speed_cntl);
 
-	pci_read_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
+	pcie_capability_read_word(rdev->pdev, PCI_EXP_LNKCTL2, &tmp16);
 	tmp16 &= ~PCI_EXP_LNKCTL2_TLS;
 	if (speed_cap == PCIE_SPEED_8_0GT)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_8_0GT; /* gen3 */
@@ -7237,7 +7256,7 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_5_0GT; /* gen2 */
 	else
 		tmp16 |= PCI_EXP_LNKCTL2_TLS_2_5GT; /* gen1 */
-	pci_write_config_word(rdev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
+	pcie_capability_write_word(rdev->pdev, PCI_EXP_LNKCTL2, tmp16);
 
 	speed_cntl = RREG32_PCIE_PORT(PCIE_LC_SPEED_CNTL);
 	speed_cntl |= LC_INITIATE_LINK_SPEED_CHANGE;
-- 
2.40.1



