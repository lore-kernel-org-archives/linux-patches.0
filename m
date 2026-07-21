Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83128231829;
	Tue, 21 Jul 2026 18:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660015; cv=none; b=fK0dMLSYNLC+4/LWSTmlBYcjSYISiW47UzB8kyRhFBHaw8k3u8KpYX2P2A8nHlgy6Ste3fvYMdJ0ojtgxAibKwBloZoWB5+mW9FdHu8han7gqAI3GW1dioY8a7n4JokJ2AwdMYS43eC4wS2QDBp0oyDVdws8Cn1zMgdTlHGwtDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660015; c=relaxed/simple;
	bh=VF2wuHM22rg9icfhGzHt00I6D/xbydtJRtlBht/FIuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/+/1dcZDAW1vlGKhrGmRU0XVxVFDB8tsa4SE0QFroQgWA/sG/m0DRKaKsbGwzQAEWV9miFwsGuUKTD2CJ+q+Ksb2KcBr0W/PBK3ed0PuexMsjhbWz7WuXopXP+yYIwYhsN+h0Ik65QPEx3P/U7KhQTU2QH1jv6DTrbMJ9KGoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhmsSSIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhmsSSIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83A31F000E9;
	Tue, 21 Jul 2026 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660014;
	bh=kzzdOd+PZD8/140Z4WGEh7sUEgp0lqdX9s3qk4aImKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhmsSSIjH0DNhgcFYONaHKgXsto7Jp0U9NxJG0Vc2sOzlyL6iu/InNks6CS+u9qFB
	 GOoRAlHx3Aw7dxdizoI5g0mqaq1qw0fy14H+BCuXzFxX+SNXThik7ANVeDLreIVKGB
	 2i8HMrvLyVfiJsogYBIX1Xi64WFSqP94wvVn7pxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0818/2077] RDMA/irdma: Replace waitqueue and flag with completion
Date: Tue, 21 Jul 2026 17:08:11 +0200
Message-ID: <20260721152612.083768563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f9be467d137f82..c345cc6542566b 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -235,8 +235,7 @@ static void irdma_complete_cqp_request(struct irdma_cqp *cqp,
 				       struct irdma_cqp_request *cqp_request)
 {
 	if (cqp_request->waiting) {
-		WRITE_ONCE(cqp_request->request_done, true);
-		wake_up(&cqp_request->waitq);
+		complete_all(&cqp_request->comp);
 	} else if (cqp_request->callback_fcn) {
 		cqp_request->callback_fcn(cqp_request);
 	}
@@ -1107,9 +1106,9 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
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
index 3d49bd57bae7cf..8c17a201c1fd2f 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -161,13 +161,12 @@ struct irdma_cqp_compl_info {
 
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
index 495e5daff4b457..8e9e159f19ffe2 100644
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
@@ -480,7 +480,7 @@ void irdma_free_cqp_request(struct irdma_cqp *cqp,
 	if (cqp_request->dynamic) {
 		kfree(cqp_request);
 	} else {
-		WRITE_ONCE(cqp_request->request_done, false);
+		reinit_completion(&cqp_request->comp);
 		cqp_request->callback_fcn = NULL;
 		cqp_request->waiting = false;
 		cqp_request->pending = false;
@@ -515,8 +515,7 @@ irdma_free_pending_cqp_request(struct irdma_cqp *cqp,
 {
 	if (cqp_request->waiting) {
 		cqp_request->compl_info.error = true;
-		WRITE_ONCE(cqp_request->request_done, true);
-		wake_up(&cqp_request->waitq);
+		complete_all(&cqp_request->comp);
 	}
 	wait_event_timeout(cqp->remove_wq,
 			   refcount_read(&cqp_request->refcnt) == 1, 1000);
@@ -609,9 +608,8 @@ static int irdma_wait_event(struct irdma_pci_f *rf,
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



