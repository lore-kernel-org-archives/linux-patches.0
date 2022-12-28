Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E2CC433EF;
	Wed, 28 Dec 2022 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241650;
	bh=MtJxME0daBU8mxhlgoTcfsB+TZFPAlcvqI2POhUuFIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzXXRta31oFtC7Byoiie2D1SPc86m4e8MV34MqBqPdSvkupdikdyIR4R6WimbwI9F
	 wA3t9ltmpAN1cVVObWD3m9j5yG8PDxLo9ONg93k496Vm5qLmzshXjuu6zmTU7Fy61i
	 yXHlW4tY9eCKN0y2mk8LaMjWY1XFCtfpx3JyRu9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/731] fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()
Date: Wed, 28 Dec 2022 15:40:14 +0100
Message-Id: <20221228144311.243019046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit c84bf485a5aaf9aa0764a58832b7ef4375c29f03 ]

The clk_disable_unprepare() should be called in the error handling
of register_framebuffer(), fix it.

Fixes: 0937a7b3625d ("video: ep93xx: Prepare clock before using it")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ep93xx-fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ep93xx-fb.c b/drivers/video/fbdev/ep93xx-fb.c
index 2398b3d48fed..305f1587bd89 100644
--- a/drivers/video/fbdev/ep93xx-fb.c
+++ b/drivers/video/fbdev/ep93xx-fb.c
@@ -552,12 +552,14 @@ static int ep93xxfb_probe(struct platform_device *pdev)
 
 	err = register_framebuffer(info);
 	if (err)
-		goto failed_check;
+		goto failed_framebuffer;
 
 	dev_info(info->dev, "registered. Mode = %dx%d-%d\n",
 		 info->var.xres, info->var.yres, info->var.bits_per_pixel);
 	return 0;
 
+failed_framebuffer:
+	clk_disable_unprepare(fbi->clk);
 failed_check:
 	if (fbi->mach_info->teardown)
 		fbi->mach_info->teardown(pdev);
-- 
2.35.1



