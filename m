Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC8A53D9D2;
	Wed, 30 Sep 2026 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790072; cv=none; b=kLjVY/06nJlQ1kN7fXAnst3IMOAsxh3yLN6BpB9dZHr0ektLqOD1OhL025+L7p0+OCBNzPg5aBF2SDxGC2BuZoxZUCP58e6jjUXgoKU1HkpxokeogZrDIWocBT47zCTC4TZvF65qt4Ltcv64r9KmLtEV9w6GWIiadv7kaWXYvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790072; c=relaxed/simple;
	bh=34vnZlKBLRsTep+8LevgA7xywmZVQppeh4GiET1MAV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fys4isW0puGZitB9brQ6u4j8s7BucFGhAQ7nx9QbEru5C3Rdd4ZKe3BSQ9yXBriM0LFEae1TmDzGTD7EH9iI44aJ0ILQ5zwEveS4swAKjlbxq4CaETb8ANs2ISQY6MecVsAet4PaRiifMYhof76jZOT7vSn3VP8HLQ4sjxGNJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weZRuNhT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weZRuNhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B598B1F000FF;
	Wed, 30 Sep 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790070;
	bh=RbeduSEVTw7KluR6GcAAzVosYWh2nb0zXfRk9xerzww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weZRuNhTYfUwG0Cnq5/hsxj6r7Dm/dLcWtuTSe6pRGnsPzB8aNa8XsG5zDSTqSZZo
	 N70cbRTTIWIkYvzCOvN0Np7CldCzNJ4mmwHOsMQc4EMyMdQjOSdYBXoO/Z7NwEUtuu
	 MNRekmDo3Svh4brqnVl0+RIN0FE/7u97mSqULPS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	James Jones <jajones@nvidia.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Zhang Enpei <zhang.enpei@zte.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 701/877] drm/nouveau/disp/r535: Add scanline position support + head state support
Date: Wed, 30 Sep 2026 17:26:52 +0200
Message-ID: <20260930152429.808310540@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 804cb093b245c752f15d17186e0d404f10303593 ]

That's right! It looks like this never actually got finished, something
which I just noticed today when I saw this fun message spamming one of my
test machine's kernel logs when enabling display debug output for nouveau:

  [drm:drm_crtc_vblank_helper_get_vblank_timestamp_internal] crtc 0 : scanoutpos query failed.

So it looks like we've been falling back to DRM's core fallback for a while
now, whoops.

So, while it seems that we do have the option of doing this through GSP -
that doesn't seem like a great idea. Mainly because reading this from GSP
would involve a lot more latency then we should have for vblank handling
due to the RPC communication. So instead of implementing that, just use
gv100_head_state and gv100_head_rgpos for implementing .state and .rgpos.
It seems to work perfectly fine!

Fixes: 9e9944449023 ("drm/nouveau/disp/r535: initial support")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Timur Tabi <ttabi@nvidia.com>
Cc: Ben Skeggs <bskeggs@nvidia.com>
Cc: James Jones <jajones@nvidia.com>
Cc: Faith Ekstrand <faith.ekstrand@collabora.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Aaron Kling <webgeek1234@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Zhang Enpei <zhang.enpei@zte.com.cn>
Cc: <stable@vger.kernel.org> # v6.7+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260429030348.3930866-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c |    4 ++--
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h  |    2 ++
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c  |    8 ++------
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c
@@ -253,7 +253,7 @@ gv100_head_vblank_get(struct nvkm_head *
 	nvkm_mask(device, 0x611d80 + (head->id * 4), 0x00000004, 0x00000004);
 }
 
-static void
+void
 gv100_head_rgpos(struct nvkm_head *head, u16 *hline, u16 *vline)
 {
 	struct nvkm_device *device = head->disp->engine.subdev.device;
@@ -263,7 +263,7 @@ gv100_head_rgpos(struct nvkm_head *head,
 	*hline = nvkm_rd32(device, 0x616334 + hoff) & 0x0000ffff;
 }
 
-static void
+void
 gv100_head_state(struct nvkm_head *head, struct nvkm_head_state *state)
 {
 	struct nvkm_device *device = head->disp->engine.subdev.device;
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h
@@ -53,6 +53,8 @@ void gf119_head_rgclk(struct nvkm_head *
 
 int gv100_head_cnt(struct nvkm_disp *, unsigned long *);
 int gv100_head_new(struct nvkm_disp *, int id);
+void gv100_head_state(struct nvkm_head *head, struct nvkm_head_state *state);
+void gv100_head_rgpos(struct nvkm_head *head, u16 *hline, u16 *vline);
 
 #define HEAD_MSG(h,l,f,a...) do {                                              \
 	struct nvkm_head *_h = (h);                                            \
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
@@ -623,14 +623,10 @@ r535_head_vblank_get(struct nvkm_head *h
 	nvkm_mask(device, 0x611d80 + (head->id * 4), 0x00000002, 0x00000002);
 }
 
-static void
-r535_head_state(struct nvkm_head *head, struct nvkm_head_state *state)
-{
-}
-
 static const struct nvkm_head_func
 r535_head = {
-	.state = r535_head_state,
+	.state = gv100_head_state,
+	.rgpos = gv100_head_rgpos,
 	.vblank_get = r535_head_vblank_get,
 	.vblank_put = r535_head_vblank_put,
 };


