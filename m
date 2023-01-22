Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5232590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD743C433EF;
	Sun, 22 Jan 2023 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401238;
	bh=waqv/JE53Q4veFAuP51d+GBwpCZJNESb8/kh4tNwexA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYyX/zOHFNLqZ822R4GJl0u5okDq9TdI5nurBFjQMfDOcS6xJjRDiMI9VkxlIrjxu
	 tyrcdIPhD0QRwXAihK+O1gdNFTvXXpz8ld0CT79Yx4Zsc6oTCpqbDqRBNQS4i17B97
	 BOybz189bR89UtRA3HK1Yec2A41j8eC73t+ioA7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 134/193] drm/amdgpu: fix amdgpu_job_free_resources v2
Date: Sun, 22 Jan 2023 16:04:23 +0100
Message-Id: <20230122150252.471317340@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

commit 74ea8e78ab349514c9f4df0be1189d91267d750d upstream.

It can be that neither fence were initialized when we run out of UVD
streams for example.

v2: fix typo breaking compile

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2324
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -154,8 +154,14 @@ void amdgpu_job_free_resources(struct am
 	struct dma_fence *f;
 	unsigned i;
 
-	/* use sched fence if available */
-	f = job->base.s_fence ? &job->base.s_fence->finished :  &job->hw_fence;
+	/* Check if any fences where initialized */
+	if (job->base.s_fence && job->base.s_fence->finished.ops)
+		f = &job->base.s_fence->finished;
+	else if (job->hw_fence.ops)
+		f = &job->hw_fence;
+	else
+		f = NULL;
+
 	for (i = 0; i < job->num_ibs; ++i)
 		amdgpu_ib_free(ring->adev, &job->ibs[i], f);
 }


