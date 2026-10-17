Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96EC31B828;
	Sat, 17 Oct 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260599; cv=none; b=EW03hM2qhMoZDD5JR1bLP8aBOtCiIXLpmK7DCyvpX71hQqgf/MGJLVOIfL+jWjAqODJGGhvbz8+JiLzjmhOwF1w89LG1zcjUv6JX9al6K8Ud08YmwEwk0MiHJBdnvBMlKT7jYPVMeQF20Qmlc/E93qo2aBrYx/Maw1sOrPSpLv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260599; c=relaxed/simple;
	bh=7NOrkHGtZUCVY/3Pk3K18TH3FuAJA3kjO/RpLKNZ7JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxqTxPVhRD1e26jZSSEnXktL483n8AGgBF6KdWF84hknkzdboP3jQjx4rgz2mJBwKNk0/x6ZPMkMQYgWZWqkTSqsfhEF1Kvg9Xmo1XxnHNVnKs6d4/fNyaHyl12uymlHCOciude3d5eQes53IkiL8ccGz/k5yRwZw/Y+zfoKyOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdhe5nLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdhe5nLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2006A1F000C4;
	Sat, 17 Oct 2026 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260598;
	bh=2hrnbKtrGpnl4mUNumOHoDn+L0PxOci03nZmis27GI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdhe5nLOy1ADTif5DXtklGxvKQP9dMuN+k9JdnftRdKj+2sLbp9gFzV4lCNCTAIZ/
	 57XupTnsK7Ngmx2c061AuKDUPhpuePWzxw1U5E13OnVcDiJSAOTwaOeX+7s3SpwAZv
	 zWfbbF11r3qRYrrUAoCtbB1Gylw1EKOy1lvuO58o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magdalena Schulfer <magdalena.schulfer@intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1599/1674] accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr
Date: Sat, 17 Oct 2026 18:04:31 +0200
Message-ID: <20261017160512.129864031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Magdalena Schulfer <magdalena.schulfer@intel.com>

[ Upstream commit 3837c3f29fbc3b8c12bebf5c62741e2befe3482a ]

Add a size parameter to ivpu_to_cpu_addr() and validate that the
whole [vpu_addr, vpu_addr + size) range stays within the BO.

Cc: stable@vger.kernel.org
Fixes: 647371a6609d ("accel/ivpu: Add GEM buffer object management")
Signed-off-by: Magdalena Schulfer <magdalena.schulfer@intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260901125749.404338-2-dawid.osuchowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.h | 14 +++++++++++---
 drivers/accel/ivpu/ivpu_ipc.c |  7 ++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.h b/drivers/accel/ivpu/ivpu_gem.h
index 6b0ceda5f2537..61458d118889e 100644
--- a/drivers/accel/ivpu/ivpu_gem.h
+++ b/drivers/accel/ivpu/ivpu_gem.h
@@ -102,15 +102,23 @@ static inline struct ivpu_device *ivpu_bo_to_vdev(struct ivpu_bo *bo)
 	return to_ivpu_device(bo->base.dev);
 }
 
-static inline void *ivpu_to_cpu_addr(struct ivpu_bo *bo, u32 vpu_addr)
+static inline void *ivpu_to_cpu_addr(struct ivpu_bo *bo, u64 vpu_addr, u64 size)
 {
+	u64 bo_size = bo->base.size;
+	u64 offset;
+
 	if (vpu_addr < bo->vpu_addr)
 		return NULL;
 
-	if (vpu_addr >= (bo->vpu_addr + bo->base.size))
+	if (size > bo_size)
+		return NULL;
+
+	offset = vpu_addr - bo->vpu_addr;
+
+	if (offset > bo_size - size)
 		return NULL;
 
-	return bo->kvaddr + (vpu_addr - bo->vpu_addr);
+	return bo->kvaddr + offset;
 }
 
 static inline u32 cpu_to_vpu_addr(struct ivpu_bo *bo, void *cpu_addr)
diff --git a/drivers/accel/ivpu/ivpu_ipc.c b/drivers/accel/ivpu/ivpu_ipc.c
index 295c0d7b50398..fdd8159610958 100644
--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -84,7 +84,7 @@ ivpu_ipc_tx_prepare(struct ivpu_device *vdev, struct ivpu_ipc_consumer *cons,
 		return -ENOMEM;
 	}
 
-	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr);
+	tx_buf = ivpu_to_cpu_addr(ipc->mem_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 	if (drm_WARN_ON(&vdev->drm, !tx_buf)) {
 		gen_pool_free(ipc->mm_tx, tx_buf_vpu_addr, sizeof(*tx_buf));
 		return -EIO;
@@ -376,7 +376,7 @@ int ivpu_ipc_irq_handler(struct ivpu_device *vdev)
 			return -EIO;
 		}
 
-		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr);
+		ipc_hdr = ivpu_to_cpu_addr(ipc->mem_rx, vpu_addr, sizeof(*ipc_hdr));
 		if (!ipc_hdr) {
 			ivpu_warn(vdev, "IPC msg 0x%x out of range\n", vpu_addr);
 			continue;
@@ -385,7 +385,8 @@ int ivpu_ipc_irq_handler(struct ivpu_device *vdev)
 
 		jsm_msg = NULL;
 		if (ipc_hdr->channel != IVPU_IPC_CHAN_BOOT_MSG) {
-			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr);
+			jsm_msg = ivpu_to_cpu_addr(ipc->mem_rx, ipc_hdr->data_addr,
+						   sizeof(*jsm_msg));
 			if (!jsm_msg) {
 				ivpu_warn(vdev, "JSM msg 0x%x out of range\n", ipc_hdr->data_addr);
 				ivpu_ipc_rx_mark_free(vdev, ipc_hdr, NULL);
-- 
2.53.0



