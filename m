Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E2D46444;
	Tue, 10 Sep 2024 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964379; cv=none; b=MCWYwGy4khGlufk6/KDid1oLGfReagL0TwFzyPRgYJLdt8ltjoDD3vQ9VYec8ww4r5FSGjYMO6tE9LFt6v7ysGCJ075gRExPpVc3PujNBc3yzzv13tXWmxHtVJQg/FIbvShH0GDpB6Jrwoz7ypJfXw6qTHGjsEFvpNZF0qs3LJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964379; c=relaxed/simple;
	bh=+IWDEtNMz4KeJNUhQq+trDrStaz5ByKIEvqpoBVC6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BC3tdlBtGbEbv6rYtbEOQsbz/KqGOTY6czRhlckPTl6jVoX5YP8lPguN6wX9PatW3NRlNztl19BVR/BUSZa45MhEMe9YG1U3gMYo4peeMv9xibzM80lSRMQOp0U1ZgP3DG9Ekd9Yjsaisn4sJX2XCO6DvzIco4ObOfpsZ2BCioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDpn9H8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDpn9H8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDF7C4CEC3;
	Tue, 10 Sep 2024 10:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964379;
	bh=+IWDEtNMz4KeJNUhQq+trDrStaz5ByKIEvqpoBVC6So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDpn9H8pDBZ4MaDcHCA/zfiZRJM15oLoiP5mwqBOrTO6/AIIdhScD6j/aXIpUeGGg
	 m8jz31NSQnvJe/HVzPpBTMT2N57iPdT0MZPK+h/0hBmRnHt85gPx/6wbEDtPTPwjJ2
	 DrdJqu8BwtCsM0c0J1XFVRramcfZ0l9bqw5tXI/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/269] drm/amdgpu: reject gang submit on reserved VMIDs
Date: Tue, 10 Sep 2024 11:32:30 +0200
Message-ID: <20240910092613.974457197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 320debca1ba3a81c87247eac84eff976ead09ee0 ]

A gang submit won't work if the VMID is reserved and we can't flush out
VM changes from multiple engines at the same time.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c  | 15 +++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 15 ++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 61668a784315..e361dc37a089 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1096,6 +1096,21 @@ static int amdgpu_cs_vm_handling(struct amdgpu_cs_parser *p)
 	unsigned int i;
 	int r;
 
+	/*
+	 * We can't use gang submit on with reserved VMIDs when the VM changes
+	 * can't be invalidated by more than one engine at the same time.
+	 */
+	if (p->gang_size > 1 && !p->adev->vm_manager.concurrent_flush) {
+		for (i = 0; i < p->gang_size; ++i) {
+			struct drm_sched_entity *entity = p->entities[i];
+			struct drm_gpu_scheduler *sched = entity->rq->sched;
+			struct amdgpu_ring *ring = to_amdgpu_ring(sched);
+
+			if (amdgpu_vmid_uses_reserved(vm, ring->vm_hub))
+				return -EINVAL;
+		}
+	}
+
 	r = amdgpu_vm_clear_freed(adev, vm, NULL);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index ff1ea99292fb..69dfc699d78b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -409,7 +409,7 @@ int amdgpu_vmid_grab(struct amdgpu_vm *vm, struct amdgpu_ring *ring,
 	if (r || !idle)
 		goto error;
 
-	if (vm->reserved_vmid[vmhub] || (enforce_isolation && (vmhub == AMDGPU_GFXHUB(0)))) {
+	if (amdgpu_vmid_uses_reserved(vm, vmhub)) {
 		r = amdgpu_vmid_grab_reserved(vm, ring, job, &id, fence);
 		if (r || !id)
 			goto error;
@@ -459,6 +459,19 @@ int amdgpu_vmid_grab(struct amdgpu_vm *vm, struct amdgpu_ring *ring,
 	return r;
 }
 
+/*
+ * amdgpu_vmid_uses_reserved - check if a VM will use a reserved VMID
+ * @vm: the VM to check
+ * @vmhub: the VMHUB which will be used
+ *
+ * Returns: True if the VM will use a reserved VMID.
+ */
+bool amdgpu_vmid_uses_reserved(struct amdgpu_vm *vm, unsigned int vmhub)
+{
+	return vm->reserved_vmid[vmhub] ||
+		(enforce_isolation && (vmhub == AMDGPU_GFXHUB(0)));
+}
+
 int amdgpu_vmid_alloc_reserved(struct amdgpu_device *adev,
 			       unsigned vmhub)
 {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
index fa8c42c83d5d..240fa6751260 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
@@ -78,6 +78,7 @@ void amdgpu_pasid_free_delayed(struct dma_resv *resv,
 
 bool amdgpu_vmid_had_gpu_reset(struct amdgpu_device *adev,
 			       struct amdgpu_vmid *id);
+bool amdgpu_vmid_uses_reserved(struct amdgpu_vm *vm, unsigned int vmhub);
 int amdgpu_vmid_alloc_reserved(struct amdgpu_device *adev,
 				unsigned vmhub);
 void amdgpu_vmid_free_reserved(struct amdgpu_device *adev,
-- 
2.43.0



