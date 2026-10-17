Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37DF3ABDB3;
	Sat, 17 Oct 2026 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255159; cv=none; b=L+jsc3iMqov1LmJubjTVZ4BqQySHOuccNK7//oouICf6pKynl7TL5sJEzssVPRtT51IP6y0UiRE4NJWGKsccE0rDoVgdJILpzKLcfUYJqzmYf+TKcHUcDODYz38n8CShk5W0AL2IzEJkPS6KvmdBG/u7TXgLXnV/Ta99bpTLWrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255159; c=relaxed/simple;
	bh=m1il9uZLgqKILyCTLkaJHxcf3yMlUFHH+m4q6Lhgtes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NYOUrWg9ncC0pnYoXx3gBTD38PjFjJNZ6H/OSJ5ojo6aMj0kO1kxYsx1QYCa6taxX81kxsNzvb+ZUOaZeeBR+d5e6mIWxP5R2Y0zUJZ9FntCtPdHPOepPMlApCmO/A4t4vNRfPIZQNSDZBelQ/eWO20b7raDya/CaBujuO+5Akk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMLL+huM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMLL+huM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D6B1F000C4;
	Sat, 17 Oct 2026 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255158;
	bh=mHDNpd/GgUM1yjw318qVjEnolqG3y+Rn0vcKWhRQCWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMLL+huMJUrp12Zow0nP+4EtVyLQckLhqVvWeXrWYVATJZ4a4TgOaJdoNkbGuuGDg
	 ix4MZhz4tRgYmsWXkv34LvdkWVw+tZ+dnJ15g8EWUFZ0skE/jMXt/MWHWPTKyFMf9g
	 Zgs6s3Fm2MBLnrBJTUHqBI5wUEatA2j0PN1ORS8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 683/869] drm/panthor: Add vm_bind region with kbo range overlap check
Date: Sat, 17 Oct 2026 17:58:44 +0200
Message-ID: <20261017160054.490595279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9b6afc9c1da13..3cad487c1b727 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -311,6 +311,9 @@ struct panthor_vm {
 		u64 end;
 	} kernel_auto_va;
 
+	/** @user_va_range: Upper boundary of VAs VM users can map objects against. */
+	u64 user_va_range;
+
 	/** @as: Address space related fields. */
 	struct {
 		/**
@@ -2323,6 +2326,8 @@ panthor_vm_create(struct panthor_device *ptdev, bool for_mcu,
 		va_range = full_va_range;
 	}
 
+	vm->user_va_range = kernel_va_start;
+
 	mutex_init(&vm->mm_lock);
 	drm_mm_init(&vm->mm, kernel_va_start, kernel_va_size);
 	vm->kernel_auto_va.start = auto_kernel_va_start;
@@ -2412,6 +2417,10 @@ panthor_vm_bind_prepare_op_ctx(struct drm_file *file,
 	if (!IS_ALIGNED(op->va | op->size | op->bo_offset, vm_pgsz))
 		return -EINVAL;
 
+	/* We don't allow mappings that overlap with kbo's reserved range */
+	if (range_overflows(op->va, op->size, vm->user_va_range))
+		return -EINVAL;
+
 	switch (op->flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) {
 	case DRM_PANTHOR_VM_BIND_OP_TYPE_MAP:
 		gem = drm_gem_object_lookup(file, op->bo_handle);
-- 
2.53.0



