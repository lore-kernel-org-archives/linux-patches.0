Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927704F3EAF;
	Tue, 13 Oct 2026 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894020; cv=none; b=KanWlz5CeAsO4PtQsNQ51jpHgZ0+He0laeb4k/HqrWVeE2xGlVTnhPDxFfIKN4Y4jMmPcwVuY4WiPjiR+44Ytr2cwcFiKPYm96pcJ4xKt+jmgdU2Fr3TI371OR/bgXl40S9nFB3QsTEosAQ3sZzecffoMohtaVl5Fk3ghKWpk04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894020; c=relaxed/simple;
	bh=ItL/fe/Zr1GBc/5u6kLuHGK14HYKF5/f2AXu6tE4uc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDxeh0K6ZqooI34wBaA25j25WR+68kmGeiagzvoZOoDCDIe349Fx0EaKxEnQUHdiRvUkbwFFzgrTHNjtC2tofVrjVH8EonGD1+RelfeitavIO6Rv+IdcpltvynU8XIYqhLAuqk8mHyo+EzszAbCNxrIshImUeJ/P7L/QwH2/pzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwZpqtUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwZpqtUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23A51F000FF;
	Tue, 13 Oct 2026 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894019;
	bh=ncAhJPofy+NnxTqOM6qsNlvqV3V5QEk9ze8uLocmj/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwZpqtUJh9a50ZwUc3Bgd1WIIZ2FCwE44uOq5oRt/cx+H8qtq4pfqzNVr2mwpwPjL
	 RhJJNl5e4eQXkRUwSmzMEL0FDMaG7HhkDnwEHQLFzJhhXwdpvQ0BHdQStlGqLy894p
	 RvNebkIV3ko3+dpZwwmPaW/ACzijccey9NO+UGjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2626e846cd2585c9aa67@syzkaller.appspotmail.com,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/621] nvmet: fix max_qid race between configfs and controller allocation
Date: Tue, 13 Oct 2026 13:36:54 +0200
Message-ID: <20261013112930.779331605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f1a8846e06388113dfdbb89dee005083fa9afdf9 ]

The function nvmet_subsys_attr_qid_max_store() can race against
nvmet_alloc_ctrl() when a subsystem's max_qid limit is modified.

Suppose max_qid is currently 64. If nvmet_alloc_ctrl() executes:
ctrl->sqs = kzalloc_objs(struct nvmet_sq *, subsys->max_qid + 1);
and at this exact point, a userspace process changes max_qid to 128,
nvmet_subsys_attr_qid_max_store() will set the new max_qid value. It
attempts to delete active controllers to force a reconnect, but the
new controller won't be deleted because it hasn't been added to the
subsys->ctrls list yet.

nvmet_alloc_ctrl() then proceeds and adds the new controller to the
subsys->ctrls list. Later, when nvmet_install_queue() is called, it
will see max_qid set to 128, but the memory allocated for sqs is only
sized for 64 entries. This results in a KASAN out-of-bounds warning
and potential memory corruptions.

Fix this by protecting the queue allocations and list insertion in
nvmet_alloc_ctrl() with down_read(&nvmet_config_sem). Because
nvmet_subsys_attr_qid_max_store() acquires down_write(&nvmet_config_sem)
to modify the attribute, this safely prevents the configfs writer from
modifying max_qid during controller creation.

Copy the max_qid from the subsystem to the controller's structure
during the allocation; ctrl->max_qid never changes as long as the
controller remains in LIVE state, so this will prevent similar race
conditions.

