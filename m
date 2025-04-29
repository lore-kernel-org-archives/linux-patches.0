Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C224DFF3;
	Tue, 29 Apr 2025 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948825; cv=none; b=UF/dalJCGfm5afSNzMJgZY/2Swgtp1b+nw4Nrh3CB8WwFVPAuIGErNAnbxwHj8umNuswX7tIn+CdiQBS0CYuKyvt3INhgT4+zwdBn82JJY9qeEXddBMinhK6W3+4ZUE9bnJIGwWxzQcgGxILCOeF0MmzNDrc+409R4HHHtv/EK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948825; c=relaxed/simple;
	bh=viKWvZrBfKRWSkN8QdWpt4i1T1vqTcCZPqR9yuCyU5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWuCgq+u0y1MpiWhct77NKCu0BQLN7pyfH7C8mpMue4zSxvu/jt/OX6PvDSvxor5zykcls4RlSzTQVW43IZC4Eyz2bT+03YAjWSyERn9BjIsw0fjx5S0EZs5xe4hJTEgG+ps2FsGLpNYphfYM0966UPOdlsM5VPNN+Qns/yEUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CODc163W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CODc163W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70164C4CEE3;
	Tue, 29 Apr 2025 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948825;
	bh=viKWvZrBfKRWSkN8QdWpt4i1T1vqTcCZPqR9yuCyU5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CODc163WMV66HfiLj6oF1Qm7OovpS14/ZKyqgipfQwtEHRlg/ZhhkVLoEDoxjAQJY
	 4T8nddTUcQXr7D4aKwPwXZf8NS74JcMAr9v0H9tEN9dRcucIOEs0lfHX5oRtJSvBpQ
	 gKxiHr+CzuqcHln16BLWzg3cfVrb/jKwrogUgMTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/373] scsi: hisi_sas: Start delivery hisi_sas_task_exec() directly
Date: Tue, 29 Apr 2025 18:39:57 +0200
Message-ID: <20250429161128.111936407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit 0e4620856b89335426a17904933a92346ee4599d ]

Currently we start delivery of commands to the DQ after returning from
hisi_sas_task_exec() with success.

Let's just start delivery directly in that function without having to check
if some local variable is set.

Link: https://lore.kernel.org/r/1639579061-179473-2-git-send-email-john.garry@huawei.com
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8aa580cd9284 ("scsi: hisi_sas: Enable force phy when SATA disk directly connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 530f61df109a3..ff6b6868cd955 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -405,8 +405,7 @@ static int hisi_sas_dif_dma_map(struct hisi_hba *hisi_hba,
 
 static int hisi_sas_task_prep(struct sas_task *task,
 			      struct hisi_sas_dq **dq_pointer,
-			      bool is_tmf, struct hisi_sas_tmf_task *tmf,
-			      int *pass)
+			      bool is_tmf, struct hisi_sas_tmf_task *tmf)
 {
 	struct domain_device *device = task->dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
@@ -544,9 +543,12 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	++(*pass);
 	WRITE_ONCE(slot->ready, 1);
 
+	spin_lock(&dq->lock);
+	hisi_hba->hw->start_delivery(dq);
+	spin_unlock(&dq->lock);
+
 	return 0;
 
 err_out_dif_dma_unmap:
@@ -564,7 +566,6 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 			      bool is_tmf, struct hisi_sas_tmf_task *tmf)
 {
 	u32 rc;
-	u32 pass = 0;
 	struct hisi_hba *hisi_hba;
 	struct device *dev;
 	struct domain_device *device = task->dev;
@@ -597,16 +598,10 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	}
 
 	/* protect task_prep and start_delivery sequence */
-	rc = hisi_sas_task_prep(task, &dq, is_tmf, tmf, &pass);
+	rc = hisi_sas_task_prep(task, &dq, is_tmf, tmf);
 	if (rc)
 		dev_err(dev, "task exec: failed[%d]!\n", rc);
 
-	if (likely(pass)) {
-		spin_lock(&dq->lock);
-		hisi_hba->hw->start_delivery(dq);
-		spin_unlock(&dq->lock);
-	}
-
 	return rc;
 }
 
-- 
2.39.5



