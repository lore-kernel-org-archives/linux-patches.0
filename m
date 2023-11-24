Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA31364A4;
	Fri, 24 Nov 2023 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrJ6EfS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DD5C433C7;
	Fri, 24 Nov 2023 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849330;
	bh=3E/inGU1NH/BLX+tutRv11R5iy5v9qHnSmXgeZY6Sqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrJ6EfS1NcTjQtkkJxWHOdY7tSG8Kx3petl3kLXYpiHg+hbc/CaCCcVJcXoo+Lr2y
	 Ao1lNr5c4N4tJItkuXQqCUNko74WSZRp9IkKMWtukUd8atbr7Fmh6zcFlXw4jYOxDt
	 aP+QWsrw07lWH78fGqoX2FSgT8qjfC+mGBAQexKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/530] PCI: Do error check on own line to split long "if" conditions
Date: Fri, 24 Nov 2023 17:44:30 +0000
Message-ID: <20231124172031.287726870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d15f18053e5cc5576af9e7eef0b2a91169b6326d ]

Placing PCI error code check inside "if" condition usually results in need
to split lines. Combined with additional conditions the "if" condition
becomes messy.

Convert to the usual error handling pattern with an additional variable to
improve code readability. In addition, reverse the logic in
pci_find_vsec_capability() to get rid of &&.

No functional changes intended.

Link: https://lore.kernel.org/r/20230911125354.25501-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[bhelgaas: PCI_POSSIBLE_ERROR()]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c    | 9 ++++++---
 drivers/pci/probe.c  | 6 +++---
 drivers/pci/quirks.c | 6 +++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 59c01d68c6d5e..5e51e8bd5c13a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -732,15 +732,18 @@ u16 pci_find_vsec_capability(struct pci_dev *dev, u16 vendor, int cap)
 {
 	u16 vsec = 0;
 	u32 header;
+	int ret;
 
 	if (vendor != dev->vendor)
 		return 0;
 
 	while ((vsec = pci_find_next_ext_capability(dev, vsec,
 						     PCI_EXT_CAP_ID_VNDR))) {
-		if (pci_read_config_dword(dev, vsec + PCI_VNDR_HEADER,
-					  &header) == PCIBIOS_SUCCESSFUL &&
-		    PCI_VNDR_HEADER_ID(header) == cap)
+		ret = pci_read_config_dword(dev, vsec + PCI_VNDR_HEADER, &header);
+		if (ret != PCIBIOS_SUCCESSFUL)
+			continue;
+
+		if (PCI_VNDR_HEADER_ID(header) == cap)
 			return vsec;
 	}
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 795534589b985..43159965e09e9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1652,15 +1652,15 @@ static void pci_set_removable(struct pci_dev *dev)
 static bool pci_ext_cfg_is_aliased(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_QUIRKS
-	int pos;
+	int pos, ret;
 	u32 header, tmp;
 
 	pci_read_config_dword(dev, PCI_VENDOR_ID, &header);
 
 	for (pos = PCI_CFG_SPACE_SIZE;
 	     pos < PCI_CFG_SPACE_EXP_SIZE; pos += PCI_CFG_SPACE_SIZE) {
-		if (pci_read_config_dword(dev, pos, &tmp) != PCIBIOS_SUCCESSFUL
-		    || header != tmp)
+		ret = pci_read_config_dword(dev, pos, &tmp);
+		if ((ret != PCIBIOS_SUCCESSFUL) || (header != tmp))
 			return false;
 	}
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e3e915329510f..7b62797e242b1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5385,7 +5385,7 @@ int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
  */
 static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 {
-	int pos, i = 0;
+	int pos, i = 0, ret;
 	u8 next_cap;
 	u16 reg16, *cap;
 	struct pci_cap_saved_state *state;
@@ -5431,8 +5431,8 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 		pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
 
 		pdev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
-		if (pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status) !=
-		    PCIBIOS_SUCCESSFUL || (status == 0xffffffff))
+		ret = pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status);
+		if ((ret != PCIBIOS_SUCCESSFUL) || (PCI_POSSIBLE_ERROR(status)))
 			pdev->cfg_size = PCI_CFG_SPACE_SIZE;
 
 		if (pci_find_saved_cap(pdev, PCI_CAP_ID_EXP))
-- 
2.42.0



