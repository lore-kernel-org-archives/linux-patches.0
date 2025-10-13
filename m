Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A24B309EF7;
	Mon, 13 Oct 2025 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367620; cv=none; b=bPtAxIJsK9KbfA7NQkUMBgajS8Kbb01IwvS/1w4HMQd3XWkDSh53S7rTR/7+o2+hTH8ml763vC/o+3EPE/LkhVPHfKsUyFZYBnPSQTd6OSFUuahCPANHbSAgrZOLeE0xQsY8DI+31aIRACo7nc0uXpGNATcnnSyHaQsoTpa/j3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367620; c=relaxed/simple;
	bh=CBTCTllIakSZoheUBnWKzZLlRp7+OldiBrJd4iKeHvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGYS3K7LP7rKxcT90LNBA4uYTgNWLCLzKUGiF485o7WEHEFcgTSc1suoAwJ41c6vNPbI8tcryJJaVJr24ZCniuMXreSSYnQxG6CP5/0Tx3tKsbE187TL26+dIc1HlOKOKhVDrrqoiuiyyt5mZtSQk91eJ8TBHduAhvJebhPlN7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mENgSXeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mENgSXeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CC4C4CEE7;
	Mon, 13 Oct 2025 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367618;
	bh=CBTCTllIakSZoheUBnWKzZLlRp7+OldiBrJd4iKeHvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mENgSXeRp/qnhVrBIWCdVA2RJe+NLX/fiHdvXq50u1NyXF3BfMKWr2OBIQ1zW01/F
	 UpySpk+3QBjoZz3Dw7Rpe2Ple5FSawdBXvJAcuiZ3GYUicr4aaxPWUfjB77fBbvfME
	 iXSNWdsm9zTdsKJD9osdPGzqS8e62Z48Hqrw/Fs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/196] scsi: myrs: Fix dma_alloc_coherent() error check
Date: Mon, 13 Oct 2025 16:44:26 +0200
Message-ID: <20251013144318.028635280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit edb35b1ffc686fd9b5a91902f034eb9f4d2c9f6b ]

Check for NULL return value with dma_alloc_coherent(), because DMA
address is not always set by dma_alloc_coherent() on failure.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250725083112.43975-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index e824be9d9bbb9..9075836ccc3e2 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -498,14 +498,14 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	/* Temporary dma mapping, used only in the scope of this function */
 	mbox = dma_alloc_coherent(&pdev->dev, sizeof(union myrs_cmd_mbox),
 				  &mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, mbox_addr))
+	if (!mbox)
 		return false;
 
 	/* These are the base addresses for the command memory mailbox array */
 	cs->cmd_mbox_size = MYRS_MAX_CMD_MBOX * sizeof(union myrs_cmd_mbox);
 	cmd_mbox = dma_alloc_coherent(&pdev->dev, cs->cmd_mbox_size,
 				      &cs->cmd_mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->cmd_mbox_addr)) {
+	if (!cmd_mbox) {
 		dev_err(&pdev->dev, "Failed to map command mailbox\n");
 		goto out_free;
 	}
@@ -520,7 +520,7 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	cs->stat_mbox_size = MYRS_MAX_STAT_MBOX * sizeof(struct myrs_stat_mbox);
 	stat_mbox = dma_alloc_coherent(&pdev->dev, cs->stat_mbox_size,
 				       &cs->stat_mbox_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->stat_mbox_addr)) {
+	if (!stat_mbox) {
 		dev_err(&pdev->dev, "Failed to map status mailbox\n");
 		goto out_free;
 	}
@@ -533,7 +533,7 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	cs->fwstat_buf = dma_alloc_coherent(&pdev->dev,
 					    sizeof(struct myrs_fwstat),
 					    &cs->fwstat_addr, GFP_KERNEL);
-	if (dma_mapping_error(&pdev->dev, cs->fwstat_addr)) {
+	if (!cs->fwstat_buf) {
 		dev_err(&pdev->dev, "Failed to map firmware health buffer\n");
 		cs->fwstat_buf = NULL;
 		goto out_free;
-- 
2.51.0



