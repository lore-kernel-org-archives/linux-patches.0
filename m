Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1DB24CEEA;
	Sat, 12 Sep 2026 14:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222132; cv=none; b=XsZQGCMlDkFEXY6v446/lxCRUmfnhmPNR/FJHzk6FNjXMGFP5i7GISsnb6WguK94PjCWaDVczsQKndbzXtqm5durBG3KV+oI5V+H157NuN+OyyPYrxNGbzA7q42/hlJwk5aO/3ZY8j0h6EzJYvi0JjfYJi+iGjjcfQBN6UiL9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222132; c=relaxed/simple;
	bh=iwCtzyC2T2WpUWPZu30eabNbozJjk3ohA5t5BdYnYeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooxKatQggXwatRlaVOuG/Ca1WjPvIptjwzQwwdF6ynyvbEdAoiYbZJMOxuNwQBmdZnDX0T1h8qLKrsUjGTulCHgF4xjya1xkF4DsV21IzcZBr3S9PYvgp92BIR0xowRuyqXXY0hneiOkB8oclxVc0sIBU+AAOKwk60byIKoPpj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTYl9Zxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTYl9Zxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BEF1F000FF;
	Sat, 12 Sep 2026 14:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222131;
	bh=9vpT/K/ASStq22WEqJA7L8jc6lyWiWRSh1GPJ/+Sj2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTYl9ZxnmtV+IsWd9BUfKcovw+NCrSUUQUF3NDgGnWxQMgfFZuU4islIqUowDpz26
	 IcJ3dpczUyKc6ee/5X9uu4wjdE/5scbYE9jNgNGzTORjM3Wn87SQlsx0G281AwOJhG
	 5fWL5zjIZpbaJPUYFRU9F3iKzegKEM8tKnl0e/38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0524/1424] drm/amdkfd: Reject zero-sized AQL queue allocations after size halving
Date: Sat, 12 Sep 2026 08:49:16 +0200
Message-ID: <20260912065619.028121139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1719,6 +1719,12 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_
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
@@ -1795,6 +1801,7 @@ err_bo_create:
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
 err_reserve_limit:
 	amdgpu_sync_free(&(*mem)->sync);
+err_alignment_size:
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1183,7 +1183,8 @@ static int kfd_ioctl_alloc_memory_of_gpu
 
 		if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM)
 			size >>= 1;
-		atomic64_add(PAGE_ALIGN(size), &pdd->vram_usage);
+		size = PAGE_ALIGN(size);
+		atomic64_add(size, &pdd->vram_usage);
 	}
 
 	mutex_unlock(&p->mutex);


