Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E3308F13;
	Mon,  1 Dec 2025 11:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588340; cv=none; b=cu7zF+rwNcsOZnSY9d1kmj9szkmAxLq+bM+s9IjOpMYU08PxOS/1A3SLDW+MzlDL9oMylizG2l3nSbj6vQ0pibk/IIO1alTS33lBLmkHKXh1jiG3J28ksFcOKb16RXjbE6uPoQZBA0FGPWjSTP4IX+xCiA0myYY3dXmPEryv+s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588340; c=relaxed/simple;
	bh=CPDMRrq2omHs54/Gl95i22yNrP9ftOn7XCPeuvVTtzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl9wJLrnOKiWWuUiecED+/fuboIrF26tQ7Pqvx2BDjyBIuL3jy0KMC3Kh9wobHAoWj+BiM6kNaEuJMHm14wseuIRuHhItKT21apZ6motDigW1VzcSRMIakqD+KGgHLzgTXREOj3XewlzlaYhkreV45M9Ny7NovDHZP2LouIpejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sb+o1CqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sb+o1CqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F2C4CEF1;
	Mon,  1 Dec 2025 11:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588340;
	bh=CPDMRrq2omHs54/Gl95i22yNrP9ftOn7XCPeuvVTtzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sb+o1CqYnNmKNczYKd6QP9zK4CLFgal5bPaUUWbAQTb7A6wAr21iJHXaX5dFR45aS
	 SBtp8ZFR/F+FkUuq+h4rUMf2ASMJIe5PQ6oZTnXV6k1+qReDuxPv2RoIskxJ8HebfU
	 G/XGou6RwHJzgHO6AMC+7+Y3bmkfOHKWOA6uGEas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+793cf822d213be1a74f2@syzkaller.appspotmail.com,
	Junjie Cao <junjie.cao@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 007/187] fbdev: bitblit: bound-check glyph index in bit_putcs*
Date: Mon,  1 Dec 2025 12:21:55 +0100
Message-ID: <20251201112241.514504365@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

commit 18c4ef4e765a798b47980555ed665d78b71aeadf upstream.

bit_putcs_aligned()/unaligned() derived the glyph pointer from the
character value masked by 0xff/0x1ff, which may exceed the actual font's
glyph count and read past the end of the built-in font array.
Clamp the index to the actual glyph count before computing the address.

This fixes a global out-of-bounds read reported by syzbot.

Reported-by: syzbot+793cf822d213be1a74f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=793cf822d213be1a74f2
Tested-by: syzbot+793cf822d213be1a74f2@syzkaller.appspotmail.com
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/bitblit.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -80,12 +80,16 @@ static inline void bit_putcs_aligned(str
 				     struct fb_image *image, u8 *buf, u8 *dst)
 {
 	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	unsigned int charcnt = vc->vc_font.charcount;
 	u32 idx = vc->vc_font.width >> 3;
 	u8 *src;
 
 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
+		u16 ch = scr_readw(s++) & charmask;
+
+		if (ch >= charcnt)
+			ch = 0;
+		src = vc->vc_font.data + (unsigned int)ch * cellsize;
 
 		if (attr) {
 			update_attr(buf, src, attr, vc);
@@ -113,14 +117,18 @@ static inline void bit_putcs_unaligned(s
 				       u8 *dst)
 {
 	u16 charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
+	unsigned int charcnt = vc->vc_font.charcount;
 	u32 shift_low = 0, mod = vc->vc_font.width % 8;
 	u32 shift_high = 8;
 	u32 idx = vc->vc_font.width >> 3;
 	u8 *src;
 
 	while (cnt--) {
-		src = vc->vc_font.data + (scr_readw(s++)&
-					  charmask)*cellsize;
+		u16 ch = scr_readw(s++) & charmask;
+
+		if (ch >= charcnt)
+			ch = 0;
+		src = vc->vc_font.data + (unsigned int)ch * cellsize;
 
 		if (attr) {
 			update_attr(buf, src, attr, vc);


