Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459BB1F63CD;
	Sun,  7 Sep 2025 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277813; cv=none; b=dMrfjXzi5Xi28XJl0l+B6bRStTWLZlvMSivFhAjZdfjyZv/H/HB2mpD+3jS0jWtT+jOaCBUmCH0snxHPnqgClLIp4/DZGITG9J290F79l3lVbqC302b4G+7UYRWidcHmIrXcuRtXMuRXgxDbHol/vXiLPatCW3tWGWpwRS10hYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277813; c=relaxed/simple;
	bh=G7oXAl3XVbfGnxtggkK8TnlyWMffGFzYkUCOWYPnscs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mfd0MNvKiJ2MQx6aPvqKmcAM6fc3HOZxrrrLvn1UoOH368WiydPqLBunr/q9xklO+F8RUhQbvJj9/DU1flz0ZGia/aT6sDwxK6k1TU0oVdkLOfSO7zlOCElSC7dkw+eaczowoPHS7In6key1I/b2d5uXf59wl/yF9TkSwO0lHX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMJNP+61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMJNP+61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA681C4CEF0;
	Sun,  7 Sep 2025 20:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277813;
	bh=G7oXAl3XVbfGnxtggkK8TnlyWMffGFzYkUCOWYPnscs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMJNP+61FaP4IjjsvFSPpEEdvTpDmJjgaeQguJhoT/k5qQBzax8O3CUJPitlo2Ezm
	 VXx/oQDHaw11j3zT/IeleMydT03hGy9m7YOgXkxLMdMtrdfViFxkx0jRLI8lEjk7Ya
	 PdYShwyQFgV/Zor+MwG9pT+lmBu95glT64zSE4w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.16 132/183] nouveau: fix disabling the nonstall irq due to storm code
Date: Sun,  7 Sep 2025 21:59:19 +0200
Message-ID: <20250907195618.929568437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 0ef5c4e4dbbfcebaa9b2eca18097b43016727dfe upstream.

Nouveau has code that when it gets an IRQ with no allowed handler
it disables it to avoid storms.

However with nonstall interrupts, we often disable them from
the drm driver, but still request their emission via the push submission.

Just don't disable nonstall irqs ever in normal operation, the
event handling code will filter them out, and the driver will
just enable/disable them at load time.

This fixes timeouts we've been seeing on/off for a long time,
but they became a lot more noticeable on Blackwell.

This doesn't fix all of them, there is a subsequent fence emission
fix to fix the last few.

Fixes: 3ebd64aa3c4f ("drm/nouveau/intr: support multiple trees, and explicit interfaces")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://lore.kernel.org/r/20250829021633.1674524-1-airlied@gmail.com
[ Fix a typo and a minor checkpatch.pl warning; remove "v2" from commit
  subject. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c        |    2 +
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c       |   23 +++++++++++------
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c       |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/priv.h        |    2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fifo.c |    1 
 5 files changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/base.c
@@ -350,6 +350,8 @@ nvkm_fifo_dtor(struct nvkm_engine *engin
 	nvkm_chid_unref(&fifo->chid);
 
 	nvkm_event_fini(&fifo->nonstall.event);
+	if (fifo->func->nonstall_dtor)
+		fifo->func->nonstall_dtor(fifo);
 	mutex_destroy(&fifo->mutex);
 
 	if (fifo->func->dtor)
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c
@@ -517,19 +517,11 @@ ga100_fifo_nonstall_intr(struct nvkm_int
 static void
 ga100_fifo_nonstall_block(struct nvkm_event *event, int type, int index)
 {
-	struct nvkm_fifo *fifo = container_of(event, typeof(*fifo), nonstall.event);
-	struct nvkm_runl *runl = nvkm_runl_get(fifo, index, 0);
-
-	nvkm_inth_block(&runl->nonstall.inth);
 }
 
 static void
 ga100_fifo_nonstall_allow(struct nvkm_event *event, int type, int index)
 {
-	struct nvkm_fifo *fifo = container_of(event, typeof(*fifo), nonstall.event);
-	struct nvkm_runl *runl = nvkm_runl_get(fifo, index, 0);
-
-	nvkm_inth_allow(&runl->nonstall.inth);
 }
 
 const struct nvkm_event_func
@@ -564,12 +556,26 @@ ga100_fifo_nonstall_ctor(struct nvkm_fif
 		if (ret)
 			return ret;
 
+		nvkm_inth_allow(&runl->nonstall.inth);
+
 		nr = max(nr, runl->id + 1);
 	}
 
 	return nr;
 }
 
+void
+ga100_fifo_nonstall_dtor(struct nvkm_fifo *fifo)
+{
+	struct nvkm_runl *runl;
+
+	nvkm_runl_foreach(runl, fifo) {
+		if (runl->nonstall.vector < 0)
+			continue;
+		nvkm_inth_block(&runl->nonstall.inth);
+	}
+}
+
 int
 ga100_fifo_runl_ctor(struct nvkm_fifo *fifo)
 {
@@ -599,6 +605,7 @@ ga100_fifo = {
 	.runl_ctor = ga100_fifo_runl_ctor,
 	.mmu_fault = &tu102_fifo_mmu_fault,
 	.nonstall_ctor = ga100_fifo_nonstall_ctor,
+	.nonstall_dtor = ga100_fifo_nonstall_dtor,
 	.nonstall = &ga100_fifo_nonstall,
 	.runl = &ga100_runl,
 	.runq = &ga100_runq,
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga102.c
@@ -30,6 +30,7 @@ ga102_fifo = {
 	.runl_ctor = ga100_fifo_runl_ctor,
 	.mmu_fault = &tu102_fifo_mmu_fault,
 	.nonstall_ctor = ga100_fifo_nonstall_ctor,
+	.nonstall_dtor = ga100_fifo_nonstall_dtor,
 	.nonstall = &ga100_fifo_nonstall,
 	.runl = &ga100_runl,
 	.runq = &ga100_runq,
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/priv.h
@@ -41,6 +41,7 @@ struct nvkm_fifo_func {
 	void (*start)(struct nvkm_fifo *, unsigned long *);
 
 	int (*nonstall_ctor)(struct nvkm_fifo *);
+	void (*nonstall_dtor)(struct nvkm_fifo *);
 	const struct nvkm_event_func *nonstall;
 
 	const struct nvkm_runl_func *runl;
@@ -200,6 +201,7 @@ u32 tu102_chan_doorbell_handle(struct nv
 
 int ga100_fifo_runl_ctor(struct nvkm_fifo *);
 int ga100_fifo_nonstall_ctor(struct nvkm_fifo *);
+void ga100_fifo_nonstall_dtor(struct nvkm_fifo *);
 extern const struct nvkm_event_func ga100_fifo_nonstall;
 extern const struct nvkm_runl_func ga100_runl;
 extern const struct nvkm_runq_func ga100_runq;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fifo.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fifo.c
@@ -601,6 +601,7 @@ r535_fifo_new(const struct nvkm_fifo_fun
 	rm->chan.func = &r535_chan;
 	rm->nonstall = &ga100_fifo_nonstall;
 	rm->nonstall_ctor = ga100_fifo_nonstall_ctor;
+	rm->nonstall_dtor = ga100_fifo_nonstall_dtor;
 
 	return nvkm_fifo_new_(rm, device, type, inst, pfifo);
 }


