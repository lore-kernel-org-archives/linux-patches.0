Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D361F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653EFC433C8;
	Tue,  1 Aug 2023 09:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882854;
	bh=65vNRZCExz/tEOS41AQXAk+lvvZ+5r64jErCSF4/yrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q4B7xA2wR/8CiHBWKwhori27kh1HEIEIC4WbMAQCrtFkDc+s5aoCqG6PC5hMdbRk
	 K8Qr5R3ynhShbQpNwtmNhChQRZOfPzhRA2HhzJ5QG6RfjhhbtUKII5TRjb+I172xSX
	 EVtSdYiHoHVm9S074DlUW0TdnnJo1SYPvCFWCsqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 026/239] PCI/ASPM: Return 0 or -ETIMEDOUT from pcie_retrain_link()
Date: Tue,  1 Aug 2023 11:18:10 +0200
Message-ID: <20230801091926.575541069@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit f5297a01ee805d7fa569d288ed65fc0f9ac9b03d ]

"pcie_retrain_link" is not a question with a true/false answer, so "bool"
isn't quite the right return type.  Return 0 for success or -ETIMEDOUT if
the retrain failed.  No functional change intended.

[bhelgaas: based on Ilpo's patch below]
Link: https://lore.kernel.org/r/20230502083923.34562-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: e7e39756363a ("PCI/ASPM: Avoid link retraining race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index db32335039d61..88aca887e3120 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -193,7 +193,7 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 	link->clkpm_disable = blacklist ? 1 : 0;
 }
 
-static bool pcie_retrain_link(struct pcie_link_state *link)
+static int pcie_retrain_link(struct pcie_link_state *link)
 {
 	struct pci_dev *parent = link->pdev;
 	unsigned long end_jiffies;
@@ -220,7 +220,9 @@ static bool pcie_retrain_link(struct pcie_link_state *link)
 			break;
 		msleep(1);
 	} while (time_before(jiffies, end_jiffies));
-	return !(reg16 & PCI_EXP_LNKSTA_LT);
+	if (reg16 & PCI_EXP_LNKSTA_LT)
+		return -ETIMEDOUT;
+	return 0;
 }
 
 /*
@@ -289,15 +291,15 @@ static void pcie_aspm_configure_common_clock(struct pcie_link_state *link)
 		reg16 &= ~PCI_EXP_LNKCTL_CCC;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 
-	if (pcie_retrain_link(link))
-		return;
+	if (pcie_retrain_link(link)) {
 
-	/* Training failed. Restore common clock configurations */
-	pci_err(parent, "ASPM: Could not configure common clock\n");
-	list_for_each_entry(child, &linkbus->devices, bus_list)
-		pcie_capability_write_word(child, PCI_EXP_LNKCTL,
+		/* Training failed. Restore common clock configurations */
+		pci_err(parent, "ASPM: Could not configure common clock\n");
+		list_for_each_entry(child, &linkbus->devices, bus_list)
+			pcie_capability_write_word(child, PCI_EXP_LNKCTL,
 					   child_reg[PCI_FUNC(child->devfn)]);
-	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, parent_reg);
+		pcie_capability_write_word(parent, PCI_EXP_LNKCTL, parent_reg);
+	}
 }
 
 /* Convert L0s latency encoding to ns */
-- 
2.39.2



