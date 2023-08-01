Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF201F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3029EC433C7;
	Tue,  1 Aug 2023 09:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882857;
	bh=NIuv8U56fPRNDTYgTGzvhmurKrIjSyf3NMRTVer8ENs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL8HlK7RGs/z7n2KMNPTV75NRFlytkoRWt6vRe7yP/o78SLzhLHhzLsxwBPgiOXEp
	 /eZdaHAo9YXg8R8ZzXbNa5esXPaHoLHN++2fVIvyUOjS9yWaQ/bJfKENVrr2/XBmzZ
	 QkPGUwKZd1Oe5NG7rfsxP/vk49CquXZTgjb4tszs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 027/239] PCI/ASPM: Factor out pcie_wait_for_retrain()
Date: Tue,  1 Aug 2023 11:18:11 +0200
Message-ID: <20230801091926.614779766@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 9c7f136433d26592cb4d9cd00b4e15c33d9797c6 ]

Factor pcie_wait_for_retrain() out from pcie_retrain_link().  No functional
change intended.

[bhelgaas: split out from
https: //lore.kernel.org/r/20230502083923.34562-1-ilpo.jarvinen@linux.intel.com]
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: e7e39756363a ("PCI/ASPM: Avoid link retraining race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 88aca887e3120..517f834ac93ef 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -193,10 +193,26 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 	link->clkpm_disable = blacklist ? 1 : 0;
 }
 
+static int pcie_wait_for_retrain(struct pci_dev *pdev)
+{
+	unsigned long end_jiffies;
+	u16 reg16;
+
+	/* Wait for Link Training to be cleared by hardware */
+	end_jiffies = jiffies + LINK_RETRAIN_TIMEOUT;
+	do {
+		pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &reg16);
+		if (!(reg16 & PCI_EXP_LNKSTA_LT))
+			return 0;
+		msleep(1);
+	} while (time_before(jiffies, end_jiffies));
+
+	return -ETIMEDOUT;
+}
+
 static int pcie_retrain_link(struct pcie_link_state *link)
 {
 	struct pci_dev *parent = link->pdev;
-	unsigned long end_jiffies;
 	u16 reg16;
 
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
@@ -212,17 +228,7 @@ static int pcie_retrain_link(struct pcie_link_state *link)
 		pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
 	}
 
-	/* Wait for link training end. Break out after waiting for timeout */
-	end_jiffies = jiffies + LINK_RETRAIN_TIMEOUT;
-	do {
-		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
-		if (!(reg16 & PCI_EXP_LNKSTA_LT))
-			break;
-		msleep(1);
-	} while (time_before(jiffies, end_jiffies));
-	if (reg16 & PCI_EXP_LNKSTA_LT)
-		return -ETIMEDOUT;
-	return 0;
+	return pcie_wait_for_retrain(parent);
 }
 
 /*
-- 
2.39.2



