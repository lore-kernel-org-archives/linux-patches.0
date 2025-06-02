Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AC230BDF;
	Mon,  2 Jun 2025 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873887; cv=none; b=lxWA7XbMYVRShESCoQreqiztMyDJRAvifPFNW1M1LD8SBGdN7b31OzarcIEc1Pd3kV5+p5l4+EGiyurMyTWgvUM3sdOAUVmO41La9tdZ3Melpd3tOKuB/9QZ5s8KWnWLNfRX4vWrH/J8qje2UBYAYWYZV+OSQOjC+aYe/Mssl4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873887; c=relaxed/simple;
	bh=tfyd2sXDaZOl1qPIoNXQ3VTB+9+zRaV1bN1DGItT2PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVRuXAjVQSXb5OV2vclJdTjSvN83jwSl91TQFip6Yo1BbNAnJkJlD8IMLwabqtueZ0OKu92VH4FtQ8GOmt4iDvhNHXeqoxVDVG5DlDgy9oWnI29Npd5xw0iMDjxbYilRv2J5o3VrWvLC9odP7t675HyyD40yAFkbMwOcbmDTFDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygcPeWLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygcPeWLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515C8C4CEEB;
	Mon,  2 Jun 2025 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873887;
	bh=tfyd2sXDaZOl1qPIoNXQ3VTB+9+zRaV1bN1DGItT2PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygcPeWLp7ay8ey1zB5Ghup5HXcCeKYaM5cRW8B3ALRbQTNLy0y5J8vGKzqS2IFD1B
	 DFeTwYkYU6YQofldwiIjKPwTAXjPag2w6gajsXaGcgLg8ZqMysd1jg5KTlkJvRpIzO
	 TmETSRXidnhKVYg/14Hf5ksd6T0DLjoKM99IsD+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/444] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  2 Jun 2025 15:45:51 +0200
Message-ID: <20250602134352.604041836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit f0842902b383982d1f72c490996aa8fc29a7aa0d ]

Fix smatch warning regarding missed calls to free_irq().  Free the phba IRQ
in the failed pci_irq_vector cases.

lpfc_init.c: lpfc_sli4_enable_msi() warn: 'phba->pcidev->irq' from
             request_irq() not released.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 424b39a8155cb..7c8e0e1d36da9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13180,6 +13180,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13260,6 +13261,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5



