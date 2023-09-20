Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAAB347C4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7415C433C8;
	Wed, 20 Sep 2023 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213030;
	bh=+Rq05fCK4SXTinzeZp0nCcum570U1BUzrJCHu0P5/ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIrk6XW/hxNYyqBMnA7HXRMGaxg4J/PKa0eMQThZ/i1Miz4tLCplOft5hS9X/1TCI
	 aep6wmDexnBh+HU+WeUVtE0FKZQrwsnnnc+yLkcKMuee27AzjIG12bhIzlAHlXZVsl
	 fyjfbdcfNQCbuLQRFLw7d6jiPAOVtltUdFeqPeQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/367] drm/amdgpu: Correct Transmit Margin masks
Date: Wed, 20 Sep 2023 13:28:32 +0200
Message-ID: <20230920112902.191129042@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 19d7a95a8ba66b198f759cf610cc935ce9840d5b ]

Previously we masked PCIe Link Control 2 register values with "7 << 9",
which was apparently intended to be the Transmit Margin field, but instead
was the high order bit of Transmit Margin, the Enter Modified Compliance
bit, and the Compliance SOS bit.

Correct the mask to "7 << 7", which is the Transmit Margin field.

Link: https://lore.kernel.org/r/20191112173503.176611-3-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ce7d88110b9e ("drm/amdgpu: Use RMW accessors for changing LNKCTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/cik.c | 8 ++++----
 drivers/gpu/drm/amd/amdgpu/si.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/cik.c b/drivers/gpu/drm/amd/amdgpu/cik.c
index b81bb414fcb30..13a5696d2a6a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/cik.c
+++ b/drivers/gpu/drm/amd/amdgpu/cik.c
@@ -1498,13 +1498,13 @@ static void cik_pcie_gen3_enable(struct amdgpu_device *adev)
 
 				/* linkctl2 */
 				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 9));
-				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 9)));
+				tmp16 &= ~((1 << 4) | (7 << 7));
+				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 7)));
 				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 9));
-				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 9)));
+				tmp16 &= ~((1 << 4) | (7 << 7));
+				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 7)));
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				tmp = RREG32_PCIE(ixPCIE_LC_CNTL4);
diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index 493af42152f26..1e350172dc7bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1737,13 +1737,13 @@ static void si_pcie_gen3_enable(struct amdgpu_device *adev)
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL, tmp16);
 
 				pci_read_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 9));
-				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 9)));
+				tmp16 &= ~((1 << 4) | (7 << 7));
+				tmp16 |= (bridge_cfg2 & ((1 << 4) | (7 << 7)));
 				pci_write_config_word(root, bridge_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				pci_read_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, &tmp16);
-				tmp16 &= ~((1 << 4) | (7 << 9));
-				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 9)));
+				tmp16 &= ~((1 << 4) | (7 << 7));
+				tmp16 |= (gpu_cfg2 & ((1 << 4) | (7 << 7)));
 				pci_write_config_word(adev->pdev, gpu_pos + PCI_EXP_LNKCTL2, tmp16);
 
 				tmp = RREG32_PCIE_PORT(PCIE_LC_CNTL4);
-- 
2.40.1



