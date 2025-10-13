Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9054F2D2384;
	Mon, 13 Oct 2025 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367112; cv=none; b=SsoD6QnHAH+aZ0q+j57sQUDyYnu65dFbvB/U+biSedJ1WTUMiATFNx5P7jhTAPiv5+4v7rsv1GBuz3XA130+1NeAJiCHxmPUS7SecXiC3V5GNGUuau/QMAtWRIC0jnGXswi2yeBRlHr4hn+GAi9mjKe77/UiDD9uWCWyLNS5ajU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367112; c=relaxed/simple;
	bh=v72xPyonNKyOIYwpDeAIeuq4mdvB72Uni5SlHTgk06U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGAqRZZn7JfXW/FBsoM0H68+ZsPP2Ki5Tc1JplL946MBGhJOjxz+2dTxGkzkrgiOQ4L/jjlizdOqehQh6vsFi3j35Jg04L/gDkHqhgQvauJ/4TrdPjVPvc7RILORSWq9RmLNYfrBHIVVZIyONmFEo1Mk2pZc+yu0kHJau11h+XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12lbB9Ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12lbB9Ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A8EC2BC87;
	Mon, 13 Oct 2025 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367112;
	bh=v72xPyonNKyOIYwpDeAIeuq4mdvB72Uni5SlHTgk06U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12lbB9LyuXXLWAcdyLQjo9Z8y4h4Yy9BkwEiCroZdR8ddYC+i7NylSZjkhs8gjpZh
	 0ASgqFjVnQH0xphipmm83rPMAzPBT3AxLx+EhkLvpgsQsbFNw+eQyOBN0zOp3BV/P+
	 5T8EJ+/ty74g62WGBb5sB175sf+u7kZteFm+Zx2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/196] scsi: myrs: Fix dma_alloc_coherent() error check
Date: Mon, 13 Oct 2025 16:44:30 +0200
Message-ID: <20251013144318.208546308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 95e7c00cb7e54..2626e13e52a2d 100644
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



