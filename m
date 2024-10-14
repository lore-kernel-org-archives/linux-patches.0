Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88420EB;
	Mon, 14 Oct 2024 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916209; cv=none; b=DH3kJH2wyRraw9N5XET6hjSbNQXxkCgITx3XbydqGPKwYz/0KXKmE9TuJfeKsJD212JId62OsQx2gqy6k98ujVuIHdrNu0cUFSAyBJ2hhAlIJ+TmgN2/8jB3iP8uYuF4osIwl1OTDfzNDoWU8U9oSjs0oQ3DOzEhfnE7cO8oXbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916209; c=relaxed/simple;
	bh=lb6O5e9SQhw5lI1tyfzOuELZb2PqhDCZw0qLyruHWIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfP+KiFag1+JGiyrMGa2Meyul+693nRkwdiUBcz3GpHrAeqRz8oh+DJt9OirZsO86YBN8i6QtJVcAGrKRQC09vfbxsy8xqPRHVeUgFkanLcT9Wm0RvC0kYWh0TjzSZWQiQX/waTtZbXqJmgpSGjkyFeg0ASDaeU8qIDvPqFqHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNgqiWZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNgqiWZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1909C4CEC7;
	Mon, 14 Oct 2024 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916209;
	bh=lb6O5e9SQhw5lI1tyfzOuELZb2PqhDCZw0qLyruHWIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNgqiWZ83y8r8rRgkwYqwYnlizy/kXbBGrezCbAtjt1yRMM3W624qVC8C21XU7DSu
	 5mbQMDTCyvB2GXysLhdG16M2sgQo8qhZTs+GxohyqOe2VEBsLFWIcx2/HO5ceOXlr+
	 gfVYBxTLgaScd9AdOLaCKDuG7uEdbVcQ4xXUV6cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 114/214] drm/nouveau: pass cli to nouveau_channel_new() instead of drm+device
Date: Mon, 14 Oct 2024 16:19:37 +0200
Message-ID: <20241014141049.441430626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Ben Skeggs <bskeggs@nvidia.com>

[ Upstream commit 5cca41ac70e5877383ed925bd017884c37edf09b ]

