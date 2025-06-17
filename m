Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E62E92CD;
	Tue, 17 Jun 2025 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178144; cv=none; b=DGEoZPaEkAPMLm1JvYKnssyifCEEwg6qZXFCJfcgvUDljklRS0xoVTYYhBOgfiVMAtNDovseW78BD9zFYw0p4yLZXyEXPyJ82aZgeBVLZDhSzVOTNu5QWEo8ObA2oPZjlkEmAbehbFZPrdn+F8VugWO6XyhNeexkyep3eaeV58U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178144; c=relaxed/simple;
	bh=4jgiDB1c4ICennXf5qRlsdpmcgdM5AA9d7RHwd86GS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXozTANMAi/EMGZ2DZwFmnNEnIZPL8wAyez2UBKAVp4rnSgvhyGsO9Gh/jMtyoG8yHRfwoCLqNDHOIy4r6RIz2pSJOKp0NNUip6KtkrEBMxA0ZA2pDzX8JPv4lg15lnj3cH7hBaJiUYEj5uAKdQwyCdt3RjqW/bE0osJNRZY85A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdIVUtmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdIVUtmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3951DC4CEE3;
	Tue, 17 Jun 2025 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178144;
	bh=4jgiDB1c4ICennXf5qRlsdpmcgdM5AA9d7RHwd86GS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdIVUtmx7xFZ1LNLyu3VXzqE9mdMGMQspZzOArjYjXAACbaxL4jUVs1+OQ/roR4wW
	 pGbdpkWXbEi15n8yIfl0lMMNRuLhUzRzu5v4+kHEbW/OEc5xgFzMLUpD/9NV8hBh0p
	 efDB1m1m5hSTxwKo+8stStcxK+WuVzj8hd/2TSzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 416/780] fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()
Date: Tue, 17 Jun 2025 17:22:04 +0200
Message-ID: <20250617152508.414646553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 3f6dae09fc8c306eb70fdfef70726e1f154e173a ]

In fb_find_mode_cvt(), iff mode->refresh somehow happens to be 0x80000000,
cvt.f_refresh will become 0 when multiplying it by 2 due to overflow. It's
then passed to fb_cvt_hperiod(), where it's used as a divider -- division
by 0 will result in kernel oops. Add a sanity check for cvt.f_refresh to
avoid such overflow...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 96fe6a2109db ("[PATCH] fbdev: Add VESA Coordinated Video Timings (CVT) support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcvt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcvt.c b/drivers/video/fbdev/core/fbcvt.c
index 64843464c6613..cd3821bd82e56 100644
--- a/drivers/video/fbdev/core/fbcvt.c
+++ b/drivers/video/fbdev/core/fbcvt.c
@@ -312,7 +312,7 @@ int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb)
 	cvt.f_refresh = cvt.refresh;
 	cvt.interlace = 1;
 
-	if (!cvt.xres || !cvt.yres || !cvt.refresh) {
+	if (!cvt.xres || !cvt.yres || !cvt.refresh || cvt.f_refresh > INT_MAX) {
 		printk(KERN_INFO "fbcvt: Invalid input parameters\n");
 		return 1;
 	}
-- 
2.39.5



