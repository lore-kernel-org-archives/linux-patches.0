Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE85F9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3559AC433CD;
	Mon, 11 Sep 2023 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445589;
	bh=lE/Z8szWwnvmmEpjil8VmyOA0C0m9AxcSBZRtkXGGhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFPlZGqohJDIOIL8J3+d1UOSVcvfkQeMYBf/3g+/558Gol78gPOisR3uUIadtklzR
	 6+LxXj0P1TENDpoHpLdRJUgZD8K4EnOtp8p7o2BZ2D+IOs+WfbPJh7S68ifWp3STj6
	 9OqPhNq84wHUO2D0cU3apnCtT2usmBngHR3vv78Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 402/600] scsi: hisi_sas: Fix warnings detected by sparse
Date: Mon, 11 Sep 2023 15:47:15 +0200
Message-ID: <20230911134645.542159385@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit c0328cc595124579328462fc45d7a29a084cf357 ]

This patch fixes the following warning:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:2168:43: sparse: sparse: restricted __le32 degrades to integer

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304161254.NztCVZIO-lkp@intel.com/
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1684118481-95908-4-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f5393a5602ca ("scsi: hisi_sas: Fix normally completed I/O analysed as failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e8a3511040af2..8544c1554f5ff 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2163,6 +2163,7 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	u32 trans_tx_fail_type = le32_to_cpu(record->trans_tx_fail_type);
 	u16 sipc_rx_err_type = le16_to_cpu(record->sipc_rx_err_type);
 	u32 dw3 = le32_to_cpu(complete_hdr->dw3);
+	u32 dw0 = le32_to_cpu(complete_hdr->dw0);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
@@ -2172,8 +2173,8 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 			 * but I/O information has been written to the host memory, we examine
 			 * response IU.
 			 */
-			if (!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_GOOD_MSK) &&
-				(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))
+			if (!(dw0 & CMPLT_HDR_RSPNS_GOOD_MSK) &&
+			    (dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))
 				return false;
 
 			ts->residual = trans_tx_fail_type;
@@ -2189,7 +2190,7 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
-		if ((complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
+		if ((dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
 		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
 			ts->stat = SAS_PROTO_RESPONSE;
 		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
-- 
2.40.1



