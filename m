Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151AC6FB0;
	Tue,  5 Dec 2023 03:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZb7V6IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A9AC433C7;
	Tue,  5 Dec 2023 03:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747911;
	bh=YbEl8/eynf2zgz7ekZ//RKW5gKgh6J84D2TsZI20nzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZb7V6IXQbIVuir5EfyzELRn4c/FUCmlbmK9UImPzKBMg1WQlr10lUFb0F3n8Bio6
	 5C23iZJO7D2EFaw9mTtGFSfGjXk2gb9wDGNB3qSC2BX2wAKWjc21GPoij2V4kVECHZ
	 jMfsV945R6Kmpj1JhVST3Ddl2uicSY3o3c9S8AQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/94] nvmet: remove unnecessary ctrl parameter
Date: Tue,  5 Dec 2023 12:16:48 +0900
Message-ID: <20231205031524.031334509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit de5878048e11f1ec44164ebb8994de132074367a ]

The function nvmet_ctrl_find_get() accepts out pointer to nvmet_ctrl
structure. This function returns the same error value from two places
that is :- NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR.

Move this to the caller so we can change the return type to nvmet_ctrl.

Now that we can changed the return type, instead of taking out pointer
to the nvmet_ctrl structure remove that function parameter and return
the valid nvmet_ctrl pointer on success and NULL on failure.

Also, add and rename the goto labels for more readability with comments.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 1c22e0295a5e ("nvmet: nul-terminate the NQNs passed in the connect command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c        | 21 +++++++++++----------
 drivers/nvme/target/fabrics-cmd.c | 11 ++++++-----
 drivers/nvme/target/nvmet.h       |  5 +++--
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index d109333b95b81..60941a08e589c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1107,19 +1107,19 @@ static void nvmet_init_cap(struct nvmet_ctrl *ctrl)
 	ctrl->cap |= NVMET_QUEUE_SIZE - 1;
 }
 
-u16 nvmet_ctrl_find_get(const char *subsysnqn, const char *hostnqn, u16 cntlid,
-		struct nvmet_req *req, struct nvmet_ctrl **ret)
+struct nvmet_ctrl *nvmet_ctrl_find_get(const char *subsysnqn,
+				       const char *hostnqn, u16 cntlid,
+				       struct nvmet_req *req)
 {
+	struct nvmet_ctrl *ctrl = NULL;
 	struct nvmet_subsys *subsys;
-	struct nvmet_ctrl *ctrl;
-	u16 status = 0;
 
 	subsys = nvmet_find_get_subsys(req->port, subsysnqn);
 	if (!subsys) {
 		pr_warn("connect request for invalid subsystem %s!\n",
 			subsysnqn);
 		req->cqe->result.u32 = IPO_IATTR_CONNECT_DATA(subsysnqn);
-		return NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
+		goto out;
 	}
 
 	mutex_lock(&subsys->lock);
@@ -1132,20 +1132,21 @@ u16 nvmet_ctrl_find_get(const char *subsysnqn, const char *hostnqn, u16 cntlid,
 			if (!kref_get_unless_zero(&ctrl->ref))
 				continue;
 
-			*ret = ctrl;
-			goto out;
+			/* ctrl found */
+			goto found;
 		}
 	}
 
+	ctrl = NULL; /* ctrl not found */
 	pr_warn("could not find controller %d for subsys %s / host %s\n",
 		cntlid, subsysnqn, hostnqn);
 	req->cqe->result.u32 = IPO_IATTR_CONNECT_DATA(cntlid);
-	status = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 
-out:
+found:
 	mutex_unlock(&subsys->lock);
 	nvmet_subsys_put(subsys);
-	return status;
+out:
+	return ctrl;
 }
 
 u16 nvmet_check_ctrl_status(struct nvmet_req *req, struct nvme_command *cmd)
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 5e47395afc1d5..58544f9bbc20c 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -213,7 +213,7 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 {
 	struct nvmf_connect_command *c = &req->cmd->connect;
 	struct nvmf_connect_data *d;
-	struct nvmet_ctrl *ctrl = NULL;
+	struct nvmet_ctrl *ctrl;
 	u16 qid = le16_to_cpu(c->qid);
 	u16 status = 0;
 
@@ -237,11 +237,12 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
-	status = nvmet_ctrl_find_get(d->subsysnqn, d->hostnqn,
-				     le16_to_cpu(d->cntlid),
-				     req, &ctrl);
-	if (status)
+	ctrl = nvmet_ctrl_find_get(d->subsysnqn, d->hostnqn,
+				   le16_to_cpu(d->cntlid), req);
+	if (!ctrl) {
+		status = NVME_SC_CONNECT_INVALID_PARAM | NVME_SC_DNR;
 		goto out;
+	}
 
 	if (unlikely(qid > ctrl->subsys->max_qid)) {
 		pr_warn("invalid queue id (%d)\n", qid);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index c51f8dd01dc48..d625ec3e437b4 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -394,8 +394,9 @@ void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl);
 void nvmet_update_cc(struct nvmet_ctrl *ctrl, u32 new);
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		struct nvmet_req *req, u32 kato, struct nvmet_ctrl **ctrlp);
-u16 nvmet_ctrl_find_get(const char *subsysnqn, const char *hostnqn, u16 cntlid,
-		struct nvmet_req *req, struct nvmet_ctrl **ret);
+struct nvmet_ctrl *nvmet_ctrl_find_get(const char *subsysnqn,
+				       const char *hostnqn, u16 cntlid,
+				       struct nvmet_req *req);
 void nvmet_ctrl_put(struct nvmet_ctrl *ctrl);
 u16 nvmet_check_ctrl_status(struct nvmet_req *req, struct nvme_command *cmd);
 
-- 
2.42.0



