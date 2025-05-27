Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E4E42A9B;
	Tue, 27 May 2025 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368135; cv=none; b=T19Z37LAz/onmpl0LcXEfBcKFHOuPwEx+GClJlLUzfYQaM6U3jky2IdsqUqEyXTSpuopvIKcHbAcCL8ANCjI380VCNavKfwA2pBK9BDuIQTglD7zdYElri625R6mHTI3xD7d2Dz4+NIKq6j7XwU4fC8gbVephfIQ//flzfTiNE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368135; c=relaxed/simple;
	bh=OKwUsQcu8BNNIaFvI93+TrqosYdWyPbWgTEKzcBBXnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLsaYrfvi1GGnUSLhuIgzKz0IbVqVQYMH7OTNa0fQOMIpmksDK/CJYStXKmSwrMbKNHwXkGKPlxhCy/om/xKM4YI/NATi19bBjtZbFaUhmUadEfLeA1v9Qe13PwctE8Bq4HFs9d9w7a7BXQvI0nFoRq5MNyL8rG1BIg0oj5KWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHNKh5uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHNKh5uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73866C4CEE9;
	Tue, 27 May 2025 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368135;
	bh=OKwUsQcu8BNNIaFvI93+TrqosYdWyPbWgTEKzcBBXnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHNKh5uIuBRM55S3aGcSkMBdREDncEva2+dKovPx61DkZKg0xIfHC+vC12gI73cSw
	 NKyM3MCwqM1KY6TekRWwHhYEqU8hqGP7odeLemsl7vJIvkeBClEXbThbBTUSl+oxEn
	 3I1/qs76n9Lbg5LTx7hveivRS29g+f8Ucxk7OaXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 579/783] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Tue, 27 May 2025 18:26:16 +0200
Message-ID: <20250527162536.721868565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index bcadf11414c8a..411a6b927c5b0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13170,6 +13170,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13250,6 +13251,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5



