Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CD113AA4F;
	Tue, 27 Feb 2024 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040793; cv=none; b=P82eOButv5IlYXfGXQMPiTp67NwS3gymGE2FPHuSGAudjenQVLtl7e6SLv4zKqmAUtdIqNXCYB2P+uLxR5/Z0iOhevH5hjwMimv6r5Mu/oE4I4Sv8LSsoTSQ+ZTYoJVU35uKofnK8/otKn86/hjFJieTu+FFLnPMiQRQlyBGujY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040793; c=relaxed/simple;
	bh=QgMdVymL7v0RotrTh7Wx9EYObZ3gPNJk/xzYSVoYpow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3LEk7C5nx3kw3ZJWQdT4x3nrBJuKqY7S7eXfvdoGDq5PuxLdaSMAQ4LmIp6HIIS9Nlb35Aex4KLlpsqEFdRE8uVcDgSzhwZ9nNmf7hT4uiwNpE3H0+TXMkzI8PnCdI7A4Qms5UOGYT7LiZ7leyUdb8ub8WZ6RJ96Lm4+6UTFGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwd2JKp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwd2JKp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49667C433F1;
	Tue, 27 Feb 2024 13:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040793;
	bh=QgMdVymL7v0RotrTh7Wx9EYObZ3gPNJk/xzYSVoYpow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwd2JKp4fotfjt6lC8SRzfXAvtKZzObx2RCqcXgIaFkDxrk43Dkt/xicTaEamAdVJ
	 Tn0jjMgcHlUa9CI+kCplts1+4ViTUw0ZhksPlNRRPOONp262vJPGoQdgnjpKIYE4D9
	 Qq1Dotp3NHK/CPzlaQumDxAZ2uWoq1tX7nIZujwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 110/334] drm/nouveau: nvkm_gsp_radix3_sg() should use nvkm_gsp_mem_ctor()
Date: Tue, 27 Feb 2024 14:19:28 +0100
Message-ID: <20240227131634.027184881@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

[ Upstream commit 34e659f34a7559ecfd9c1f5b24d4c291f3f54711 ]

Function nvkm_gsp_radix3_sg() uses nvkm_gsp_mem objects to allocate the
radix3 tables, but it unnecessarily creates those objects manually
instead of using the standard nvkm_gsp_mem_ctor() function like the
rest of the code does.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240202230608.1981026-2-ttabi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 6208ddd929645..a41735ab60683 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1950,20 +1950,20 @@ nvkm_gsp_radix3_dtor(struct nvkm_gsp *gsp, struct nvkm_gsp_radix3 *rx3)
  * See kgspCreateRadix3_IMPL
  */
 static int
-nvkm_gsp_radix3_sg(struct nvkm_device *device, struct sg_table *sgt, u64 size,
+nvkm_gsp_radix3_sg(struct nvkm_gsp *gsp, struct sg_table *sgt, u64 size,
 		   struct nvkm_gsp_radix3 *rx3)
 {
 	u64 addr;
 
 	for (int i = ARRAY_SIZE(rx3->mem) - 1; i >= 0; i--) {
 		u64 *ptes;
-		int idx;
+		size_t bufsize;
+		int ret, idx;
 
-		rx3->mem[i].size = ALIGN((size / GSP_PAGE_SIZE) * sizeof(u64), GSP_PAGE_SIZE);
-		rx3->mem[i].data = dma_alloc_coherent(device->dev, rx3->mem[i].size,
-						      &rx3->mem[i].addr, GFP_KERNEL);
-		if (WARN_ON(!rx3->mem[i].data))
-			return -ENOMEM;
+		bufsize = ALIGN((size / GSP_PAGE_SIZE) * sizeof(u64), GSP_PAGE_SIZE);
+		ret = nvkm_gsp_mem_ctor(gsp, bufsize, &rx3->mem[i]);
+		if (ret)
+			return ret;
 
 		ptes = rx3->mem[i].data;
 		if (i == 2) {
@@ -2003,7 +2003,7 @@ r535_gsp_fini(struct nvkm_gsp *gsp, bool suspend)
 		if (ret)
 			return ret;
 
-		ret = nvkm_gsp_radix3_sg(gsp->subdev.device, &gsp->sr.sgt, len, &gsp->sr.radix3);
+		ret = nvkm_gsp_radix3_sg(gsp, &gsp->sr.sgt, len, &gsp->sr.radix3);
 		if (ret)
 			return ret;
 
@@ -2211,7 +2211,7 @@ r535_gsp_oneinit(struct nvkm_gsp *gsp)
 	memcpy(gsp->sig.data, data, size);
 
 	/* Build radix3 page table for ELF image. */
-	ret = nvkm_gsp_radix3_sg(device, &gsp->fw.mem.sgt, gsp->fw.len, &gsp->radix3);
+	ret = nvkm_gsp_radix3_sg(gsp, &gsp->fw.mem.sgt, gsp->fw.len, &gsp->radix3);
 	if (ret)
 		return ret;
 
-- 
2.43.0



