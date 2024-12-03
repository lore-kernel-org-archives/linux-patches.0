Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83781E3DCF;
	Tue,  3 Dec 2024 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241630; cv=none; b=kkhrnesbCesulxIZmRFZeLser7QVbrPR+1gcSefKHpMa2OThbFeCDZGhlMBCvpMgVoB49Jqwa4AM6Sv3oGlzB8097lYYiVwuBDn2lA5qk4tx57cH9oIl1+ngz2JewznoIoMljkq952Dw0+eQaXonMLDl0CJd26Y//K/TpJemK08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241630; c=relaxed/simple;
	bh=C6vp2ZumRNQSrx522167lTCUN6OothOBf29x/Qoow6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ8y8jz/J8wU03CJBMf3UpQpHjYEifh+yagQYzjod7GNNIeMcEgSj+CaEm/hQ36hOzGtlbHVE/21PMJeN/Jd94e0so/dLWhlaIy+QUDBgI1UgahTHliKxr2SP4mLJqDQht+Hm/ncoAMVSxJ0lc2bBc/LIDUMjmx7F6e7jbkFtjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glcXP92p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glcXP92p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F03DC4CED6;
	Tue,  3 Dec 2024 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241629;
	bh=C6vp2ZumRNQSrx522167lTCUN6OothOBf29x/Qoow6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glcXP92pH9VzyBOeGR2p9nL2nKlWs+pUw77Ox3L+WLVvncK6oCf7m4E3+Qs8hqTrh
	 OoRhxNLf4/T1Bq2uUw/V1a0FvNKhLBJLi2mqMml3Xf+OEAaceTbwKmPJ2jptHqMc8q
	 IJo4FnzF8QrYMAiKhTrz0GritMBBX+eQUPRkDC+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/826] fbdev: sh7760fb: Fix a possible memory leak in sh7760fb_alloc_mem()
Date: Tue,  3 Dec 2024 15:42:52 +0100
Message-ID: <20241203144801.119527223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit f89d17ae2ac42931be2a0153fecbf8533280c927 ]

When information such as info->screen_base is not ready, calling
sh7760fb_free_mem() does not release memory correctly. Call
dma_free_coherent() instead.

Fixes: 4a25e41831ee ("video: sh7760fb: SH7760/SH7763 LCDC framebuffer driver")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh7760fb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sh7760fb.c b/drivers/video/fbdev/sh7760fb.c
index 3d2a27fefc874..130adef2e4686 100644
--- a/drivers/video/fbdev/sh7760fb.c
+++ b/drivers/video/fbdev/sh7760fb.c
@@ -409,12 +409,11 @@ static int sh7760fb_alloc_mem(struct fb_info *info)
 		vram = PAGE_SIZE;
 
 	fbmem = dma_alloc_coherent(info->device, vram, &par->fbdma, GFP_KERNEL);
-
 	if (!fbmem)
 		return -ENOMEM;
 
 	if ((par->fbdma & SH7760FB_DMA_MASK) != SH7760FB_DMA_MASK) {
-		sh7760fb_free_mem(info);
+		dma_free_coherent(info->device, vram, fbmem, par->fbdma);
 		dev_err(info->device, "kernel gave me memory at 0x%08lx, which is"
 			"unusable for the LCDC\n", (unsigned long)par->fbdma);
 		return -ENOMEM;
-- 
2.43.0



