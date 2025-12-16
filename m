Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA595368289;
	Tue, 16 Dec 2025 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887374; cv=none; b=EQAWmuCv6Dx2tAgV4PmHAf0wejNooU4RlNeeK9NHySEsXYiWyZsKsOzSFkPv8hq5sAbZeljzT02aAkfOutPf22E3NoBanzfoGZ1Nu/WyAu7bxKQMy66AxId/TFnmbhWyfZrMknMX/+AzJgOaudysohZyP231tJzbiUoMmnP1RPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887374; c=relaxed/simple;
	bh=k31IFOoRKxtc8pLlet0xN4ukyiTxiNvYjvsX6nb7Ycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNONvHBWIhxpJpNzbpayvtlcGyLEQL+aVlypmHHaZ3qGqylURpsb9C48rwF0MCm001qsjEG21m4NMt2+8U3w+m04HXuI07uiVVwbrHpf79aatyLR8LflBoTVd3cnnXEaJGouOsAywIqDEk+1FmHG73h4c9e8MqMGPNS/e7WpQNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVMetHUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVMetHUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F03C4CEF5;
	Tue, 16 Dec 2025 12:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887374;
	bh=k31IFOoRKxtc8pLlet0xN4ukyiTxiNvYjvsX6nb7Ycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVMetHUCyztYrOQ9MkHTPmEs0BkYvpOH00gqhauc07mNIxaP/MhSkAzc1+JswkQLT
	 2qoDWiRTQ6OVowKVn2P8Bv0ZLQt4pD/0KteQVfBW53kd4ueoH0dth5dkoCcCZvZx2h
	 9cbwOK6nTHF4IMg8KcG0gCZodUzoDTRwmLXh7Kx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/614] accel/amdxdna: Fix incorrect command state for timed out job
Date: Tue, 16 Dec 2025 12:08:54 +0100
Message-ID: <20251216111407.387740631@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

[ Upstream commit 6fb7f298883246e21f60f971065adcb789ae6eba ]

When a command times out, mark it as ERT_CMD_STATE_TIMEOUT. Any other
commands that are canceled due to this timeout should be marked as
ERT_CMD_STATE_ABORT.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251029193423.2430463-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 15 +++++++++++++--
 drivers/accel/amdxdna/amdxdna_ctx.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index e9f9b1fa5dc1b..c9f712f0ec00c 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -204,10 +204,13 @@ aie2_sched_resp_handler(void *handle, void __iomem *data, size_t size)
 
 	cmd_abo = job->cmd_bo;
 
-	if (unlikely(!data))
+	if (unlikely(job->job_timeout)) {
+		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		ret = -EINVAL;
 		goto out;
+	}
 
-	if (unlikely(size != sizeof(u32))) {
+	if (unlikely(!data) || unlikely(size != sizeof(u32))) {
 		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
 		goto out;
@@ -260,6 +263,13 @@ aie2_sched_cmdlist_resp_handler(void *handle, void __iomem *data, size_t size)
 	int ret = 0;
 
 	cmd_abo = job->cmd_bo;
+
+	if (unlikely(job->job_timeout)) {
+		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_TIMEOUT);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (unlikely(!data) || unlikely(size != sizeof(u32) * 3)) {
 		amdxdna_cmd_set_state(cmd_abo, ERT_CMD_STATE_ABORT);
 		ret = -EINVAL;
@@ -362,6 +372,7 @@ aie2_sched_job_timedout(struct drm_sched_job *sched_job)
 
 	xdna = hwctx->client->xdna;
 	trace_xdna_job(sched_job, hwctx->name, "job timedout", job->seq);
+	job->job_timeout = true;
 	mutex_lock(&xdna->dev_lock);
 	aie2_hwctx_stop(xdna, hwctx, sched_job);
 
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index 7cd7a55936f09..8c1d181df6e79 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -105,6 +105,7 @@ struct amdxdna_sched_job {
 	/* user can wait on this fence */
 	struct dma_fence	*out_fence;
 	bool			job_done;
+	bool			job_timeout;
 	u64			seq;
 	struct amdxdna_gem_obj	*cmd_bo;
 	size_t			bo_cnt;
-- 
2.51.0



