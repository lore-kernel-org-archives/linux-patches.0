Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507342F12D0;
	Fri, 17 Oct 2025 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713040; cv=none; b=O7Zzx9qE+JeuqyLE3FdydLdIVVpH1L4+UGcKPf+f4OXZCOJW1A/sC4mnBQr4VI5+CYsR3PIF4V4X65y/ps5VasNnxSs9+LRgLoamQ/ugzm2+2pt6zsCE/XUNxozaJZ/rShzmPLKXKvKPCETZMn5Cc9i52RmbzA/wIqlk1SkEFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713040; c=relaxed/simple;
	bh=g67lQ70QXYs8RENpJMZpW+cEMslYobu+6MmBf6wc2N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwNidVrSGGH/fEsQjaTVj/Hkc2VAHQj/nvdRTDfdCUIvzg/ocITZfGkMxVXEVW5EHPl8C+3SD+8lkMMbRog5azDRTD2+6QmzuHde64UnGnIl9gml5188O730WNJjsvWWZ+gn5dddllfwbsWqgXauXpllGBmLTg0GsV2BPF0R8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mga+7BB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mga+7BB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBBCC4CEE7;
	Fri, 17 Oct 2025 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713040;
	bh=g67lQ70QXYs8RENpJMZpW+cEMslYobu+6MmBf6wc2N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mga+7BB7wofr2lbUe8NDcZjkgxLlU82NLOc7FJ/me7osHz06XIzfQx9AxqbvZ/XUI
	 ezzYdgrMls2jlGrCpHlE0tuWCB7ccCNBuNQv+03Q4AvyLsPMcbhtz+fA0J0g4+Gr6X
	 U1edGGCzRvAGR16g5j/BAmievFBa9hFPFQ5ideDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/168] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
Date: Fri, 17 Oct 2025 16:51:46 +0200
Message-ID: <20251017145130.020222059@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cfe84473a5153..b500c343cad75 100644
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



