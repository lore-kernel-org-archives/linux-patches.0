Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30D3BB11C;
	Fri, 15 May 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862129; cv=none; b=Wvi11vnB4vSRYI4a6FXoslOGC6GZcgz+yKE4S0F6XYhU+cK2J11+BUSmEmOUEllpN+cqzr0OzlDam9uEoK2iPPYgNtivi8hdvSiVd/XT2JFaYDjyS1hFlaeKJErLbuWmeXmvOc1v8u6H98G4044ufED6O+U5nRekFGGJXdZA6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862129; c=relaxed/simple;
	bh=OL/PTm887cmcnN5m8VFY9FpY55BUYKgp02UktFaQgiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijkWmszD/yOCOyM2P2F7X+8JszpOb5wJn7nIa4qvkw+Kh4xfFJTopKYZFHTGnIb6jZYf8rmrUzHgub5NaDitEzzIg4c5iWMPT48r1P+2YJuZ3iqt9knkw80UJdglCxRQaFhnFLSqrkXoTs7NGckx2TXtHlYdS9oXaXWFfXz1+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SScn/vSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SScn/vSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A94C2BCB0;
	Fri, 15 May 2026 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862129;
	bh=OL/PTm887cmcnN5m8VFY9FpY55BUYKgp02UktFaQgiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SScn/vSdUseNTZIMi2QrdbmGtHjXqtcWBWmw+3+Mu3r6w2u2YBDG3JSHgtTi6EqBz
	 DApT/EkCUpT1a4toORvWDHLWTNzoCKXAKxiapwdoHAigSxl8uez71gbGCXTUKyye3r
	 bRaRTaLiGM98OdISX+a3gKoeD/LV4aaL2Iy0/SA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Mathew Alwin <alwin.mathew@intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jia Yao <jia.yao@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 120/188] drm/xe/uapi: Reject coh_none PAT index for CPU cached memory in madvise
Date: Fri, 15 May 2026 17:48:57 +0200
Message-ID: <20260515154659.933472581@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yao <jia.yao@intel.com>

commit 4e5591c2fc1b30f4ea5e2eab4c3a695acc404e39 upstream.

Add validation in xe_vm_madvise_ioctl() to reject PAT indices with
XE_COH_NONE coherency mode when applied to CPU cached memory.

Using coh_none with CPU cached buffers is a security issue. When the
kernel clears pages before reallocation, the clear operation stays in
CPU cache (dirty). GPU with coh_none can bypass CPU caches and read
stale sensitive data directly from DRAM, potentially leaking data from
previously freed pages of other processes.

This aligns with the existing validation in vm_bind path
(xe_vm_bind_ioctl_validate_bo).

v2(Matthew brost)
- Add fixes
- Move one debug print to better place

v3(Matthew Auld)
- Should be drm/xe/uapi
- More Cc

v4(Shuicheng Lin)
- Fix kmem leak issues by the way

v5
- Remove kmem leak because it has been merged by another patch

v6
- Remove the fix which is not related to current fix

v7
- No change

v8
- Rebase

v9
- Limit the restrictions to iGPU

v10
- No change

Fixes: ada7486c5668 ("drm/xe: Implement madvise ioctl for xe")
Cc: <stable@vger.kernel.org> # v6.18+
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Mathew Alwin <alwin.mathew@intel.com>
Cc: Michal Mrozek <michal.mrozek@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Jia Yao <jia.yao@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Acked-by: Michal Mrozek <michal.mrozek@intel.com>
Acked-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260417055917.2027459-2-jia.yao@intel.com
(cherry picked from commit 016ccdb674b8c899940b3944952c96a6a490d10a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm_madvise.c |   47 +++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -299,6 +299,45 @@ static bool madvise_args_are_sane(struct
 	return true;
 }
 
+static bool check_pat_args_are_sane(struct xe_device *xe,
+				    struct xe_vmas_in_madvise_range *madvise_range,
+				    u16 pat_index)
+{
+	u16 coh_mode = xe_pat_index_get_coh_mode(xe, pat_index);
+	int i;
+
+	/*
+	 * Using coh_none with CPU cached buffers is not allowed on iGPU.
+	 * On iGPU the GPU shares the LLC with the CPU, so with coh_none
+	 * the GPU bypasses CPU caches and reads directly from DRAM,
+	 * potentially seeing stale sensitive data from previously freed
+	 * pages. On dGPU this restriction does not apply, because the
+	 * platform does not provide a non-coherent system memory access
+	 * path that would violate the DMA coherency contract.
+	 */
+	if (coh_mode != XE_COH_NONE || IS_DGFX(xe))
+		return true;
+
+	for (i = 0; i < madvise_range->num_vmas; i++) {
+		struct xe_vma *vma = madvise_range->vmas[i];
+		struct xe_bo *bo = xe_vma_bo(vma);
+
+		if (bo) {
+			/* BO with WB caching + COH_NONE is not allowed */
+			if (XE_IOCTL_DBG(xe, bo->cpu_caching == DRM_XE_GEM_CPU_CACHING_WB))
+				return false;
+			/* Imported dma-buf without caching info, assume cached */
+			if (XE_IOCTL_DBG(xe, !bo->cpu_caching))
+				return false;
+		} else if (XE_IOCTL_DBG(xe, xe_vma_is_cpu_addr_mirror(vma) ||
+					    xe_vma_is_userptr(vma)))
+			/* System memory (userptr/SVM) is always CPU cached */
+			return false;
+	}
+
+	return true;
+}
+
 static bool check_bo_args_are_sane(struct xe_vm *vm, struct xe_vma **vmas,
 				   int num_vmas, u32 atomic_val)
 {
@@ -384,6 +423,14 @@ int xe_vm_madvise_ioctl(struct drm_devic
 	if (err || !madvise_range.num_vmas)
 		goto unlock_vm;
 
+	if (args->type == DRM_XE_MEM_RANGE_ATTR_PAT) {
+		if (!check_pat_args_are_sane(xe, &madvise_range,
+					     args->pat_index.val)) {
+			err = -EINVAL;
+			goto free_vmas;
+		}
+	}
+
 	if (madvise_range.has_bo_vmas) {
 		if (args->type == DRM_XE_MEM_RANGE_ATTR_ATOMIC) {
 			if (!check_bo_args_are_sane(vm, madvise_range.vmas,


