Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE0A56B850;
	Wed,  9 Sep 2026 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963179; cv=none; b=TirmhEKaUthYkTwdziSl2o4mku5Is5Gyu2SQEMRDs+zO2rHZ+WCeG/dweyyQSn0kCc90NlnntBghtYnsrK56NLxAs3OIRffzTaqoMntwH38NBXJTJ+Sr+dtDANzwX0QZ/AJh/51B1EY9k5Q9uPnmNWqTgxNJW8ORxjTEQGA7i3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963179; c=relaxed/simple;
	bh=9UQ27gDBGwO80/PtfeiJrLSlDJTXAgY1PRWtLpE93nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbB4Kb4LqKmpJ1ZyRKuD2BwHn08+phAdPBuSwxwpTxy41M+MntTitNimyDNZE43KvF4uZTtSPTDUZYkou4Up33AReVxStdMojLjvtXjCJzSKtvJNQkMyxfKJVq38o1UXOvalUTwuFmdbYddL36mEJHBQYDDuUCu3gR361pdGv/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOMuJxRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOMuJxRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45CB1F00A3A;
	Wed,  9 Sep 2026 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963178;
	bh=Ymv1smFveDhOi+NYoTNh5eTCi7D0oFdRqiQxijwWyW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOMuJxREgfH0TKR2rEQlngHNg7pdP7IqC3UlKUphYfRhuZ8vO17xyc0RpxPrepu+r
	 UbV2kyx54duz5HnuLgnFpryDb0VcL4mLGaJTkHgmiRtmxi6rl/kOO/a62fUntYd3NZ
	 1blw1qnmzvoJ7lnBzC85TGTMz2Z2Th2omggtDaOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 519/556] drm/amdkfd: Reject zero-sized AQL queue allocations after size halving
Date: Wed,  9 Sep 2026 15:43:19 +0200
Message-ID: <20260909134248.685287075@linuxfoundation.org>
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
@@ -1795,6 +1795,12 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_
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
@@ -1886,6 +1892,7 @@ err_bo_create:
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
 err_reserve_limit:
 	amdgpu_sync_free(&(*mem)->sync);
+err_alignment_size:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1200,7 +1200,8 @@ static int kfd_ioctl_alloc_memory_of_gpu
 
 		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
 			size >>= 1;
-		atomic64_add(PAGE_ALIGN(size), &pdd->vram_usage);
+		size = PAGE_ALIGN(size);
+		atomic64_add(size, &pdd->vram_usage);
 	}
 
 	mutex_unlock(&p->mutex);


