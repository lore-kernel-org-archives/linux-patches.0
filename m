Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C0B3905EB;
	Sat, 17 Oct 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254467; cv=none; b=EeHlEn3s5RKAKvTdbZNPETBNpsINEcKkIAmRQ1ziOihXXAeR9XS09n2gYyT7zwChMNS41Ns+ET0fwHYjGKu5UDHo65E38bOPVO7uU8I2vWOBt0igEKSzSSJkZzPiC4FPzAIBp+VIJfsQcd0z6zoT3eyyohYzFYvs93BieZUDZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254467; c=relaxed/simple;
	bh=9V6Og64V8KXws5HsRn5rsEwl9GxV/lh8dKkt/wFwuIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6mEkHxnZv5c2ZyCoeRvihkAQwcHl2pQ/7XWGC7IQ4qZkxjKn/O/LIG2qTeClwZBSLa4Sf4bByan1cnR7eUfxNKaJnxElAELKHm8v5frmPjzG+KKUKb0+tFE+tjB4ImAvSsilzjkl+7v7ExKJJKWAGYzr8d9sEcsxrQy0W4Zs7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQfHEcIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQfHEcIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9E1F000C4;
	Sat, 17 Oct 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254466;
	bh=dMCdDWvFWaBC2cowUttiZ0rLCuW9mWEcUFpvvKf2DWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQfHEcIjzAwvIBmYuBpUmwbiQ+43QJiUkdyyyXdx6anqHiUw2y21QMfyA39mQti+v
	 M4jn5gPtd4jPtn2CRm111CFd6qR3tXydul5VpDnY767pIux0gSWKISuez4Fl9O67IF
	 EXEOr89Zxhs6HYSlq9TNaUpUcevW5B0ndXpTHpUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 455/869] RDMA/irdma: Replace waitqueue and flag with completion
Date: Sat, 17 Oct 2026 17:54:56 +0200
Message-ID: <20261017160048.803641326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ad50b77282f8a..c1e5bcf6ab604 100644
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
index e5dc43442dff7..47b95efd51cea 100644
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
index 45c3f82887eff..1a73e1b740745 100644
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



