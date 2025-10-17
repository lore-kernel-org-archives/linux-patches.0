Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B71D2F12B0;
	Fri, 17 Oct 2025 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713526; cv=none; b=S/GOxX5tOJRCUtcTEvVqTuyBkWGTf49G90tsbrnJ+lzB4Vi3+R9+f/Hscz2cSonFy/lyFcpp9bddXuFV7Can8WMJed5Xotnqhbl5fCEx6ooZCW3CtIU3Xjdj0aqF6LdBffHZf3WDbjjkH1fzfeCkB4b+S17q02L9F+GK5om2qdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713526; c=relaxed/simple;
	bh=S+F8+OSp8rwBVjkBd/WkjbzI4H5g6bp0wba1oFl1wgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+Y1vjuq6z+eVuuxmeRJvL0RLHhfOp/6Lki5ow6AjDvrD8XvXBd9POFGGnrHrLjFKKKqvn2DUio1kNHTvRQQMd2trg7VdRk8HyMkgiPFVGTSegT/nJU0DUK2ogKsVRyOTBR9wJB5lr/ndaQadBccbd1OtF0SvO1EpX3kTYabRdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCz9zO/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCz9zO/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80088C4CEE7;
	Fri, 17 Oct 2025 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713525;
	bh=S+F8+OSp8rwBVjkBd/WkjbzI4H5g6bp0wba1oFl1wgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCz9zO/8Jns9zRQGGEHXZo83cQ11Nm0wSSa5AS+l6r8MVxG782c/MuIJlO1I7P8Yz
	 hV90RZDocRuKUX8ORGmzEUDIfK8T/urx3khzBZqtWW3CG6QP1ZGGajiKJ472kQZfBX
	 XkK2/C2zjmPEdosSerreVagXGfu5Z8qVTjp463GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/201] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
Date: Fri, 17 Oct 2025 16:51:28 +0200
Message-ID: <20251017145135.741720622@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43ebb331e2167..47c4434dc7e79 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -139,7 +139,7 @@ static void mvs_free(struct mvs_info *mvi)
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



