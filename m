Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6B168B6
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7828AC433D2;
	Mon, 22 May 2023 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782795;
	bh=R26zJtzdtddNubaKQC8tq6jK3Q8VjDVlXSJ6hBQOJuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZsoGb5nNbwWX7LevoTkSbKMH7Diow5+iuFK16m++PCGYGaHz3osfTHP//X8weynN
	 O/rMMXeLLifu/f6nUai8+gzH6xCBTEFNcit1KJyJ4Hn39eNbyZkroEbup43LmC5+ed
	 L/xS1mRXPKC8BEE2kJrb9EMptIoJRCwxwxT1wGgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongjie Li <u202112089@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/203] fbdev: arcfb: Fix error handling in arcfb_probe()
Date: Mon, 22 May 2023 20:07:27 +0100
Message-Id: <20230522190355.600813535@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zongjie Li <u202112089@hust.edu.cn>

[ Upstream commit 5a6bef734247c7a8c19511664ff77634ab86f45b ]

Smatch complains that:
arcfb_probe() warn: 'irq' from request_irq() not released on lines: 587.

Fix error handling in the arcfb_probe() function. If IO addresses are
not provided or framebuffer registration fails, the code will jump to
the err_addr or err_register_fb label to release resources.
If IRQ request fails, previously allocated resources will be freed.

Fixes: 1154ea7dcd8e ("[PATCH] Framebuffer driver for Arc LCD board")
Signed-off-by: Zongjie Li <u202112089@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/arcfb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/arcfb.c b/drivers/video/fbdev/arcfb.c
index 45e64016db328..024d0ee4f04f9 100644
--- a/drivers/video/fbdev/arcfb.c
+++ b/drivers/video/fbdev/arcfb.c
@@ -523,7 +523,7 @@ static int arcfb_probe(struct platform_device *dev)
 
 	info = framebuffer_alloc(sizeof(struct arcfb_par), &dev->dev);
 	if (!info)
-		goto err;
+		goto err_fb_alloc;
 
 	info->screen_base = (char __iomem *)videomemory;
 	info->fbops = &arcfb_ops;
@@ -535,7 +535,7 @@ static int arcfb_probe(struct platform_device *dev)
 
 	if (!dio_addr || !cio_addr || !c2io_addr) {
 		printk(KERN_WARNING "no IO addresses supplied\n");
-		goto err1;
+		goto err_addr;
 	}
 	par->dio_addr = dio_addr;
 	par->cio_addr = cio_addr;
@@ -551,12 +551,12 @@ static int arcfb_probe(struct platform_device *dev)
 			printk(KERN_INFO
 				"arcfb: Failed req IRQ %d\n", par->irq);
 			retval = -EBUSY;
-			goto err1;
+			goto err_addr;
 		}
 	}
 	retval = register_framebuffer(info);
 	if (retval < 0)
-		goto err1;
+		goto err_register_fb;
 	platform_set_drvdata(dev, info);
 	fb_info(info, "Arc frame buffer device, using %dK of video memory\n",
 		videomemorysize >> 10);
@@ -580,9 +580,12 @@ static int arcfb_probe(struct platform_device *dev)
 	}
 
 	return 0;
-err1:
+
+err_register_fb:
+	free_irq(par->irq, info);
+err_addr:
 	framebuffer_release(info);
-err:
+err_fb_alloc:
 	vfree(videomemory);
 	return retval;
 }
-- 
2.39.2



