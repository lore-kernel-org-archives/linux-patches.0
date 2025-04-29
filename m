Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA60F18BBBB;
	Tue, 29 Apr 2025 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947626; cv=none; b=JjAh6PsQ3Wyrg4pe8fABDL+Vt8XbxeZoFJHElNWeYJxrPWVb8g7TZJTW8wOfQPvyyarcWO95XXGIWA0boEXq+uvOZZM1L9/4cywSQu5VmK4sTrqvAlQdE7AZQ5pNwZsy5Aq8L4hGGUN42logWMPG9JYr1v9kpmqBseP74H4KW40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947626; c=relaxed/simple;
	bh=8B+6uklgJsM8rzanZJOHpHpczLSsjARprR2aB4ijtTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjVk98Kkk19Wvyspkt65X8aw4PPLWCpykYAGpzrZkScxFHcL/28e6plB1TJHCNjPZs064AesbISr4sfRBeoMYLPBQ6Vu+E+uViDLQBOQ/9HtaEzv6mQAG1ZHBx9b0QA7tlLp4y05Y6zUMS8vcB82Jl8EmmSqegwao5jcBqiikfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7T/Z7DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7T/Z7DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587D6C4CEE3;
	Tue, 29 Apr 2025 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947626;
	bh=8B+6uklgJsM8rzanZJOHpHpczLSsjARprR2aB4ijtTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7T/Z7DIOtsX5xFeaEZqkIxyOzTmxNpab7zik3NkKZATc6a5TLxcCWl9EHrih5Tc5
	 /Mov56fo0V2m+UqBsOxe2nHLN1OOqFLfX6Is3FVJYmF2w3q77zXJvEEb10O+6EVJS+
	 9FB4g/sGK3z2QyYF282Usrzhga8rU34sZ6Lwz4tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/280] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Tue, 29 Apr 2025 18:39:57 +0200
Message-ID: <20250429161117.410529571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dba935c712d64..45b04f3c37764 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -673,13 +673,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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
@@ -688,6 +681,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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



