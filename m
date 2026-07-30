Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B04119F8;
	Thu, 30 Jul 2026 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423564; cv=none; b=ZrXcQUqzFt5RmTMnBnda5rHxNu1BfX0dqP+rFMGvQlCiQb1rxq87RwuX+t/MZeIzSa5ivH67vqvR9bkRPwZRPWAEMbiEWPcyRWCVefl1Sx1tWlA24IJsG9UoHWJVsqMhUWf2rd0jx2DAN+JVM4Pt4Csf+I+JhHRXpoGNvvYrdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423564; c=relaxed/simple;
	bh=Aj0XuLSOBGZZdKXHk5Of6bLB+Xhm0FcpDlo9OlSXN8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeBsE//UOYYNRV1E59UL16U+8/DnQVG4RFCpvUI419MTXCc8lWlEf5ZLUVhbwPE8B2QP0j6sigTP90Ii488a8XlnMzxRCdkVKcQcWOMr+q7cfTMEYG71c5ccl27KLZFduOG/v88L6kbex/TESsqI3j8MmEgHqbnxEkwoHGPACSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBwkuEyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBwkuEyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E981F000E9;
	Thu, 30 Jul 2026 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423563;
	bh=0ue9QMAzr6E0ooARmvPSfHTruvG2/p2vg46ed06ypX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBwkuEyQMt5Q+xFKxnw6SGrT/ot1L/H2rXb13YkOocH2csejiyHvN5w3EcYv3PzJ3
	 +FlX/rQUf/cOU+YAZ6EhjH+6q+MobqIf9ZzUR5y4HvTEr3wrdtY7FJ5QLTq7cZr/aX
	 oAKyHMcnuD0O++IemOUwcxENe8Cl0ZBGSL/HmWmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/675] ASoC: amd: ps: disable MSI on resume in ACP PCI driver
Date: Thu, 30 Jul 2026 16:06:59 +0200
Message-ID: <20260730141447.022158937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 5893013efabb056399a01e267f410cf76eba25eb ]

BIOS/firmware may re-enable MSI in PCI config space during system
level resume even though this driver only uses legacy INTx interrupts.
If MSI is left enabled with stale address/data registers, the device
will write interrupts to a bogus address causing IOMMU IO_PAGE_FAULT
and interrupt delivery failure.

Clear the MSI Enable bit before reinitializing the ACP hardware on
system level resume.

Fixes: 491628388005 ("ASoC: amd: ps: add callback functions for acp pci driver pm ops")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260707060130.2514138-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index c62299b2920417..34efb42be768fb 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -683,8 +683,37 @@ static int snd_acp_runtime_resume(struct device *dev)
 	return acp_hw_runtime_resume(dev);
 }
 
+static void acp_disable_msi_on_resume(struct pci_dev *pdev)
+{
+	u16 control;
+
+	if (!pdev->msi_cap)
+		return;
+
+	pci_read_config_word(pdev, pdev->msi_cap + PCI_MSI_FLAGS, &control);
+	if (control & PCI_MSI_FLAGS_ENABLE) {
+		dev_warn(&pdev->dev,
+			 "ACP: MSI unexpectedly enabled after resume (flags=0x%04x), disabling\n",
+			 control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(pdev, pdev->msi_cap + PCI_MSI_FLAGS, control);
+	}
+}
+
 static int snd_acp_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	/*
+	 * BIOS/firmware may re-enable MSI in PCI config space during
+	 * system resume even though this driver only uses legacy INTx
+	 * interrupts. If MSI is left enabled with stale address/data
+	 * registers, the device will write interrupts to a bogus address
+	 * causing IOMMU IO_PAGE_FAULT and interrupt delivery failure.
+	 * Explicitly clear the MSI Enable bit before reinitializing
+	 * the ACP hardware.
+	 */
+	acp_disable_msi_on_resume(pdev);
 	return acp_hw_resume(dev);
 }
 
-- 
2.53.0



