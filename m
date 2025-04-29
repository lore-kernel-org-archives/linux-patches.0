Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA531C148;
	Tue, 29 Apr 2025 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948890; cv=none; b=URbNJW/fbzjkiiAGLV8XPJoqBL5arz2VLlXZbG0iVOu0HGkPGMrUFf2x5tg/6o9ODqOG3ASI9Sea6dtKoeMHfJ+9RpskrAth6RMGh3WZuhiRgQvFYdtvVTYdEQchPZ5hsiQ4XQrj2/FTy1jrDGjNCp8NoLieujalLlzvvN9DQ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948890; c=relaxed/simple;
	bh=eMKoWRJMjG8VwyEMLqO44TUZHrzkiB7wNKxohLYjLik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxAepsk4UGXy/KL14G+hhxP1YaXhTBkrcN7QkVI7RDs/cxOTyrnLgnWxX27FdijIOqBtWKqQ8LgYnM0Etl+nvaeqXH4L1rUWyL31/Wn74wUO82IBAJKzi+EZxqnPjYRwl2Zm9e528ipYOqPui63Ea0UHYNlt/i0hgdZ/nMjH2WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClBqtrVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClBqtrVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB7DC4CEE3;
	Tue, 29 Apr 2025 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948890;
	bh=eMKoWRJMjG8VwyEMLqO44TUZHrzkiB7wNKxohLYjLik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClBqtrVGJoUEqKREIDmD5NVpDNOfrSmmXNfUrsl0RkEU63wpHeu0NRcPOBXgbIRpC
	 kErwXVKkHwY5xkwvItRPicT8+tXAXiAAG81ZQ0JI6OznTpAcTl//qKbmGsWbbm4z7y
	 jztHpUNGPCoAg32yz6n8n3K9J3jzdrO1ak7FjooM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/373] scsi: hisi_sas: Fix setting of hisi_sas_slot.is_internal
Date: Tue, 29 Apr 2025 18:40:00 +0200
Message-ID: <20250429161128.238796621@linuxfoundation.org>
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

[ Upstream commit c763ec4c10f78678d6d4415646237f07109a5a5f ]

The hisi_sas_slot.is_internal member is not set properly for ATA commands
which the driver sends directly. A TMF struct pointer is normally used as a
test to set this, but it is NULL for those commands. It's not ideal, but
pass an empty TMF struct to set that member properly.

Link: https://lore.kernel.org/r/1643627607-138785-1-git-send-email-john.garry@huawei.com
Fixes: dc313f6b125b ("scsi: hisi_sas: Factor out task prep and delivery code")
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8aa580cd9284 ("scsi: hisi_sas: Enable force phy when SATA disk directly connected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b9f4f7fadfd40..9663492e566d1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -408,8 +408,7 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_slot *slot,
 			   struct hisi_sas_dq *dq,
 			   struct hisi_sas_device *sas_dev,
-			   struct hisi_sas_internal_abort *abort,
-			   struct hisi_sas_tmf_task *tmf)
+			   struct hisi_sas_internal_abort *abort)
 {
 	struct hisi_sas_cmd_hdr *cmd_hdr_base;
 	int dlvry_queue_slot, dlvry_queue;
@@ -435,8 +434,6 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
 	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
 
-	slot->tmf = tmf;
-	slot->is_internal = tmf;
 	task->lldd_task = slot;
 
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
@@ -595,7 +592,7 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	slot->is_internal = tmf;
 
 	/* protect task_prep and start_delivery sequence */
-	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, NULL, tmf);
+	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, NULL);
 
 	return 0;
 
@@ -1333,12 +1330,13 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
 	int s = sizeof(struct host_to_dev_fis);
+	struct hisi_sas_tmf_task tmf = {};
 
 	ata_for_each_link(link, ap, EDGE) {
 		int pmp = sata_srst_pmp(link);
 
 		hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
-		rc = hisi_sas_exec_internal_tmf_task(device, fis, s, NULL);
+		rc = hisi_sas_exec_internal_tmf_task(device, fis, s, &tmf);
 		if (rc != TMF_RESP_FUNC_COMPLETE)
 			break;
 	}
@@ -1349,7 +1347,7 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 
 			hisi_sas_fill_ata_reset_cmd(link->device, 0, pmp, fis);
 			rc = hisi_sas_exec_internal_tmf_task(device, fis,
-							     s, NULL);
+							     s, &tmf);
 			if (rc != TMF_RESP_FUNC_COMPLETE)
 				dev_err(dev, "ata disk %016llx de-reset failed\n",
 					SAS_ADDR(device->sas_addr));
@@ -2003,7 +2001,7 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	slot->port = port;
 	slot->is_internal = true;
 
-	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, abort, NULL);
+	hisi_sas_task_deliver(hisi_hba, slot, dq, sas_dev, abort);
 
 	return 0;
 
-- 
2.39.5



