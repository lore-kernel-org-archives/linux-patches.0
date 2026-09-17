Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788EB547052;
	Thu, 17 Sep 2026 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665087; cv=none; b=ZHcKpUQXkpfSWVZe5iCPiJJv0oMRheA/A99iqArjIBc3AauN692+T9fIs/dRe95uL9aWGjWnKWeUG3DS5EzBv0e02LP2FWdYIjbQNwB7v8xQse1JKPGRmJ6Or1SiGOoyEyWkM8NiUy91ak/J0koSKmpLws06QHScb6z7JpVGztY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665087; c=relaxed/simple;
	bh=t/KgLQMxEmcfvMG9p13SG4M/7YykohSmH5S7RDftoNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvhrv13+jogrUyQjsC+Gkx/D4UJ0O2D22Fp39AYpo4UEGxcAxGaHPyuaYiEqD5AcyHYC8GxZ07yUpYzrxUTEe5YKgOByWpueY9sUmGBZq0cgTn51F6SDMH9LG7GCapzegYc7TdNjnRHD9kLt5ytdKCGO6z3qSIuyA/E4avd31p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXhnQx83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXhnQx83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ED71F000FF;
	Thu, 17 Sep 2026 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665086;
	bh=J4QCDCQYGVSU5U1ttNoIvRLxNUkPrFCaUQZY+dHEokk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXhnQx83D5hXOFDwGtI81csKBoOiZIP7G1nxpDj5YRbzX3tMEKiZQmVevn6CO2DgT
	 /Ch60Ac0jzXhCFNEApGSzUzFfSczYJN6X5LTRhbXfoRCWFW0N5EIhGOlbj/2VfCkBu
	 bCmHfs/evJlCl8+UvOrc9uox7fkyvcv0D2FIxnVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0587/1250] RDMA/irdma: Replace waitqueue and flag with completion
Date: Thu, 17 Sep 2026 16:06:22 +0100
Message-ID: <20260917151607.796232832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7bad0e38786a2..cbf7f4d75e5ea 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -167,8 +167,7 @@ static void irdma_complete_cqp_request(struct irdma_cqp *cqp,
 				       struct irdma_cqp_request *cqp_request)
 {
 	if (cqp_request->waiting) {
-		WRITE_ONCE(cqp_request->request_done, true);
-		wake_up(&cqp_request->waitq);
+		complete_all(&cqp_request->comp);
 	} else if (cqp_request->callback_fcn) {
 		cqp_request->callback_fcn(cqp_request);
 	}
@@ -1039,9 +1038,9 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
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
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index 0c16045a34be6..777d2ed406f8a 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -160,13 +160,12 @@ struct irdma_cqp_compl_info {
 
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
 	bool pending:1;
diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index f78d5dd4b24a9..43734ab827c07 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -442,7 +442,7 @@ struct irdma_cqp_request *irdma_alloc_and_get_cqp_request(struct irdma_cqp *cqp,
 		if (cqp_request) {
 			cqp_request->dynamic = true;
 			if (wait)
-				init_waitqueue_head(&cqp_request->waitq);
+				init_completion(&cqp_request->comp);
 		}
 	}
 	if (!cqp_request) {
@@ -479,7 +479,7 @@ void irdma_free_cqp_request(struct irdma_cqp *cqp,
 	if (cqp_request->dynamic) {
 		kfree(cqp_request);
 	} else {
-		WRITE_ONCE(cqp_request->request_done, false);
+		reinit_completion(&cqp_request->comp);
 		cqp_request->callback_fcn = NULL;
 		cqp_request->waiting = false;
 		cqp_request->pending = false;
@@ -514,8 +514,7 @@ irdma_free_pending_cqp_request(struct irdma_cqp *cqp,
 {
 	if (cqp_request->waiting) {
 		cqp_request->compl_info.error = true;
-		WRITE_ONCE(cqp_request->request_done, true);
-		wake_up(&cqp_request->waitq);
+		complete_all(&cqp_request->comp);
 	}
 	wait_event_timeout(cqp->remove_wq,
 			   refcount_read(&cqp_request->refcnt) == 1, 1000);
@@ -608,9 +607,8 @@ static int irdma_wait_event(struct irdma_pci_f *rf,
 	cqp_timeout.compl_cqp_cmds = atomic64_read(&rf->sc_dev.cqp->completed_ops);
 	do {
 		irdma_cqp_ce_handler(rf, &rf->ccq.sc_cq);
-		if (wait_event_timeout(cqp_request->waitq,
-				       READ_ONCE(cqp_request->request_done),
-				       msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
+		if (wait_for_completion_timeout(&cqp_request->comp,
+					msecs_to_jiffies(CQP_COMPL_WAIT_TIME_MS)))
 			break;
 
 		if (cqp_request->pending)
-- 
2.53.0



