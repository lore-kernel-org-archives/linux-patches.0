Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADD64ED1B4;
	Tue, 13 Oct 2026 12:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893599; cv=none; b=Le48HDi6q8xVU6kmKKQkXpwz5PIyOxaio//2pHCv6koLzBP1yiUnr/9q2xhxmSGfDzeNe/2AYVpRsg1fXCLHQR+wUW3wB/6yMAsFg38PxyrV12RSuZ+/9Av34mAh34qqts8Ii7RjBmXMKHpnTQMlHmSAFbbLBgbKeEhu213A73U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893599; c=relaxed/simple;
	bh=ynUjDjqQ6e6Rj4mt7gbHkzS9/2GVkJ931LiRr/2+nOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeqrCeyIsR1jUFtXLyF/e77dRD69pcs8sgSQRJOllhSVFSCYdCs8u3EUQiqfCtwg7l1KiI5yZg9fY1jI6wqwD+70PWxPiLuybw344B9JdliJRzdiUsYV+6BKhFf6N2sHlE7DtFvu+0quFRqolne+SDjiD3o33jccRDc2RGVDCuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13XiU7ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13XiU7ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8DB1F000FF;
	Tue, 13 Oct 2026 12:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893598;
	bh=ROafOc1EagFSZmkMB8Xn8ik10E7mnkwg6bFEQoPIYbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13XiU7ysi4OQm27yGGv6XbpK4uLfoL1mZx+3a1BnqGvGxjzbdNaF14jYZPlUI2Un3
	 2CpGZBXQZpGKwhvBuxwXLUmzCJlR2vZASDfokx9RqzOmqhuz7foKcv1rDXL3T0uqqx
	 BqV8afgYN3HFowLuSy6gNw+SyUENdPJRrnPDRqbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/621] accel/amdxdna: Fill invalid payload for failed command
Date: Tue, 13 Oct 2026 13:34:33 +0200
Message-ID: <20261013112927.457091633@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 89ff45359abbf9d8d3c4aa3f5a57ed0be82b5a12 ]

Newer userspace applications may read the payload of a failed command
to obtain detailed error information. However, the driver and old firmware
versions may not support returning advanced error information.
In this case, initialize the command payload with an invalid value so
userspace can detect that no detailed error information is available.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260227004841.3080241-1-lizhi.hou@amd.com
Stable-dep-of: 1ba02717e821 ("accel/amdxdna: Fix VMA access race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 23 ++++++++---------------
 drivers/accel/amdxdna/amdxdna_ctx.c | 27 +++++++++++++++++++++++++++
 drivers/accel/amdxdna/amdxdna_ctx.h |  3 +++
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 92a09b06309da..6d8a79978c381 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -204,13 +204,13 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 	cmd_abo = job->cmd_bo;
 
 	if (unlikely(job->job_timeout)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_TIMEOUT);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely(!data) || unlikely(size != sizeof(u32))) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -220,7 +220,7 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 	if (status == AIE2_STATUS_SUCCESS)
 		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_COMPLETED);
 	else
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ERROR);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ERROR);
 
 out:
 	aie2_sched_notify(job);
@@ -264,13 +264,13 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 	cmd_abo = job->cmd_bo;
 
 	if (unlikely(job->job_timeout)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_TIMEOUT);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely(!data) || unlikely(size != sizeof(u32) * 3)) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, 0, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -290,19 +290,12 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 		 fail_cmd_idx, fail_cmd_status);
 
 	if (fail_cmd_status == AIE2_STATUS_SUCCESS) {
-		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
+		amdxdna_cmd_set_error(cmd_abo, job, fail_cmd_idx, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
-		goto out;
+	} else {
+		amdxdna_cmd_set_error(cmd_abo, job, fail_cmd_idx, ERT_CMD_STATE_ERROR);
 	}
-	amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ERROR);
-
-	if (amdxdna_cmd_get_op(cmd_abo) == ERT_CMD_CHAIN) {
-		struct amdxdna_cmd_chain *cc = amdxdna_cmd_get_payload(cmd_abo, NULL);
 
-		cc->error_index = fail_cmd_idx;
-		if (cc->error_index >= cc->command_count)
-			cc->error_index = 0;
-	}
 out:
 	aie2_sched_notify(job);
 	return ret;
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index db94a8d0e4bb0..feac65f2cab76 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -135,6 +135,33 @@ int amdxdna_cmd_get_cu_idx(struct amdxdna_gem_obj *abo)
 	return -1;
 }
 
+int amdxdna_cmd_set_error(struct amdxdna_gem_obj *abo,
+			  struct amdxdna_sched_job *job, u32 cmd_idx,
+			  enum ert_cmd_state error_state)
+{
+	struct amdxdna_client *client = job->hwctx->client;
+	struct amdxdna_cmd *cmd = abo->mem.kva;
+	struct amdxdna_cmd_chain *cc = NULL;
+
+	cmd->header &= ~AMDXDNA_CMD_STATE;
+	cmd->header |= FIELD_PREP(AMDXDNA_CMD_STATE, error_state);
+
+	if (amdxdna_cmd_get_op(abo) == ERT_CMD_CHAIN) {
+		cc = amdxdna_cmd_get_payload(abo, NULL);
+		cc->error_index = (cmd_idx < cc->command_count) ? cmd_idx : 0;
+		abo = amdxdna_gem_get_obj(client, cc->data[cc->error_index], AMDXDNA_BO_CMD);
+		if (!abo)
+			return -EINVAL;
+		cmd = abo->mem.kva;
+	}
+
+	memset(cmd->data, 0xff, abo->mem.size - sizeof(*cmd));
+	if (cc)
+		amdxdna_gem_put_obj(abo);
+
+	return 0;
+}
+
 /*
  * This should be called in close() and remove(). DO NOT call in other syscalls.
  * This guarantee that when hwctx and resources will be released, if user
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index 383f3f15fac8c..d54ccf1a3b6f2 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -139,6 +139,9 @@ amdxdna_cmd_get_state(struct amdxdna_gem_obj *abo)
 
 void *amdxdna_cmd_get_payload(struct amdxdna_gem_obj *abo, u32 *size);
 int amdxdna_cmd_get_cu_idx(struct amdxdna_gem_obj *abo);
+int amdxdna_cmd_set_error(struct amdxdna_gem_obj *abo,
+			  struct amdxdna_sched_job *job, u32 cmd_idx,
+			  enum ert_cmd_state error_state);
 
 void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job);
 void amdxdna_hwctx_remove_all(struct amdxdna_client *client);
-- 
2.53.0



