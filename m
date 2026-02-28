Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AEB34403F;
	Sat, 28 Feb 2026 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301518; cv=none; b=GMyJdmpDouFMNjTV71mW/3/bATL1VS8aBTjT1Dv7C8yeekmpkNGxJG1b7llqu7s0FgrNsT67C7jc1eACSgRmK7sXRSiiN2MY+1BzU7oCwONOG+y3VRctTnowsyAoRpHAiRZ1wQSS52kGcUpaC64gv0rq4PFjBf2lMA1vVVcY0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301518; c=relaxed/simple;
	bh=UmNODIjRBGYjANutFAHjE91yfU3Hbe5VmmxH/daOofI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+BkL5vhpR9qxGRan6D/NUPd3tnFU9VdaaRQ41M5avTde1V4A+6lrEyl/cz81999n7ClvMXHRs/YxyqR5y2cvTquaGaLCvheFubM51VUyUUOxkE5IrouyHMbsxxs6E98M+czjp/SeD3D8BsGqfTU3p4mbj5d/y7+wTCW3e0R/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ui66hbsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ui66hbsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55775C116D0;
	Sat, 28 Feb 2026 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301518;
	bh=UmNODIjRBGYjANutFAHjE91yfU3Hbe5VmmxH/daOofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ui66hbsHMzAG7PK20q3p0uKSABqjzR5OPe+3ImucINGWI259itpCsiiMIr/BoS6K9
	 xXFnRsA74BhFQHYDIq4RDExzPieMPDOfbJf3dvklT4fp4nPL9+6Zw69b2vr/AEtjGd
	 r2a2+4dru0EmrayMp/2MZrhSOxKf3LWgaFuuSSw/Wq0TuaNMuflAO2Qt2/YnAAETsk
	 GCpCeF85kuVvxB2nqDSyRzpRvzq9h4SkwiQZNUxatAU/r+du+IXJkZiDiVjOh2uPfG
	 BBDrzdfyF8U9rIPffxUqXj8UAgbW2fqMdjxJZotmH8OW3fLPjJDVHN7ObCMrMO1XnL
	 yormckCZNNXRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	stable@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 704/752] drm/amdgpu: fix sync handling in amdgpu_dma_buf_move_notify
Date: Sat, 28 Feb 2026 12:46:55 -0500
Message-ID: <20260228174750.1542406-704-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit b18fc0ab837381c1a6ef28386602cd888f2d9edf ]

Invalidating a dmabuf will impact other users of the shared BO.
In the scenario where process A moves the BO, it needs to inform
process B about the move and process B will need to update its
page table.

The commit fixes a synchronisation bug caused by the use of the
ticket: it made amdgpu_vm_handle_moved behave as if updating
the page table immediately was correct but in this case it's not.

An example is the following scenario, with 2 GPUs and glxgears
running on GPU0 and Xorg running on GPU1, on a system where P2P
PCI isn't supported:

glxgears:
  export linear buffer from GPU0 and import using GPU1
  submit frame rendering to GPU0
  submit tiled->linear blit
Xorg:
  copy of linear buffer

The sequence of jobs would be:
  drm_sched_job_run                       # GPU0, frame rendering
  drm_sched_job_queue                     # GPU0, blit
  drm_sched_job_done                      # GPU0, frame rendering
  drm_sched_job_run                       # GPU0, blit
  move linear buffer for GPU1 access      #
  amdgpu_dma_buf_move_notify -> update pt # GPU0

It this point the blit job on GPU0 is still running and would
likely produce a page fault.

Cc: stable@vger.kernel.org
Fixes: a448cb003edc ("drm/amdgpu: implement amdgpu_gem_prime_move_notify v2")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index ed3bef1edfe44..f20d4bc58904d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -489,8 +489,15 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 		r = dma_resv_reserve_fences(resv, 2);
 		if (!r)
 			r = amdgpu_vm_clear_freed(adev, vm, NULL);
+
+		/* Don't pass 'ticket' to amdgpu_vm_handle_moved: we want the clear=true
+		 * path to be used otherwise we might update the PT of another process
+		 * while it's using the BO.
+		 * With clear=true, amdgpu_vm_bo_update will sync to command submission
+		 * from the same VM.
+		 */
 		if (!r)
-			r = amdgpu_vm_handle_moved(adev, vm, ticket);
+			r = amdgpu_vm_handle_moved(adev, vm, NULL);
 
 		if (r && r != -EBUSY)
 			DRM_ERROR("Failed to invalidate VM page tables (%d))\n",
-- 
2.51.0

