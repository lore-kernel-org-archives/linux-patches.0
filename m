Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AA44C97;
	Tue, 11 Nov 2025 00:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822093; cv=none; b=W0Z4dnNja/w4IbDOYBUQO4DU4RIsvk0lMWUuJiG6Q4ImuOeUqoR/8PLDQXBXnHIcSbXtEjIxqhP3nri2UZPG4F4dTopp5o8uTcrkYYYgIfzK6VumN6rzJWRsxKoHQzBCJCVGYLydcDU04fMPvpBQfdpQArMEDkawvLN/BOQSUto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822093; c=relaxed/simple;
	bh=KnYJiYTZjG42VqUhEvhftKkTQxHfl9GTYHYjDsi18Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLob2CkYNkoXWqyzIlOYAiV6yX+ui8xENT+CBnlEsCA04q6QqlTPLA+koN+44yegQu4JWhdE8TZT47JSKY6Nffjh2opZRqmbelRCwA6hur1qle/vnakriEWE7XruL+v6MOpdzz6PKqkWyUh9YOgyE4RODVvCHpyk10fnkCmcnGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6WBlq2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6WBlq2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA0C19424;
	Tue, 11 Nov 2025 00:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822092;
	bh=KnYJiYTZjG42VqUhEvhftKkTQxHfl9GTYHYjDsi18Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6WBlq2esXNmFWusFykHd4CJD7uPYVKersya7oOY//neC15XybSND425Is3GyRqeU
	 ntkH5WE1jTn9y7WGr8bPNXn+PNdUdoiK4Ir12wonSG4fUC10+0S/Nbha9k6PR6elm+
	 HL6gIC2wryB4b7vLBfNxDy41QTdbD0gbLvdHHWSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+793cf822d213be1a74f2@syzkaller.appspotmail.com,
	Junjie Cao <junjie.cao@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 014/849] fbdev: bitblit: bound-check glyph index in bit_putcs*
Date: Tue, 11 Nov 2025 09:33:04 +0900
Message-ID: <20251111004536.808055651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