Fixes: 3e980f5995e0 ("nvmet: expose max queues to configfs")
Reported-by: syzbot+2626e846cd2585c9aa67@syzkaller.appspotmail.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c   |  8 ++---
 drivers/nvme/target/core.c        | 49 +++++++++++++++++--------------
 drivers/nvme/target/fabrics-cmd.c |  2 +-
 drivers/nvme/target/nvmet.h       |  6 ++++
 drivers/nvme/target/pci-epf.c     |  2 +-
 5 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index fe7b6f8639f0a..4b4811f06982e 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1338,7 +1338,7 @@ static u16 nvmet_set_feat_arbitration(struct nvmet_req *req)
 
 void nvmet_execute_set_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u32 cdw11 = le32_to_cpu(req->cmd->common.cdw11);
 	u16 status = 0;
@@ -1360,7 +1360,7 @@ void nvmet_execute_set_features(struct nvmet_req *req)
 			break;
 		}
 		nvmet_set_result(req,
-			(subsys->max_qid - 1) | ((subsys->max_qid - 1) << 16));
+			(ctrl->max_qid - 1) | ((ctrl->max_qid - 1) << 16));
 		break;
 	case NVME_FEAT_IRQ_COALESCE:
 		status = nvmet_set_feat_irq_coalesce(req);
@@ -1497,7 +1497,7 @@ void nvmet_get_feat_async_event(struct nvmet_req *req)
 
 void nvmet_execute_get_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 status = 0;
 
@@ -1537,7 +1537,7 @@ void nvmet_execute_get_features(struct nvmet_req *req)
 		break;
 	case NVME_FEAT_NUM_QUEUES:
 		nvmet_set_result(req,
-			(subsys->max_qid-1) | ((subsys->max_qid-1) << 16));
+			(ctrl->max_qid-1) | ((ctrl->max_qid-1) << 16));
 		break;
 	case NVME_FEAT_KATO:
 		nvmet_get_feat_kato(req);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 3310d0b44ccff..1a064d1c3af30 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -867,7 +867,7 @@ u16 nvmet_check_cqid(struct nvmet_ctrl *ctrl, u16 cqid, bool create)
 	if (!ctrl->cqs)
 		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
 
-	if (cqid > ctrl->subsys->max_qid)
+	if (cqid > ctrl->max_qid)
 		return NVME_SC_QID_INVALID | NVME_STATUS_DNR;
 
 	if ((create && ctrl->cqs[cqid]) || (!create && !ctrl->cqs[cqid]))
