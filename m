Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6448B1D04BB;
	Mon, 21 Oct 2024 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506596; cv=none; b=fkELMeJWMqfN83dqdKkDc/UQQ7AcE15HH+frcOWF+M1Ww9LHKfFSj2JKa3tbM0XjazRVShU+kLFFA53GzGUw4nQhBun4CtBkWkIg3ykXbRz4CKYNMGF4Oav2C/D/HroTVK4l78esUM3KPxyN+eZBcb/luuAm1bkuN+RynIaFcBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506596; c=relaxed/simple;
	bh=fLx/CbloLoNf9dT4tMTpTI7PfeNRXSeFQrmwFD76tVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvwrGxf16vnZGtCiCt3dX8b6gpXku4b0Q4E5nhec6D81VEVvhbjxysyYoUT4rM50RuywmCTEKTvgnf+taxiehB2JiW70UAeWGso9brf6KBB3P4Z4tRNHHUIdjrIMKVuq8XVycrTJnhVhphO1Q2uNpelnzLToxEOKLLRoi1WkINk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlyOzViO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlyOzViO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54B0C4CEC3;
	Mon, 21 Oct 2024 10:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506596;
	bh=fLx/CbloLoNf9dT4tMTpTI7PfeNRXSeFQrmwFD76tVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlyOzViOy6LcL2Lubas0p6WFC4O6GsvndCYIaZfzPL5oCpFZHFSJ0AgJ1/GZDyU18
	 eh+ucUaMv0xvEK8FH2RnbgntVM1Lc7znGZYMOsN68L3DO2cegSY+4uj446Fji2pI3l
	 KTDzbBT1QrNxZniP0zCyVAH8CjfQw9plJA4F4mGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 057/135] scsi: ufs: core: Fix the issue of ICU failure
Date: Mon, 21 Oct 2024 12:23:33 +0200
Message-ID: <20241021102301.560588893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit bf0c6cc73f7f91ec70307f7c72343f6cb7d65d01 upstream.

When setting the ICU bit without using read-modify-write, SQRTCy will
restart SQ again and receive an RTC return error code 2 (Failure - SQ
not stopped).

Additionally, the error log has been modified so that this type of error
can be observed.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20241001091917.6917-2-peter.wang@mediatek.com
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs-mcq.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -539,7 +539,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
-	u32 nexus, id, val;
+	u32 nexus, id, val, rtc;
 	int err;
 
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
@@ -569,17 +569,18 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba
 	opr_sqd_base = mcq_opr_base(hba, OPR_SQD, id);
 	writel(nexus, opr_sqd_base + REG_SQCTI);
 
-	/* SQRTCy.ICU = 1 */
-	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
+	/* Initiate Cleanup */
+	writel(readl(opr_sqd_base + REG_SQRTC) | SQ_ICU,
+		opr_sqd_base + REG_SQRTC);
 
 	/* Poll SQRTSy.CUS = 1. Return result from SQRTSy.RTC */
 	reg = opr_sqd_base + REG_SQRTS;
 	err = read_poll_timeout(readl, val, val & SQ_CUS, 20,
 				MCQ_POLL_US, false, reg);
-	if (err)
-		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%ld\n",
-			__func__, id, task_tag,
-			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
+	rtc = FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg));
+	if (err || rtc)
+		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%d RTC=%d\n",
+			__func__, id, task_tag, err, rtc);
 
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err = -ETIMEDOUT;


