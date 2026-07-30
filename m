Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86EB43E081;
	Thu, 30 Jul 2026 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422636; cv=none; b=nHJH1BjfdCnAwP/urSS5Okw5oR6ZMAht9qxgoBL57qLP22NLu4byW8z592UGdmHTuOvAvif0wjpOgcAWMN8sXlXmHuXkPC5KH/PJc0oVT+kuOGR5EUYjV6bjqiB2lowgtf49y79IhW9Ynxwq844cSgBCCN0DDHVQb/jk6P4cYZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422636; c=relaxed/simple;
	bh=wjvVY3+vsyGb3/jTbj/leUz89U/y6X8A5ca40a1Izbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NULvDEt42L2ya61HdhMKetpNofPB4Lr+lB0bdzdcRaA6xkT3jFcaeiaaXk4RcT95urIWJgUXJCM1FS2ynFSQCdYOb26ot4Z7h7AlIobQ5DqrAAp8L0ZxW3OYADsjsvUL6Lq8KtC5fVO2cR1mLq23F0iifUbDV13PqM8GL5vIYEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ivpmw8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ivpmw8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0050E1F00A3F;
	Thu, 30 Jul 2026 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422635;
	bh=6k/BQPazGAKF5boLjInTXBNh/z6CIYNtTJkMkMsSeHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ivpmw8QMMxcnsusUWrZhy7dVgvc2O0pn/MOwS7u5eKDJEV85/rLn46sd0h7cK0O3
	 9aS4xnfUh/tvDMpq2YEXPDNF5t4zNzg5ssrCtU/2xTNdhYVt2YNa2NLWmsIeeo+5hp
	 XAZHXcgYXKSY+gp+VTc9BPkZR2AI0G2+OLl9SGv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	timur.kristof@gmail.com,
	christian.koenig@amd.com,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 462/744] drm/amdgpu: always emit the job vm fence
Date: Thu, 30 Jul 2026 16:12:15 +0200
Message-ID: <20260730141454.116998405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b2ff0595c31cce4303957dd0058e14c89eb70152 upstream.

We need the fence to reemit the gds switch or spm update
after a queue reset.

Fixes: a17ef941212b ("drm/amdgpu: rework ring reset backup and reemit v9")
Cc: timur.kristof@gmail.com
Cc: christian.koenig@amd.com
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bc639a9eadc75822f7f15a4315c198a4b5513bd2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -865,12 +865,10 @@ void amdgpu_vm_flush(struct amdgpu_ring
 					    job->oa_size);
 	}
 
-	if (vm_flush_needed || pasid_mapping_needed || cleaner_shader_needed) {
-		amdgpu_fence_emit(ring, job->hw_vm_fence, 0);
-		fence = &job->hw_vm_fence->base;
-		/* get a ref for the job */
-		dma_fence_get(fence);
-	}
+	amdgpu_fence_emit(ring, job->hw_vm_fence, 0);
+	fence = &job->hw_vm_fence->base;
+	/* get a ref for the job */
+	dma_fence_get(fence);
 
 	if (vm_flush_needed) {
 		mutex_lock(&id_mgr->lock);


