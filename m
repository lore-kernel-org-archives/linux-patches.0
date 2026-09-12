Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4656537E5F3;
	Sat, 12 Sep 2026 08:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203561; cv=none; b=AOaukAW5rP3307IgejapOVkae7sVKI2nXNdO0ZjQRQ3U92uIkJ3u7TuWBv38yrZGv3tcX7C11Es2syomiIm7pkbJxdh5DeJ5F3Pwtc+8D2KYF7YKVZQc5MesON8t+NN2DMXh1zatsVEDzzfB8jxxgIuJQX1nS4nAzlA1phFrJAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203561; c=relaxed/simple;
	bh=26d6rlRr1rQh0s25Itsqlnh+5k9XmXrqcDuoGRLjZbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd/5QRdRYuy4v7g3H4LgJU7GqG0NBsG1ric2GzY5FOuViZaD4l3b9o6BZB9nbrDtLRuxZjyUwj51UOswrHjTgJtOKklJp3lDZf6HyOsyfylKvwTVAi2D0iuDfD49wr3tBMXqSCBY2KssAM0QwCPbUwJn66ZMr6K8tuteGFFN52g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4TX1gJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4TX1gJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FED1F000FF;
	Sat, 12 Sep 2026 08:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203560;
	bh=iwOG66mAyDzAtgxLzdhHq7Rs9r9iZJrYVELEUdgnlxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4TX1gJkQWZa/IANb9afYHO6OBKY6i1MMtrI9Kr/5w1RGdTlXyA6gmEZXj7qoIKky
	 wIJbEikTseGriewPeh/+0eaiIwdl53oCp2+ANwqMooHmaQkATrn6iKNA0A4WchiaSf
	 W1PfsSCK6qYChEUby73+NvKbXPqy0hcfD8dGbTjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2626e846cd2585c9aa67@syzkaller.appspotmail.com,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1434/1815] nvmet: fix max_qid race between configfs and controller allocation
Date: Sat, 12 Sep 2026 08:53:04 +0200
Message-ID: <20260912065722.681362130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3fde09b4d78aa..7764a3c0195c9 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1337,7 +1337,7 @@ static u16 nvmet_set_feat_arbitration(struct nvmet_req *req)
 
 void nvmet_execute_set_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u32 cdw11 = le32_to_cpu(req->cmd->common.cdw11);
 	u16 status = 0;
@@ -1359,7 +1359,7 @@ void nvmet_execute_set_features(struct nvmet_req *req)
 			break;
 		}
 		nvmet_set_result(req,
-			(subsys->max_qid - 1) | ((subsys->max_qid - 1) << 16));
+			(ctrl->max_qid - 1) | ((ctrl->max_qid - 1) << 16));
 		break;
 	case NVME_FEAT_IRQ_COALESCE:
 		status = nvmet_set_feat_irq_coalesce(req);
@@ -1496,7 +1496,7 @@ void nvmet_get_feat_async_event(struct nvmet_req *req)
 
 void nvmet_execute_get_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 status = 0;
 
@@ -1536,7 +1536,7 @@ void nvmet_execute_get_features(struct nvmet_req *req)
 		break;
 	case NVME_FEAT_NUM_QUEUES:
 		nvmet_set_result(req,
-			(subsys->max_qid-1) | ((subsys->max_qid-1) << 16));
+			(ctrl->max_qid-1) | ((ctrl->max_qid-1) << 16));
 		break;
 	case NVME_FEAT_KATO:
 		nvmet_get_feat_kato(req);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 48a9a07f0f624..23fa90ec3c00e 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -876,7 +876,7 @@ u16 nvmet_check_cqid(struct nvmet_ctrl *ctrl, u16 cqid, bool create)
 	if (!ctrl->cqs)
 		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
 
-	if (cqid > ctrl->subsys->max_qid)
+	if (cqid > ctrl->max_qid)
 		return NVME_SC_QID_INVALID | NVME_STATUS_DNR;
 
 	if ((create && ctrl->cqs[cqid]) || (!create && !ctrl->cqs[cqid]))
@@ -924,7 +924,7 @@ u16 nvmet_check_sqid(struct nvmet_ctrl *ctrl, u16 sqid,
 	if (!ctrl->sqs)
 		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
 
-	if (sqid > ctrl->subsys->max_qid)
+	if (sqid > ctrl->max_qid)
 		return NVME_SC_QID_INVALID | NVME_STATUS_DNR;
 
 	if ((create && ctrl->sqs[sqid]) ||
@@ -1653,11 +1653,29 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	if (!ctrl->changed_ns_list)
 		goto out_free_ctrl;
 
-	ctrl->sqs = kzalloc_objs(struct nvmet_sq *, subsys->max_qid + 1);
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
+	ctrl->sqs = kzalloc_objs(struct nvmet_sq *, ctrl->max_qid + 1);
 	if (!ctrl->sqs)
 		goto out_free_changed_ns_list;
 
-	ctrl->cqs = kzalloc_objs(struct nvmet_cq *, subsys->max_qid + 1);
+	ctrl->cqs = kzalloc_objs(struct nvmet_cq *, ctrl->max_qid + 1);
 	if (!ctrl->cqs)
 		goto out_free_sqs;
 
@@ -1670,22 +1688,6 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
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
@@ -1693,6 +1695,9 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	nvmet_setup_p2p_ns_map(ctrl, args->p2p_client);
 	nvmet_debugfs_ctrl_setup(ctrl);
 	mutex_unlock(&subsys->lock);
+	up_read(&nvmet_config_sem);
+
+	nvmet_start_keep_alive_timer(ctrl);
 
 	if (args->hostid)
 		uuid_copy(&ctrl->hostid, args->hostid);
@@ -1722,14 +1727,14 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
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
index 7cadd1c9e44cc..42d1d18116715 100644
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
index 1645f4c818afa..7750f5b1edbb4 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -265,6 +265,7 @@ struct nvmet_ctrl {
 
 	uuid_t			hostid;
 	u16			cntlid;
+	u16			max_qid;
 	u32			kato;
 
 	struct nvmet_port	*port;
@@ -753,6 +754,11 @@ static inline struct nvmet_subsys *nvmet_req_subsys(struct nvmet_req *req)
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
index 346a4badd6b29..803e85df50e54 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2081,7 +2081,7 @@ static int nvmet_pci_epf_create_ctrl(struct nvmet_pci_epf *nvme_epf,
 	}
 
 	/* Allocate our queues, up to the maximum number. */
-	ctrl->nr_queues = min(ctrl->tctrl->subsys->max_qid + 1, max_nr_queues);
+	ctrl->nr_queues = min(ctrl->tctrl->max_qid + 1, max_nr_queues);
 	ret = nvmet_pci_epf_alloc_queues(ctrl);
 	if (ret)
 		goto out_put_ctrl;
-- 
2.53.0



