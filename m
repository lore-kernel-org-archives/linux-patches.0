Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E6E330B26;
	Fri, 17 Oct 2025 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716322; cv=none; b=hho/KuYSy2gpcTzlNLsH3PIF5C+6ybqBEOuxS3iV1WgXyD238dEuYZtFp55vlQ4pAw0jGKgYJC1s3AZ8LuH55BKop/axjFHaN+0BXUNKhTB883qdjUANryvXCyWPietKGT/LYL0kqq6l8cxxUzRfkJdSjGcplBn+H4np27yLg7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716322; c=relaxed/simple;
	bh=OeazGBfjBxjwemXiP4ZbchwUW8stUDtyu0wMugZN1rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA9PFKi/p3S4GpQLdZiTfgW5NGmWdMz7xnf5NTZ48/vsk5utfLarHYM/3D2HQkn0MKuAIPLJIoVroAlD2RFmaa753Iskxzx/m1i4GVQWa5qbMEaUZPUHco7Ike1t5jMsML3rRFsMNV/QoxkLxq4fXyEYkz5BunQuQUKKQw0pSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Paqq1kdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Paqq1kdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94213C4CEE7;
	Fri, 17 Oct 2025 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716322;
	bh=OeazGBfjBxjwemXiP4ZbchwUW8stUDtyu0wMugZN1rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Paqq1kddUEmSPYH3bQ98IPD+3cyVzFz8qcP0N/yNohEEF6YWPE5fg/ZQYKgj22BKP
	 OhGgHbT56ZiHZR5VUis1bOUEqBNP8sUVRSl87pQB+/9A4S6aMgE7J6ZFWn4+0A+wqe
	 cpUdmIwE9Sr2/VYaKD4HZPLyuqGIsC1s/Q63TWVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/276] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
Date: Fri, 17 Oct 2025 16:53:56 +0200
Message-ID: <20251017145147.702484206@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 60cd16a3b7439ccb699d0bf533799eeb894fd217 ]

During the detaching of Marvell's SAS/SATA controller, the original code
calls cancel_delayed_work() in mvs_free() to cancel the delayed work
item mwq->work_q. However, if mwq->work_q is already running, the
cancel_delayed_work() may fail to cancel it. This can lead to
use-after-free scenarios where mvs_free() frees the mvs_info while
mvs_work_queue() is still executing and attempts to access the
already-freed mvs_info.

A typical race condition is illustrated below:

CPU 0 (remove)            | CPU 1 (delayed work callback)
mvs_pci_remove()          |
  mvs_free()              | mvs_work_queue()
    cancel_delayed_work() |
      kfree(mvi)          |
                          |   mvi-> // UAF

Replace cancel_delayed_work() with cancel_delayed_work_sync() to ensure
that the delayed work item is properly canceled and any executing
delayed work item completes before the mvs_info is deallocated.

This bug was found by static analysis.

Fixes: 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change; bug fixes")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5f217f9ab5223..d348350c15094 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -141,7 +141,7 @@ static void mvs_free(struct mvs_info *mvi)
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
-		cancel_delayed_work(&mwq->work_q);
+		cancel_delayed_work_sync(&mwq->work_q);
 	kfree(mvi->rsvd_tags);
 	kfree(mvi);
 }
-- 
2.51.0



