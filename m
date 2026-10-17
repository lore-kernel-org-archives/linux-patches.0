Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8424237C109;
	Sat, 17 Oct 2026 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259367; cv=none; b=gfhuQNkl69kQVxafWs/PK38gwpqadNsKtRDyl+IvN9gCKesWTtIq0oZyHXf6PQVeWDLVwRiOp5wzVaOT5j+yPk8DsnNo+v09PqwW8xKDghC71XmHJti4cVmBDP2oFvV+BCX/4pmMEgvKY/a+E7q0m6lV8DaukV+ZPVF28MeBdy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259367; c=relaxed/simple;
	bh=vgnEU4G1ziG606X0qZEdMbIYZRdLzfbc2/gahyYrFbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQeEcmLMtn0KKpsil/zl3pkT/814aCtzWZlHGVD8AketPwD/A1UUtMPMvNFD9htfkkgH6RLsxb+X82Q4PoHrb9smpIHRq6f6pH9sIU8Oey1IrR+Sz/E9ylVEWEX9hbxGMJvxPdDpnukmtaaNkb6lbmYOpTvSAmbL8yt/08ga2+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR4XTNP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR4XTNP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F91F000C4;
	Sat, 17 Oct 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259366;
	bh=2M7QiyhY1C7ZNcKBX7qGtZnDvU4J3UTRUVGQBXKwl54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR4XTNP1NCAxa4QbFkSBELSz1jzZUbBCtfHx7lqPMKaGytiz2GB3QdoezSQ042fXe
	 P1GDMBu9zOpKkpird3HQdc6nF4hU7bT7Lt8QWGrqp70ufmdf/sFLs7T20dbWKkKRzL
	 F1ySZF4pdBiLASDazAxIdwAiMDvGjDuTPrxYibG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1149/1674] RDMA/irdma: Replace waitqueue and flag with completion
Date: Sat, 17 Oct 2026 17:57:01 +0200
Message-ID: <20261017160500.643451441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit d9c8c45e6d2f438a3c8e643ae78b59454fa0fadd ]

The driver previously used a waitqueue along with an explicit
request_done flag, but without proper barriers around request_done.

An earlier patch by Gui-Dong Han <hanguidong02@gmail.com> attempted
to fix this by adding the missing memory barriers. Rather than
adding the barriers, this patch replaces the waitqueue+flag with
a completion, which is designed for this exact purpose.

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Link: https://patch.msgid.link/r/20260616155601.1081448-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c    |  7 +++----
 drivers/infiniband/hw/irdma/main.h  |  3 +--
 drivers/infiniband/hw/irdma/utils.c | 12 +++++-------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 1745f40b075fd..fd18474a3d2fe 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1001,9 +1001,9 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
 	INIT_LIST_HEAD(&cqp->cqp_avail_reqs);
 	INIT_LIST_HEAD(&cqp->cqp_pending_reqs);
 
-	/* init the waitqueue of the cqp_requests and add them to the list */
+	/* init the completion of the cqp_requests and add them to the list */
 	for (i = 0; i < sqsize; i++) {
-		init_waitqueue_head(&cqp->cqp_requests[i].waitq);
+		init_completion(&cqp->cqp_requests[i].comp);
 		list_add_tail(&cqp->cqp_requests[i].list, &cqp->cqp_avail_reqs);
 	}
 	init_waitqueue_head(&cqp->remove_wq);
@@ -2103,8 +2103,7 @@ void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq)
 			cqp_request->compl_info.error = info.error;
 
 			if (cqp_request->waiting) {
-				WRITE_ONCE(cqp_request->request_done, true);
-				wake_up(&cqp_request->waitq);
+				complete_all(&cqp_request->comp);
 				irdma_put_cqp_request(&rf->cqp, cqp_request);
 			} else {
 				if (cqp_request->callback_fcn)
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 19bc3842642f8..456208395ad8c 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -155,13 +155,12 @@ struct irdma_cqp_compl_info {
 
 struct irdma_cqp_request {
 	struct cqp_cmds_info info;
-	wait_queue_head_t waitq;
+	struct completion comp;
 	struct list_head list;
 	refcount_t refcnt;
 	void (*callback_fcn)(struct irdma_cqp_request *cqp_request);
 	void *param;
 	struct irdma_cqp_compl_info compl_info;
-	bool request_done; /* READ/WRITE_ONCE macros operate on it */
 	bool waiting:1;
 	bool dynamic:1;
 };
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 21c83f000a786..834cf42546053 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -445,7 +445,7 @@ struct irdma_cqp_request *irdma_alloc_and_get_cqp_request(struct irdma_cqp *cqp,
 		if (cqp_request) {
 			cqp_request->dynamic = true;
 			if (wait)
-				init_waitqueue_head(&cqp_request->waitq);
+				init_completion(&cqp_request->comp);
 		}
 	}
 	if (!cqp_request) {
@@ -482,7 +482,7 @@ void irdma_free_cqp_request(struct irdma_cqp *cqp,
 	if (cqp_request->dynamic) {
 		kfree(cqp_request);
 	} else {
-		WRITE_ONCE(cqp_request->request_done, false);
+		reinit_completion(&cqp_request->comp);
 		cqp_request->callback_fcn = NULL;
 		cqp_request->waiting = false;
 
@@ -516,8 +516,7 @@ irdma_free_pending_cqp_request(struct irdma_cqp *cqp,
 {
 	if (cqp_request->waiting) {
 		cqp_request->compl_info.error = true;
-		WRITE_ONCE(cqp_request->request_done, true);
-		wake_up(&cqp_request->waitq);
+		complete_all(&cqp_request->comp);
 	}
 	wait_event_timeout(cqp->remove_wq,
 			   refcount_read(&cqp_request->refcnt) == 1, 1000);
@@ -571,9 +570,8 @@ static int irdma_wait_event(struct irdma_pci_f *rf,
 	cqp_timeout.compl_cqp_cmds = atomic64_read(&rf->sc_dev.cqp->completed_ops);
 	do {
 		irdma_cqp_ce_handler(rf, &rf->ccq.sc_cq);
-		if (wait_event_timeout(cqp_request->waitq,
-				       READ_ONCE(cqp_request->request_done),
-				       msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
+		if (wait_for_completion_timeout(&cqp_request->comp,
+					msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
 			break;
 
 		irdma_check_cqp_progress(&cqp_timeout, &rf->sc_dev);
-- 
2.53.0



