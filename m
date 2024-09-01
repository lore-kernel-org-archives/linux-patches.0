Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD2B183090;
	Sun,  1 Sep 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207807; cv=none; b=m013SO27bVQSndkZSJvBpQ6VWH1wv2sXrUj0+qH79I/ixFqx7/Q3vk0+sj6VqYKGxH+16V4bIFT9A22Hx04yllSYBrAw4LP8ynUhQgtbv89BYggI7kxlA+YIoxoF612HXOzuE89BO/H2IiI5iXVyCE7XMPQYhOV0FkdLBubitPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207807; c=relaxed/simple;
	bh=4LE36Gmeh5dUvzzB+TKF9HiR0+kHsHb66Xf2NsgXR0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX0KJ92BXG44n5aZdQxKu96r/C9i2WS9CCL3xXbu+Y2tgJ8SRz2e7XkoCnGqli6lg9yiqomRTRyfPCn+hsY95qi6vR20b0cVkAM7VhU8vkycpRlcue3LX4QcQRmTrGBhzxGPonNFOWx0CJnd/PLgtjA044kOkJXnEYvzvPE6i80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yinq472D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yinq472D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F22C4CEC3;
	Sun,  1 Sep 2024 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207807;
	bh=4LE36Gmeh5dUvzzB+TKF9HiR0+kHsHb66Xf2NsgXR0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yinq472DAKVnMHX/ZUchBAZDnkUBR9VBgSkumJUjFYaR/aEPgSsG6OUEeFp5NSiH4
	 pPV/0dZ5s5BoN0tbnrqE/ZscLjqLzJnn7mCfgWZw+PnCtHf2xXrvsJvXcC84FI51UW
	 0StXlLeSI0TnYYmDYxI7MvEBkBbhetFqsx1Awjns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 83/98] fbmem: Check virtual screen sizes in fb_set_var()
Date: Sun,  1 Sep 2024 18:16:53 +0200
Message-ID: <20240901160806.827529554@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 6c11df58fd1ac0aefcb3b227f72769272b939e56 upstream.

Verify that the fbdev or drm driver correctly adjusted the virtual
screen sizes. On failure report the failing driver and reject the screen
size change.

Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1006,6 +1006,17 @@ fb_set_var(struct fb_info *info, struct
 		if (ret)
 			goto done;
 
+		/* verify that virtual resolution >= physical resolution */
+		if (var->xres_virtual < var->xres ||
+		    var->yres_virtual < var->yres) {
+			pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
+				info->fix.id,
+				var->xres_virtual, var->yres_virtual,
+				var->xres, var->yres);
+			ret = -EINVAL;
+			goto done;
+		}
+
 		if ((var->activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW) {
 			struct fb_var_screeninfo old_var;
 			struct fb_videomode mode;


