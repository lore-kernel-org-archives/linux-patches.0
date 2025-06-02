Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C007D22DA0C;
	Mon,  2 Jun 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873797; cv=none; b=KVq3OVyXwSZ11iXOk9BKlAVzxRl6GyCmg7TEDypTCgfQahQAlsY+/MsgEO13WCweSjf74sL1Ubz4IIeO5F8OXwyatoKuNCJKEoQQk2KhTJlNkppnKTbe2bh+0oF8ZuFp8YfSm5YdRcrHpzVKGl4ES6SgEsqulmZnZFv2/OBKweg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873797; c=relaxed/simple;
	bh=BGK5kVP04FKe7WwtsRpVBbzZbqoD7gxvjFx5KvYEcYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewnn5NIGfYuVrd68tAZOpAhwGie/qHgpPh6AM1eAD4DLaunIGM+2/uoQy3OQxpomYxZrvosHUSscg7ALMDqt3Hd6GDfFv55UVEb2ktzVAH2TL8MDjfT5vZDdnJjom9ZLQ1VsgliXfzScBFdTr4fRncSAxG8Z1hBygVlRKwHRpT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YWo+UJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YWo+UJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF9EC4CEF0;
	Mon,  2 Jun 2025 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873797;
	bh=BGK5kVP04FKe7WwtsRpVBbzZbqoD7gxvjFx5KvYEcYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YWo+UJ+wrjbKT1F0BmD4IbaweLsBo8CSC0Q3zodithHk5Y8kPpDECI6XHkz6PwVN
	 Us69B9+uk4RUwY/HCnyIWND9LHBD++CaGNBSOFsAUUJ5+Gtc7FaK/VQbdncxfEzB7d
	 ExFGNlv7I2pMI0z4lqXHogM/52wb6v2cTS6VHA5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/444] drm/v3d: Add clock handling
Date: Mon,  2 Jun 2025 15:45:20 +0200
Message-ID: <20250602134351.320096475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 4dd40b5f9c3d89b67af0dbe059cf4a51aac6bf06 ]

Since the initial commit 57692c94dcbe ("drm/v3d: Introduce a new DRM driver
for Broadcom V3D V3.x+") the struct v3d_dev reserved a pointer for
an optional V3D clock. But there wasn't any code, which fetched it.
So add the missing clock handling before accessing any V3D registers.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250201125046.33030-1-wahrenst@gmx.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index ffbbe9d527d32..0e8ea99011884 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -226,11 +226,21 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	v3d->clk = devm_clk_get_optional(dev, NULL);
+	if (IS_ERR(v3d->clk))
+		return dev_err_probe(dev, PTR_ERR(v3d->clk), "Failed to get V3D clock\n");
+
+	ret = clk_prepare_enable(v3d->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't enable the V3D clock\n");
+		return ret;
+	}
+
 	mmu_debug = V3D_READ(V3D_MMU_DEBUG_INFO);
 	mask = DMA_BIT_MASK(30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_PA_WIDTH));
 	ret = dma_set_mask_and_coherent(dev, mask);
 	if (ret)
-		return ret;
+		goto clk_disable;
 
 	v3d->va_width = 30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_VA_WIDTH);
 
@@ -245,28 +255,29 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 		ret = PTR_ERR(v3d->reset);
 
 		if (ret == -EPROBE_DEFER)
-			return ret;
+			goto clk_disable;
 
 		v3d->reset = NULL;
 		ret = map_regs(v3d, &v3d->bridge_regs, "bridge");
 		if (ret) {
 			dev_err(dev,
 				"Failed to get reset control or bridge regs\n");
-			return ret;
+			goto clk_disable;
 		}
 	}
 
 	if (v3d->ver < 41) {
 		ret = map_regs(v3d, &v3d->gca_regs, "gca");
 		if (ret)
-			return ret;
+			goto clk_disable;
 	}
 
 	v3d->mmu_scratch = dma_alloc_wc(dev, 4096, &v3d->mmu_scratch_paddr,
 					GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
 	if (!v3d->mmu_scratch) {
 		dev_err(dev, "Failed to allocate MMU scratch page\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto clk_disable;
 	}
 
 	ret = v3d_gem_init(drm);
@@ -289,6 +300,8 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 	v3d_gem_destroy(drm);
 dma_free:
 	dma_free_wc(dev, 4096, v3d->mmu_scratch, v3d->mmu_scratch_paddr);
+clk_disable:
+	clk_disable_unprepare(v3d->clk);
 	return ret;
 }
 
@@ -303,6 +316,8 @@ static void v3d_platform_drm_remove(struct platform_device *pdev)
 
 	dma_free_wc(v3d->drm.dev, 4096, v3d->mmu_scratch,
 		    v3d->mmu_scratch_paddr);
+
+	clk_disable_unprepare(v3d->clk);
 }
 
 static struct platform_driver v3d_platform_driver = {
-- 
2.39.5



