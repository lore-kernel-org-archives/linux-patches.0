Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7424221DA7;
	Tue, 29 Apr 2025 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948854; cv=none; b=VyFGkmxHRnfD6lU7lbl9aaK8hJ2hmop9MS2pdJ5gAQLGhKZ+Fn25egFTMwOdDdmoFd9m5IjPt8XyEV82cuEkqDizNZ2hEqPv7RExKOEyOfDcGF7HrV2FZlqM+Q0XY4e7NKg4O2knnweWM0PCGHl3wVU+XRTZjYtCBWvI7QrCZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948854; c=relaxed/simple;
	bh=gm0DBgfve22zdTraMYcf6ZMZDGwwklbLN9D0BRKNP60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFlxiq6zwdrytuuI+uw3FYoVswwoTSdEBC1dnXOjp2JePvkjJR8ovrU94hdl6udc+2AiaEGJ1UWLHFTDzwuussqJF/7bPK+Zu+ReH0pfwPUD4Nu5c2H2fLyUtYVFDTFw6MPQ7epG3dibtEZlopFHS1yRVMKr22VSkcNnql5lXXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzIWLtN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzIWLtN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AFAC4CEE3;
	Tue, 29 Apr 2025 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948854;
	bh=gm0DBgfve22zdTraMYcf6ZMZDGwwklbLN9D0BRKNP60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzIWLtN+SKADmvumnyo+TUF56YdL+h5waad8V/blce+JoREhXZv6BLvV82BwURlmW
	 Jov8zckC/BHEinxYUF+DHsE2A9Z9f0LILLT2jDGFHBwFvHnk5UjpVhCo+QBUIWTQxb
	 9eEt9B6EfJMa4NqXz7j4frIkqsfci/8hqrUpm2ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/373] scsi: hisi_sas: Pass abort structure for internal abort
Date: Tue, 29 Apr 2025 18:39:58 +0200
Message-ID: <20250429161128.151820584@linuxfoundation.org>
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

[ Upstream commit 08c61b5d902b70180b517e9f2616ad70b7a98dcf ]

To help factor out code in future, it's useful to know if we're executing
an internal abort, so pass a pointer to the structure. The idea is that a
NULL pointer means not an internal abort.

Link: https://lore.kernel.org/r/1639579061-179473-4-git-send-email-john.garry@huawei.com
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8aa580cd9284 ("scsi: hisi_sas: Enable force phy when SATA disk directly connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  5 +++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 21 ++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 57be32ba0109f..39da9f1645135 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -134,6 +134,11 @@ struct hisi_sas_rst {
 	bool done;
 };
 
+struct hisi_sas_internal_abort {
+	unsigned int flag;
+	unsigned int tag;
+};
+
 #define HISI_SAS_RST_WORK_INIT(r, c) \
 	{	.hisi_hba = hisi_hba, \
 		.completion = &c, \
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ff6b6868cd955..321e6fae03adc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -273,11 +273,11 @@ static void hisi_sas_task_prep_ata(struct hisi_hba *hisi_hba,
 }
 
 static void hisi_sas_task_prep_abort(struct hisi_hba *hisi_hba,
-		struct hisi_sas_slot *slot,
-		int device_id, int abort_flag, int tag_to_abort)
+		struct hisi_sas_internal_abort *abort,
+		struct hisi_sas_slot *slot, int device_id)
 {
 	hisi_hba->hw->prep_abort(hisi_hba, slot,
-			device_id, abort_flag, tag_to_abort);
+			device_id, abort->flag, abort->tag);
 }
 
 static void hisi_sas_dma_unmap(struct hisi_hba *hisi_hba,
@@ -1968,8 +1968,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 static int
 hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
-				  struct sas_task *task, int abort_flag,
-				  int task_tag, struct hisi_sas_dq *dq)
+				  struct hisi_sas_internal_abort *abort,
+				  struct sas_task *task,
+				  struct hisi_sas_dq *dq)
 {
 	struct domain_device *device = task->dev;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
@@ -2026,8 +2027,7 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	memset(hisi_sas_status_buf_addr_mem(slot), 0,
 	       sizeof(struct hisi_sas_err_record));
 
-	hisi_sas_task_prep_abort(hisi_hba, slot, device_id,
-				      abort_flag, task_tag);
+	hisi_sas_task_prep_abort(hisi_hba, abort, slot, device_id);
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
@@ -2065,9 +2065,12 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 {
 	struct sas_task *task;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_internal_abort abort = {
+		.flag = abort_flag,
+		.tag = tag,
+	};
 	struct device *dev = hisi_hba->dev;
 	int res;
-
 	/*
 	 * The interface is not realized means this HW don't support internal
 	 * abort, or don't need to do internal abort. Then here, we return
@@ -2092,7 +2095,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	add_timer(&task->slow_task->timer);
 
 	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
-						task, abort_flag, tag, dq);
+						&abort, task, dq);
 	if (res) {
 		del_timer(&task->slow_task->timer);
 		dev_err(dev, "internal task abort: executing internal task failed: %d\n",
-- 
2.39.5



