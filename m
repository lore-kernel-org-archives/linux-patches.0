Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F73A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egJNXCVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B52CC433C8;
	Wed, 15 Nov 2023 19:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077902;
	bh=SW6CaQVTNqMtK+Hyr004yBAtXRT9GOqshwtO6KnkyvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egJNXCVSa3I4Pp3uoRPeztR/3ZheJBxMY4RQ3A/UnK7WiOTkCD6iOKabOH6KQec4j
	 I9DWmidAHpwf5gaGrxyi7I9LueklFG+eKku+0gYLoVTTZ5X4qKI+sEfHaTJfw30Sq8
	 BHlg4ygZqF1VHKuJ+JeOBk5nSd07IoAi6uQbL/jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 590/603] fbdev: imsttfb: fix double free in probe()
Date: Wed, 15 Nov 2023 14:18:55 -0500
Message-ID: <20231115191652.062536001@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f4c8677488fb8..1b322ac35d863 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1419,7 +1419,6 @@ static int init_imstt(struct fb_info *info)
 	if ((info->var.xres * info->var.yres) * (info->var.bits_per_pixel >> 3) > info->fix.smem_len
 	    || !(compute_imstt_regvals(par, info->var.xres, info->var.yres))) {
 		printk("imsttfb: %ux%ux%u not supported\n", info->var.xres, info->var.yres, info->var.bits_per_pixel);
-		framebuffer_release(info);
 		return -ENODEV;
 	}
 
@@ -1451,14 +1450,11 @@ static int init_imstt(struct fb_info *info)
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
2.42.0



