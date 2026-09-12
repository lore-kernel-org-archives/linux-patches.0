Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAB2BDC0E;
	Sat, 12 Sep 2026 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200209; cv=none; b=YaG4NKUkm68VzaEX86i2xjNHfkZQtyZMR73RpCnAix/YHOVG5PpPU+kpxCgTgN6vwhThJav4ChEP60SmNkUNIWemkbAx3DMfSCKoDNUeyWc97dqS+jP95HzMlboC5a+Khyx/cdGZIlnj4DU8EglZDhQGpmGG4uC/ZmgBlLbOoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200209; c=relaxed/simple;
	bh=HX54tk2PDLT5MhbfrVQoQzBx4rFoPwsnt91YfrY2jGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqkTcG2zKsxvpB8baLfdbtMG+GxwIoHUvUBdXwCj0NvKSkvjvnzc2Ovmm+BoHZIVW9P3xyiK8Ek5viuVWCOLN2GiP0vx8N4jayLOcKNR+135jWyzz+ozXRXXBT2f+Eq3BEuGDpG6Cdkc7Fbb0tjz4tgQDZCAm9B8ogxY+j9raUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELN/hSQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELN/hSQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A951F0089A;
	Sat, 12 Sep 2026 08:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200208;
	bh=sZsST5ccR2zESgPkly3qf7FQkCluDfx15QZiNpr/QjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELN/hSQ2OpXQBp3hsTIqQa13x0UL9NhhO+0/15gpV868cydEXWQUBBrioSq7VMm0R
	 1Pp4Rhv1UgFIEyCOv93KT9j/yJIunjtENHiYhjW9FGUu8JduzwDsgcVu+41mdwMaM/
	 imzPQAu4P1WJMR3GSOypuBZ4Mw+omuBgCwZBcPGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0744/1815] drm/panthor: Add vm_bind region with kbo range overlap check
Date: Sat, 12 Sep 2026 08:41:34 +0200
Message-ID: <20260912065706.373149904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 985f5e12f3cdf43030e13c2bbd154913133b5c3f ]

When a VM is created, caller has to specify the range of the address space
carve-out set aside for mapping kernel BO's. That means vm_bind mappings of
UM-exposed BO's should not intersect with that region, but at the moment
we're not checking this.

At first, I thought of giving these values to drm_gpuvm_init() through its
reserve_{offset, range} arguments, but it turns out that is meant for VM
address spans that are not managed through the usual drm_gpuvm split/merge
circuit, so storing the end of the user VA range at VM creation time and
doing a quick check in the vm_bind ioctl path was the simplest workaround.

The new check also makes sure vm_bind range doesn't overflow the size of a
64-bit unsigned integer. That was already being done further down the call
stack inside drm_gpuvm_sm_map -> drm_gpuvm_range_valid, but it's best to
fail early in the driver before GPUVM functions are invoked so that we
won't waste time allocating vm_bind context resources.

Fixes: 12cf826bf1dd ("drm/panthor: Support sparse mappings")
Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260720-vm_bind_checks-v6-1-c2c7dbe93a73@collabora.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 904be1af286f5..fba2fff94ce32 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -318,6 +318,9 @@ struct panthor_vm {
 		u64 end;
 	} kernel_auto_va;
 
+	/** @user_va_range: Upper boundary of VAs VM users can map objects against. */
+	u64 user_va_range;
+
 	/** @as: Address space related fields. */
 	struct {
 		/**
@@ -2901,6 +2904,8 @@ panthor_vm_create(struct panthor_device *ptdev, bool for_mcu,
 		va_range = full_va_range;
 	}
 
+	vm->user_va_range = kernel_va_start;
+
 	mutex_init(&vm->mm_lock);
 	drm_mm_init(&vm->mm, kernel_va_start, kernel_va_size);
 	vm->kernel_auto_va.start = auto_kernel_va_start;
@@ -2989,6 +2994,10 @@ panthor_vm_bind_prepare_op_ctx(struct drm_file *file,
 	if (!IS_ALIGNED(op->va | op->size | op->bo_offset, vm_pgsz))
 		return -EINVAL;
 
+	/* We don't allow mappings that overlap with kbo's reserved range */
+	if (range_overflows(op->va, op->size, vm->user_va_range))
+		return -EINVAL;
+
 	switch (op->flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) {
 	case DRM_PANTHOR_VM_BIND_OP_TYPE_MAP:
 		if (!(op->flags & DRM_PANTHOR_VM_BIND_OP_MAP_SPARSE)) {
-- 
2.53.0



