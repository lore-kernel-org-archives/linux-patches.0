Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216506;
	b=BlwXOpoQrHaDC+UyJ5R+XNSBzAKowaRWMGsmMLb5+mAKzWacwvMQgGw4smSFDwEmwKwW
	 qz8U5GIhir2dUgNgV0EkLQc6oLvnEscCn4fnbCopTbcZAppfzZHugMI3Tp+oktKKwGVbx
	 zjlKF9CnWwdrv7FDJ7cJgqh7OMRWi56fngq7Ew9TciFzz8sua0WthpERxAGc5U7qpZOhp
	 eUzfZCOkbqNPEkd9cb+geKoEzRD8YSsBtumgy38vug3uD1IRVWqwscFtfbCEAFvUqFM1w
	 hATpDd1zPJgPqAFx7zUBDuQk1CKPsdeTS1VQp//x9miaSjFiLmaf09BhfB5445iod1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4M1l2dJnbzPmqVfJHJy/yO8e5+gKIq8rD8RvjUdpEQ=;
	b=ewKOH6H6+lKLO9MswPrwZXh1dPOyhAArp74HJs0+TihuLJyvd0EH9HdBmBfCac01kcpm
	 caTj6kkItml3VnEizHUnR2l/T/lnVnLSPLsx9ZhBIg0z9PhNhlBcYuFQjvwts0qlauyI7
	 farvjM8eOzGpxXHS+gzCgCp+XpQyr+QHf1w463XcgHQb/fBJHttioPl9dldOMaCTHdd6U
	 IR1M/f/fCFyAkZgYHJP/JcJKzHBJRpVA7bkUG8xB5mQiNM7BQgUxzMq27Wv6qEwDMGKH3
	 TefSVgPE3XmpGZFRdTwF4y89DSqEjaDeZWJHQaNhWxAoghv870d9jt9HSqpMvLG2kFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C94B4LOY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E841606A31E;
	Wed, 28 Oct 2026 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C94B4LOY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2E71F01825;
	Wed, 28 Oct 2026 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216506;
	bh=M4M1l2dJnbzPmqVfJHJy/yO8e5+gKIq8rD8RvjUdpEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C94B4LOYFfK2lHIkG++FFpgxqh+vn5XzYj7w5YKCfZqqYJtjqrgRy5oZA3wlopxHs
	 jCENMWSR27pMdvJKLvtu1ZScpcVE0slUraUEzRVYqwKsf/h4+WrLsdj9SQO+grjP2O
	 AJtIILoLoYlDM8JeRElzhIAH4f7wMsxSJXUPhjc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2626e846cd2585c9aa67@syzkaller.appspotmail.com,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1553/1887] nvmet: fix max_qid race between configfs and controller allocation
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028170534.807951604@linuxfoundation.org>
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
 drivers/nvme/target/admin-cmd.c   |  8 +++---
 drivers/nvme/target/core.c        | 41 ++++++++++++++++++-------------
 drivers/nvme/target/fabrics-cmd.c |  2 +-
 drivers/nvme/target/nvmet.h       |  6 +++++
 4 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index b28a31cbfeae4..9d4180ceceb23 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -831,7 +831,7 @@ u16 nvmet_set_feat_async_event(struct nvmet_req *req, u32 mask)
 
 void nvmet_execute_set_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u32 cdw11 = le32_to_cpu(req->cmd->common.cdw11);
 	u16 status = 0;
@@ -850,7 +850,7 @@ void nvmet_execute_set_features(struct nvmet_req *req)
 			break;
 		}
 		nvmet_set_result(req,
-			(subsys->max_qid - 1) | ((subsys->max_qid - 1) << 16));
+			(ctrl->max_qid - 1) | ((ctrl->max_qid - 1) << 16));
 		break;
 	case NVME_FEAT_KATO:
 		status = nvmet_set_feat_kato(req);
@@ -905,7 +905,7 @@ void nvmet_get_feat_async_event(struct nvmet_req *req)
 
 void nvmet_execute_get_features(struct nvmet_req *req)
 {
-	struct nvmet_subsys *subsys = nvmet_req_subsys(req);
+	struct nvmet_ctrl *ctrl = nvmet_req_ctrl(req);
 	u32 cdw10 = le32_to_cpu(req->cmd->common.cdw10);
 	u16 status = 0;
 
@@ -942,7 +942,7 @@ void nvmet_execute_get_features(struct nvmet_req *req)
 		break;
 	case NVME_FEAT_NUM_QUEUES:
 		nvmet_set_result(req,
-			(subsys->max_qid-1) | ((subsys->max_qid-1) << 16));
+			(ctrl->max_qid-1) | ((ctrl->max_qid-1) << 16));
 		break;
 	case NVME_FEAT_KATO:
 		nvmet_get_feat_kato(req);
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index ed0c3b451fd71..ed92999609c7f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1470,7 +1470,25 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
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
@@ -1488,25 +1506,12 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
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
 	list_add_tail(&ctrl->subsys_entry, &subsys->ctrls);
 	nvmet_setup_p2p_ns_map(ctrl, req);
 	mutex_unlock(&subsys->lock);
+	up_read(&nvmet_config_sem);
+
+	nvmet_start_keep_alive_timer(ctrl);
 
 	*ctrlp = ctrl;
 	return 0;
@@ -1514,6 +1519,8 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 out_free_sqs:
 	kfree(ctrl->sqs);
 out_free_changed_ns_list:
+	mutex_unlock(&subsys->lock);
+	up_read(&nvmet_config_sem);
 	kfree(ctrl->changed_ns_list);
 out_free_ctrl:
 	kfree(ctrl);
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 6c882ca588bd9..7807cee08790b 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -351,7 +351,7 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
-	if (unlikely(qid > ctrl->subsys->max_qid)) {
+	if (unlikely(qid > ctrl->max_qid)) {
 		pr_warn("invalid queue id (%d)\n", qid);
 		status = NVME_SC_CONNECT_INVALID_PARAM | NVME_STATUS_DNR;
 		req->cqe->result.u32 = IPO_IATTR_CONNECT_SQE(qid);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 5a8bdd51e30c9..09778c5d26791 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -190,6 +190,7 @@ struct nvmet_ctrl {
 
 	uuid_t			hostid;
 	u16			cntlid;
+	u16			max_qid;
 	u32			kato;
 
 	struct nvmet_port	*port;
@@ -617,6 +618,11 @@ static inline struct nvmet_subsys *nvmet_req_subsys(struct nvmet_req *req)
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
-- 
2.53.0



