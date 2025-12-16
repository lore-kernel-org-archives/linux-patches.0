Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D9236A028;
	Tue, 16 Dec 2025 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887401; cv=none; b=DfJhFp8pgX2LVykurblmPnu7ptGai8NQeQlkIP967Nedm7msfVmIT/y9abhtQxE0ZF2WbJtAh0e+APtWAAV9Lnowz6vuzgRp4XOPF6b0DFmG2i871fBw4mrnql9et6wMDPcGzrCtXpT756M1qXSECxRhsftQnFs7gNFDOnunJJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887401; c=relaxed/simple;
	bh=pUjdAUOt5Mm6tx1gG6Wb8vOV2mCY2aUcPKuCalxMYig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9SHguuuCpsPc0/XLdGCvcC59VlsbL+y2cZCONTnGIp14UQ4Dfof8XVdoSqMCX9C5VU25jc8QZlim0mI1Xt3fHsBgi2OsUdpsEvWXbuN76oJJmo+DTVKT5wp1oNT2bOYN+IJ4/VpqSaI9sOmaSI67CQRUkRqAHQLEw3hl/6gS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPOb5dVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPOb5dVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A0BC4CEF1;
	Tue, 16 Dec 2025 12:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887401;
	bh=pUjdAUOt5Mm6tx1gG6Wb8vOV2mCY2aUcPKuCalxMYig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPOb5dVek2O0Y/5ge1wcTtz3kXsk/6faCFqDUkDzdPdYZ0YHqy5QKbxOe36VSHjiJ
	 4Zpuz+DUzgoLetsrHtySMCX5e7SJ9Bqmn9E+EU1pG+dMtac23oXUTVTxdL4N4pRLME
	 nKGNaA05W9PzGTQq+q96tkYAzcMAEpcOuSX1h12s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/614] accel/amdxdna: Fix dma_fence leak when job is canceled
Date: Tue, 16 Dec 2025 12:09:46 +0100
Message-ID: <20251216111409.309150132@linuxfoundation.org>
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
index c9f712f0ec00c..2e479a8d86c31 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -189,7 +189,6 @@ aie2_sched_notify(struct amdxdna_sched_job *job)
 
 	up(&job->hwctx->priv->job_sem);
 	job->job_done = true;
-	dma_fence_put(fence);
 	mmput_async(job->mm);
 	aie2_job_put(job);
 }
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 4bfe4ef20550f..856fb25086f12 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -389,6 +389,7 @@ void amdxdna_sched_job_cleanup(struct amdxdna_sched_job *job)
 	trace_amdxdna_debug_point(job->hwctx->name, job->seq, "job release");
 	amdxdna_arg_bos_put(job);
 	amdxdna_gem_put_obj(job->cmd_bo);
+	dma_fence_put(job->fence);
 }
 
 int amdxdna_cmd_submit(struct amdxdna_client *client,
-- 
2.51.0



