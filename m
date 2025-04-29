Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21270221719;
	Tue, 29 Apr 2025 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945758; cv=none; b=kYw1+5tCXlHY+Ct+XTVUWuSuHtxGM+g6tF4nR7G6ez+qH9bm9AUVSF3NeKjIXGr/dzvUi4jK9mh7f7O6NdD3XsxBKwO1ALJYOl7rQo/q1C04tyKmK196EqRR4lnkpWFGLOuBuzi95qwI3znSYOA1sOllDFLMrySxTkgguYkjd0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945758; c=relaxed/simple;
	bh=TexlMEBf0oSdKQJu32TwWinxHFZsV3vwesicoQ23HtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pd6evPCRXFakpD33t7CkwxeC9c83pg7u0gy4T9fWeAXNsJGjorHYA3dTBu01vhHQ4j1D+OF5XSc1AyBICh5etnVKwbtMArPnsQQapTLLAB4LiNUyfdPUBCcpAhR5U0N32Q0h+P8ZuP/fWiuw5NcTe9APsp3h3jbIB63mhlLRE5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jq97pPpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jq97pPpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7FEC4CEE3;
	Tue, 29 Apr 2025 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945758;
	bh=TexlMEBf0oSdKQJu32TwWinxHFZsV3vwesicoQ23HtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq97pPpyeANGAkEf1mqRLYnpTidHcWpmN96WXiwo7Jpu9PepnnFc0agWhVrXRC6Ek
	 cCE/8hTJMCpkRVKg99x0xMWUXmvTTEGMx1O+/po0dW7NbZjfqDCQKzR+ry5U+sonQC
	 pGQwRbQ2MZxJohTAHCChHJRoSEfIx8bwAZNV+ISU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 039/311] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Tue, 29 Apr 2025 18:37:56 +0200
Message-ID: <20250429161122.627059196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 4c324085062919d4e21c69e5e78456dcec0052fe ]

A race can occur between the MCQ completion path and the abort handler:
once a request completes, __blk_mq_free_request() sets rq->mq_hctx to
NULL, meaning the subsequent ufshcd_mcq_req_to_hwq() call in
ufshcd_mcq_abort() can return a NULL pointer. If this NULL pointer is
dereferenced, the kernel will crash.

Add a NULL check for the returned hwq pointer. If hwq is NULL, log an
error and return FAILED, preventing a potential NULL-pointer
dereference.  As suggested by Bart, the ufshcd_cmd_inflight() check is
removed.

This is similar to the fix in commit 74736103fb41 ("scsi: ufs: core: Fix
ufshcd_abort_one racing issue").

This is found by our static analysis tool KNighter.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250410001320.2219341-1-chenyuan0y@gmail.com
Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 240ce135bbfbc..f1294c29f4849 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -677,13 +677,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int err;
 
-	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
-		dev_err(hba->dev,
-			"%s: skip abort. cmd at tag %d already completed.\n",
-			__func__, tag);
-		return FAILED;
-	}
-
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
@@ -692,6 +685,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+	if (!hwq) {
+		dev_err(hba->dev, "%s: skip abort. cmd at tag %d already completed.\n",
+			__func__, tag);
+		return FAILED;
+	}
 
 	if (ufshcd_mcq_sqe_search(hba, hwq, tag)) {
 		/*
-- 
2.39.5



