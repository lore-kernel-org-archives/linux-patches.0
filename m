Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A9882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB2C4339C;
	Fri, 10 Mar 2023 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461451;
	bh=Mc3pjDmNp2g+BPcYk2DbXqbglROYEEIhDgSOsJn+dQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaaCxL9L4kFTNYY6GM7Z2w/Sm5RsBmrU9SSWK3hDCiCrabLLGdCreD2jt3kqEhwnJ
	 YUU5wm58tmvhxz+tyALJl1bn9ypetdojFzUrrh8R8DCgAPtqUxADi3GkIN/kQSJKih
	 VTSHCxImDiE+IN30lPIZZXpRGcLQdw1lLmd9Amzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.15 132/136] scsi: mpt3sas: Dont change DMA mask while reallocating pools
Date: Fri, 10 Mar 2023 14:44:14 +0100
Message-Id: <20230310133711.220674508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 9df650963bf6d6c2c3fcd325d8c44ca2b99554fe upstream.

When a pool crosses the 4GB boundary region then before reallocating pools
change the coherent DMA mask to 32 bits and keep the normal DMA mask set to
63/64 bits.

Link: https://lore.kernel.org/r/20220825075457.16422-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2990,19 +2990,26 @@ static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
+	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint ||
-	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= 32)
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
+	    dma_get_required_mask(&pdev->dev) <= 32) {
 		ioc->dma_mask = 32;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
 		ioc->dma_mask = 63;
-	else
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
+	} else {
 		ioc->dma_mask = 64;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
+	}
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)))
+	if (ioc->use_32bit_dma)
+		coherent_dma_mask = DMA_BIT_MASK(32);
+
+	if (dma_set_mask(&pdev->dev, dma_mask) ||
+	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
 		return -ENODEV;
 
 	if (ioc->dma_mask > 32) {


