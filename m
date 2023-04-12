Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B002F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A1C433D2;
	Wed, 12 Apr 2023 08:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288624;
	bh=wCvjPwQ/isy/0PMDVZFcUXo3lTVoQtGdjn7ZpjYmpoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0RxCdF1znYVd7jSF7R63vrry88wKhCrEK76Cetgm+OrOL07jIN0jQXAZYZyTUkeF
	 QmqWGPXOJEtQOtY0bHTJ9kuu/Y/F1yEBguWb0cB5xP+9hwpDySSiEyXvLzePPtPz5v
	 A8zwbQeMM8PEQzsDxHWTfGGXWUhB9ZRvoXKung6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/93] drm/amdgpu: fix amdgpu_job_free_resources v2
Date: Wed, 12 Apr 2023 10:33:22 +0200
Message-Id: <20230412082823.954152927@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

[ Upstream commit 1427a720273976a81d13d9d9fa60d53ce881cbd7 ]

It can be that neither fence were initialized when we run out of UVD
streams for example.

v2: fix typo breaking compile

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2324
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index de29518673dd3..90a83aaa9908c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -135,8 +135,14 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 	else
 		hw_fence = &job->hw_fence;
 
-	/* use sched fence if available */
-	f = job->base.s_fence ? &job->base.s_fence->finished : hw_fence;
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
-- 
2.39.2



