Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260C0369D4E;
	Wed, 20 May 2026 16:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295265; cv=none; b=III0iUnqBAMy4F/sO2NIz/DYtQaE9tcDTEH4u6fqyHQ1WwGqfkzXouDNtJDDyv6BQQdfQ+zgs1FkuPiM9s47lUWvUCUHfbUSX1Y+eQAsiIEBfxVMNX3VEuV+pbtnUVm9cefkwO+sFhi/brUzQqDkhSpK0L8vz3xNnW6k07EqfwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295265; c=relaxed/simple;
	bh=QA7awYhLaLcR0u6LXAkDHHxYn93onZdE5l+R6NMR2/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGaSi6o0exZf5oAviiF2hLJbAH2xEGva79XHqIP3gZHMu73XNNqj55xGjzZ6Se7hKXSnM/urXJ/wmC+HHIexYrOiCB+/U2WHOWcPTFmlp5XzsGXK+9c0BqTfSXLcZNelBDX61cXyfT2SA7btrbteOQjax3aQoSwpWVwWvJhr8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDw8G4sK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDw8G4sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828131F00893;
	Wed, 20 May 2026 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295264;
	bh=+AjcQdD3YvFVjsWs9her8BzKeClTRhpxbdlJBTKSHCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDw8G4sKrnOQCwRJ9RVAcP68MAcA0UxiuHrJ6f+uUU3yINQrWoKK3AudQSZTJDP0H
	 hWO7CG/rap3PMaQdkY1RqfbFYJ7V776FfIXDtj68ohYjbk9ExHIvh5WPyWuX4PoUvg
	 euZNkoY7oY94r3YiWBi3E7qDjxyt3/+oAbhESxW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victoria Brekenfeld <victoria@system76.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0354/1146] drm/msm: Fix VM_BIND UNMAP locking
Date: Wed, 20 May 2026 18:10:04 +0200
Message-ID: <20260520162156.211442662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 85042c2cd970a6b0e686329387096fe19989ae62 ]

Wrong argument meant that the objs involved in UNMAP ops were not always
getting locked.

Since _NO_SHARE objs share a common resv with the VM (which is always
locked) this would only show up with non-_NO_SHARE BOs.

Reported-by: Victoria Brekenfeld <victoria@system76.com>
Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/94
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/713898/
Message-ID: <20260324220519.1221471-2-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index 1c2f486302bcd..9e3632019bc92 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -1245,7 +1245,7 @@ vm_bind_job_lock_objects(struct msm_vm_bind_job *job, struct drm_exec *exec)
 			case MSM_VM_BIND_OP_UNMAP:
 				ret = drm_gpuvm_sm_unmap_exec_lock(job->vm, exec,
 							      op->iova,
-							      op->obj_offset);
+							      op->range);
 				break;
 			case MSM_VM_BIND_OP_MAP:
 			case MSM_VM_BIND_OP_MAP_NULL: {
-- 
2.53.0



