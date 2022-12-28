Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13E11875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01238C433D2;
	Wed, 28 Dec 2022 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243198;
	bh=FKtCj8p/pFb9w5475+Qx7EIJbbFLYrGQLnNpQwnJEmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+E6YDm07BFX0+J/EzKjccO5gDGNamWNPn9Np3nZhE0jyQBpgZsjCzLX2hj0S0pPr
	 jxxivf6jK95m2U/FPkBAEnE4Lz82+oiCX6YSpuDMEipFtaMoEfgRGmv+Ieuh5Y3TO1
	 QPxpY0FfJCoIft5E0OSFj8el00d5h2HFSh6c+C0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 676/731] scsi: ufs: Reduce the START STOP UNIT timeout
Date: Wed, 28 Dec 2022 15:43:03 +0100
Message-Id: <20221228144316.070794153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit dcd5b7637c6d442d957f73780a03047413ed3a10 ]

Reduce the START STOP UNIT command timeout to one second since on Android
devices a kernel panic is triggered if an attempt to suspend the system
takes more than 20 seconds. One second should be enough for the START STOP
UNIT command since this command completes in less than a millisecond for
the UFS devices I have access to.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20221018202958.1902564-7-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dae1a85f1512..a428b8145dcc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8476,8 +8476,6 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
-	unsigned long deadline;
-	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8510,14 +8508,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
-		ret = -ETIMEDOUT;
-		remaining = deadline - jiffies;
-		if (remaining <= 0)
-			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+				   HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.35.1



