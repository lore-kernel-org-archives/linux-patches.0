Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C99C13DBA0;
	Mon, 16 Sep 2024 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488481; cv=none; b=uiQ4RvmapoYkCkFTU55hxQV8CRntuo9fMgUME0r/Dra0I3Rf9hf9Zk6bE29SUpCWuOwRRu2+cPAFFEB75nUFSKYYqfv7r7eQ3XgizWxvYy8tp/I/YY/C/oRWX/Th+zOuPkjF1FHuV09v4fdOoPM52RAYiYHhWNMK9wmkaN/7Ma4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488481; c=relaxed/simple;
	bh=IpfzF2RuzOJLkTtSQYxKijihcb7Iw1TspsDhhA3M//A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8zCTMkp+ngJVKzyg+tqAErYsNDlmx1VPPTid4fKQWRdmNJH4s0pHERDc9BR4Xx9pUvl62nrjsiSPBLPvAvcyOA7QSNtJiA1VVlgL/8/zh74WzYrrc60/N+VKewFFwhdXeAWYlNGrr6jZiq+u2WfeySjY6qbLkijnJBqb6n2AUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkFjDMRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkFjDMRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97E0C4CEC4;
	Mon, 16 Sep 2024 12:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488481;
	bh=IpfzF2RuzOJLkTtSQYxKijihcb7Iw1TspsDhhA3M//A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkFjDMRHsFQsZ28sMqnhb83iBqFZpO8/9BLkgtWp0M6vIBcjwYcKrK+iimpqGzX8O
	 bddkYHs71voEi8R0Qj4R9HwMyvETJLUFi6akhPy6Xw71Hw7E8//0PdbMbLow0DmPzI
	 H11YM0GbrE3ai6pcYhN9GcxfQ7Z8tMe8BEI5C/3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.10 102/121] drm/nouveau/fb: restore init() for ramgp102
Date: Mon, 16 Sep 2024 13:44:36 +0200
Message-ID: <20240916114232.494821754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@nvidia.com>

commit 6db9df4f7055eb4ea339e7b83ca676edd9ec1277 upstream.

init() was removed from ramgp102 when reworking the memory detection, as
it was thought that the code was only necessary when the driver performs
mclk changes, which nouveau doesn't support on pascal.

However, it turns out that we still need to execute this on some GPUs to
restore settings after DEVINIT, so revert to the original behaviour.

v2: fix tags in commit message, cc stable

Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/319
Fixes: 2c0c15a22fa0 ("drm/nouveau/fb/gp102-ga100: switch to simpler vram size detection method")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240904232418.8590-1-bskeggs@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ram.h      |    2 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp100.c |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp102.c |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ram.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ram.h
@@ -46,6 +46,8 @@ u32 gm107_ram_probe_fbp(const struct nvk
 u32 gm200_ram_probe_fbp_amount(const struct nvkm_ram_func *, u32,
 			       struct nvkm_device *, int, int *);
 
+int gp100_ram_init(struct nvkm_ram *);
+
 /* RAM type-specific MR calculation routines */
 int nvkm_sddr2_calc(struct nvkm_ram *);
 int nvkm_sddr3_calc(struct nvkm_ram *);
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp100.c
@@ -27,7 +27,7 @@
 #include <subdev/bios/init.h>
 #include <subdev/bios/rammap.h>
 
-static int
+int
 gp100_ram_init(struct nvkm_ram *ram)
 {
 	struct nvkm_subdev *subdev = &ram->fb->subdev;
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramgp102.c
@@ -5,6 +5,7 @@
 
 static const struct nvkm_ram_func
 gp102_ram = {
+	.init = gp100_ram_init,
 };
 
 int


