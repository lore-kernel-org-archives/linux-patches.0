Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D77E15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACA0C433D6;
	Tue,  8 Nov 2022 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915760;
	bh=P/dKi00nqYsKddUPWFkuhSbz9HUs8JGCLjgIgv6rD5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwsUBt4PqZ+EOmooId67/UbNLTHnroy13XM/ZTP6y4xFmIy/uyNfuoA/0V32OlC8O
	 zfm1ThCSSnp8jy0ZWDOhbFpQ+0nXGP8ocOy+sK0/buBRgJ4u3xB/VvOF3lTfz788hC
	 k00MDememuMgzyi6M6u1qZ+tKFUygJ13g1uwpv/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/118] fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards
Date: Tue,  8 Nov 2022 14:38:51 +0100
Message-Id: <20221108133343.008901111@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 776d875fd4cbb3884860ea7f63c3958f02b0c80e ]

When the text console is scrolling text upwards it calls the fillrect()
function to empty the new line. The current implementation doesn't seem
to work correctly on HCRX cards in 32-bit mode and leave garbage in that
line instead. Fix it by falling back to standard cfb_fillrect() in that
case.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/stifb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 7753e586e65a..3feb6e40d56d 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1055,7 +1055,8 @@ stifb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 {
 	struct stifb_info *fb = container_of(info, struct stifb_info, info);
 
-	if (rect->rop != ROP_COPY)
+	if (rect->rop != ROP_COPY ||
+	    (fb->id == S9000_ID_HCRX && fb->info.var.bits_per_pixel == 32))
 		return cfb_fillrect(info, rect);
 
 	SETUP_HW(fb);
-- 
2.35.1



