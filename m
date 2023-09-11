Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6191170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44C1C433CA;
	Mon, 11 Sep 2023 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441635;
	bh=Q1Gl0qzPOx1cg7lCmpzsCwUCQg3Z4X7zwuf1WzsNSWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pW5se9wOWhzXPp3nZip5fpB4rIpLHesFNmlrvk6fthI5//vtEiDtF5t5T4EyUC5RV
	 8OKZprIK1sebWpG3ZEX7s848zgfp0FsM9xE3Y1Vqw0X97JDV8yXsZ7wY5kL+Bquv7G
	 ZxQlYtMV6Pnp0q3SQhBg2AjiykvL/PMWlZu4HxNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 482/739] scsi: ufs: Fix residual handling
Date: Mon, 11 Sep 2023 15:44:41 +0200
Message-ID: <20230911134704.603982700@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2903265e27bfc6dea915dd9e17a1b2587f621f73 ]

Only call scsi_set_resid() in case of an underflow. Do not call
scsi_set_resid() in case of an overflow.

Cc: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230724200843.3376570-2-bvanassche@acm.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++++--
 include/ufs/ufs.h         |  6 ++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1294467757964..fa18806e80b61 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5251,9 +5251,17 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	int result = 0;
 	int scsi_status;
 	enum utp_ocs ocs;
+	u8 upiu_flags;
+	u32 resid;
 
-	scsi_set_resid(lrbp->cmd,
-		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
+	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
+	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
+	/*
+	 * Test !overflow instead of underflow to support UFS devices that do
+	 * not set either flag.
+	 */
+	if (resid && !(upiu_flags & UPIU_RSP_FLAG_OVERFLOW))
+		scsi_set_resid(lrbp->cmd, resid);
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 198cb391f9db2..29760d5cb273c 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -102,6 +102,12 @@ enum {
 	UPIU_CMD_FLAGS_READ	= 0x40,
 };
 
+/* UPIU response flags */
+enum {
+	UPIU_RSP_FLAG_UNDERFLOW	= 0x20,
+	UPIU_RSP_FLAG_OVERFLOW	= 0x40,
+};
+
 /* UPIU Task Attributes */
 enum {
 	UPIU_TASK_ATTR_SIMPLE	= 0x00,
-- 
2.40.1



