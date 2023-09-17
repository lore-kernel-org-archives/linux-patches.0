Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF410F9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA3BC433C8;
	Sun, 17 Sep 2023 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979088;
	bh=K08NqUdJjDJ2RSQeN8ikpd6gjanTkbkD3ytlr5NYKo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuX7F6WlYUSkfOSuPA09c85/iCHFVkMzu2fnDLfXlcJkmuFeFJGC7dxqNH8eayf6P
	 NUTtKGyjimc+89HjwKOl6e264qGcFRlMdZvCEPiBdf87goFRiuLXb6RRGoLXNOzLbb
	 ht+5AKwiIkXbiy96bEQBYRDXOPmwlR8j+P3vFrec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Qi Liu <liuqi115@huawei.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/406] scsi: hisi_sas: Modify v3 HW SSP underflow error processing
Date: Sun, 17 Sep 2023 21:11:04 +0200
Message-ID: <20230917191106.736391060@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 62413199cd6d2906c121c2dfa3d7b82fd05f08db ]

In case of SSP underflow allow the response frame IU to be examined for
setting the response stat value rather than always setting
SAS_DATA_UNDERRUN.

This will mean that we call sas_ssp_task_response() in those scenarios and
may send sense data to upper layer.

Such a condition would be for bad blocks were we just reporting an
underflow error to upper layer, but now the sense data will tell
immediately that the media is faulty.

Link: https://lore.kernel.org/r/1645703489-87194-7-git-send-email-john.garry@huawei.com
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f5393a5602ca ("scsi: hisi_sas: Fix normally completed I/O analysed as failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 39 +++++++++++++++++---------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 59ac0f8e6d5c3..937e4ba46134e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -392,6 +392,8 @@
 #define CMPLT_HDR_ERROR_PHASE_MSK   (0xff << CMPLT_HDR_ERROR_PHASE_OFF)
 #define CMPLT_HDR_RSPNS_XFRD_OFF	10
 #define CMPLT_HDR_RSPNS_XFRD_MSK	(0x1 << CMPLT_HDR_RSPNS_XFRD_OFF)
+#define CMPLT_HDR_RSPNS_GOOD_OFF	11
+#define CMPLT_HDR_RSPNS_GOOD_MSK	(0x1 << CMPLT_HDR_RSPNS_GOOD_OFF)
 #define CMPLT_HDR_ERX_OFF		12
 #define CMPLT_HDR_ERX_MSK		(0x1 << CMPLT_HDR_ERX_OFF)
 #define CMPLT_HDR_ABORT_STAT_OFF	13
@@ -2115,7 +2117,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static void
+static bool
 slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	       struct hisi_sas_slot *slot)
 {
@@ -2133,6 +2135,15 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
 		if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
+			/*
+			 * If returned response frame is incorrect because of data underflow,
+			 * but I/O information has been written to the host memory, we examine
+			 * response IU.
+			 */
+			if (!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_GOOD_MSK) &&
+				(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))
+				return false;
+
 			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
 		} else if (dw3 & CMPLT_HDR_IO_IN_TARGET_MSK) {
@@ -2164,6 +2175,7 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	default:
 		break;
 	}
+	return true;
 }
 
 static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
@@ -2238,19 +2250,20 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 	if ((dw0 & CMPLT_HDR_CMPLT_MSK) == 0x3) {
 		u32 *error_info = hisi_sas_status_buf_addr_mem(slot);
 
-		slot_err_v3_hw(hisi_hba, task, slot);
-		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d addr=%016llx CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
-				 slot->idx, task, sas_dev->device_id,
-				 SAS_ADDR(device->sas_addr),
-				 dw0, dw1, complete_hdr->act, dw3,
-				 error_info[0], error_info[1],
-				 error_info[2], error_info[3]);
-		if (unlikely(slot->abort)) {
-			sas_task_abort(task);
-			return;
+		if (slot_err_v3_hw(hisi_hba, task, slot)) {
+			if (ts->stat != SAS_DATA_UNDERRUN)
+				dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d addr=%016llx CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+					slot->idx, task, sas_dev->device_id,
+					SAS_ADDR(device->sas_addr),
+					dw0, dw1, complete_hdr->act, dw3,
+					error_info[0], error_info[1],
+					error_info[2], error_info[3]);
+			if (unlikely(slot->abort)) {
+				sas_task_abort(task);
+				return;
+			}
+			goto out;
 		}
-		goto out;
 	}
 
 	switch (task->task_proto) {
-- 
2.40.1



