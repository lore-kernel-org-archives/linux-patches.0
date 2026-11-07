Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065487;
	b=bpj3aoWkN65iRTw8CUrOj/u7WPAsFJrlUxlDu4sQVA9fT6PPr/oe7+MxJV6DWCeSdHA9
	 O9GtReWlisb6n5FlgESBxD82hTzlfB66qNmHK2hpSQxZLJk1gQdaLas+xgwzeCZqxWJfV
	 EKSn9zY+EvFmHjgxPQh+lpkQ2pj/VjwWYUameLFudt8K3etWtOBGwNbAI2qTtKrJkVKpF
	 ZgVXXWxo0eHJsKkGSBCnvl7coj3qHy4w/KtK4yuD3CREY9rcsCjilv+rFrXzUF4n2IOac
	 X2DAICPjKQjWU3LP5lwIJoBFOqpWu13eOkyF404XYklgPV0YcmBU2dxE/1nViDwzTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vHAzIAnaxk/Mf61bxlxHa1BqlW9iFuwRZLXa2HucWug=;
	b=fdC8kZMNYyAiUIlz7WkKaheOT6Vk5isQBAJpCpEtEZxnFXr5dWySb2FpUh8tizv2uK4P
	 cCFZdPHagXGQr1flprlI4cd6G8Xy34PkeOcd4oU8wRFRBvFA253OQ0JTzhg0ymmVJbQ2h
	 YD4Dys86VvCzWUHPB+icRi+h+iHn+Qsexe5NLIJML+sP5Ah7Wa4rOXDmHY/X/xybF/A99
	 50qHDIYN0LcazymfVNg55E07NdrkXKi3ou73cHRw/O5CuFCbRqzzh3HB2UOzOu1gMLly5
	 vv2WVM0BvQKWHW3ccsx1zCR2YSADgEd55EjMX1di1IMjQZNtd5Mcft4p83F18we0HLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRz2ktqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF1606A338;
	Sat,  7 Nov 2026 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRz2ktqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEA71F0089F;
	Sat,  7 Nov 2026 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065486;
	bh=vHAzIAnaxk/Mf61bxlxHa1BqlW9iFuwRZLXa2HucWug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRz2ktqqYgaD2KfdvS0Y/lYxaxbd/UcwwEoy1mgAEZJOxQb7BpEwZajU1J21lFGCw
	 XIn3gBBt5Y+mHMMvzKZrIX+m17LnqZnU8JxOo+Jch90LVzaqWbKnFbUCZfGovTi3Al
	 GS+Rr+oAVH1hcfjpr7OjMe6ZqcxcYdKyX4+hpL3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1179/1257] drm/amdgpu: guard VCE/UVD sched entity teardown on failed probe
Date: Sat,  7 Nov 2026 08:57:55 -0500
Message-ID: <20261107135011.736159161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

[ Upstream commit c3fed6272bb4771a849c33c781af99afa90e90ad ]

Since commit 037b98a2312e ("drm/amdgpu: move UVD and VCE sched entity
init after sched init"), drm_sched_entity_init() for the VCE and UVD
kernel entities runs in the scheduler-init phase, well after the
IP-block sw_init phase has allocated the vcpu_bos.

If probe fails between the two phases, amdgpu_device_fini_sw() still
runs the per-IP sw_fini callbacks for blocks that did complete
sw_init. Both amdgpu_vce_sw_fini() and amdgpu_uvd_sw_fini() then call
drm_sched_entity_destroy() on an entity that was never initialized:
entity->rq is NULL and drm_sched_entity_flush() dereferences it,
oopsing in whatever context drove the failed probe.

The hole was latent-but-safe until commit 2df5efb45425 ("drm/sched:
Remove redundant entity->rq initialization and checks") removed the
if (!entity->rq) early return that commit 1decbf6bb0b4 ("drm/sched:
Fix entities with 0 rqs.") had put in drm_sched_entity_flush(), on the
grounds that entity->rq can never be NULL. That holds only for
entities that completed drm_sched_entity_init() — not for the
never-initialized entity this teardown path reaches.

Observed on real hardware: MI50 (Vega20, VCE 4.0 / UVD 7.2) behind a
Thunderbolt link — a pciehp presence/link-change event re-probes the
device; when the re-probe fails (-EINVAL here), the cleanup path
NULL-derefs inside drm_sched_entity_flush() in the pciehp IRQ thread
and takes the whole machine down (panic_on_oops, EFI pstore capture).
Reproduced twice on 7.3-rc5, 2026-10-06 and 2026-10-09, identical
signature; the faulting instruction is `mov (%rax),%r15` on rax =
entity->rq == NULL, i.e. `sched = entity->rq->sched`:

  BUG: kernel NULL pointer dereference
  RIP: drm_sched_entity_flush+0x34/0x2d0 [gpu_sched]
  drm_sched_entity_destroy
  amdgpu_vce_sw_fini
  vce_v4_0_sw_fini
  amdgpu_device_fini_sw
  ...
  pciehp_configure_device
  pciehp_handle_presence_or_link_change

Guard the entity teardown on entity->rq, which is set only by
drm_sched_entity_init(). amdgpu_ring_fini() already self-guards via
the rings[] registration, and the vcpu_bo/firmware cleanup still runs
as before.

v2: retarget Fixes: at commit 2df5efb45425 ("drm/sched: Remove
redundant entity->rq initialization and checks") — the !entity->rq
check from commit 1decbf6bb0b4 ("drm/sched: Fix entities with 0
rqs.") that Alex pointed to was removed by it in the 7.3 window,
so this is a regression there, not a pre-existing hole.

Fixes: 2df5efb45425 ("drm/sched: Remove redundant entity->rq initialization and checks")
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3ad55d18f468fa81be725301d1e138ecd5148e6a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c | 3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
index ecd7caa95d4b2..cd35ff7ca8642 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -377,7 +377,8 @@ int amdgpu_uvd_sw_fini(struct amdgpu_device *adev)
 	void *addr = amdgpu_bo_kptr(adev->uvd.ib_bo);
 	int i, j;
 
-	drm_sched_entity_destroy(&adev->uvd.entity);
+	if (adev->uvd.entity.rq)
+		drm_sched_entity_destroy(&adev->uvd.entity);
 
 	for (j = 0; j < adev->uvd.num_uvd_inst; ++j) {
 		if (adev->uvd.harvest_config & (1 << j))
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
index 1f7a98cdce5a2..3952af9ae115a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -253,7 +253,8 @@ int amdgpu_vce_sw_fini(struct amdgpu_device *adev)
 	if (adev->vce.vcpu_bo == NULL)
 		return 0;
 
-	drm_sched_entity_destroy(&adev->vce.entity);
+	if (adev->vce.entity.rq)
+		drm_sched_entity_destroy(&adev->vce.entity);
 
 	for (i = 0; i < adev->vce.num_rings; i++)
 		amdgpu_ring_fini(&adev->vce.ring[i]);
-- 
2.53.0



