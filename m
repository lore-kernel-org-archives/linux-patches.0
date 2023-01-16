Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC00446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D46C433D2;
	Mon, 16 Jan 2023 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885118;
	bh=hqmIFF6FRBevN8BnrGrGgRfs2wEOCrsDsUNJ+1Oa90I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fL5+Zu94FEueNgevbWOYXwSh5Be+RIygj8FFrnzlcvJIe+0JR2btZCTfVmsHFCbG
	 TeG+KddQ41bnniht46Eeoti4T0kcGkf2aKaeGp6RtupLhcsexRj0EjONe6TvsnF9Pk
	 yBYd4wAJ97IOdKhFxt46dr05++jXkdxW02wKt4Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 5.15 81/86] scsi: mpt3sas: Remove scsi_dma_map() error messages
Date: Mon, 16 Jan 2023 16:51:55 +0100
Message-Id: <20230116154750.408864951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

commit 0c25422d34b4726b2707d5f38560943155a91b80 upstream.

When scsi_dma_map() fails by returning a sges_left value less than zero,
the amount of logging produced can be extremely high.  In a recent end-user
environment, 1200 messages per second were being sent to the log buffer.
This eventually overwhelmed the system and it stalled.

These error messages are not needed. Remove them.

Link: https://lore.kernel.org/r/20220303140203.12642-1-sreekanth.reddy@broadcom.com
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2594,12 +2594,8 @@ _base_check_pcie_native_sgl(struct MPT3S
 
 	/* Get the SG list pointer and info. */
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return 1;
-	}
 
 	/* Check if we need to build a native SG list. */
 	if (!base_is_prp_possible(ioc, pcie_device,
@@ -2706,12 +2702,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPT
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-		 "scsi_dma_map failed: request for %d bytes!\n",
-		 scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = ioc->max_sges_in_main_message;
@@ -2854,12 +2846,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = (ioc->request_sz -


