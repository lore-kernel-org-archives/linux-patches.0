Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C42828ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC98C433D2;
	Mon, 12 Dec 2022 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852239;
	bh=4tkd72EE69XYSBz0xDakBXOQRnSmlAAMOLW05bBB4qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jThdUefJygQ9LAfSpDv7tRndl6tna9bDuzc+Vw9KMeAv9SDgIi3975VH5SDypZz2/
	 gDkCHRhzqgpEmUT0oY/YM3ZOoNaAd1okDwotcuE/xTNirdddCMw8DZplPY7rvZyz6N
	 26iXWolrA7z4IIL3M0TiMCKLv1wi8yjzyg3OFseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 041/157] drm/amdgpu: fix use-after-free during gpu recovery
Date: Mon, 12 Dec 2022 14:16:29 +0100
Message-Id: <20221212130936.188753570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit 3cb93f390453cde4d6afda1587aaa00e75e09617 ]

[Why]
    [  754.862560] refcount_t: underflow; use-after-free.
    [  754.862898] Call Trace:
    [  754.862903]  <TASK>
    [  754.862913]  amdgpu_job_free_cb+0xc2/0xe1 [amdgpu]
    [  754.863543]  drm_sched_main.cold+0x34/0x39 [amd_sched]

[How]
    The fw_fence may be not init, check whether dma_fence_init
    is performed before job free

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 3b025aace283..eb4c0523e42d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -167,7 +167,11 @@ static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
 	amdgpu_sync_free(&job->sync);
 	amdgpu_sync_free(&job->sched_sync);
 
-	dma_fence_put(&job->hw_fence);
+	/* only put the hw fence if has embedded fence */
+	if (!job->hw_fence.ops)
+		kfree(job);
+	else
+		dma_fence_put(&job->hw_fence);
 }
 
 void amdgpu_job_free(struct amdgpu_job *job)
-- 
2.35.1



