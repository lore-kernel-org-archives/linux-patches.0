Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD0151CCC;
	Tue, 20 Feb 2024 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464995; cv=none; b=BKkXQ6dDfv4Kt4x9wlGqchagfhWny6KaJHs3sdOuME+GKPn75HiWhNDn2QN88gAImnC7mHVyVWkamxVbMMM0JnGKOviZpN5y0bljS2CnvSg2hC0mKyLM/JJ6PjDB19y7haq6bFVHlM6kS5xiusig4BPahwah9tid3jo/Vg6NkiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464995; c=relaxed/simple;
	bh=Mshwr+75PW/q25fvzdEZdohh/ELvXgy07xGaL/yd8Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFFYKd7Ldmjv7XcV0M/+mckQglnAa/7cL0USIAJMS67GeUBk9qgAZJfC0xxJKhLh6Br1aGC8xJZ9kpw0SLcV3gjgkWnPPX2N6PzymfZzwJM1WdBR5ATI3P5ozDmNCnP1d5PMgC18yApe69OWUawQwZd27ybkO80uiE7KR4vHDJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlU6Vs1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlU6Vs1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEB8C433F1;
	Tue, 20 Feb 2024 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464995;
	bh=Mshwr+75PW/q25fvzdEZdohh/ELvXgy07xGaL/yd8Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlU6Vs1Ig9gZUC9owWHVGqu9D4KymF4obu2OFVivjY/j2k4tT+T++nP82v/Vyub+O
	 W2RuoSoSmqyfcGSS1lM7/oAGxmKdj7O/+WTcfLcCF6oqimHpoNubBCXwiONq+DMHhu
	 atFE2Gc62apAey3+FjLNhOFIO4fpGc+Xk+eZf+u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH 6.7 203/309] drm/nouveau: fix several DMA buffer leaks
Date: Tue, 20 Feb 2024 21:56:02 +0100
Message-ID: <20240220205639.543274672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

commit 042b5f83841fbf7ce39474412db3b5e4765a7ea7 upstream.

Nouveau manages GSP-RM DMA buffers with nvkm_gsp_mem objects.  Several of
these buffers are never dealloced.  Some of them can be deallocated
right after GSP-RM is initialized, but the rest need to stay until the
driver unloads.

Also futher bullet-proof these objects by poisoning the buffer and
clearing the nvkm_gsp_mem object when it is deallocated.  Poisoning
the buffer should trigger an error (or crash) from GSP-RM if it tries
to access the buffer after we've deallocated it, because we were wrong
about when it is safe to deallocate.

Finally, change the mem->size field to a size_t because that's the same
type that dma_alloc_coherent expects.

Cc: <stable@vger.kernel.org> # v6.7
Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240202230608.1981026-1-ttabi@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../gpu/drm/nouveau/include/nvkm/subdev/gsp.h |  2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    | 59 ++++++++++++-------
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
index d1437c08645f..6f5d376d8fcc 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h
@@ -9,7 +9,7 @@
 #define GSP_PAGE_SIZE  BIT(GSP_PAGE_SHIFT)
 
 struct nvkm_gsp_mem {
-	u32 size;
+	size_t size;
 	void *data;
 	dma_addr_t addr;
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 5e1fa176aac4..6208ddd92964 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -997,6 +997,32 @@ r535_gsp_rpc_get_gsp_static_info(struct nvkm_gsp *gsp)
 	return 0;
 }
 
+static void
+nvkm_gsp_mem_dtor(struct nvkm_gsp *gsp, struct nvkm_gsp_mem *mem)
+{
+	if (mem->data) {
+		/*
+		 * Poison the buffer to catch any unexpected access from
+		 * GSP-RM if the buffer was prematurely freed.
+		 */
+		memset(mem->data, 0xFF, mem->size);
+
+		dma_free_coherent(gsp->subdev.device->dev, mem->size, mem->data, mem->addr);
+		memset(mem, 0, sizeof(*mem));
+	}
+}
+
+static int
+nvkm_gsp_mem_ctor(struct nvkm_gsp *gsp, size_t size, struct nvkm_gsp_mem *mem)
+{
+	mem->size = size;
+	mem->data = dma_alloc_coherent(gsp->subdev.device->dev, size, &mem->addr, GFP_KERNEL);
+	if (WARN_ON(!mem->data))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int
 r535_gsp_postinit(struct nvkm_gsp *gsp)
 {
@@ -1024,6 +1050,13 @@ r535_gsp_postinit(struct nvkm_gsp *gsp)
 
 	nvkm_inth_allow(&gsp->subdev.inth);
 	nvkm_wr32(device, 0x110004, 0x00000040);
+
+	/* Release the DMA buffers that were needed only for boot and init */
+	nvkm_gsp_mem_dtor(gsp, &gsp->boot.fw);
+	nvkm_gsp_mem_dtor(gsp, &gsp->libos);
+	nvkm_gsp_mem_dtor(gsp, &gsp->rmargs);
+	nvkm_gsp_mem_dtor(gsp, &gsp->wpr_meta);
+
 	return ret;
 }
 
@@ -1532,27 +1565,6 @@ r535_gsp_msg_run_cpu_sequencer(void *priv, u32 fn, void *repv, u32 repc)
 	return 0;
 }
 
-static void
-nvkm_gsp_mem_dtor(struct nvkm_gsp *gsp, struct nvkm_gsp_mem *mem)
-{
-	if (mem->data) {
-		dma_free_coherent(gsp->subdev.device->dev, mem->size, mem->data, mem->addr);
-		mem->data = NULL;
-	}
-}
-
-static int
-nvkm_gsp_mem_ctor(struct nvkm_gsp *gsp, u32 size, struct nvkm_gsp_mem *mem)
-{
-	mem->size = size;
-	mem->data = dma_alloc_coherent(gsp->subdev.device->dev, size, &mem->addr, GFP_KERNEL);
-	if (WARN_ON(!mem->data))
-		return -ENOMEM;
-
-	return 0;
-}
-
-
 static int
 r535_gsp_booter_unload(struct nvkm_gsp *gsp, u32 mbox0, u32 mbox1)
 {
@@ -2150,6 +2162,11 @@ r535_gsp_dtor(struct nvkm_gsp *gsp)
 	mutex_destroy(&gsp->cmdq.mutex);
 
 	r535_gsp_dtor_fws(gsp);
+
+	nvkm_gsp_mem_dtor(gsp, &gsp->shm.mem);
+	nvkm_gsp_mem_dtor(gsp, &gsp->loginit);
+	nvkm_gsp_mem_dtor(gsp, &gsp->logintr);
+	nvkm_gsp_mem_dtor(gsp, &gsp->logrm);
 }
 
 int
-- 
2.43.2



