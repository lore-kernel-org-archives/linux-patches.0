Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC841E48E;
	Thu, 11 Apr 2024 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832679; cv=none; b=EbVwF4+EhGOh5dUviEndLEeanY3gtd+0oJwFiZMxohgNTR74yx8WxSmiJHJztLwJPolfJjnBZUTMk6afYQMhTZs0V9UQenTVRuc2pblCMHUxDEWD7Cdkjj7IE8R4qHpNzvvzL0d5dRtEtc6awqKfuWAnT6xzTy15rCA+LTFonvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832679; c=relaxed/simple;
	bh=jMnytF2zrywdmJrUkPs1nXl35BJwHHP4wNvHNJFAJ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C292p1jvZbGeLu7jockZByFXsez4YW+oHSyvG6PM/tP+V6Vyu1x8/VMkKAoh6g9puze3IANhuVed9jE6/zw4KU8p7/KxNo/gIqIIv7nhlaIniKCsoXFbeZJImgfa+OJoQNbXojRsV6ealQlXEZLlvSKuBFKKl5inJlqBkuewib8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWLiDfvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWLiDfvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16737C433C7;
	Thu, 11 Apr 2024 10:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832679;
	bh=jMnytF2zrywdmJrUkPs1nXl35BJwHHP4wNvHNJFAJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWLiDfviI18yEDM58SC5MFynYcljYu9hwzbBx3O0ZymdXiHCpiU1icr/hpKDiF2rq
	 9+/J30Z0S38//JUex6sZEyo1cKvA1u2ehPbPIwoLRpGunoAFmIIfvy6/1zg4o3K0CX
	 ij0o6s89T0BquyMu+ZBDbpHkx6nlK+PDWABvgDm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/57] fbmon: prevent division by zero in fb_videomode_from_videomode()
Date: Thu, 11 Apr 2024 11:57:53 +0200
Message-ID: <20240411095409.352978961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit c2d953276b8b27459baed1277a4fdd5dd9bd4126 ]

The expression htotal * vtotal can have a zero value on
overflow. It is necessary to prevent division by zero like in
fb_var_to_videomode().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
index b0e690f41025a..9ca99da3a56a0 100644
--- a/drivers/video/fbdev/core/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -1311,7 +1311,7 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
 int fb_videomode_from_videomode(const struct videomode *vm,
 				struct fb_videomode *fbmode)
 {
-	unsigned int htotal, vtotal;
+	unsigned int htotal, vtotal, total;
 
 	fbmode->xres = vm->hactive;
 	fbmode->left_margin = vm->hback_porch;
@@ -1344,8 +1344,9 @@ int fb_videomode_from_videomode(const struct videomode *vm,
 	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
 		 vm->vsync_len;
 	/* prevent division by zero */
-	if (htotal && vtotal) {
-		fbmode->refresh = vm->pixelclock / (htotal * vtotal);
+	total = htotal * vtotal;
+	if (total) {
+		fbmode->refresh = vm->pixelclock / total;
 	/* a mode must have htotal and vtotal != 0 or it is invalid */
 	} else {
 		fbmode->refresh = 0;
-- 
2.43.0



