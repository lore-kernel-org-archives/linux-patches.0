Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D0354706B;
	Thu, 17 Sep 2026 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670962; cv=none; b=JqjhK4BFbD+h7hmKnuJD9M0fZRq9+lG5y8SAZi9bx2MxkTkCEudjKhke2vYsSU26fAc0xdIv7W3sxYxtAe1dbRt1SDBkWRZij8cF7HnPU8wMGrV7GOkkl0euhoOgU3bCgofk1l/azG33Ad/JDWlSAPmaf7xwJBqE6QtyoFNfFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670962; c=relaxed/simple;
	bh=Vo6i+dTZ/8GAHN/RT4bCs6RQ0fHeMYRJ4/vfrQC3hZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpWuJrEdQEf3HHFlAEmg1TiW7hzNRrRcGzPa1LUTDsmPRTnemKsXFIBzEDPQaMz1kkcGX057tGE0PsUFLP3q6u+LN7/bjMJKxFSs2u2HJalqN4ZCoHjyBnsGxgKzRY6T6eGkx26vT0q486/Y7wlj7GrEFAve7hi5Co8TSKFAQAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKsLTXfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKsLTXfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7846A1F000FF;
	Thu, 17 Sep 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670961;
	bh=IM6S50k2bolyOna7+RvrXz7l0RGGogQTUXJV80ZI2Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKsLTXfCBHTHt7cjGqpd8pPz6vk1LIL94hkMfEHTIgwHfu1O1jzq10WamijF6ECBw
	 tEF/tpTDTm2fmt0ccEhSHCMSFOUW8ebJf93Lyfmuji695AMADwFCzl+iQGwmaBCFOO
	 gi3scigdpAD/8cV7aHH0j/NYllwoJKxMjF/cCjuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magdalena Schulfer <magdalena.schulfer@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 0825/1102] accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr
Date: Thu, 17 Sep 2026 16:12:48 +0100
Message-ID: <20260917151601.218958108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -73,15 +73,23 @@ static inline bool ivpu_bo_is_snooped(st
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
@@ -78,7 +78,7 @@ ivpu_ipc_tx_prepare(struct ivpu_device *
 		return -ENOMEM;
 	}
 
-	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr);
+	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 	if (drm_WARN_ON(&vdev->drm, !tx_buf)) {
 		gen_pool_free(ipc->mm_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 		return -EIO;
@@ -414,7 +414,7 @@ void ivpu_ipc_irq_handler(struct ivpu_de
 			return;
 		}
 
-		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr);
+		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr, sizeof(*ipc_hdr));
 		if (!ipc_hdr) {
 			ivpu_warn_ratelimited(vdev, "IPC msg 0x%x out of range\n", vpu_addr);
 			continue;
@@ -423,7 +423,8 @@ void ivpu_ipc_irq_handler(struct ivpu_de
 
 		jsm_msg = NULL;
 		if (ipc_hdr->channel != IVPU_IPC_CHAN_BOOT_MSG) {
-			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr);
+			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr,
+						   sizeof(*jsm_msg));
 			if (!jsm_msg) {
 				ivpu_warn_ratelimited(vdev, "JSM msg 0x%x out of range\n",
 						      ipc_hdr->data_addr);


