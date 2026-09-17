Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42C502579;
	Thu, 17 Sep 2026 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666303; cv=none; b=WNrECDv0PNssLgmvuJBE4WnRkNBeJOG9gAi9Czb84JujWxU0tj2Vf910jimn60o4bWtwRMzdGn+dEfUe5ieZpq56/g931lKVA08ebjkKIvxIy5BjtfXsM8XyAU8yO+uo3SgofLi3FZuTVNmlCf3aAvJSRdS38iLPWAFZXnEXzsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666303; c=relaxed/simple;
	bh=Ht1+W+9E+gUmYjotrxdQ2NU8NVAyQvFPgRfWlVqBV84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNe4jRUYsrTc5s/5yvc3OPZnZfjODX/h5JGtOnpbvjsyqAo9FyijBGujUPtO/TLg2Trp3OXHRsePjayjgBLgOmXxcvHIr+v0JuORgeT6vdVw408a3TY4vn2r1/cQ/oNAMx3TmkzcewpbwVR54EJBN9sR5dG6tAI3jslUaiutgaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk23FucP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk23FucP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB071F000FF;
	Thu, 17 Sep 2026 17:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666302;
	bh=bkMKiU/Jd27KdqQNCZvGe/xQ9Y9h9c66nvu4++f60VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uk23FucPkIdX5jvFOilaFwReePwl/jb8phEP8GfnvgulzV7DXdcKDUmvo5NkriHot
	 LMO/bEtrnsLazVpKVBdjfrs7aYjrGbeMC7Yz3pEqcSdyX4D9ODGGvI8x1apvcumgHu
	 XgAs5BBeFnAFoSLVkCtFi3YkBOGePqX6fmQLhmTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magdalena Schulfer <magdalena.schulfer@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.18 0993/1250] accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr
Date: Thu, 17 Sep 2026 16:13:08 +0100
Message-ID: <20260917151618.945989851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Magdalena Schulfer <magdalena.schulfer@intel.com>

commit 3837c3f29fbc3b8c12bebf5c62741e2befe3482a upstream.

Add a size parameter to ivpu_to_cpu_addr() and validate that the
whole [vpu_addr, vpu_addr + size) range stays within the BO.

Cc: stable@vger.kernel.org
Fixes: 647371a6609d ("accel/ivpu: Add GEM buffer object management")
Signed-off-by: Magdalena Schulfer <magdalena.schulfer@intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260901125749.404338-2-dawid.osuchowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_gem.h |   14 +++++++++++---
 drivers/accel/ivpu/ivpu_ipc.c |    7 ++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/accel/ivpu/ivpu_gem.h
+++ b/drivers/accel/ivpu/ivpu_gem.h
@@ -74,15 +74,23 @@ static inline bool ivpu_bo_is_snooped(st
 	return ivpu_bo_cache_mode(bo) == DRM_IVPU_BO_CACHED;
 }
 
-static inline void *ivpu_to_cpu_addr(struct ivpu_bo *bo, u32 vpu_addr)
+static inline void *ivpu_to_cpu_addr(struct ivpu_bo *bo, u64 vpu_addr, u64 size)
 {
+	u64 bo_size = ivpu_bo_size(bo);
+	u64 offset;
+
 	if (vpu_addr < bo->vpu_addr)
 		return NULL;
 
-	if (vpu_addr >= (bo->vpu_addr + ivpu_bo_size(bo)))
+	if (size > bo_size)
+		return NULL;
+
+	offset = vpu_addr - bo->vpu_addr;
+
+	if (offset > bo_size - size)
 		return NULL;
 
-	return ivpu_bo_vaddr(bo) + (vpu_addr - bo->vpu_addr);
+	return ivpu_bo_vaddr(bo) + offset;
 }
 
 static inline u32 cpu_to_vpu_addr(struct ivpu_bo *bo, void *cpu_addr)
--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -79,7 +79,7 @@ ivpu_ipc_tx_prepare(struct ivpu_device *
 		return -ENOMEM;
 	}
 
-	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr);
+	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 	if (drm_WARN_ON(&vdev->drm, !tx_buf)) {
 		gen_pool_free(ipc->mm_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 		return -EIO;
@@ -416,7 +416,7 @@ void ivpu_ipc_irq_handler(struct ivpu_de
 			return;
 		}
 
-		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr);
+		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr, sizeof(*ipc_hdr));
 		if (!ipc_hdr) {
 			ivpu_warn_ratelimited(vdev, "IPC msg 0x%x out of range\n", vpu_addr);
 			continue;
@@ -425,7 +425,8 @@ void ivpu_ipc_irq_handler(struct ivpu_de
 
 		jsm_msg = NULL;
 		if (ipc_hdr->channel != IVPU_IPC_CHAN_BOOT_MSG) {
-			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr);
+			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr,
+						   sizeof(*jsm_msg));
 			if (!jsm_msg) {
 				ivpu_warn_ratelimited(vdev, "JSM msg 0x%x out of range\n",
 						      ipc_hdr->data_addr);


