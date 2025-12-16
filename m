Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D2B3451BF;
	Tue, 16 Dec 2025 11:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886272; cv=none; b=HtCDJwdYUxXVSc+isRXMoKOY1D2Mawut8n8jsNBt4WlsfmfnB5lCiBVG4YhkDhRCojtC3eTGJR4hFnv3zR7TaWvx1SQxdm9dP+esRVaw86YJsjsn2q4YonA/cSflFzwfe3RRLhytRMMJbn+yBSAyIpe1esN0QZMatv0CaAOpBY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886272; c=relaxed/simple;
	bh=EyRCKv2NApV1PQLD6KgCY4F4cZu0xbRRWn1g6uBc1KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYcL87YBt1niL3FFvGw30zW809zhMrDQcLrlsLFKXZzeX39MwVE9U/uuHAyHdMOuSUxnu5ZH6iBhAHcOFGH/NT5Rn/xz4LeqcAuLHpkGBtRmX00bsk8KS87J9CedREkHdUmReWOYvCZWyiodtJqgtr5+Q2gwmv3W3/+3t6dW7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEBnaRy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEBnaRy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE14DC4CEF1;
	Tue, 16 Dec 2025 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886272;
	bh=EyRCKv2NApV1PQLD6KgCY4F4cZu0xbRRWn1g6uBc1KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEBnaRy8iZZ9yjhs5aigBn1QkCxrWXaQscgKULUxvKEPs0iP1iZ8ptLehex5ScIwH
	 ICTWd+g4J3uglu3NzMppxCtc5ix3h1LReuofKjDQnU5EIW+smfLHATOMGc/q8+w4Qa
	 nOu8pvNG/Md+Xt7U/I1+lPKbrdvqY3+3MZCsJMtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 355/507] drm/panthor: Avoid adding of kernel BOs to extobj list
Date: Tue, 16 Dec 2025 12:13:16 +0100
Message-ID: <20251216111358.318068712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit ce04ec03a9c2c4f3e60e26f21311b25d5a478208 ]

The kernel BOs unnecessarily got added to the external objects list
of drm_gpuvm, when mapping to GPU, which would have resulted in few
extra CPU cycles being spent at the time of job submission as
drm_exec_until_all_locked() loop iterates over all external objects.

Kernel BOs are private to a VM and so they share the dma_resv object of
the dummy GEM object created for a VM. Use of DRM_EXEC_IGNORE_DUPLICATES
flag ensured the recursive locking of the dummy GEM object was ignored.
Also no extra space got allocated to add fences to the dma_resv object
of dummy GEM object. So no other impact apart from few extra CPU cycles.

This commit sets the pointer to dma_resv object of GEM object of
kernel BOs before they are mapped to GPU, to prevent them from
being added to external objects list.

v2: Add R-bs and fixes tags

Fixes: 8a1cc07578bf ("drm/panthor: Add GEM logical block")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251120172118.2741724-1-akash.goel@arm.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 6830a89a7c10b..aca09bc449fc1 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -145,6 +145,9 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 	bo = to_panthor_bo(&obj->base);
 	kbo->obj = &obj->base;
 	bo->flags = bo_flags;
+	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
+	drm_gem_object_get(bo->exclusive_vm_root_gem);
+	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 
 	if (vm == panthor_fw_vm(ptdev))
 		debug_flags |= PANTHOR_DEBUGFS_GEM_USAGE_FLAG_FW_MAPPED;
@@ -168,9 +171,6 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 		goto err_free_va;
 
 	kbo->vm = panthor_vm_get(vm);
-	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
-	drm_gem_object_get(bo->exclusive_vm_root_gem);
-	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 	return kbo;
 
 err_free_va:
-- 
2.51.0



