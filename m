Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBAB1F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80669C433C7;
	Tue,  1 Aug 2023 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881857;
	bh=eIctwurLPCh32SM1IM67378SVqHj0DNRthqx0eX63PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3cJSB9HuEW4aXb7oTzDxFrPJClB5duGZ4vzVBacGkX/oGnCLWuzRkX3ubPQYL+9D
	 Lb12Q9bhcWFTCPhEMlkUgdVs+Ngn0NrATPL+rjqRO6TPD4VZi6Oc3T1st9b6VGp/E5
	 31QL2aZLLdyU8ha4jkVDGk4IC4gy6g4Qiu7+j7Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/155] PCI/ASPM: Avoid link retraining race
Date: Tue,  1 Aug 2023 11:18:47 +0200
Message-ID: <20230801091910.744645461@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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
index 5e09cbb563366..3078de668f911 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -212,8 +212,19 @@ static int pcie_wait_for_retrain(struct pci_dev *pdev)
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



