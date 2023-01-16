Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968F66FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC38C433D2;
	Mon, 16 Jan 2023 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887613;
	bh=tzSOTSA0HP8n3RgsL4EscEvLzrTLGfxDw45WANuCjio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbxiieLhEoVSBnwjmdR74dFFdbPH5dYAppuoG72jeYul+TUYK/mtIBNtxzqczS/Ja
	 l10W0biL7VJfiFbYGZ8A9jYxJpJu+CEsSKKn81rpEArdWk3eksUEMAF7RDE0LVtYik
	 ENL0OIxQ5Yd4RgDcBeGxcckCP+qH6hBnw2AfaIvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 198/521] scsi: fcoe: Fix possible name leak when device_register() fails
Date: Mon, 16 Jan 2023 16:47:40 +0100
Message-Id: <20230116154855.948911788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 47b6a122c7b69a876c7ee2fc064a26b09627de9d ]

If device_register() returns an error, the name allocated by dev_set_name()
needs to be freed. As the comment of device_register() says, one should use
put_device() to give up the reference in the error path. Fix this by
calling put_device(), then the name can be freed in kobject_cleanup().

The 'fcf' is freed in fcoe_fcf_device_release(), so the kfree() in the
error path can be removed.

The 'ctlr' is freed in fcoe_ctlr_device_release(), so don't use the error
label, just return NULL after calling put_device().

Fixes: 9a74e884ee71 ("[SCSI] libfcoe: Add fcoe_sysfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221112094310.3633291-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 5c8310bade61..dab025e3ed27 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -831,14 +831,15 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 
 	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
 	error = device_register(&ctlr->dev);
-	if (error)
-		goto out_del_q2;
+	if (error) {
+		destroy_workqueue(ctlr->devloss_work_q);
+		destroy_workqueue(ctlr->work_q);
+		put_device(&ctlr->dev);
+		return NULL;
+	}
 
 	return ctlr;
 
-out_del_q2:
-	destroy_workqueue(ctlr->devloss_work_q);
-	ctlr->devloss_work_q = NULL;
 out_del_q:
 	destroy_workqueue(ctlr->work_q);
 	ctlr->work_q = NULL;
@@ -1037,16 +1038,16 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->selected = new_fcf->selected;
 
 	error = device_register(&fcf->dev);
-	if (error)
-		goto out_del;
+	if (error) {
+		put_device(&fcf->dev);
+		goto out;
+	}
 
 	fcf->state = FCOE_FCF_STATE_CONNECTED;
 	list_add_tail(&fcf->peers, &ctlr->fcfs);
 
 	return fcf;
 
-out_del:
-	kfree(fcf);
 out:
 	return NULL;
 }
-- 
2.35.1



