Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81580746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF598C433C8;
	Sun, 17 Sep 2023 20:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982520;
	bh=zt5v0ZTNQZ9r5T5RvVVwwQF0lNkEGU4vb1xx2u9rhA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvK5sosYF8Qi2X5qeJr4OBiUtSuKXWgb+KV2X8IsJYL2jt4kKrAJYRHuAvk3Avfng
	 xI/3INru2TsLdphDLaZeJiumeYrn+uPw4/MPdS+Ro4pAKWAJwnjDMVZtRoCndqQjOb
	 RpWy0W6Um3LnJW5UbsMBb1btMECGUP/Igs2NvIGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/511] scsi: hisi_sas: Fix normally completed I/O analysed as failed
Date: Sun, 17 Sep 2023 21:11:14 +0200
Message-ID: <20230917191119.783066229@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit f5393a5602cacfda2014e0ff8220e5a7564e7cd1 ]

The PIO read command has no response frame and the struct iu[1024] won't be
filled. I/Os which are normally completed will be treated as failed in
sas_ata_task_done() when iu contains abnormal dirty data.

Consequently ending_fis should not be filled by iu when the response frame
hasn't been written to memory.

Fixes: d380f55503ed ("scsi: hisi_sas: Don't bother clearing status buffer IU in task prep")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1689045300-44318-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 +++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  6 ++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b0b2361e63fef..c40588ed68a54 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2026,6 +2026,11 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	u16 dma_tx_err_type = le16_to_cpu(err_record->dma_tx_err_type);
 	u16 sipc_rx_err_type = le16_to_cpu(err_record->sipc_rx_err_type);
 	u32 dma_rx_err_type = le32_to_cpu(err_record->dma_rx_err_type);
+	struct hisi_sas_complete_v2_hdr *complete_queue =
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_v2_hdr *complete_hdr =
+			&complete_queue[slot->cmplt_queue_slot];
+	u32 dw0 = le32_to_cpu(complete_hdr->dw0);
 	int error = -1;
 
 	if (err_phase == 1) {
@@ -2310,7 +2315,8 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			break;
 		}
 		}
-		hisi_sas_sata_done(task, slot);
+		if (dw0 & CMPLT_HDR_RSPNS_XFRD_MSK)
+			hisi_sas_sata_done(task, slot);
 	}
 		break;
 	default:
@@ -2442,7 +2448,8 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 	{
 		ts->stat = SAS_SAM_STAT_GOOD;
-		hisi_sas_sata_done(task, slot);
+		if (dw0 & CMPLT_HDR_RSPNS_XFRD_MSK)
+			hisi_sas_sata_done(task, slot);
 		break;
 	}
 	default:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d26b2c9b7c874..b8a12d3ad5f27 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2196,7 +2196,8 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 			ts->stat = SAS_OPEN_REJECT;
 			ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		}
-		hisi_sas_sata_done(task, slot);
+		if (dw0 & CMPLT_HDR_RSPNS_XFRD_MSK)
+			hisi_sas_sata_done(task, slot);
 		break;
 	case SAS_PROTOCOL_SMP:
 		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
@@ -2322,7 +2323,8 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 		ts->stat = SAS_SAM_STAT_GOOD;
-		hisi_sas_sata_done(task, slot);
+		if (dw0 & CMPLT_HDR_RSPNS_XFRD_MSK)
+			hisi_sas_sata_done(task, slot);
 		break;
 	default:
 		ts->stat = SAS_SAM_STAT_CHECK_CONDITION;
-- 
2.40.1



