Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215541;
	b=0j3KpXRumocfa8xGPem7f8zNoVQTiVVoeOOZ8i6PQEXdkmY+mvoyq5xHnwBN7x1DJn+r
	 fKyh2Lou6eu8YoMdQhCCVvntQ3XGnUiKLPi7mMdwk7vJX9K6lknH8pO2Bz/VEp9I2yE2t
	 IxKPmYhLIRWavXz7NCXCFngjFlmEjG8cnPxlSlySz05p50rQ8wb8OSPiT3yyvWF6+esZG
	 yh+L9GE2t9WYqEE6nOe6l+ZFy7IbXxspdCVojYF2HaooHM4GRE0m9xfJZSO8FreWWO8bW
	 OjjM7dUyzhDgE5yP0yFYsKDQUNDDUGYbFnfpoWNaxDU0lMbLtpz6CnXZzHQv1sV1w+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bG3bi1FrLFUFE1gtt3Z9zm1EnpL6aH6Z1mbJcleAEKM=;
	b=Jc9SeAcXz1YtBuR8VSqm8ikAElIrXhYY/m/m9xP6j2kwCxYZqMSm7VBJwAEWMhex7XH7
	 BbfQjKfldTQ/Qm7J7Gvfx76FN64fUPFuIr66NSOeFh5igTCA9v98gRPv7blV8imnqd5f4
	 6LMg6VNPkLDWzVkJiFyuzC5egm1cYOxE/a+VRu71A28SSTDP30x50DMhivMlTvBDd0q0S
	 7ZfbsFj9Io3kziL1XiAkd6A5J/DSp9rVxUDHVK7nA806GE5GHLBl06zPrCBLT+DPKaBPb
	 i0hkRfPO8F+T764NuGXxnxvaPB67Z7ZLUBYEcr+XsS5+WsXgwwBK0c/dnzCvSWTTllQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MG1VnNcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BF606A31A;
	Wed, 28 Oct 2026 19:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MG1VnNcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C021F01825;
	Wed, 28 Oct 2026 19:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215540;
	bh=bG3bi1FrLFUFE1gtt3Z9zm1EnpL6aH6Z1mbJcleAEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MG1VnNcW8sRigZxZ9FYhLVO/96uRugHRIu5LuxgU3uA0wJwVEKGncAWjTIqxFYww8
	 V38QMg6NR57ACrOIOXlxRkMQz6AaevOPm8qN68Z8MIwcvHtUNaOUqSSq/u8bzV/gdX
	 ulLEnU6IiDak41WwxRoVCarA3DJevEpY4RmPAAsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1246/1887] RDMA/irdma: Replace waitqueue and flag with completion
Date: Wed, 28 Oct 2026 17:55:42 +0100
Message-ID: <20261028170527.779604736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 918a2d783141f..6f71edf4e5e1e 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -994,9 +994,9 @@ static int irdma_create_cqp(struct irdma_pci_f *rf)
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
@@ -2086,8 +2086,7 @@ void irdma_cqp_ce_handler(struct irdma_pci_f *rf, struct irdma_sc_cq *cq)
 			cqp_request->compl_info.error = info.error;
 
 			if (cqp_request->waiting) {
-				WRITE_ONCE(cqp_request->request_done, true);
-				wake_up(&cqp_request->waitq);
+				complete_all(&cqp_request->comp);
 				irdma_put_cqp_request(&rf->cqp, cqp_request);
 			} else {
 				if (cqp_request->callback_fcn)
diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index e38172af69395..7f8428d00a9fb 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -153,13 +153,12 @@ struct irdma_cqp_compl_info {
 
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
index b66910b2942c2..9187614e7442f 100644
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



