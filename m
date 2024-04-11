Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1925C145B28;
	Thu, 11 Apr 2024 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830437; cv=none; b=UFSOSTVZQuR6PSz5hSY6tVdBHby4mHNeoCp56cRposyB5ZffWH/Zi3MLQQ3dQr8ossAyQjDiAFlYppYXD21Y+dsePByoV8JXClF3VmY3J+lzwd3sBSG7fS/R1ZbXr9XCEFbCGVnxbImiktqotEONBRIGytTc1yHIvfA5EnlV5Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830437; c=relaxed/simple;
	bh=MyU0IAWzR6C2RY3EXP2BPALFUp0kNTMtwHMuwlYE2/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pvx2kh1cd9LeXD0g054lFC7G0+TE76OBPYAxDr5P6l9vSOVplY5FOyxZQb8drGUZrJlvC/7eNlL8Kl380qWhljjlfNnBmEBj7tnyTWNVxKhIXQn3TVrqptCUNDUXoaaWyoXib9mcHyu4wGZD7JK3gF77yrE2vrpsbRVVlhKL0Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hir788aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hir788aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B8DC433C7;
	Thu, 11 Apr 2024 10:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830437;
	bh=MyU0IAWzR6C2RY3EXP2BPALFUp0kNTMtwHMuwlYE2/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hir788aCsOXCpXquQLM2h1GFf0cMeUU8afkXTAqEH0wraKmYs3e+ba+sYA63OmKMl
	 lpZ9HVXQoSMO9YqYVFawwTjzpIe24BVLTSADGjz5AqHUrbAOaJvRzFtBkwf0e7JTSu
	 tzjSib7fFgvNmQtk58CeW06Rv0OAixOnk7JDbbG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 138/143] nouveau: fix devinit paths to only handle display on GSP.
Date: Thu, 11 Apr 2024 11:56:46 +0200
Message-ID: <20240411095425.054960679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

[ Upstream commit 718c4fb221dbeff9072810841b949413c5ffc345 ]

This reverts:
nouveau/gsp: don't check devinit disable on GSP.
and applies a further fix.

It turns out the open gpu driver, checks this register,
but only for display.

Match that behaviour and in the turing path only disable
the display block. (ampere already only does displays).

Fixes: 5d4e8ae6e57b ("nouveau/gsp: don't check devinit disable on GSP.")
Reviewed-by: Danilo Krummrich <dakr@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240408064243.2219527-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm107.c | 12 ++++++++----
 drivers/gpu/drm/nouveau/nvkm/subdev/devinit/r535.c  |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm107.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm107.c
index 7bcbc4895ec22..271bfa038f5bc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm107.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm107.c
@@ -25,6 +25,7 @@
 
 #include <subdev/bios.h>
 #include <subdev/bios/init.h>
+#include <subdev/gsp.h>
 
 void
 gm107_devinit_disable(struct nvkm_devinit *init)
@@ -33,10 +34,13 @@ gm107_devinit_disable(struct nvkm_devinit *init)
 	u32 r021c00 = nvkm_rd32(device, 0x021c00);
 	u32 r021c04 = nvkm_rd32(device, 0x021c04);
 
-	if (r021c00 & 0x00000001)
-		nvkm_subdev_disable(device, NVKM_ENGINE_CE, 0);
-	if (r021c00 & 0x00000004)
-		nvkm_subdev_disable(device, NVKM_ENGINE_CE, 2);
+	/* gsp only wants to enable/disable display */
+	if (!nvkm_gsp_rm(device->gsp)) {
+		if (r021c00 & 0x00000001)
+			nvkm_subdev_disable(device, NVKM_ENGINE_CE, 0);
+		if (r021c00 & 0x00000004)
+			nvkm_subdev_disable(device, NVKM_ENGINE_CE, 2);
+	}
 	if (r021c04 & 0x00000001)
 		nvkm_subdev_disable(device, NVKM_ENGINE_DISP, 0);
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/r535.c
index 11b4c9c274a1a..666eb93b1742c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/r535.c
@@ -41,6 +41,7 @@ r535_devinit_new(const struct nvkm_devinit_func *hw,
 
 	rm->dtor = r535_devinit_dtor;
 	rm->post = hw->post;
+	rm->disable = hw->disable;
 
 	ret = nv50_devinit_new_(rm, device, type, inst, pdevinit);
 	if (ret)
-- 
2.43.0



