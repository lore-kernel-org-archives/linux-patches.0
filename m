Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011FF278750;
	Tue, 27 May 2025 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365712; cv=none; b=PCeDIirBhQUnxafvFY2n4wGF2RvURU+A+PDIwgkYFi4SVaWdtNv4xZ6usHjkg6oxMDEjpNCa/0Hs2M8nYKKPFSicn8a3wVaYM3lFVE0rvVFr9y3uPSg684B9rvcTQ9Li5B//2cY/0YDtB33D4Uw7GZkQesONvF4gwFJwrQtfgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365712; c=relaxed/simple;
	bh=4nwGX/H14yIoHFDyAGGF8uUDmKmDrnXZCoLEh+/5Tqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1nsrIaPMWE5cpccsV0BuDyVJU6yEj1o4l1DICzfiOdhfqw8ucl5I8pH2TjuuTvwoYfdYzUmofXqZxeArmc++B/vLzayV4Mcr1Vh93LOt/FQNPsoHN68DLUnR687WgNLFM0phQCCZLaj0nvjZfhyIXAYI2r0XkcoBAATMjq6s18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZrrw5kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZrrw5kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBDDC4CEE9;
	Tue, 27 May 2025 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365711;
	bh=4nwGX/H14yIoHFDyAGGF8uUDmKmDrnXZCoLEh+/5Tqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZrrw5kDb36rnx3wJI97u7v5uBm1jpC02p7VJ4euvGYwZuzKrLsd/mcanSd6xDCZq
	 KAErgWY7ItCuJe662se2BDFmfEMqSCgjmiGUahD0NOgkvPXCI0Rg7ioWv0xdDCqZtk
	 qgVt8ml8Qc7k2pcM9LjxoGhWFbSC3jtfNEHOM0LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 464/626] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Tue, 27 May 2025 18:25:57 +0200
Message-ID: <20250527162503.855667496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a3658ef1141b2..50c761991191f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13190,6 +13190,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13270,6 +13271,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5



