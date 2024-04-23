Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026A11487C4;
	Tue, 23 Apr 2024 21:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908752; cv=none; b=grjzgutKf/38rnLkN6Jvudrxxh7yrNjcxMgBVYjFXFcDdLQaHTLEOy4WsxVR9Hro7AIUMQgrUvL/SyH8ns66myIjRZ8W4PVvoJGEQD233oweDLv5HsFy6aZBFyIx9kxqV1d6XJykHW9lLKmKsGNbKKZu2Lyc1sbVvmH5knl4854=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908752; c=relaxed/simple;
	bh=RVOzppF3a+KRNHoxvOwnfOyztYlBJ/JMY6IfM10FKYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfuSEnfPmYgTeIDLjobmPAaV5OIT3PRW+tgAQlMdTbT4OQraNCoLt9JabTBuqCmN9JnaBY/uCOtt+NveZNL2bdUg1LjyYRhN/ztrvbjM7pFoCgH5XI3IqmmVBkZjHdAE4HZHIlQcsTrLXOyAMiZgAz7VfHOWVdYI38FSipEa3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4EGjMmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4EGjMmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD020C32783;
	Tue, 23 Apr 2024 21:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908751;
	bh=RVOzppF3a+KRNHoxvOwnfOyztYlBJ/JMY6IfM10FKYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4EGjMmcbvxO2nUOAoBE288n5ki394zVIqVZWF05ttn+PZ/Zo7Sl8mjeetFwoBQzB
	 0b2vwQ/xaBnAJJ7TcbGiy3tGaIST6T0GrvVR6aBhKYAeLfU/YjJL7ehTxZixaq7yoe
	 hQ9TFaOSgbZYKHi5+T52vTWeTFiwOQezThOkPrnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Stolyarov <hexed@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	xinhui pan <xinhui.pan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 127/141] drm/amdgpu: validate the parameters of bo mapping operations more clearly
Date: Tue, 23 Apr 2024 14:39:55 -0700
Message-ID: <20240423213857.330463061@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xinhui pan <xinhui.pan@amd.com>

commit 6fef2d4c00b5b8561ad68dd2b68173f5c6af1e75 upstream.

Verify the parameters of
amdgpu_vm_bo_(map/replace_map/clearing_mappings) in one common place.

Fixes: dc54d3d1744d ("drm/amdgpu: implement AMDGPU_VA_OP_CLEAR v2")
Cc: stable@vger.kernel.org
Reported-by: Vlad Stolyarov <hexed@google.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   72 +++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 26 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1400,6 +1400,37 @@ static void amdgpu_vm_bo_insert_map(stru
 	trace_amdgpu_vm_bo_map(bo_va, mapping);
 }
 
+/* Validate operation parameters to prevent potential abuse */
+static int amdgpu_vm_verify_parameters(struct amdgpu_device *adev,
+					  struct amdgpu_bo *bo,
+					  uint64_t saddr,
+					  uint64_t offset,
+					  uint64_t size)
+{
+	uint64_t tmp, lpfn;
+
+	if (saddr & AMDGPU_GPU_PAGE_MASK
+	    || offset & AMDGPU_GPU_PAGE_MASK
+	    || size & AMDGPU_GPU_PAGE_MASK)
+		return -EINVAL;
+
+	if (check_add_overflow(saddr, size, &tmp)
+	    || check_add_overflow(offset, size, &tmp)
+	    || size == 0 /* which also leads to end < begin */)
+		return -EINVAL;
+
+	/* make sure object fit at this offset */
+	if (bo && offset + size > amdgpu_bo_size(bo))
+		return -EINVAL;
+
+	/* Ensure last pfn not exceed max_pfn */
+	lpfn = (saddr + size - 1) >> AMDGPU_GPU_PAGE_SHIFT;
+	if (lpfn >= adev->vm_manager.max_pfn)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * amdgpu_vm_bo_map - map bo inside a vm
  *
@@ -1426,21 +1457,14 @@ int amdgpu_vm_bo_map(struct amdgpu_devic
 	struct amdgpu_bo *bo = bo_va->base.bo;
 	struct amdgpu_vm *vm = bo_va->base.vm;
 	uint64_t eaddr;
+	int r;
 
-	/* validate the parameters */
-	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK || size & ~PAGE_MASK)
-		return -EINVAL;
-	if (saddr + size <= saddr || offset + size <= offset)
-		return -EINVAL;
-
-	/* make sure object fit at this offset */
-	eaddr = saddr + size - 1;
-	if ((bo && offset + size > amdgpu_bo_size(bo)) ||
-	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
-		return -EINVAL;
+	r = amdgpu_vm_verify_parameters(adev, bo, saddr, offset, size);
+	if (r)
+		return r;
 
 	saddr /= AMDGPU_GPU_PAGE_SIZE;
-	eaddr /= AMDGPU_GPU_PAGE_SIZE;
+	eaddr = saddr + (size - 1) / AMDGPU_GPU_PAGE_SIZE;
 
 	tmp = amdgpu_vm_it_iter_first(&vm->va, saddr, eaddr);
 	if (tmp) {
@@ -1493,17 +1517,9 @@ int amdgpu_vm_bo_replace_map(struct amdg
 	uint64_t eaddr;
 	int r;
 
-	/* validate the parameters */
-	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK || size & ~PAGE_MASK)
-		return -EINVAL;
-	if (saddr + size <= saddr || offset + size <= offset)
-		return -EINVAL;
-
-	/* make sure object fit at this offset */
-	eaddr = saddr + size - 1;
-	if ((bo && offset + size > amdgpu_bo_size(bo)) ||
-	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
-		return -EINVAL;
+	r = amdgpu_vm_verify_parameters(adev, bo, saddr, offset, size);
+	if (r)
+		return r;
 
 	/* Allocate all the needed memory */
 	mapping = kmalloc(sizeof(*mapping), GFP_KERNEL);
@@ -1517,7 +1533,7 @@ int amdgpu_vm_bo_replace_map(struct amdg
 	}
 
 	saddr /= AMDGPU_GPU_PAGE_SIZE;
-	eaddr /= AMDGPU_GPU_PAGE_SIZE;
+	eaddr = saddr + (size - 1) / AMDGPU_GPU_PAGE_SIZE;
 
 	mapping->start = saddr;
 	mapping->last = eaddr;
@@ -1604,10 +1620,14 @@ int amdgpu_vm_bo_clear_mappings(struct a
 	struct amdgpu_bo_va_mapping *before, *after, *tmp, *next;
 	LIST_HEAD(removed);
 	uint64_t eaddr;
+	int r;
+
+	r = amdgpu_vm_verify_parameters(adev, NULL, saddr, 0, size);
+	if (r)
+		return r;
 
-	eaddr = saddr + size - 1;
 	saddr /= AMDGPU_GPU_PAGE_SIZE;
-	eaddr /= AMDGPU_GPU_PAGE_SIZE;
+	eaddr = saddr + (size - 1) / AMDGPU_GPU_PAGE_SIZE;
 
 	/* Allocate all the needed memory */
 	before = kzalloc(sizeof(*before), GFP_KERNEL);


