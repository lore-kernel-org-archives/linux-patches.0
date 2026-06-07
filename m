Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DDA4204E;
	Sun,  7 Jun 2026 10:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829697; cv=none; b=pwGd3I1t7JvFH9AS8LkvYlzlxzWCSZcPQSXqxI04JKfEbgwAhN5+qMyoJNZZpWqh9ExMpgBYaGA2ite7azGjy+HuWvX40VGNB5CEo8cMH50Nk8HgoNfOCpcugP75t4gDse6EmvoEHVuYnvUIJZin37Ej/DrG8sZ/2tSikSErz/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829697; c=relaxed/simple;
	bh=SsU8QYoaSYylEmrSYNuU1xobibhAAQcPs6l7eB6Xu5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU7ejsxCuy2b6AE3nacYWFfQCNhv2Uho5XU11GgyGqaEKLt/8RnIF/K16ubAnIs6ikL5/tXmFZNEQOv4g9lbh62zN3/Q4Hd49wCItWYADnVXgR1vmoHbblB5n9KLYJdSZZal/BXGAfyYT9cdPNL2p5AK3KIwz2l4COtdwN8SBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWrZUH/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWrZUH/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F471F00893;
	Sun,  7 Jun 2026 10:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829696;
	bh=0diksRj4cWQ7i+dUikheq3XA/OaIPJL71J8JQ57oOWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWrZUH/1O8nXVooRzriBtLaOJ/twChSDsRb8dDiPysJSh/EL7tVEn3ei8otf/9hft
	 cCxplbM2STGb+Z4D2ByZpW6/bFevg8JWJV1jB5n3x/fIuxtgskNvcfl+F1KzRPyx3H
	 kVYn4Eo8kLVEfpZmsgvJzG7SCUbiYV/VFchzCe9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 306/332] drm/amdgpu: fix calling VM invalidation in amdgpu_hmm_invalidate_gfx
Date: Sun,  7 Jun 2026 12:01:15 +0200
Message-ID: <20260607095739.315557951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 1c824497d8acd3187d585d6187cedc1897dcc871 upstream.

Otherwise we don't invalidate page tables on next CS.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b6444d1bcbc34f6f2a31a3aab3059be082f3683e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c  |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -78,6 +78,7 @@ static bool amdgpu_hmm_invalidate_gfx(st
 
 	mmu_interval_set_seq(mni, cur_seq);
 
+	amdgpu_vm_bo_invalidate(bo, false);
 	r = dma_resv_wait_timeout(bo->tbo.base.resv, DMA_RESV_USAGE_BOOKKEEP,
 				  false, MAX_SCHEDULE_TIMEOUT);
 	mutex_unlock(&adev->notifier_lock);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1613,6 +1613,7 @@ int amdgpu_vm_handle_moved(struct amdgpu
 {
 	struct amdgpu_bo_va *bo_va;
 	struct dma_resv *resv;
+	struct amdgpu_bo *bo;
 	bool clear, unlock;
 	int r;
 
@@ -1632,11 +1633,13 @@ int amdgpu_vm_handle_moved(struct amdgpu
 	while (!list_empty(&vm->invalidated)) {
 		bo_va = list_first_entry(&vm->invalidated, struct amdgpu_bo_va,
 					 base.vm_status);
-		resv = bo_va->base.bo->tbo.base.resv;
+		bo = bo_va->base.bo;
+		resv = bo->tbo.base.resv;
 		spin_unlock(&vm->status_lock);
 
 		/* Try to reserve the BO to avoid clearing its ptes */
-		if (!adev->debug_vm && dma_resv_trylock(resv)) {
+		if (!adev->debug_vm && !amdgpu_ttm_tt_get_usermm(bo->tbo.ttm) &&
+		    dma_resv_trylock(resv)) {
 			clear = false;
 			unlock = true;
 		/* The caller is already holding the reservation lock */


