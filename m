Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29E914430D;
	Thu, 13 Jun 2024 12:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280615; cv=none; b=uDZkDqLvvCRCdF/3v/W3H3QcXzWspm0gIgflW7uI7mgN8S370klPn/Eq9xWJQjNG7X8F4njltI6iQQczGQxGB1MZ0hgQWItN/sb7wamOWfQqNO9uxV0cmBbFIOgDpni92jVw5QKF+yds7ak4m0rsi32VXBHTpqGA0iuiqwjGoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280615; c=relaxed/simple;
	bh=JdZG1Aq3rRrzQntd9+sN5G01rLGBijv2aqbbb8StzcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ctt3zW4IC8IlJP5hX7tZwQEKjQ8Gclxciud+0CrP73lmdxkG9K61vDCTrn0BzYG4Y3Vp3iDY+bNguQA3pv1UzC+q3g23z9eG6OiE7T+QHOYhGQLeseqccKkWyHuvnsfK88HBtt6vLvP7OGJIcVejtz3yuEHkMb9xEZEjZvwueLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9yZbI2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9yZbI2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7EFC2BBFC;
	Thu, 13 Jun 2024 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280614;
	bh=JdZG1Aq3rRrzQntd9+sN5G01rLGBijv2aqbbb8StzcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9yZbI2cIdqA2q8NhRhdb3/IjP04tFpVcmn0M7Xh78SBhD9XFntDvBvDg/h31fErb
	 3kQGXE2WkjbDRZVA8GKQ16oPTHWSrwnQAaVLT8uvT1jqdBqK+nrN6WnWXoYTvGr5pw
	 rXB1eTit193R5lOKbPTvTqVfj6dMLl+6hg7tonWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <Lang.Yu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>
Subject: [PATCH 6.6 106/137] drm/amdkfd: handle duplicate BOs in reserve_bo_and_cond_vms
Date: Thu, 13 Jun 2024 13:34:46 +0200
Message-ID: <20240613113227.409054997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Lang Yu <Lang.Yu@amd.com>

commit 2a705f3e49d20b59cd9e5cc3061b2d92ebe1e5f0 upstream.

Observed on gfx8 ASIC where KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM is used.
Two attachments use the same VM, root PD would be locked twice.

[   57.910418] Call Trace:
[   57.793726]  ? reserve_bo_and_cond_vms+0x111/0x1c0 [amdgpu]
[   57.793820]  amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu+0x6c/0x1c0 [amdgpu]
[   57.793923]  ? idr_get_next_ul+0xbe/0x100
[   57.793933]  kfd_process_device_free_bos+0x7e/0xf0 [amdgpu]
[   57.794041]  kfd_process_wq_release+0x2ae/0x3c0 [amdgpu]
[   57.794141]  ? process_scheduled_works+0x29c/0x580
[   57.794147]  process_scheduled_works+0x303/0x580
[   57.794157]  ? __pfx_worker_thread+0x10/0x10
[   57.794160]  worker_thread+0x1a2/0x370
[   57.794165]  ? __pfx_worker_thread+0x10/0x10
[   57.794167]  kthread+0x11b/0x150
[   57.794172]  ? __pfx_kthread+0x10/0x10
[   57.794177]  ret_from_fork+0x3d/0x60
[   57.794181]  ? __pfx_kthread+0x10/0x10
[   57.794184]  ret_from_fork_asm+0x1b/0x30

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.6.x only
Signed-off-by: Tomáš Trnka <trnka@scm.com>
[TT: trivially adjusted for 6.6 which does not have commit 05d249352f
     (third argument to drm_exec_init removed)]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1135,7 +1135,8 @@ static int reserve_bo_and_cond_vms(struc
 	int ret;
 
 	ctx->sync = &mem->sync;
-	drm_exec_init(&ctx->exec, DRM_EXEC_INTERRUPTIBLE_WAIT);
+	drm_exec_init(&ctx->exec, DRM_EXEC_INTERRUPTIBLE_WAIT |
+		      DRM_EXEC_IGNORE_DUPLICATES);
 	drm_exec_until_all_locked(&ctx->exec) {
 		ctx->n_vms = 0;
 		list_for_each_entry(entry, &mem->attachments, list) {


