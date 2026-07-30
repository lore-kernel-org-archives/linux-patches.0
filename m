Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5806422540;
	Thu, 30 Jul 2026 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421523; cv=none; b=ppUEBHsCytFAkxiQLouOToxFX0zkrdz/hjz7/0KS7yOwG1vsgRt7owbvJDoNdCxipgygWSootoCNedaDQq5WkgD9wTB6IE+jVm86Pu6j5tL0TuU/TXe7zXexLX+B+rgbywKARU5M9jy+xTrpxUNXvSBsXBqTMNnl8QMUn+p0DfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421523; c=relaxed/simple;
	bh=l6N4+oro9ANRMZVghqjXvd89jDQtBeOTtMlI+sM7ItI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtfzjD5Mm7JNE/BC682Doag6kr6c19sOqs0786MERqsfl6IPoCpnEI/h3o8C78AtA6Mb1lU+vKR0mV9+b42dcKlXojFmGL+rTmNg5GKP279UmQlg+gNpaKUqwfFnjNJUadZa0CU+6HoNIXw3BTyPq25gBWFj6E/7/gwh3O/hwE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5ROuhWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5ROuhWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0641F000E9;
	Thu, 30 Jul 2026 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421521;
	bh=hDzVdLLDiYvg0b94Wa4+wm/NKF3XBwk+OurcSIXsF8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5ROuhWkcQ1ZlxDv60AiikD+TVchqrk9KlrAhcMb0wIvvzBwlgaLe6QXTPGkbIFLI
	 bwdMTnmkPUNQUJL0zFF9vWzKPBYOckduJ0pq3JMU64c8g7DjI5zS9gGJRHoF/kPOkG
	 zBr6ixkBIDBYiLHsG6dLWSij7bLOyeuOLIKomEK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 077/744] ASoC: amd: ps: disable MSI on resume in ACP PCI driver
Date: Thu, 30 Jul 2026 16:05:50 +0200
Message-ID: <20260730141445.908667909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9751cf0784a6db..cccf9d85c860f0 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -692,8 +692,37 @@ static int snd_acp_runtime_resume(struct device *dev)
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



