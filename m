Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B290235968;
	Mon,  2 Jun 2025 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877333; cv=none; b=XURU5dfAO2JTvr+R18d7V5Sb15K+zyMcx0euBGD1xJpzRIr1MNy4cxilaEqGtPtV1pBZAcjQ3pOMy1PBgLWQCVwQb6b45T6AwTLY3TVc+wozNr2ydWfKCgc3kNn2WaYkqtVRFqemMcNS4nwbqowPG/bOtVrWK6NpaWGmEKw1hiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877333; c=relaxed/simple;
	bh=Qtht5JU6ta9hmvsfI5X2pCpXsslJDK/3yR/Uu8bp3Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzCwVR7OkOsj3IWG86wE7RuEFKExLhZeTeNmvGqc1/5KeMWz+HqpjlndPoL634PHkPOxsX3Gvz3Ypu/b+bP1lW9sL3Fds/Z+0eMb5ZmSpR1E+P0lxbdMcPCO22DXHVA4irjFfPRV6ncLwhlGvsvMqymbO+9gNz6M4d4zUEoQzRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jejpY4iV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jejpY4iV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC07C4CEEB;
	Mon,  2 Jun 2025 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877333;
	bh=Qtht5JU6ta9hmvsfI5X2pCpXsslJDK/3yR/Uu8bp3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jejpY4iVt3ZiCxas9IfGiAhQUOpZ6vGAx2r6qBGcqIt0huUBxJmD5HhdnGjml5VXo
	 tnHZ0wEaT6P1UDjf24CExu6+V/JzJwoSqOCSbz1UCWJudxivkhhgRU1xT8g5DCA1VI
	 8qr9aUWx5sk7KNm0fkhd1Dfb9rCzwli/y8teMVEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/325] scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails
Date: Mon,  2 Jun 2025 15:48:00 +0200
Message-ID: <20250602134328.081408076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a0bafde34d86..97f3c5240d572 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13204,6 +13204,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 	eqhdl = lpfc_get_eq_hdl(0);
 	rc = pci_irq_vector(phba->pcidev, 0);
 	if (rc < 0) {
+		free_irq(phba->pcidev->irq, phba);
 		pci_free_irq_vectors(phba->pcidev);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0496 MSI pci_irq_vec failed (%d)\n", rc);
@@ -13284,6 +13285,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 			eqhdl = lpfc_get_eq_hdl(0);
 			retval = pci_irq_vector(phba->pcidev, 0);
 			if (retval < 0) {
+				free_irq(phba->pcidev->irq, phba);
 				lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 					"0502 INTR pci_irq_vec failed (%d)\n",
 					 retval);
-- 
2.39.5



