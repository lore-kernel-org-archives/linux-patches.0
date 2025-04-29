Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7069222AE68;
	Tue, 29 Apr 2025 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950294; cv=none; b=FQi/5vnJaKw0jikjZVRs/Ix5rMDbZmA74atSW3SqxkiZVGM8Tf+dT/032Ts5lN+5NfQggYT12DXyDpTm3LW40y1pcAnXn+pSAMVvOTuhLhyNZUjbBUgOGiMQJ/Lj3Dq0Keq1yO+3LcQjOJ2RAQaVvClxTWht5KgUtIh2tCa8kAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950294; c=relaxed/simple;
	bh=5VpjnhmgHLqJRnD9dj/vReGQXb8twnSevk9HurDrXok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzZdwzOBrHmAEtUkWfOdabiKCzNUJRjn+sBaZTei+s3TUs3FNBz23JseCN7V+DL3rZ3FK5tlGn9IH/XN+R+fiLzJvQZdpw/OxaLGvcUB7CUKlUMOnXd1uafnR3c5n+Y7Y1hCJc0fecaWIvCENizVSG8F3rSNyUNeABKQmKpe0BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYPweh8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYPweh8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA40FC4CEE3;
	Tue, 29 Apr 2025 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950294;
	bh=5VpjnhmgHLqJRnD9dj/vReGQXb8twnSevk9HurDrXok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYPweh8StupyvIlepK2fpbTnWVJ3v5pNovFuwv2tHCwI53nK2wpb3KUSuDpdZVuUC
	 fgpaYnliuwFaOqNCrwlFQBcE7ou/7xzyGXnYSc46VcOnpNg/E+X852B/BOLp62fb7z
	 mcDOmKQauS+yFtZziaNR9xWaL/ADfPTXCZHCLF/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/204] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Tue, 29 Apr 2025 18:42:18 +0200
Message-ID: <20250429161101.451933628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da8c1734d3335..411109a5ebbff 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -632,13 +632,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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
@@ -647,6 +640,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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



