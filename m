Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B65C34D92F;
	Tue, 16 Dec 2025 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885590; cv=none; b=XWK2WJ/QtraarQU+Zpq9EedCnF2WgMwfF8PH3psB6dLZzZRCT+Gqo7tWS9Penv57QTS0sbAxKXwjf5EbuBb/+e5iiXNGt2Oe3aW0Gq/cEhlUMc9fNl0+M6Rb5/SezqcAQ3QqDJTbCwdEAQhVugJjeJKAfGk6/wQuxDhtcwSd9Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885590; c=relaxed/simple;
	bh=NXz0LP5tZep1EGGYecMGuzfN1lnsirU97OWWVCMNU5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/bnPC25kAsApcJ0ySKSLq1sNqzXpKBo7rRaEazXFQFhsKEFBxamPYP0gNWGsN8FYi2WGXJmTkKP9cVN5CO/kjlg46PEGV2dETwWbbPVmwT1QhNrgQHaj7z0LuGYhB7epjrQfg4Q1MyMgVXageb0YsBQsdQpEb2LfsiqTNXtAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvcNKfoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvcNKfoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8A3C4CEF1;
	Tue, 16 Dec 2025 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885590;
	bh=NXz0LP5tZep1EGGYecMGuzfN1lnsirU97OWWVCMNU5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvcNKfoHssvPgQ0dpC3EfprY3h9VAivKNIEn3PmVIPtdP+1ajwaouviY7/ey3GxX8
	 1J5vmh1vgVP0uj4y9JqauoJdhGndFPXLChp9ZJG+ZKctSgiQCkqZLBipVL8Tpw7x/B
	 I187WNoQ0e4nln70CnF+ed4V1C51i6OODurRR65Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 185/507] accel/amdxdna: Fix dma_fence leak when job is canceled
Date: Tue, 16 Dec 2025 12:10:26 +0100
Message-ID: <20251216111352.216544457@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit dea9f84776b96a703f504631ebe9fea07bd2c181 ]

Currently, dma_fence_put(job->fence) is called in job notification
callback. However, if a job is canceled, the notification callback is never
invoked, leading to a memory leak. Move dma_fence_put(job->fence)
to the job cleanup function to ensure the fence is always released.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251105194140.1004314-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 1 -
 drivers/accel/amdxdna/amdxdna_ctx.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 3a9239da588c5..b02f84121f3a5 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -183,7 +183,6 @@ aie2_sched_notify(struct amdxdna_sched_job *job)
 
 	up(&job->hwctx->priv->job_sem);
 	job->job_done = true;
-	dma_fence_put(fence);
 	mmput_async(job->mm);
 	aie2_job_put(job);
 }
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index b47a7f8e90170..7242af5346f98 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -375,6 +375,7 @@ void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job)
 	trace_amdxdna_debug_point(job->hwctx->name, job->seq, "job release");
 	amdxdna_arg_bos_put(job);
 	amdxdna_gem_put_obj(job->cmd_bo);
+	dma_fence_put(job->fence);
 }
 
 int amdxdna_cmd_submit(struct amdxdna_client *client,
-- 
2.51.0



