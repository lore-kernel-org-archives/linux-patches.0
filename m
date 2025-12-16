Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB732345732;
	Tue, 16 Dec 2025 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887579; cv=none; b=q1DJqKFrxqEC+7jflHfFX82J9n7eUYRPWriNAt4B0bz0xXmaAyx7b4cwGJQFCuUwdNK7+CEOPQRnEf4Iz2RbyoiONpqCiJmdnEHy7XGrclA6SV+/4vqj96YdlKvwB9/A7QQNiv+OnJ/g7sLhSpABJMf4ixMRS2e1ZlV+sqXHwrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887579; c=relaxed/simple;
	bh=WleXmH1fQ7gID7NqDSZD7rXYG83u8yvIaVAh8VK6PbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhxzkxzhAX4lYoff5kfWhcHnz2nOIOdQn4skK7JXFZVB90TvTNrT3mCNNpqtR6g7SJcoykCoTTuZlGmWkwhVD3SOWeW95aisCPbEbUU/zy7X+7xqMEuQA4tzpAIz5crdqXMeK0NhVjbQs9wzZeqcb8/gXzv1MWoRcFb2iDCl1vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4EgQSd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4EgQSd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F4AC4CEF1;
	Tue, 16 Dec 2025 12:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887579;
	bh=WleXmH1fQ7gID7NqDSZD7rXYG83u8yvIaVAh8VK6PbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4EgQSd/IkJsYeTTbWNO07pCkwzzsrb6lyopE9mvFAZX3Mwx3hRZuRD06Se98VX1a
	 3zlNFk6l1ZF8on9ccVJpOj6O0IvJl9+uGFxH/86d40LAZmH+G3CkxKX2K+ddrtaEAg
	 jP6luMfVz04GNA6/HGFyTbmoP4GliC58l/DQqFp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/614] accel/amdxdna: Fix deadlock between context destroy and job timeout
Date: Tue, 16 Dec 2025 12:10:39 +0100
Message-ID: <20251216111411.230477117@linuxfoundation.org>
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

[ Upstream commit ca2583412306ceda9304a7c4302fd9efbf43e963 ]

Hardware context destroy function holds dev_lock while waiting for all jobs
to complete. The timeout job also needs to acquire dev_lock, this leads to
a deadlock.

Fix the issue by temporarily releasing dev_lock before waiting for all
jobs to finish, and reacquiring it afterward.

Fixes: 4fd6ca90fc7f ("accel/amdxdna: Refactor hardware context destroy routine")
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251107181050.1293125-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 2e479a8d86c31..75246c481fa50 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -681,17 +681,19 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 	ndev->hwctx_num--;
 
 	XDNA_DBG(xdna, "%s sequence number %lld", hwctx->name, hwctx->priv->seq);
-	drm_sched_entity_destroy(&hwctx->priv->entity);
-
 	aie2_hwctx_wait_for_idle(hwctx);
 
 	/* Request fw to destroy hwctx and cancel the rest pending requests */
 	aie2_release_resource(hwctx);
 
+	mutex_unlock(&xdna->dev_lock);
+	drm_sched_entity_destroy(&hwctx->priv->entity);
+
 	/* Wait for all submitted jobs to be completed or canceled */
 	wait_event(hwctx->priv->job_free_wq,
 		   atomic64_read(&hwctx->job_submit_cnt) ==
 		   atomic64_read(&hwctx->job_free_cnt));
+	mutex_lock(&xdna->dev_lock);
 
 	drm_sched_fini(&hwctx->priv->sched);
 	aie2_ctx_syncobj_destroy(hwctx);
-- 
2.51.0



