Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C75372F2;
	Wed, 23 Sep 2026 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174116; cv=none; b=M9GyapOZgY1ZH8Hgq3MoN6RBK3pliXIXhtY+/aI3meIGfvWdGOdCXGjBIg5pCbod3yQKxhQ4w3ssk72H5itiAGUyvQ4KLjFylW1MF6FRk9P9ZMN2uYR8Y5/13QqHQOY5Qq2dgXjAVI9v+aTERBxxhHsH5cFTEXCoKJDCiuIDLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174116; c=relaxed/simple;
	bh=UeE24GUslXazPsS3Pr6B4NFd70xgxZq8hAvvORoNhGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMXp84LGFSAeI4O9ZF159P43EZSl8ihnwf4UuGWVSOGU5Br5uCsVeccusCVyMQJwN7SBiBvdNSIVEmh2fF2OGNSN7SPMJA5wkkwyu7Ytjv22D+BwKe/y8f2uJiICCw1mJMuQUm6p28lmzSg+0lH6dhd0f5BH//klesUlErOirfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDmcNYkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDmcNYkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C910F1F000FF;
	Wed, 23 Sep 2026 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174115;
	bh=3AV9ms9X1uXZgaRNcE6WokXFv0n2gSDoeMkWF/H4Dxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDmcNYkAo0Yf4CbJfK5gKobXrC47FjQu3K5XPOEFc1cEe46Gq8i43mbUD5PYUg9Hh
	 ztRmEHh7xa0iMYRAf8CqIpcgM5jMcsWl31Rz5aeGLNKPQ8dR26m4ePsxoV8VFiTWpe
	 lNlEchzZXGRRbp8pJUWIK+DUxiVtMH10RWckf4LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mike Lothian <mike@fireburn.co.uk>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 408/438] drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments
Date: Wed, 23 Sep 2026 16:07:09 +0200
Message-ID: <20260923140655.478711693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Mike Lothian <mike@fireburn.co.uk>

commit 636139603b99d2e3a18a46cf3f8d39313ce8042e upstream.

amdgpu_dma_buf_map() adds VRAM to the allowed domains for a peer2peer
attachment.  GTT is only a fallback placement when VRAM is preferred, so
ttm_bo_validate() migrates the buffer from GTT into VRAM.  While the
exporting device is runtime suspended its SDMA rings are down and the
move fails:

  amdgpu: Move buffer fallback to memcpy unavailable

An importer on a second GPU reaches this holding no runtime PM
reference on the exporter, e.g. a compositor on the APU submitting a
frame that references a buffer exported by an idle dGPU:

  amdgpu_cs_ioctl -> amdgpu_cs_parser_bos -> amdgpu_cs_bo_validate
    -> ttm_bo_validate -> amdgpu_bo_move -> dma_buf_map_attachment
      -> amdgpu_dma_buf_map -> ttm_bo_validate -> amdgpu_bo_move

Pinning a dma-buf into VRAM has the same requirement, which
commit 030631e97b20 ("drm/amdgpu: revert "take runtime pm reference
when we attach a buffer" v2") called out as the one case that would
need the reference back.

Take it in attach and drop it in detach.  pm_runtime_get_if_active()
never resumes the device, so it cannot deadlock against the reservation
taken during resume, which is why the old pm_runtime_get_sync() had to
go.  If the device is not active, clear peer2peer instead: the buffer
then stays in GTT, which remains accessible while the GPU is powered
down.  If runtime PM is disabled, take a plain reference so the put in
detach stays balanced.

Fixes: 030631e97b20 ("drm/amdgpu: revert "take runtime pm reference when we attach a buffer" v2")
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Assisted-by: Claude:Opus-5 [Claude Code]
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 062ff15e30a48d14fb7d7558eba84f8dc97197f0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |   43 +++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -43,6 +43,7 @@
 #include <linux/dma-buf.h>
 #include <linux/dma-fence-array.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/pm_runtime.h>
 
 static const struct dma_buf_attach_ops amdgpu_dma_buf_attach_ops;
 
@@ -100,15 +101,54 @@ static int amdgpu_dma_buf_attach(struct
 	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
 		attach->peer2peer = false;
 
+	/*
+	 * Only allow P2P while the exporter is active, and keep it active
+	 * until detach.  With runtime PM disabled take a plain reference so
+	 * the put in detach stays balanced.
+	 */
+	if (attach->peer2peer) {
+		struct device *dev = adev_to_drm(adev)->dev;
+		int ret = pm_runtime_get_if_active(dev);
+
+		if (!ret)
+			attach->peer2peer = false;
+		else if (ret < 0)
+			pm_runtime_get_noresume(dev);
+	}
+
 	r = dma_resv_lock(bo->tbo.base.resv, NULL);
 	if (r)
-		return r;
+		goto err_pm_put;
 
 	amdgpu_vm_bo_update_shared(bo);
 
 	dma_resv_unlock(bo->tbo.base.resv);
 
 	return 0;
+
+err_pm_put:
+	if (attach->peer2peer)
+		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+	return r;
+}
+
+/**
+ * amdgpu_dma_buf_detach - &dma_buf_ops.detach implementation
+ *
+ * @dmabuf: DMA-buf where we remove the attachment from
+ * @attach: the attachment to remove
+ *
+ * Drop the runtime PM reference taken in amdgpu_dma_buf_attach().
+ */
+static void amdgpu_dma_buf_detach(struct dma_buf *dmabuf,
+				  struct dma_buf_attachment *attach)
+{
+	struct drm_gem_object *obj = dmabuf->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+
+	if (attach->peer2peer)
+		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 }
 
 /**
@@ -350,6 +390,7 @@ static void amdgpu_dma_buf_vunmap(struct
 
 const struct dma_buf_ops amdgpu_dmabuf_ops = {
 	.attach = amdgpu_dma_buf_attach,
+	.detach = amdgpu_dma_buf_detach,
 	.pin = amdgpu_dma_buf_pin,
 	.unpin = amdgpu_dma_buf_unpin,
 	.map_dma_buf = amdgpu_dma_buf_map,


