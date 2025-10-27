Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3838231D746;
	Mon, 27 Oct 2025 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591213; cv=none; b=XsQ1qCd/Qd3ZT0Lj+Q1dNvB/kS9R6tL/Cw7MQh+XbdTFDkDRSpGiUjJQ0m+dsJFnlc7TKv5Vk4PmGMZWxGfkoK0Lw7RFFArNwTsA0d15Ib5SaJ9wLy1lrmKbd/didDACy5DNPMxSgTHggZJweGnzB7fWYPyw8EuSnuD7RKlAEE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591213; c=relaxed/simple;
	bh=nFvv2Lf5pSdyTGBmtWxruduN055e70vpdYqKxKJhkqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSmoTrTI/QW8+lFReZ4vYIEfypO1o7/2UwnFRebwa7BhT+LfbJnKSsk1933cIAzFpZ9ZFjk5I56Mf8ajUF0V4lMyyWOmnjfCRRet47w8eZcwiW22y+ttrtq2mGn0aZEXLtgOUDlTS59mDXGL9MHCWp9ctE3nv1OgRvLMAF72W44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkr22FgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkr22FgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2062C4CEF1;
	Mon, 27 Oct 2025 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591213;
	bh=nFvv2Lf5pSdyTGBmtWxruduN055e70vpdYqKxKJhkqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkr22FgPaI2TdigsEvlCZhNzRFQR41OX4rC0w1RS+NHU6K5JHj+87fFoH84fecHiY
	 wM3TlD7qXd/WlhxL0NSl5zENMe7ZKA3vKhZAf5RBTgt4nfgZEL/d1/E0ODmslOwv/H
	 RS0By1yP3aRWa30NA4PMa1Rx7YFZ12Pk6B7ERS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/332] scsi: mvsas: Fix use-after-free bugs in mvs_work_queue
Date: Mon, 27 Oct 2025 19:32:42 +0100
Message-ID: <20251027183527.494791926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ccbea18f8ee12..c9dfbc1e37655 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -142,7 +142,7 @@ static void mvs_free(struct mvs_info *mvi)
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



