Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D79F369D4E;
	Wed, 20 May 2026 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295257; cv=none; b=qdu2GL4PzRaNcS2gzu5Yl7+qG6GFiTtYMfd9QNC3EraXw/UsN9iDwJ06MyPiLtYuxB7HWqBplDIKSOoqtM+IHsWk9w+tCA9kM90toA33wvuko9qNCFThk3Mu/209b924iKxrc4ksmaUBQqhlmRpBaN4ppZzj9BQLLL9zzOSGzxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295257; c=relaxed/simple;
	bh=I0A6SWy2RmzsIykz7xZLqoozub/+HdeA6eviqZaCpIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLv2k63VXIcn5qz6PuhqM2F/cWwtKI15naq+IEszVXBq2hrdufHX/FnD9uguB0LYSWTfq6FBo20WgZp7AnSZniuzLxg896lJ+ouC9QUb/CCmogJZCdhVMfoYXuYUb+QdOBemFSD0ozY7rLq4QGuUy+dHhzRxqtSUfmRiOsDqrmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fgbym7MN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fgbym7MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927471F00893;
	Wed, 20 May 2026 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295256;
	bh=4Qe6meEKU/7HhIutPjonvPn1u9s9lPynsVwu2spLXR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fgbym7MNTLV2K3qwKWqsMp+Nmgog1DJgCI2JfJTLtLf9CAi+shVcOw5/t+LvvNy06
	 YKHIfCiBprhW5fVMp9kNv06PYyw+RZBYawdUMTjz1GRbISGnliCKkFgJIvmbqSnT5x
	 y85z31rCqfdI2C2QD5LhCA6EL0xs3BGfs6gEVm8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0351/1146] drm/msm/vma: Avoid lock in VM_BIND fence signaling path
Date: Wed, 20 May 2026 18:10:01 +0200
Message-ID: <20260520162156.143938010@linuxfoundation.org>
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

[ Upstream commit 8a7023b035355ef5bfa096bd323256fa8abbbc6a ]

Use msm_gem_unpin_active(), similar to what is used in the GEM_SUBMIT
path.  This avoids needing to hold the obj lock, and the end result is
the same.  (As with GEM_SUBMIT, we know the fence isn't signaled yet.)

Reported-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Fixes: 2e6a8a1fe2b2 ("drm/msm: Add VM_BIND ioctl")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/712230/
Message-ID: <20260316184442.673558-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c     | 3 +++
 drivers/gpu/drm/msm/msm_gem_vma.c | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index b27abaa13926d..2cb3ab04f1250 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -507,8 +507,11 @@ void msm_gem_unpin_locked(struct drm_gem_object *obj)
  */
 void msm_gem_unpin_active(struct drm_gem_object *obj)
 {
+	struct msm_drm_private *priv = obj->dev->dev_private;
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
+	GEM_WARN_ON(!mutex_is_locked(&priv->lru.lock));
+
 	msm_obj->pin_count--;
 	GEM_WARN_ON(msm_obj->pin_count < 0);
 	update_lru_active(obj);
diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index adf88cf8f41aa..1c2f486302bcd 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -696,6 +696,7 @@ static struct dma_fence *
 msm_vma_job_run(struct drm_sched_job *_job)
 {
 	struct msm_vm_bind_job *job = to_msm_vm_bind_job(_job);
+	struct msm_drm_private *priv = job->vm->drm->dev_private;
 	struct msm_gem_vm *vm = to_msm_vm(job->vm);
 	struct drm_gem_object *obj;
 	int ret = vm->unusable ? -EINVAL : 0;
@@ -738,12 +739,14 @@ msm_vma_job_run(struct drm_sched_job *_job)
 	if (ret)
 		msm_gem_vm_unusable(job->vm);
 
+	mutex_lock(&priv->lru.lock);
+
 	job_foreach_bo (obj, job) {
-		msm_gem_lock(obj);
-		msm_gem_unpin_locked(obj);
-		msm_gem_unlock(obj);
+		msm_gem_unpin_active(obj);
 	}
 
+	mutex_unlock(&priv->lru.lock);
+
 	/* VM_BIND ops are synchronous, so no fence to wait on: */
 	return NULL;
 }
-- 
2.53.0