Both of these are stored in nouveau_cli already, and also allows the
removal of some void casts.

Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240726043828.58966-32-bskeggs@nvidia.com
Stable-dep-of: 04e0481526e3 ("nouveau/dmem: Fix privileged error in copy engine channel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv04/crtc.c |  2 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c  | 21 +++++++++++----------
 drivers/gpu/drm/nouveau/nouveau_chan.h  |  3 ++-
 drivers/gpu/drm/nouveau/nouveau_drm.c   |  4 ++--
 6 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/crtc.c b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
index 4310ad71870b1..8fed62e002fea 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/crtc.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/crtc.c
@@ -1157,7 +1157,7 @@ nv04_crtc_page_flip(struct drm_crtc *crtc, struct drm_framebuffer *fb,
 	chan = drm->channel;
 	if (!chan)
 		return -ENODEV;
-	cli = (void *)chan->user.client;
+	cli = chan->cli;
 	push = chan->chan.push;
 
 	s = kzalloc(sizeof(*s), GFP_KERNEL);
diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index d56909071de66..0dd38e73676da 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -356,7 +356,7 @@ nouveau_abi16_ioctl_channel_alloc(ABI16_IOCTL_ARGS)
 	list_add(&chan->head, &abi16->channels);
 
 	/* create channel object and initialise dma and fence management */
-	ret = nouveau_channel_new(drm, device, false, runm, init->fb_ctxdma_handle,
+	ret = nouveau_channel_new(cli, false, runm, init->fb_ctxdma_handle,
 				  init->tt_ctxdma_handle, &chan->chan);
 	if (ret)
 		goto done;
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 70fb003a66669..933356e938903 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -859,7 +859,7 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict,
 {
 	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
 	struct nouveau_channel *chan = drm->ttm.chan;
-	struct nouveau_cli *cli = (void *)chan->user.client;
+	struct nouveau_cli *cli = chan->cli;
 	struct nouveau_fence *fence;
 	int ret;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index 7c97b28868076..cee36b1efd391 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -52,7 +52,7 @@ static int
 nouveau_channel_killed(struct nvif_event *event, void *repv, u32 repc)
 {
 	struct nouveau_channel *chan = container_of(event, typeof(*chan), kill);
-	struct nouveau_cli *cli = (void *)chan->user.client;
+	struct nouveau_cli *cli = chan->cli;
 
 	NV_PRINTK(warn, cli, "channel %d killed!\n", chan->chid);
 
@@ -66,7 +66,7 @@ int
 nouveau_channel_idle(struct nouveau_channel *chan)
 {
 	if (likely(chan && chan->fence && !atomic_read(&chan->killed))) {
-		struct nouveau_cli *cli = (void *)chan->user.client;
+		struct nouveau_cli *cli = chan->cli;
 		struct nouveau_fence *fence = NULL;
 		int ret;
 
@@ -142,10 +142,11 @@ nouveau_channel_wait(struct nvif_push *push, u32 size)
 }
 
 static int
-nouveau_channel_prep(struct nouveau_drm *drm, struct nvif_device *device,
+nouveau_channel_prep(struct nouveau_cli *cli,
 		     u32 size, struct nouveau_channel **pchan)
 {
-	struct nouveau_cli *cli = (void *)device->object.client;
+	struct nouveau_drm *drm = cli->drm;
+	struct nvif_device *device = &cli->device;
 	struct nv_dma_v0 args = {};
 	struct nouveau_channel *chan;
 	u32 target;
@@ -155,6 +156,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nvif_device *device,
 	if (!chan)
 		return -ENOMEM;
 
+	chan->cli = cli;
 	chan->device = device;
 	chan->drm = drm;
 	chan->vmm = nouveau_cli_vmm(cli);
@@ -254,7 +256,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nvif_device *device,
 }
 
 static int
-nouveau_channel_ctor(struct nouveau_drm *drm, struct nvif_device *device, bool priv, u64 runm,
+nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
 		     struct nouveau_channel **pchan)
 {
 	const struct nvif_mclass hosts[] = {
@@ -279,7 +281,7 @@ nouveau_channel_ctor(struct nouveau_drm *drm, struct nvif_device *device, bool p
 		struct nvif_chan_v0 chan;
 		char name[TASK_COMM_LEN+16];
 	} args;
-	struct nouveau_cli *cli = (void *)device->object.client;
+	struct nvif_device *device = &cli->device;
 	struct nouveau_channel *chan;
 	const u64 plength = 0x10000;
 	const u64 ioffset = plength;
@@ -298,7 +300,7 @@ nouveau_channel_ctor(struct nouveau_drm *drm, struct nvif_device *device, bool p
 		size = ioffset + ilength;
 
 	/* allocate dma push buffer */
-	ret = nouveau_channel_prep(drm, device, size, &chan);
+	ret = nouveau_channel_prep(cli, size, &chan);
 	*pchan = chan;
 	if (ret)
 		return ret;
@@ -493,13 +495,12 @@ nouveau_channel_init(struct nouveau_channel *chan, u32 vram, u32 gart)
 }
 
 int
-nouveau_channel_new(struct nouveau_drm *drm, struct nvif_device *device,
+nouveau_channel_new(struct nouveau_cli *cli,
 		    bool priv, u64 runm, u32 vram, u32 gart, struct nouveau_channel **pchan)
 {
-	struct nouveau_cli *cli = (void *)device->object.client;
 	int ret;
 
-	ret = nouveau_channel_ctor(drm, device, priv, runm, pchan);
+	ret = nouveau_channel_ctor(cli, priv, runm, pchan);
 	if (ret) {
 		NV_PRINTK(dbg, cli, "channel create, %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.h b/drivers/gpu/drm/nouveau/nouveau_chan.h
index 5de2ef4e98c2b..260febd634ee2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.h
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.h
@@ -12,6 +12,7 @@ struct nouveau_channel {
 		struct nvif_push *push;
 	} chan;
 
+	struct nouveau_cli *cli;
 	struct nvif_device *device;
 	struct nouveau_drm *drm;
 	struct nouveau_vmm *vmm;
@@ -62,7 +63,7 @@ struct nouveau_channel {
 int nouveau_channels_init(struct nouveau_drm *);
 void nouveau_channels_fini(struct nouveau_drm *);
 
-int  nouveau_channel_new(struct nouveau_drm *, struct nvif_device *, bool priv, u64 runm,
+int  nouveau_channel_new(struct nouveau_cli *, bool priv, u64 runm,
 			 u32 vram, u32 gart, struct nouveau_channel **);
 void nouveau_channel_del(struct nouveau_channel **);
 int  nouveau_channel_idle(struct nouveau_channel *);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index a58c31089613e..88413b5c8684a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -356,7 +356,7 @@ nouveau_accel_ce_init(struct nouveau_drm *drm)
 		return;
 	}
 
-	ret = nouveau_channel_new(drm, device, false, runm, NvDmaFB, NvDmaTT, &drm->cechan);
+	ret = nouveau_channel_new(&drm->client, false, runm, NvDmaFB, NvDmaTT, &drm->cechan);
 	if (ret)
 		NV_ERROR(drm, "failed to create ce channel, %d\n", ret);
 }
@@ -384,7 +384,7 @@ nouveau_accel_gr_init(struct nouveau_drm *drm)
 		return;
 	}
 
-	ret = nouveau_channel_new(drm, device, false, runm, NvDmaFB, NvDmaTT, &drm->channel);
+	ret = nouveau_channel_new(&drm->client, false, runm, NvDmaFB, NvDmaTT, &drm->channel);
 	if (ret) {
 		NV_ERROR(drm, "failed to create kernel channel, %d\n", ret);
 		nouveau_accel_gr_fini(drm);
-- 
2.43.0



