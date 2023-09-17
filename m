Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DD746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA90C433C9;
	Sun, 17 Sep 2023 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982513;
	bh=7FGpjJlD3fOxRmnQYK2Hd9BsEedbazZDxiQFtmkRSRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQGE2C/yw6noyHR5e7/0p1ZDVGEMnAEc84mUWxwfKxpHn/tJOdhbKZsYYZ/a1rsTx
	 vsFclCaIXwNZC7HDOxz6nxirkTnjL0JM4hLzWvOUXegkylFvP8dgkvi+nIG6pI51VN
	 v0BoxTZ2fycNLxQNE/YEjJDEOXKvgbu/4L6QuGB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/511] scsi: hisi_sas: Modify v3 HW SATA completion error processing
Date: Sun, 17 Sep 2023 21:11:12 +0200
Message-ID: <20230917191119.733946871@linuxfoundation.org>
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

[ Upstream commit 7e15334f5d256367fb4c77f4ee0003e1e3d9bf9d ]

If the I/O completion response frame returned by the target device has been
written to the host memory and the err bit in the status field of the
received fis is 1, ts->stat should set to SAS_PROTO_RESPONSE, and this will
let EH analyze and further determine cause of failure.

Link: https://lore.kernel.org/r/1657823002-139010-5-git-send-email-john.garry@huawei.com
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f5393a5602ca ("scsi: hisi_sas: Fix normally completed I/O analysed as failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 00f0847e1487a..7204666c04076 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -480,6 +480,9 @@ struct hisi_sas_err_record_v3 {
 #define RX_DATA_LEN_UNDERFLOW_OFF	6
 #define RX_DATA_LEN_UNDERFLOW_MSK	(1 << RX_DATA_LEN_UNDERFLOW_OFF)
 
+#define RX_FIS_STATUS_ERR_OFF		0
+#define RX_FIS_STATUS_ERR_MSK		(1 << RX_FIS_STATUS_ERR_OFF)
+
 #define HISI_SAS_COMMAND_ENTRIES_V3_HW 4096
 #define HISI_SAS_MSI_COUNT_V3_HW 32
 
@@ -2151,6 +2154,7 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 			hisi_sas_status_buf_addr_mem(slot);
 	u32 dma_rx_err_type = le32_to_cpu(record->dma_rx_err_type);
 	u32 trans_tx_fail_type = le32_to_cpu(record->trans_tx_fail_type);
+	u16 sipc_rx_err_type = le16_to_cpu(record->sipc_rx_err_type);
 	u32 dw3 = le32_to_cpu(complete_hdr->dw3);
 
 	switch (task->task_proto) {
@@ -2178,7 +2182,10 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-		if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
+		if ((complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
+		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
+			ts->stat = SAS_PROTO_RESPONSE;
+		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
 			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
 		} else if (dw3 & CMPLT_HDR_IO_IN_TARGET_MSK) {
-- 
2.40.1



