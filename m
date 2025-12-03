Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C83570A1;
	Wed,  3 Dec 2025 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778688; cv=none; b=XudQXzb9BlaVqBQ1KFPi/Dair7OKGTVDfUBCDNgCBRSlEIWuZEihVbawILMi3E1w0EmUUIT1mJjKUxh/8agW8fMbjVXikiVNU/p2Y0B0zXL2x58ZwRSvstpsqbLLDe8LfI70cObVWdsPsyxbqVGDEDtx24OKbZOf3CtvesB2lyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778688; c=relaxed/simple;
	bh=fu8yBS1MbOGFL7CVQdFpmuWIty1loRz+Oe1Mmz51pho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQk3SVqrTvV1zp62Fo0A7r7lelQUzj7A4n84jbtSNht9err5ht+gyOxZQ4ko7fg3Nx7UmgnUH2Z0DYLNo3dKGKej8YmjybzXABw5XlyzPP6LEkwvAtsLu+fyP8pS9dZ+Sy8Hjyjd5vpVEefWJLB00eiVdKvjpbedFySPR3TMRqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDVKLfUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDVKLfUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7814AC4CEF5;
	Wed,  3 Dec 2025 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778688;
	bh=fu8yBS1MbOGFL7CVQdFpmuWIty1loRz+Oe1Mmz51pho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDVKLfUAcwFInc+/zAz+VXsAgPdXeS0QUtuJZYqrabj08oBAiSODbpOzQ91ZxISFC
	 HZQLI8w8G8ZvEB+JgDYsB8pmxSbXhnSm+JcXjIA1CcmdIIcVrHfP1srSxvQKzT8HX5
	 hHzl5iApWLAKlUddUZAp+5DkYaeBHWWr89kBPZzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+793cf822d213be1a74f2@syzkaller.appspotmail.com,
	Junjie Cao <junjie.cao@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 029/568] fbdev: bitblit: bound-check glyph index in bit_putcs*
Date: Wed,  3 Dec 2025 16:20:31 +0100
Message-ID: <20251203152441.731602484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,12 +79,16 @@ static inline void bit_putcs_aligned(str
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
@@ -112,14 +116,18 @@ static inline void bit_putcs_unaligned(s
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


