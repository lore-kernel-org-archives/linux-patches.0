Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C6E585992;
	Wed,  9 Sep 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964379; cv=none; b=rCALvrVUu6LAzqbTFrCLJTsyIE3wHJt3wDKZKFtLZSKZeUP5NjICGPSFQVRtOxya0T9Jy68AlTIoit8JC/uP8z36iSenhu9nFtuVlLZtgpmz0komif33QuANLBLY5Lnv08Ub3AtesKvK1CDSmb/n3GS/qrzlK+PO6sTs9tQygwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964379; c=relaxed/simple;
	bh=Gn65+KW98vSrtZUTFOfH5ESTnlhMgVQ6TDEg7ywM6vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieAfhZ/EsSgmCGWhsJUPtRim7esvxW0WSYssDvGuFMGbZdE/3ucXgkeEAoD6vFFazHbg3/F+kWx1+d4E0xTR6F0ze5OebsCKDz/h11LqViJy8DzdQGpCD2HuFEJcT3k8YcMPz5biRldVpXhfOKo1djvkK10DxjUMtkQac4J5cYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/UNw7/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/UNw7/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916091F00A3A;
	Wed,  9 Sep 2026 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964378;
	bh=5QDS8Ol71WyqJZ3yhSDrqxa/Iizx9cGoXNS7G2u7GmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/UNw7/CckDlRMhUoDI6v5/YGqHE30f16JcslEr3rIzeljFcdC0nTTqmoEffTQbEw
	 1HKOtwg5H2VncHXUhzy/i+FwHALZ1YErOWdJw1Jm7w3mz/A678pbBX1nlrdEAjT0Ap
	 STuzkchJ8p7TShUq4hh+JggF9X0RFx/+XpeD/QOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 403/583] drm/amdkfd: Reject zero-sized AQL queue allocations after size halving
Date: Wed,  9 Sep 2026 15:41:28 +0200
Message-ID: <20260909134251.962835038@linuxfoundation.org>
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

From: Sunday Clement <Sunday.Clement@amd.com>

commit 40ba09e11188d1b7f79d51fc28aca5ea45e0c138 upstream.

KFD_IOC_ALLOC_MEMORY_OF_GPU with flag
KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM and size=1 triggers the AQL
wraparound workaround (size >>= 1), reducing size to 0. The resulting
zero passes through PAGE_ALIGN(0) = 0 without validation, bypassing the
per-process VRAM quota check in reserve_mem_limit()
(vram_used + 0 > vram_available is always false).

The fix adds post-halving zero-size validation in the primary
allocation path (amdgpu_amdkfd_gpuvm.c). The check happens after size
halving but before reserve_mem_limit(), and uses err_alignment_size
error path to properly clean up the allocated kgd_mem structure and
mutex.

Cc: stable@vger.kernel.org
Signed-off-by: Sunday Clement <Sunday.Clement@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    7 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         |    3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1777,6 +1777,12 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_
 		size >>= 1;
 	aligned_size = PAGE_ALIGN(size);
 
+	/* reject AQL queue with size < 2 */
+	if (!aligned_size) {
+		ret = -EINVAL;
+		goto err_alignment_size;
+	}
+
 	(*mem)->alloc_flags = flags;
 
 	amdgpu_sync_create(&(*mem)->sync);
@@ -1868,6 +1874,7 @@ err_bo_create:
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
 err_reserve_limit:
 	amdgpu_sync_free(&(*mem)->sync);
+err_alignment_size:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1162,7 +1162,8 @@ static int kfd_ioctl_alloc_memory_of_gpu
 
 		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
 			size >>= 1;
-		atomic64_add(PAGE_ALIGN(size), &pdd->vram_usage);
+		size = PAGE_ALIGN(size);
+		atomic64_add(size, &pdd->vram_usage);
 	}
 
 	mutex_unlock(&p->mutex);


