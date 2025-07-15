Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B52397BF;
	Tue, 15 Jul 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586060; cv=none; b=SkqWhx1Sb9Cnoh9rNHnhsFdawki15CFena0WnHY7Q1U9rrbz50EkoVTcORp1pqfxwVcs+CQ8XbWUvb6pRy/kG7vrQqHfPSzqCVmF+y6SiHl9NXjqpsZ+HYlCVUPaSE+g611pWg4W6L4RMdxdNzbLuEXqVWnCGlsh6OVb3fT3MqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586060; c=relaxed/simple;
	bh=dz+3jQjyYfu54lG1kZPfYTUxohwTyeLg6ZMkPASc30M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaqFhiU1EHUfIm4yI53nvGCT94Jh0LgSuw7pIE8Zw0WKEmMyJ+1Ca9W2GalyBB2huBS+BGIj4GAO/s4HfjDzb6RCTiQuAqrfC1DV7vXBg5nJmZyELfrFr1lqYYcdLURDQelwwGVxRUTiOCKEg454XWK0LcQh+SlYyKzLSLtE6WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmPsKLsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmPsKLsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04E5C4CEE3;
	Tue, 15 Jul 2025 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586060;
	bh=dz+3jQjyYfu54lG1kZPfYTUxohwTyeLg6ZMkPASc30M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmPsKLsLZChDIbLz5U4bUkA+a3J+2FsoQASF0o3DzRVm8tLerKhu0Dwh5sV/QJRQ/
	 wedR05RYPHmzeAkWoBzcxg2nNvMxKQXE1+HTjhu2VFkyhLElGvcNJRhHHio+XvrsUD
	 0MdqqLR4hmlGFoSwSuCkV9MzsZLOvFRGaxOHTKl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/109] drm/tegra: nvdec: Fix dma_alloc_coherent error check
Date: Tue, 15 Jul 2025 15:13:35 +0200
Message-ID: <20250715130802.043844264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 44306a684cd1699b8562a54945ddc43e2abc9eab ]

Check for NULL return value with dma_alloc_coherent, in line with
Robin's fix for vic.c in 'drm/tegra: vic: Fix DMA API misuse'.

Fixes: 46f226c93d35 ("drm/tegra: Add NVDEC driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250702-nvdec-dma-error-check-v1-1-c388b402c53a@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/nvdec.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/nvdec.c b/drivers/gpu/drm/tegra/nvdec.c
index 4860790666af5..14ef61b44f47c 100644
--- a/drivers/gpu/drm/tegra/nvdec.c
+++ b/drivers/gpu/drm/tegra/nvdec.c
@@ -261,10 +261,8 @@ static int nvdec_load_falcon_firmware(struct nvdec *nvdec)
 
 	if (!client->group) {
 		virt = dma_alloc_coherent(nvdec->dev, size, &iova, GFP_KERNEL);
-
-		err = dma_mapping_error(nvdec->dev, iova);
-		if (err < 0)
-			return err;
+		if (!virt)
+			return -ENOMEM;
 	} else {
 		virt = tegra_drm_alloc(tegra, size, &iova);
 		if (IS_ERR(virt))
-- 
2.39.5



