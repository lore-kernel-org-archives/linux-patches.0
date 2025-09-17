Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB651EB1AA;
	Wed, 17 Sep 2025 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113391; cv=none; b=sAk1odbX8XCZdvE+braUbcgrYuZB8bbNMB0vzOqbIRprlO8UPjLeAFXHysrsf7l2V2sPHSihsfCYVCMW6y390h2BmooRvmSmU2aXa+uv1pYv9+JMNGNYanBta0e+aTt/e/YoSjQbdITOjV4MtQEjj0gJ/TuakDGA7ogFChTgr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113391; c=relaxed/simple;
	bh=v6sk01Nop+vS8Njv/UwcBt+sIwWyzxsQZ3KROsBGbjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbqFxQe+K/ZvcPGBR9FcjGtqG3EQB+LcRBI4v0uA21rmzFRe4efG5ZK/xIgmFO2C0u0d2XVBpaa0T60DdGVJ+7QCWmP69vtuMaL4rZwjLuGf9cV4bny/+2lvcQlEPY7D7vJfwj5mp20mVEBWJCL7aha5Gp7AlObYDldh5yWDUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrGMijaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrGMijaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F1AC4CEF0;
	Wed, 17 Sep 2025 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113391;
	bh=v6sk01Nop+vS8Njv/UwcBt+sIwWyzxsQZ3KROsBGbjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrGMijaBe3sDaV8t3svc6v/IrDQbrNsXiEg+o+0WgKW5UpHZ1Hx+kRUq1TLJ6Vrz+
	 MGPg9wTKfDw6VKbY5GFqQPcH2zXTqrZUfdEMAWh0064MTX0qE2ogrwhT3l0s3u+Ydq
	 qL8LIFRhcbiA47z3FkhRXNGKjEafLS9oXS5uY1E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 069/140] drm/amdgpu/vcn: Allow limiting ctx to instance 0 for AV1 at any time
Date: Wed, 17 Sep 2025 14:34:01 +0200
Message-ID: <20250917123345.995970906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 3318f2d20ce48849855df5e190813826d0bc3653 upstream.

There is no reason to require this to happen on first submitted IB only.
We need to wait for the queue to be idle, but it can be done at any
time (including when there are multiple video sessions active).

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8908fdce0634a623404e9923ed2f536101a39db5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |   12 ++++++++----
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   12 ++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1813,15 +1813,19 @@ static int vcn_v3_0_limit_sched(struct a
 				struct amdgpu_job *job)
 {
 	struct drm_gpu_scheduler **scheds;
-
-	/* The create msg must be in the first IB submitted */
-	if (atomic_read(&job->base.entity->fence_seq))
-		return -EINVAL;
+	struct dma_fence *fence;
 
 	/* if VCN0 is harvested, we can't support AV1 */
 	if (p->adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0)
 		return -EINVAL;
 
+	/* wait for all jobs to finish before switching to instance 0 */
+	fence = amdgpu_ctx_get_fence(p->ctx, job->base.entity, ~0ull);
+	if (fence) {
+		dma_fence_wait(fence, false);
+		dma_fence_put(fence);
+	}
+
 	scheds = p->adev->gpu_sched[AMDGPU_HW_IP_VCN_DEC]
 		[AMDGPU_RING_PRIO_DEFAULT].sched;
 	drm_sched_entity_modify_sched(job->base.entity, scheds, 1);
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1737,15 +1737,19 @@ static int vcn_v4_0_limit_sched(struct a
 				struct amdgpu_job *job)
 {
 	struct drm_gpu_scheduler **scheds;
-
-	/* The create msg must be in the first IB submitted */
-	if (atomic_read(&job->base.entity->fence_seq))
-		return -EINVAL;
+	struct dma_fence *fence;
 
 	/* if VCN0 is harvested, we can't support AV1 */
 	if (p->adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0)
 		return -EINVAL;
 
+	/* wait for all jobs to finish before switching to instance 0 */
+	fence = amdgpu_ctx_get_fence(p->ctx, job->base.entity, ~0ull);
+	if (fence) {
+		dma_fence_wait(fence, false);
+		dma_fence_put(fence);
+	}
+
 	scheds = p->adev->gpu_sched[AMDGPU_HW_IP_VCN_ENC]
 		[AMDGPU_RING_PRIO_0].sched;
 	drm_sched_entity_modify_sched(job->base.entity, scheds, 1);


