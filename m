Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF759443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893C8C433C7;
	Sun, 13 Aug 2023 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961897;
	bh=cPSuqEhjVSebTno1xrhJL7L9CBGw2VlW4+aC/EksmQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LaK3OZAAAhlacc5v0PSC5if+/TirlSMU2+g0Ez44N1PRE7s8LrM/awscSw6vYmsM
	 rjSDxSjBX4hp03TSMG6lTwn4tTupOVjsuFSFcq5g8CkJbWKSfW1fT1XTUVVG+1pjSr
	 DZ4XEgRhfLg9BP8xPdQgxcoDM+RoCJ9ZPeNvYchA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	David Airlie <airlied@gmail.com>,
	nouveau@lists.freedesktop.org,
	Karol Herbst <kherbst@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.4 039/206] drm/nouveau/gr: enable memory loads on helper invocation on all channels
Date: Sun, 13 Aug 2023 23:16:49 +0200
Message-ID: <20230813211726.114391910@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

commit 1cb9e2ef66d53b020842b18762e30d0eb4384de8 upstream.

We have a lurking bug where Fragment Shader Helper Invocations can't load
from memory. But this is actually required in OpenGL and is causing random
hangs or failures in random shaders.

It is unknown how widespread this issue is, but shaders hitting this can
end up with infinite loops.

We enable those only on all Kepler and newer GPUs where we use our own
Firmware.

Nvidia's firmware provides a way to set a kernelspace controlled list of
mmio registers in the gr space from push buffers via MME macros.

v2: drop code for gm200 and newer.

Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@gmail.com>
Cc: nouveau@lists.freedesktop.org
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230622152017.2512101-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h  |    1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c  |    4 +++-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c  |   10 ++++++++++
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c |    1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c  |    1 +
 drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c  |    1 +
 6 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.h
@@ -117,6 +117,7 @@ void gk104_grctx_generate_r418800(struct
 
 extern const struct gf100_grctx_func gk110_grctx;
 void gk110_grctx_generate_r419eb0(struct gf100_gr *);
+void gk110_grctx_generate_r419f78(struct gf100_gr *);
 
 extern const struct gf100_grctx_func gk110b_grctx;
 extern const struct gf100_grctx_func gk208_grctx;
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk104.c
@@ -906,7 +906,9 @@ static void
 gk104_grctx_generate_r419f78(struct gf100_gr *gr)
 {
 	struct nvkm_device *device = gr->base.engine.subdev.device;
-	nvkm_mask(device, 0x419f78, 0x00000001, 0x00000000);
+
+	/* bit 3 set disables loads in fp helper invocations, we need it enabled */
+	nvkm_mask(device, 0x419f78, 0x00000009, 0x00000000);
 }
 
 void
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110.c
@@ -820,6 +820,15 @@ gk110_grctx_generate_r419eb0(struct gf10
 	nvkm_mask(device, 0x419eb0, 0x00001000, 0x00001000);
 }
 
+void
+gk110_grctx_generate_r419f78(struct gf100_gr *gr)
+{
+	struct nvkm_device *device = gr->base.engine.subdev.device;
+
+	/* bit 3 set disables loads in fp helper invocations, we need it enabled */
+	nvkm_mask(device, 0x419f78, 0x00000008, 0x00000000);
+}
+
 const struct gf100_grctx_func
 gk110_grctx = {
 	.main  = gf100_grctx_generate_main,
@@ -854,4 +863,5 @@ gk110_grctx = {
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
 	.r419eb0 = gk110_grctx_generate_r419eb0,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk110b.c
@@ -103,4 +103,5 @@ gk110b_grctx = {
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
 	.r419eb0 = gk110_grctx_generate_r419eb0,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgk208.c
@@ -568,4 +568,5 @@ gk208_grctx = {
 	.dist_skip_table = gf117_grctx_generate_dist_skip_table,
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r418800 = gk104_grctx_generate_r418800,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgm107.c
@@ -988,4 +988,5 @@ gm107_grctx = {
 	.r406500 = gm107_grctx_generate_r406500,
 	.gpc_tpc_nr = gk104_grctx_generate_gpc_tpc_nr,
 	.r419e00 = gm107_grctx_generate_r419e00,
+	.r419f78 = gk110_grctx_generate_r419f78,
 };


