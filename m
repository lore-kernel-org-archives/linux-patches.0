Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049651A4F12;
	Wed, 20 Nov 2024 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107499; cv=none; b=tnWFGCn/DK1h0LnliH8vXKdHdUAq04mRqL03GkLiPftHf+mNFgzdweqDGMixxydEs9NQGWbrLPwOrCiSEoldiK958QBBc6miZKD1e0kn9jLMpz9d88zr4eP6g+KtCE1vD/qbQKUX2mefpie92m+TgLkvoK/lnFV09Jy9L5J/yo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107499; c=relaxed/simple;
	bh=aBJHE97SdiSWXqQ8Kgq3UKew4vtHnXzriNvoG6w8/4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBTaK4BroiP898PyQCKdHUDqJi+oa3cmZ6Fs8GZxOfJJzlDNZFbeRP17eIYcNJMEYoFDYuOhkr2aFXSSUAihSzDhNArJclw8dOa36OKJhYU6ZFJBm4k2EhqEpk30tPgMaKHhy6TWj6jOSMF2rM+lzEPb+JKiBdcRU6kmpQedcdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbBJ0Xqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbBJ0Xqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5EBC4CECD;
	Wed, 20 Nov 2024 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107498;
	bh=aBJHE97SdiSWXqQ8Kgq3UKew4vtHnXzriNvoG6w8/4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbBJ0Xqk5tQ4mHMR19d+Ugf+uFDNyMKlrIeF6rJLUNCWAbzTcljqFwOj2iAKGsdpq
	 lDTbGDNecTaF3pfwQekwzSdcHuLgCuQNE74nXsDKMzWFps+CZ0NLgMjev/4tq2kv2C
	 w/MYvKTAd9UViD3dUfRYELST0lFFGNUMx7VB9PPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 022/107] drm/panthor: Fix handling of partial GPU mapping of BOs
Date: Wed, 20 Nov 2024 13:55:57 +0100
Message-ID: <20241120125630.178040469@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit 3387e043918e154ca08d83954966a8b087fe2835 ]

This commit fixes the bug in the handling of partial mapping of the
buffer objects to the GPU, which caused kernel warnings.

Panthor didn't correctly handle the case where the partial mapping
spanned multiple scatterlists and the mapping offset didn't point
to the 1st page of starting scatterlist. The offset variable was
not cleared after reaching the starting scatterlist.

Following warning messages were seen.
WARNING: CPU: 1 PID: 650 at drivers/iommu/io-pgtable-arm.c:659 __arm_lpae_unmap+0x254/0x5a0
<snip>
pc : __arm_lpae_unmap+0x254/0x5a0
lr : __arm_lpae_unmap+0x2cc/0x5a0
<snip>
Call trace:
 __arm_lpae_unmap+0x254/0x5a0
 __arm_lpae_unmap+0x108/0x5a0
 __arm_lpae_unmap+0x108/0x5a0
 __arm_lpae_unmap+0x108/0x5a0
 arm_lpae_unmap_pages+0x80/0xa0
 panthor_vm_unmap_pages+0xac/0x1c8 [panthor]
 panthor_gpuva_sm_step_unmap+0x4c/0xc8 [panthor]
 op_unmap_cb.isra.23.constprop.30+0x54/0x80
 __drm_gpuvm_sm_unmap+0x184/0x1c8
 drm_gpuvm_sm_unmap+0x40/0x60
 panthor_vm_exec_op+0xa8/0x120 [panthor]
 panthor_vm_bind_exec_sync_op+0xc4/0xe8 [panthor]
 panthor_ioctl_vm_bind+0x10c/0x170 [panthor]
 drm_ioctl_kernel+0xbc/0x138
 drm_ioctl+0x210/0x4b0
 __arm64_sys_ioctl+0xb0/0xf8
 invoke_syscall+0x4c/0x110
 el0_svc_common.constprop.1+0x98/0xf8
 do_el0_svc+0x24/0x38
 el0_svc+0x34/0xc8
 el0t_64_sync_handler+0xa0/0xc8
 el0t_64_sync+0x174/0x178
<snip>
panthor : [drm] drm_WARN_ON(unmapped_sz != pgsize * pgcount)
WARNING: CPU: 1 PID: 650 at drivers/gpu/drm/panthor/panthor_mmu.c:922 panthor_vm_unmap_pages+0x124/0x1c8 [panthor]
<snip>
pc : panthor_vm_unmap_pages+0x124/0x1c8 [panthor]
lr : panthor_vm_unmap_pages+0x124/0x1c8 [panthor]
<snip>
panthor : [drm] *ERROR* failed to unmap range ffffa388f000-ffffa3890000 (requested range ffffa388c000-ffffa3890000)

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241111134720.780403-1-akash.goel@arm.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index d18f32640a79f..64378e8f124bd 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -990,6 +990,8 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova, int prot,
 
 		if (!size)
 			break;
+
+		offset = 0;
 	}
 
 	return panthor_vm_flush_range(vm, start_iova, iova - start_iova);
-- 
2.43.0



