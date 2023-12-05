Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624036FAF;
	Tue,  5 Dec 2023 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HH7vY1Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE852C433C9;
	Tue,  5 Dec 2023 03:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746881;
	bh=oc3qm+uW1uBgYRbni2up2HvGclD6Jp10aDJWRIBCRis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HH7vY1QaewxLJA5JEYCpm1Q4ZdwpwUeSxaiZimpGXEdPhxMuk+tXyrO5GRNtsnr0p
	 P0XfQtbsR25NpXrSEJBDas4Z6FOhLY/hs7vM0VvwXF9h4WfdUjW556MJOJVdO4pAU2
	 Pjo+xuy3bRGyslEkz9UccEZ9ig7DCxaji7vH8RBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/71] PCI/ASPM: Add L1 PM substate support to pci_disable_link_state()
Date: Tue,  5 Dec 2023 12:16:52 +0900
Message-ID: <20231205031521.014788245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit aff5d0552da4055da3faa27ee4252e48bb1f5821 ]

Add support for disabling states L1.1 and L1.2 to pci_disable_link_state().
Allow separate control of ASPM and PCI PM L1 substates.

Link: https://lore.kernel.org/r/d81f8036-c236-6463-48e7-ebcdcda85bba@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 3cb4f534bac0 ("Revert "PCI/ASPM: Disable only ASPM_STATE_L1 when driver, disables L1"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 11 ++++++++++-
 include/linux/pci.h     | 10 +++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1f9e89c2c10d3..8f934c88dcd76 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1110,7 +1110,16 @@ static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 	if (state & PCIE_LINK_STATE_L0S)
 		link->aspm_disable |= ASPM_STATE_L0S;
 	if (state & PCIE_LINK_STATE_L1)
-		link->aspm_disable |= ASPM_STATE_L1;
+		/* L1 PM substates require L1 */
+		link->aspm_disable |= ASPM_STATE_L1 | ASPM_STATE_L1SS;
+	if (state & PCIE_LINK_STATE_L1_1)
+		link->aspm_disable |= ASPM_STATE_L1_1;
+	if (state & PCIE_LINK_STATE_L1_2)
+		link->aspm_disable |= ASPM_STATE_L1_2;
+	if (state & PCIE_LINK_STATE_L1_1_PCIPM)
+		link->aspm_disable |= ASPM_STATE_L1_1_PCIPM;
+	if (state & PCIE_LINK_STATE_L1_2_PCIPM)
+		link->aspm_disable |= ASPM_STATE_L1_2_PCIPM;
 	pcie_config_aspm_link(link, policy_to_aspm_state(link));
 
 	if (state & PCIE_LINK_STATE_CLKPM)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f8036acf2c12b..5e21876341c62 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1496,9 +1496,13 @@ extern bool pcie_ports_native;
 #define pcie_ports_native	false
 #endif
 
-#define PCIE_LINK_STATE_L0S	1
-#define PCIE_LINK_STATE_L1	2
-#define PCIE_LINK_STATE_CLKPM	4
+#define PCIE_LINK_STATE_L0S		BIT(0)
+#define PCIE_LINK_STATE_L1		BIT(1)
+#define PCIE_LINK_STATE_CLKPM		BIT(2)
+#define PCIE_LINK_STATE_L1_1		BIT(3)
+#define PCIE_LINK_STATE_L1_2		BIT(4)
+#define PCIE_LINK_STATE_L1_1_PCIPM	BIT(5)
+#define PCIE_LINK_STATE_L1_2_PCIPM	BIT(6)
 
 #ifdef CONFIG_PCIEASPM
 int pci_disable_link_state(struct pci_dev *pdev, int state);
-- 
2.42.0



