Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25364F391B;
	Thu, 17 Sep 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666975; cv=none; b=pcdlxEE6GVEZUDtSReJjrrOMse3DyFJgOPlkQG/wDJmlklB53TeMtmRxmX4uAC0ZKPOzAC8Nqw5XCeNaU6cKVB/GhsvjYmlhkd/YCsuMrryWQ+ppfS4EU6QeHuQcdU4UbUFkTyClK79QRrWKvjqQZx2ZRqEU8JjeAfLqbJRsVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666975; c=relaxed/simple;
	bh=3dWt/A7nOJk7UiAsLmsJHXifmFbFBwn4Fw1RIsH9e40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlBJcefjDjYw8BuLP+rIhL6Pnxhvgk+tefFC0SsGFRLYNW4QPAUnJW63v0pTc7e5frqTe1xSexMkYnDIy9qAkG3VDLZC0niryCvUMtQtUH0IqoZGK7ZtS24wjUCs7kJ7yE7bLdnt1kfowQMf1x21sJJRGbOuIQIXv89yK3NsExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf/9M1c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf/9M1c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924821F000FF;
	Thu, 17 Sep 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666973;
	bh=upsS7T8yw+o41zfwYP2tPC42xyMMT45scJdWdxOUbdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf/9M1c+JUaSfmASuGKe/2g825vYHyQd5zx4CDbm0hWVY8OiLIDpNW2ZtaD4vJRg+
	 LJC2wxu6LL7TdIgi76tD8O1pB+vhSTSMGHYpDfJaTXU+pe7jn93fyQkJhV/JGIOKJL
	 5jAICiymj41rNfMZTLMQG1N0JFNvajdUkI9ZvBLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1184/1250] drm/amdgpu: Make amdgpu_vm_flush() non-failing in submission path
Date: Thu, 17 Sep 2026 16:16:19 +0100
Message-ID: <20260917151624.375245787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 37872d06f85f0349e7b1f0680aea77326f7c135e ]

amdgpu_vm_flush() is used during job submission and is not expected to
fail. Convert it to return void and simplify the caller.

Initialize the COND_EXEC patch location to 0 so it is safe to call
amdgpu_ring_patch_cond_exec() when init_cond_exec is not supported.

Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6760f5cb12d2 ("drm/amdgpu: avoid force-completing uninitialized UVD rings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    9 ++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   10 +++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -208,13 +208,8 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 		dma_fence_put(tmp);
 	}
 
-	if (job) {
-		r = amdgpu_vm_flush(ring, job, need_pipe_sync);
-		if (r) {
-			amdgpu_ring_undo(ring);
-			goto free_fence;
-		}
-	}
+	if (job)
+		amdgpu_vm_flush(ring, job, need_pipe_sync);
 
 	amdgpu_ring_ib_begin(ring);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -760,12 +760,9 @@ bool amdgpu_vm_need_pipeline_sync(struct
  * @need_pipe_sync: is pipe sync needed
  *
  * Emit a VM flush when it is necessary.
- *
- * Returns:
- * 0 on success, errno otherwise.
  */
-int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
-		    bool need_pipe_sync)
+void amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job,
+		     bool need_pipe_sync)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_isolation *isolation =
@@ -811,7 +808,7 @@ int amdgpu_vm_flush(struct amdgpu_ring *
 
 	if (!vm_flush_needed && !gds_switch_needed && !need_pipe_sync &&
 	    !cleaner_shader_needed)
-		return 0;
+		return;
 
 	amdgpu_ring_ib_begin(ring);
 
@@ -902,7 +899,6 @@ int amdgpu_vm_flush(struct amdgpu_ring *
 	}
 
 	amdgpu_ring_ib_end(ring);
-	return 0;
 }
 
 /**
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -516,7 +516,7 @@ int amdgpu_vm_validate(struct amdgpu_dev
 		       struct ww_acquire_ctx *ticket,
 		       int (*callback)(void *p, struct amdgpu_bo *bo),
 		       void *param);
-int amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_pipe_sync);
+void amdgpu_vm_flush(struct amdgpu_ring *ring, struct amdgpu_job *job, bool need_pipe_sync);
 int amdgpu_vm_update_pdes(struct amdgpu_device *adev,
 			  struct amdgpu_vm *vm, bool immediate);
 int amdgpu_vm_clear_freed(struct amdgpu_device *adev,