@@ -915,7 +915,7 @@ u16 nvmet_check_sqid(struct nvmet_ctrl *ctrl, u16 sqid,
 	if (!ctrl->sqs)
 		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
 
-	if (sqid > ctrl->subsys->max_qid)
+	if (sqid > ctrl->max_qid)
 		return NVME_SC_QID_INVALID | NVME_STATUS_DNR;
 
 	if ((create && ctrl->sqs[sqid]) ||
@@ -1647,13 +1647,31 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	if (!ctrl->changed_ns_list)
 		goto out_free_ctrl;
 
-	ctrl->sqs = kcalloc(subsys->max_qid + 1,
+	/*
+	 * Discovery controllers may use some arbitrary high value
+	 * in order to cleanup stale discovery sessions
+	 */
+	if (nvmet_is_disc_subsys(ctrl->subsys) && !kato)
+		kato = NVMET_DISC_KATO_MS;
+
+	/* keep-alive timeout in seconds */
+	ctrl->kato = DIV_ROUND_UP(kato, 1000);
+
+	ctrl->err_counter = 0;
+	spin_lock_init(&ctrl->error_lock);
+
+	down_read(&nvmet_config_sem);
+	mutex_lock(&subsys->lock);
+
+	ctrl->max_qid = subsys->max_qid;
+
+	ctrl->sqs = kcalloc(ctrl->max_qid + 1,
 			sizeof(struct nvmet_sq *),
 			GFP_KERNEL);
 	if (!ctrl->sqs)
 		goto out_free_changed_ns_list;
 
-	ctrl->cqs = kcalloc(subsys->max_qid + 1, sizeof(struct nvmet_cq *),
+	ctrl->cqs = kcalloc(ctrl->max_qid + 1, sizeof(struct nvmet_cq *),
 			   GFP_KERNEL);
 	if (!ctrl->cqs)
 		goto out_free_sqs;
@@ -1667,22 +1685,6 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	}
 	ctrl->cntlid = ret;
 
-	/*
-	 * Discovery controllers may use some arbitrary high value
-	 * in order to cleanup stale discovery sessions
-	 */
-	if (nvmet_is_disc_subsys(ctrl->subsys) && !kato)
-		kato = NVMET_DISC_KATO_MS;
-
-	/* keep-alive timeout in seconds */
-	ctrl->kato = DIV_ROUND_UP(kato, 1000);
-
-	ctrl->err_counter = 0;
-	spin_lock_init(&ctrl->error_lock);
-
-	nvmet_start_keep_alive_timer(ctrl);
-
-	mutex_lock(&subsys->lock);
 	ret = nvmet_ctrl_init_pr(ctrl);
 	if (ret)
 		goto init_pr_fail;
@@ -1690,6 +1692,9 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	nvmet_setup_p2p_ns_map(ctrl, args->p2p_client);
 	nvmet_debugfs_ctrl_setup(ctrl);
 	mutex_unlock(&subsys->lock);
+	up_read(&nvmet_config_sem);
+
+	nvmet_start_keep_alive_timer(ctrl);
 
 	dhchap_status = nvmet_setup_auth(ctrl, args->sq, false);
 	if (dhchap_status) {
@@ -1716,14 +1721,14 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	return ctrl;
 
 init_pr_fail:
-	mutex_unlock(&subsys->lock);
-	nvmet_stop_keep_alive_timer(ctrl);
 	ida_free(&cntlid_ida, ctrl->cntlid);
 out_free_cqs:
 	kfree(ctrl->cqs);
 out_free_sqs:
 	kfree(ctrl->sqs);
 out_free_changed_ns_list:
+	mutex_unlock(&subsys->lock);
+	up_read(&nvmet_config_sem);
 	kfree(ctrl->changed_ns_list);
 out_free_ctrl:
 	kfree(ctrl);
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 7b8d8b397802c..bc837fbfada15 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -370,7 +370,7 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
-	if (unlikely(qid > ctrl->subsys->max_qid)) {
+	if (unlikely(qid > ctrl->max_qid)) {
 		pr_warn("invalid queue id (%d)\n", qid);
 		status = NVME_SC_CONNECT_INVALID_PARAM | NVME_STATUS_DNR;
 		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(qid);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 3e8a43df57a67..87e2fdbd18656 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -264,6 +264,7 @@ struct nvmet_ctrl {
 
 	uuid_t			hostid;
 	u16			cntlid;
+	u16			max_qid;
 	u32			kato;
 
 	struct nvmet_port	*port;
@@ -750,6 +751,11 @@ static inline struct nvmet_subsys *nvmet_req_subsys(struct nvmet_req *req)
 	return req->sq->ctrl->subsys;
 }
 
+static inline struct nvmet_ctrl *nvmet_req_ctrl(struct nvmet_req *req)
+{
+	return req->sq->ctrl;
+}
+
 static inline bool nvmet_is_disc_subsys(struct nvmet_subsys *subsys)
 {
     return subsys->type != NVME_NQN_NVME;
diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 1afda3686311a..e3815be98ee6e 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2085,7 +2085,7 @@ static int nvmet_pci_epf_create_ctrl(struct nvmet_pci_epf *nvme_epf,
 	}
 
 	/* Allocate our queues, up to the maximum number. */
-	ctrl->nr_queues = min(ctrl->tctrl->subsys->max_qid + 1, max_nr_queues);
+	ctrl->nr_queues = min(ctrl->tctrl->max_qid + 1, max_nr_queues);
 	ret = nvmet_pci_epf_alloc_queues(ctrl);
 	if (ret)
 		goto out_put_ctrl;
-- 
2.53.0



