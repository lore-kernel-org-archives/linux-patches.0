Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB31168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C2C433EF;
	Mon,  8 May 2023 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544369;
	bh=aSFNXfwWMM7rrn6Wf1sNpsdwGY2Sz1jIh9jWdXjU+sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjHU8HnBbRiTX4nIS419TGxvjqRILH88Y4TiNzS8N0XFyM62UAu+dFtAQq931EzKc
	 M+8tXzGUe96a/fumOuI/Kg37E0UDrbJ+bGN8Ywy+bfV3Hdmhx4CKembEsS22CyfhIl
	 /9fXce0B2ZBfnJNQRVMisdI7on4cSisCRWu/ZNtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 380/694] scsi: hisi_sas: Handle NCQ error when IPTT is valid
Date: Mon,  8 May 2023 11:43:35 +0200
Message-Id: <20230508094445.240317169@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit bb544224da77b96b2c11a13872bf91ede1e015be ]

If an NCQ error occurs when the IPTT is valid and slot->abort flag is set
in completion path, sas_task_abort() will be called to abort only one NCQ
command now, and the host would be set to SHOST_RECOVERY state. But this
may not kick-off EH Immediately until other outstanding QCs timeouts. As a
result, the host may remain in the SHOST_RECOVERY state for up to 30
seconds, such as follows:

[7972317.645234] hisi_sas_v3_hw 0000:74:04.0: erroneous completion iptt=3264 task=00000000466116b8 dev id=2 sas_addr=0x5000000000000502 CQ hdr: 0x1883 0x20cc0 0x40000 0x20420000 Error info: 0x0 0x0 0x200000 0x0
[7972341.508264] sas: Enter sas_scsi_recover_host busy: 32 failed: 32
[7972341.984731] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 32 tries: 1

All NCQ commands that are in the queue should be aborted when an NCQ error
occurs in this scenario.

Fixes: 05d91b557af9 ("scsi: hisi_sas: Directly trigger SCSI error handling for completion errors")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1679283265-115066-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index d643c5a49aa94..70c24377c6a19 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1258,7 +1258,11 @@ static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 
 		slot_err_v1_hw(hisi_hba, task, slot);
 		if (unlikely(slot->abort)) {
-			sas_task_abort(task);
+			if (dev_is_sata(device) && task->ata_task.use_ncq)
+				sas_ata_device_link_abort(device, true);
+			else
+				sas_task_abort(task);
+
 			return;
 		}
 		goto out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cded42f4ca445..02575d81afca2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2404,7 +2404,11 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 				 error_info[2], error_info[3]);
 
 		if (unlikely(slot->abort)) {
-			sas_task_abort(task);
+			if (dev_is_sata(device) && task->ata_task.use_ncq)
+				sas_ata_device_link_abort(device, true);
+			else
+				sas_task_abort(task);
+
 			return;
 		}
 		goto out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a63279f55d096..9afc23e3a80fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2320,7 +2320,11 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 					error_info[0], error_info[1],
 					error_info[2], error_info[3]);
 			if (unlikely(slot->abort)) {
-				sas_task_abort(task);
+				if (dev_is_sata(device) && task->ata_task.use_ncq)
+					sas_ata_device_link_abort(device, true);
+				else
+					sas_task_abort(task);
+
 				return;
 			}
 			goto out;
-- 
2.39.2



