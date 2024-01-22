Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BFF5662;
	Tue, 23 Jan 2024 00:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969503; cv=none; b=C4vagdQRmTx+k+7+NFXYSIHbywew26FdI4vacelhy8FR5xn6PLPSot5Fs5M5Rd6kluBudFNNw6qYEfllHY5DKXCeeoGxa0kzomBHr27Q7Z5hM2kL+apEwQksY7LVQEDKLfSGJLG+I76DszY7S1dy5sUfz+aBmTBaaeQiKYBjVdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969503; c=relaxed/simple;
	bh=0DXwUaR0VggXMxYkKz32oLwLHF1KUpZrtX3PhcO0yeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j44/Y73E0acvX6KLUNXBKCv7wY+OMdQobuqvD0ck1fGc+gpGrrDxMbmLNU9iZ/71MSgI9648utpYU4bk/Y/n1FrwlDwGo5DOHr3a0kHPk1SO4/+RPiFKd6+MjShHREZoI6yv/C99oNfddDPrz+O4GTVXXrajxhpf9PDQHPq1LgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwQQcsbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwQQcsbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19174C433A6;
	Tue, 23 Jan 2024 00:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969503;
	bh=0DXwUaR0VggXMxYkKz32oLwLHF1KUpZrtX3PhcO0yeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwQQcsbOn68XpQvyN6no3Hw5Xv1xRduXnSx51LllB4vvAPvYFF/LhA1YuJv7ZLWEr
	 b288lJrkT0AFJoVEUIhlaX26CF7Ec79y4AJr8Tv1D8qiqoW1sI8ij0wvMb89V92VPv
	 RllGbY4cF58/nFt83o47xn3XtT3pVkw1chABmD6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Teddy Wang <teddy.wang@siliconmotion.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-fbdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 265/641] fbdev/sm712fb: Use correct initializer macros for struct fb_ops
Date: Mon, 22 Jan 2024 15:52:49 -0800
Message-ID: <20240122235826.218003281@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 12d55c013a09a2d490f004a324c20800e4ff35ec ]

Only initialize mmap and draw helpers with macros; leave read/write
callbacks to driver implementations. Fixes the following warnings:

  CC [M]  drivers/video/fbdev/sm712fb.o
  sm712fb.c:1355:25: warning: initialized field overwritten [-Woverride-init]
  1355 |         .fb_fillrect  = cfb_fillrect,
       |                         ^~~~~~~~~~~~
  sm712fb.c:1355:25: note: (near initialization for 'smtcfb_ops.fb_fillrect')
  sm712fb.c:1356:25: warning: initialized field overwritten [-Woverride-init]
  1356 |         .fb_imageblit = cfb_imageblit,
       |                         ^~~~~~~~~~~~~
  sm712fb.c:1356:25: note: (near initialization for 'smtcfb_ops.fb_imageblit')
  sm712fb.c:1357:25: warning: initialized field overwritten [-Woverride-init]
  1357 |         .fb_copyarea  = cfb_copyarea,
       |                         ^~~~~~~~~~~~
  sm712fb.c:1357:25: note: (near initialization for 'smtcfb_ops.fb_copyarea')
  sm712fb.c:1358:25: warning: initialized field overwritten [-Woverride-init]
  1358 |         .fb_read      = smtcfb_read,
       |                         ^~~~~~~~~~~
  sm712fb.c:1358:25: note: (near initialization for 'smtcfb_ops.fb_read')
  sm712fb.c:1359:25: warning: initialized field overwritten [-Woverride-init]
  1359 |         .fb_write     = smtcfb_write,
       |                         ^~~~~~~~~~~~
  sm712fb.c:1359:25: note: (near initialization for 'smtcfb_ops.fb_write')

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 586132cf1d38 ("fbdev/sm712fb: Initialize fb_ops to fbdev I/O-memory helpers")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fbdev@vger.kernel.org
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127131655.4020-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm712fb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 3f8ef50e3209..104f122e0f27 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1347,16 +1347,14 @@ static int smtc_set_par(struct fb_info *info)
 
 static const struct fb_ops smtcfb_ops = {
 	.owner        = THIS_MODULE,
-	FB_DEFAULT_IOMEM_OPS,
 	.fb_check_var = smtc_check_var,
 	.fb_set_par   = smtc_set_par,
 	.fb_setcolreg = smtc_setcolreg,
 	.fb_blank     = smtc_blank,
-	.fb_fillrect  = cfb_fillrect,
-	.fb_imageblit = cfb_imageblit,
-	.fb_copyarea  = cfb_copyarea,
+	__FB_DEFAULT_IOMEM_OPS_DRAW,
 	.fb_read      = smtcfb_read,
 	.fb_write     = smtcfb_write,
+	__FB_DEFAULT_IOMEM_OPS_MMAP,
 };
 
 /*
-- 
2.43.0



