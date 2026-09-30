Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193F7522F1E;
	Wed, 30 Sep 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790399; cv=none; b=MZ9sTSeOCW70qJVZXsNObNfUxCkD2+1g5VOhK8Pajlp6jNH0HGoymQUZDTzoxaJYDhb2IO5KHT2heeFpdJHeJdZ4E+AYrRXq/w7YABbWbISkMCh76cJAAa6vuyPHvXjjJVGCnMHMksYOszKJoEGbHFwCvNsb7u1fxosPkG+gqQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790399; c=relaxed/simple;
	bh=/8jEio+m7cWw8QcqNcA/Wa+w+CpLQ0ionDXmN+rNaOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcnD6UnTN2d+g6oul1WvqI02FlQE/FZEgPPMpkFYGFKL/APzUjX+ZK1Dg9b4jSP5tRzHMMOw5w3N1xKGuDvRDCMhwIVXgb+wUVOOn6v/sUOx/neBme+lZLAjGf4HYue20pAx/BjSMsCPFnJQiobVuw3RyUsTceEsJFoyK/15Cas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM+d3plG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM+d3plG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740511F000FF;
	Wed, 30 Sep 2026 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790395;
	bh=Qpi0/IM6ddDlz6trrCWVpU2qW7dmuOTSw6tTiJY4LUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM+d3plGnI7oD7DSDMO7eP92X5C2mgV6DozWmwqsiVCeiiDRaoBp5MQ5IlURDZq64
	 IreZD8GL4oR0Ty5Itg/U3DX7stl2LgKHye9gtvbOPqyhPV+39UWH7LMDPY+4ygzVyD
	 pE9gClD1M0vP0s+AAmieYIkb/5w1qvK5Y81CLCbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mike Lothian <mike@fireburn.co.uk>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 813/877] drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments
Date: Wed, 30 Sep 2026 17:28:44 +0200
Message-ID: <20260930152432.265142207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Mike Lothian <mike@fireburn.co.uk>

[ Upstream commit 636139603b99d2e3a18a46cf3f8d39313ce8042e ]

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
[ omitted err_pm_put cleanup because this branch lacks the reservation-locking failure path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |   36 ++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -41,6 +41,7 @@
 #include <linux/dma-buf.h>
 #include <linux/dma-fence-array.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/pm_runtime.h>
 
 static const struct dma_buf_attach_ops amdgpu_dma_buf_attach_ops;
 
@@ -97,10 +98,44 @@ static int amdgpu_dma_buf_attach(struct
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
 	return 0;
 }
 
 /**
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
+}
+
+/**
  * amdgpu_dma_buf_pin - &dma_buf_ops.pin implementation
  *
  * @attach: attachment to pin down
@@ -270,6 +305,7 @@ static int amdgpu_dma_buf_begin_cpu_acce
 
 const struct dma_buf_ops amdgpu_dmabuf_ops = {
 	.attach = amdgpu_dma_buf_attach,
+	.detach = amdgpu_dma_buf_detach,
 	.pin = amdgpu_dma_buf_pin,
 	.unpin = amdgpu_dma_buf_unpin,
 	.map_dma_buf = amdgpu_dma_buf_map,


