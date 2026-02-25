Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A8B22127B;
	Wed, 25 Feb 2026 01:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983969; cv=none; b=fZwp87uznKtBvFagAVxlfFuNAA3CloYoDzKe4pW6bbpZYPVHWBAIijUdALbgx8cy/bLQWJ2tymZOHLezJPQzd/sJ04ffpJ4CwavhOJKYmXjg1jj9ryVsS+r3A3zuyMZafLVIzW3q4iZo46tM2+cvttrrRp5rZOi8KTC2FNvPZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983969; c=relaxed/simple;
	bh=LLLSyw6+qw3zHZMNgSUScI2IpUr+B1QRylTMMZCOVck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvGwjZvjExlFrd1gij4FYXl9xf93ana+yqsECwCl2Uy4tG0kK7ou77LfBWmolQwX+DCia1rjM/il5vRYoGSUPuuSc46MXRlM1FOBGPtGQaknB77Zff7c8PM2wqrOVIXs6iYt+buXOigYtZ1qLazr0Qa6RCCT1HLHgMaE5Bdmcho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OjCFiyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OjCFiyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006E5C116D0;
	Wed, 25 Feb 2026 01:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983969;
	bh=LLLSyw6+qw3zHZMNgSUScI2IpUr+B1QRylTMMZCOVck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OjCFiyH8vLKCcQL09g3BFSZpq7ie6MD4knnihysd205PPMS117CGZrwyqdIrqKQq
	 RYqTE9PepFqko1kdB5tlRliIRuBh4f/SlPhd7e4+WH8wx3VlsG1luroIWUBiKt3UEi
	 zDamoTepRX/jYtLy8h3KMIQxn1A7Ucv/DRiXV1wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/641] accel/amdxdna: Stop job scheduling across aie2_release_resource()
Date: Tue, 24 Feb 2026 17:19:10 -0800
Message-ID: <20260225012354.340687672@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

[ Upstream commit f1370241fe8045702bc9d0812b996791f0500f1b ]

Running jobs on a hardware context while it is in the process of
releasing resources can lead to use-after-free and crashes.

Fix this by stopping job scheduling before calling
aie2_release_resource() and restarting it after the release completes.
Additionally, aie2_sched_job_run() now checks whether the hardware
context is still active.

Fixes: 4fd6ca90fc7f ("accel/amdxdna: Refactor hardware context destroy routine")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260130003255.2083255-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 75246c481fa50..c3cb24d96cee3 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -317,6 +317,9 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	int ret;
 
+	if (hwctx->status != HWCTX_STAT_READY)
+		return NULL;
+
 	if (!mmget_not_zero(job->mm))
 		return ERR_PTR(-ESRCH);
 
@@ -684,7 +687,10 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 	aie2_hwctx_wait_for_idle(hwctx);
 
 	/* Request fw to destroy hwctx and cancel the rest pending requests */
+	drm_sched_stop(&hwctx->priv->sched, NULL);
 	aie2_release_resource(hwctx);
+	hwctx->status = HWCTX_STAT_STOP;
+	drm_sched_start(&hwctx->priv->sched, 0);
 
 	mutex_unlock(&xdna->dev_lock);
 	drm_sched_entity_destroy(&hwctx->priv->entity);
-- 
2.51.0



