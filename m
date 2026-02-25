Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC0418DB2A;
	Wed, 25 Feb 2026 01:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983140; cv=none; b=uquR/7xBO1Be8gO8I6pUxNJ9nLwCxfDkbp50k4oMxoY3Mr+rTnymKDFUyclKHV9OOyxfp1Z9ShJRYnuWnTV5qQ0FntbJkmu2XCB45XukYAx9Q4wTJBGunlFx7/Iv5dG93EwZT0UE0H1LjwA5NE6Yqh+jDPQNcPimvXZIvXNkdd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983140; c=relaxed/simple;
	bh=euh9su5Sdnj6hPb58bdQGNoZiJo+d0H/xEZiPb7DouM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc/RmwV6zF/goKj6hafzoxw6v4beKDJmxxBFAPpTbfsLoca5yCTNG6vkw6uVFsrW+HL0oRffTdiIUZWcHs/5HL4CX++AnABYx0sXU9A6gKBCa48pDobmP/6s2tuKiem6dQdDaiCB7Z1JKaL0qRj0eO/JqpvcsJYOWwChYl0+9k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbnNO6Nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbnNO6Nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FFBC116D0;
	Wed, 25 Feb 2026 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983140;
	bh=euh9su5Sdnj6hPb58bdQGNoZiJo+d0H/xEZiPb7DouM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbnNO6NwJUtnHjlS+LwcBIjKFdX9wp6rq4SzbwQMFzcpfMRTRifheThxCybVU2is0
	 JhgGdf41uSaFqkUxov2lp/8HTfxATBQ9Q5VfIIIeGfA/XrXbruEiTy3RDiuqBxkEGv
	 7DJ9WLd0YLw+ML8TCcBj/yF81+pio9tmTWoytiRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 294/781] accel/amdxdna: Stop job scheduling across aie2_release_resource()
Date: Tue, 24 Feb 2026 17:16:43 -0800
Message-ID: <20260225012406.921350988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 42d876a427c59..2c36ed7e9639c 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -315,6 +315,9 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 	struct dma_fence *fence;
 	int ret;
 
+	if (hwctx->status != HWCTX_STAT_READY)
+		return NULL;
+
 	if (!mmget_not_zero(job->mm))
 		return ERR_PTR(-ESRCH);
 
@@ -693,7 +696,10 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
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



