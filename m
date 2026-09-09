Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE057D214;
	Wed,  9 Sep 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963053; cv=none; b=f9jm1QckzGW62RQ0Talg4VQHUVPg11ActmVON+DMvZnm6WMmur7dH2SqfxHtIePLjBNvKIOCoOVRAIolNx4SrF9vnciI7NVDrKUbkucTk+1OAmC4Xt3DY3utpbZcnn0czSJ4F5WZ6gk1mF8+d6TzX19psuEwIjcvyaZm2v/43gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963053; c=relaxed/simple;
	bh=gfRh4ZZrvMhdJFO1qzyanKIVfrb3wv3oxwrHDrFNBwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA1KzgnH1BJFPsZ5QBU6feY3rOIx3qjkLVagzTZZn2JETXZNkfVfBh418YenNGrb+xUCvE0lYGJ/K79BYKvBKolWSdwS89xzafWvs98BOIeCHIEBww+rtzvOjbK5i82D/A5BWmdh7jY2eejfjK9QjAZeoyRu0GxmdU1NBza3G34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJVG9VVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJVG9VVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE9A1F00A3A;
	Wed,  9 Sep 2026 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963052;
	bh=rDlJ3/OOPDQTJtvG3LMGVsVoQ5sttePi4YBhLVbZAHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJVG9VVJKIltc9xK9EwiSHEIo5NLtS7+CJGUaSucXKDHcQjllZwF5uTSXZk+E7lbm
	 BJSrNgc27iVuESVElkS1Oo2wo4wNwMxkn/VaqX1Nu7X6oNqAAbs5lYOSa1PCct6EG3
	 N6t66F0jkO8qthNwMHd92h/lVUO3H7eyv6eTobTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 503/556] drm/amdgpu: clamp the isolation index for rings outside a partition
Date: Wed,  9 Sep 2026 15:43:03 +0200
Message-ID: <20260909134248.163403795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

commit b30900566642ceb2c9e12b56c2afec28d0fd91a0 upstream.

adev->isolation[] has one slot per partition, but a ring that is not
assigned to one keeps AMDGPU_XCP_NO_PARTITION, which is ~0, so indexing
the array with it is out of bounds. SDMA submissions hit this on both
the isolation enforcement and the VM flush path and trip UBSAN.

Fall back to the first slot the way the cleaner shader path already
does, and stop taking the address before the ring type check that makes
it relevant.

Cc: stable@vger.kernel.org
Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    5 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c     |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6834,8 +6834,8 @@ struct dma_fence *amdgpu_device_enforce_
 						  struct amdgpu_ring *ring,
 						  struct amdgpu_job *job)
 {
-	struct amdgpu_isolation *isolation = &adev->isolation[ring->xcp_id];
 	struct drm_sched_fence *f = job->base.s_fence;
+	struct amdgpu_isolation *isolation;
 	struct dma_fence *dep;
 	void *owner;
 	int r;
@@ -6848,6 +6848,9 @@ struct dma_fence *amdgpu_device_enforce_
 	    ring->funcs->type != AMDGPU_RING_TYPE_COMPUTE)
 		return NULL;
 
+	isolation = &adev->isolation[ring->xcp_id == AMDGPU_XCP_NO_PARTITION ?
+				     0 : ring->xcp_id];
+
 	/*
 	 * All submissions where enforce isolation is false are handled as if
 	 * they come from a single client. Use ~0l as the owner to distinct it
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -773,7 +773,9 @@ void amdgpu_vm_flush(struct amdgpu_ring
 		     bool need_pipe_sync)
 {
 	struct amdgpu_device *adev = ring->adev;
-	struct amdgpu_isolation *isolation = &adev->isolation[ring->xcp_id];
+	struct amdgpu_isolation *isolation =
+		&adev->isolation[ring->xcp_id == AMDGPU_XCP_NO_PARTITION ?
+				 0 : ring->xcp_id];
 	unsigned vmhub = ring->vm_hub;
 	struct amdgpu_vmid_mgr *id_mgr = &adev->vm_manager.id_mgr[vmhub];
 	struct amdgpu_vmid *id = &id_mgr->ids[job->vmid];


