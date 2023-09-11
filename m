Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD0C1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAF5C433C8;
	Mon, 11 Sep 2023 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441496;
	bh=Nji1C/hhKWRs9P1TLr8QVGaZS/We7XM5weKvAhCLqGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v56uM4EUaCtRCeFcj6hFFYFj1d8J7Izo0lL8uZyYoGJRUR7uZWQyYeJHjTYB9BiF7
	 oJMAo29o7YkzFoM9m3k9t/XjqS/3KFzzChwDFzVlpH37LsOSvzYfFrnpuvL0zCkLUO
	 AGKMKMvD3AH4H9XsaBhHRKSKGdACBQq9t6Y5fPew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 406/739] PCI: Make link retraining use RMW accessors for changing LNKCTL
Date: Mon, 11 Sep 2023 15:43:25 +0200
Message-ID: <20230911134702.517493323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit fb0171a4c01b4825e36a5584eaa84291179c64ce ]

Don't assume that the device is fully under the control of PCI core.  Use
RMW capability accessors in link retraining which do proper locking to
avoid losing concurrent updates to the register values.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Fixes: 4ec73791a64b ("PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum")
Fixes: 7d715a6c1ae5 ("PCI: add PCI Express ASPM support")
Link: https://lore.kernel.org/r/20230717120503.15276-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 60230da957e0c..f7315b13bb826 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4927,7 +4927,6 @@ static int pcie_wait_for_link_status(struct pci_dev *pdev,
 int pcie_retrain_link(struct pci_dev *pdev, bool use_lt)
 {
 	int rc;
-	u16 lnkctl;
 
 	/*
 	 * Ensure the updated LNKCTL parameters are used during link
@@ -4939,17 +4938,14 @@ int pcie_retrain_link(struct pci_dev *pdev, bool use_lt)
 	if (rc)
 		return rc;
 
-	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &lnkctl);
-	lnkctl |= PCI_EXP_LNKCTL_RL;
-	pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
+	pcie_capability_set_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_RL);
 	if (pdev->clear_retrain_link) {
 		/*
 		 * Due to an erratum in some devices the Retrain Link bit
 		 * needs to be cleared again manually to allow the link
 		 * training to succeed.
 		 */
-		lnkctl &= ~PCI_EXP_LNKCTL_RL;
-		pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnkctl);
+		pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_RL);
 	}
 
 	return pcie_wait_for_link_status(pdev, use_lt, !use_lt);
-- 
2.40.1



