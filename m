Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB8BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD9BC433EF;
	Tue,  7 Mar 2023 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212875;
	bh=cp1WTNH8NCKuZCAdIpnWWiih9OqgJnIfgLdj0K47gNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaC4VBGz+GAQAZzxvca36C3Jf9jhd+RnMhPjDe0i8PGJK7QlZ5g1GP+ruiTrWW3xE
	 uRygT9JRoQJlvV1TuHwfBbF5A0mEndlvzpQOgnzMIJqBvZ/Uh54E8L2bYw0FWTgMD1
	 qvwKAFUX3aourRO69C1Y0vbMNr4fV/fnyU5M9Shc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiwoong Kim <kwmad.kim@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 308/885] scsi: ufs: exynos: Fix DMA alignment for PAGE_SIZE != 4096
Date: Tue,  7 Mar 2023 17:54:02 +0100
Message-Id: <20230307170015.495106332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 86bd0c4a2a5dc4265884648cb92c681646509692 ]

The Exynos UFS controller only supports scatter/gather list elements that
are aligned on a 4 KiB boundary. Fix DMA alignment in case PAGE_SIZE !=
4096. Rename UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE into
UFSHCD_QUIRK_4KB_DMA_ALIGNMENT.

Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only page-aligned sg entries")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c     | 4 ++--
 drivers/ufs/host/ufs-exynos.c | 2 +-
 include/ufs/ufshcd.h          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fb5c9e2fc5348..e08ce7f2ff3af 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5068,8 +5068,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	ufshcd_hpb_configure(hba, sdev);
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
-		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
+	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
+		blk_queue_update_dma_alignment(q, 4096 - 1);
 	/*
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index c3628a8645a56..3cdac89a28b81 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1673,7 +1673,7 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
 				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
-				  UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
+				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 2bb89290da63c..b54f22840dabf 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -566,9 +566,9 @@ enum ufshcd_quirks {
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
 	/*
-	 * This quirk allows only sg entries aligned with page size.
+	 * Align DMA SG entries on a 4 KiB boundary.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 << 14,
 
 	/*
 	 * This quirk needs to be enabled if the host controller does not
-- 
2.39.2



