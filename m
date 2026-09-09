Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B8D57D209;
	Wed,  9 Sep 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964490; cv=none; b=cQsZlj5ileZy9srGUKxVCi2SObKVVsBT1j+qe5vBgMmIEQH3nhhQUyzsphE0fn21JEQ1n4CifhBjmY6Y7Yl7yJRge0d7C8TSuZpZU3koT7JD/K4PEMHQGc4W3Z1qGUs4OiAMXlvpTMUaEJ7CVJnVle6WIpPzuAKLrTlTblctq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964490; c=relaxed/simple;
	bh=OVu3+YkVYtLMY88VnBEKnavxuS3yt9rg/rR+SabBnYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx9rw3ZSncm37gCW8A3gPEeJSaQNfkFqxkXHxMlLLiNkUx54w6k9vtTxowU3J50Mh7a6xK360PZ0DEh61UYGOk8U2WZx+58aSE1MquR+lp3ROoipPPn6xeydIJ1HHZS7RQWex67tEdS4ZdxXStHsLSXCS4f9H5xArYRfk+fqtyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r9Q/Xqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r9Q/Xqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A79F1F00A3A;
	Wed,  9 Sep 2026 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964488;
	bh=JYBp0Y0rG5V8FFr7pk3QGN5IZD9O2IiRArW0u65P3Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0r9Q/Xqv0SeAda8ZYYkDyPQnm6Oy49wbwDKfgLFISPgdDlSqooFpooUIg6Yc7YEUP
	 qCkonVknX8g8Y/OHLS5az3jDom/b17kiqw/0xSIaKNRE9+oTr8dNU3TZ7sT06Meazv
	 1QFuQwKfU26GjCA9q5zyUIdeh0XrX33g/I+D5NDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 392/583] drm/amdgpu: clamp the isolation index for rings outside a partition
Date: Wed,  9 Sep 2026 15:41:17 +0200
Message-ID: <20260909134251.569409507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7556,8 +7556,8 @@ struct dma_fence *amdgpu_device_enforce_
 						  struct amdgpu_ring *ring,
 						  struct amdgpu_job *job)
 {
-	struct amdgpu_isolation *isolation = &adev->isolation[ring->xcp_id];
 	struct drm_sched_fence *f = job->base.s_fence;
+	struct amdgpu_isolation *isolation;
 	struct dma_fence *dep;
 	void *owner;
 	int r;
@@ -7570,6 +7570,9 @@ struct dma_fence *amdgpu_device_enforce_
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
@@ -768,7 +768,9 @@ int amdgpu_vm_flush(struct amdgpu_ring *
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


