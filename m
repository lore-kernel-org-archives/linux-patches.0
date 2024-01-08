Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5295101D;
	Mon,  8 Jan 2024 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOkn21tD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F46C433CB;
	Mon,  8 Jan 2024 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728445;
	bh=IXqUNCjznSSY/yQzj8A0KZzLepv5DhZ/WuP6aTEs1Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOkn21tD9Zll8IrW1rbLG2HncG3AHfSIhqzZCFpubZVP3zGz30PgN10nG6L7xprAC
	 EwPT1shjwWRU60fpqU900iuigTSeaXBkHtCi+zZ07Q7UBkTOh6KJRxE6BWmn7oGBSe
	 V4acDgbF74LIVE5BtohCA+6K6R2CBwzXZVNGPO+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/150] fbdev: imsttfb: fix double free in probe()
Date: Mon,  8 Jan 2024 16:35:29 +0100
Message-ID: <20240108153514.816570277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e08c30efda21ef4c0ec084a3a9581c220b442ba9 ]

The init_imstt() function calls framebuffer_release() on error and then
the probe() function calls it again.  It should only be done in probe.

Fixes: 518ecb6a209f ("fbdev: imsttfb: Fix error path of imsttfb_probe()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 3d1ae5267a738..aa51cb72cbba5 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1419,7 +1419,6 @@ static int init_imstt(struct fb_info *info)
 	if ((info->var.xres * info->var.yres) * (info->var.bits_per_pixel >> 3) > info->fix.smem_len
 	    || !(compute_imstt_regvals(par, info->var.xres, info->var.yres))) {
 		printk("imsttfb: %ux%ux%u not supported\n", info->var.xres, info->var.yres, info->var.bits_per_pixel);
-		framebuffer_release(info);
 		return -ENODEV;
 	}
 
@@ -1452,14 +1451,11 @@ static int init_imstt(struct fb_info *info)
 	              FBINFO_HWACCEL_FILLRECT |
 	              FBINFO_HWACCEL_YPAN;
 
-	if (fb_alloc_cmap(&info->cmap, 0, 0)) {
-		framebuffer_release(info);
+	if (fb_alloc_cmap(&info->cmap, 0, 0))
 		return -ENODEV;
-	}
 
 	if (register_framebuffer(info) < 0) {
 		fb_dealloc_cmap(&info->cmap);
-		framebuffer_release(info);
 		return -ENODEV;
 	}
 
-- 
2.43.0



