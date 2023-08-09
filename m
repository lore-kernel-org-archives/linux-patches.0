Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B6D17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F689C433C8;
	Wed,  9 Aug 2023 11:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580435;
	bh=aU3qxn3G6HJeo84kmnq0JMS1zMg0+w/83krGntnvmA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzveRZOA9XijqPOOi701Ct3VO1oowBzrxv83P/XS97IbIdsdhSqlF6IJ+6D2uVHZS
	 0KHDvsbMpQWHUOCxcOfL1ERdJQ0aFnQCb55gMGxv3lDrxmpgpBgXEmjG4E4SdD9zk0
	 Cw6ykLrN5wF2Arejoo3jSaScqnlGDyDE78849ltY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/154] PCI/ASPM: Avoid link retraining race
Date: Wed,  9 Aug 2023 12:40:47 +0200
Message-ID: <20230809103637.477080966@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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

[ Upstream commit e7e39756363ad5bd83ddeae1063193d0f13870fd ]

PCIe r6.0.1, sec 7.5.3.7, recommends setting the link control parameters,
then waiting for the Link Training bit to be clear before setting the
Retrain Link bit.

This avoids a race where the LTSSM may not use the updated parameters if it
is already in the midst of link training because of other normal link
activity.

Wait for the Link Training bit to be clear before toggling the Retrain Link
bit to ensure that the LTSSM uses the updated link control parameters.

[bhelgaas: commit log, return 0 (success)/-ETIMEDOUT instead of bool for
both pcie_wait_for_retrain() and the existing pcie_retrain_link()]
Suggested-by: Lukas Wunner <lukas@wunner.de>
Fixes: 7d715a6c1ae5 ("PCI: add PCI Express ASPM support")
Link: https://lore.kernel.org/r/20230502083923.34562-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 749a367bde2df..55270180ae081 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -220,8 +220,19 @@ static int pcie_wait_for_retrain(struct pci_dev *pdev)
 static int pcie_retrain_link(struct pcie_link_state *link)
 {
 	struct pci_dev *parent = link->pdev;
+	int rc;
 	u16 reg16;
 
+	/*
+	 * Ensure the updated LNKCTL parameters are used during link
+	 * training by checking that there is no ongoing link training to
+	 * avoid LTSSM race as recommended in Implementation Note at the
+	 * end of PCIe r6.0.1 sec 7.5.3.7.
+	 */
+	rc = pcie_wait_for_retrain(parent);
+	if (rc)
+		return rc;
+
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
 	reg16 |= PCI_EXP_LNKCTL_RL;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
-- 
2.39.2



