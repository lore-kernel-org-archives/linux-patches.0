Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F894315A;
	Mon, 23 Jun 2025 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714909; cv=none; b=kLz8XRBwOci9m7GXg4OJUfZBu28fBfRHJUKBxZK0bL4YZHs1p+WraNhMw8Dc+PHTAx4vrgIReIlCrHlpbx38JMpleiq5vEbgwRZ5CdtKFcCGuTF0GDfIEigGjO8rawsoVPEI0wNt3RbFwwei3FPo75Va7bRoriEYETJczJA+sKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714909; c=relaxed/simple;
	bh=qGdEpWbb3xxldjIdGMAZ7KiDddAnwRrv/yem41a3U4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvQ/cSggG+ux3gDXAzBJbDFqgxtsQkjTp5VL4mVka9s3aA2pTJ3k0HKlV+wUekff/78GBLozfefEQpv1lMn1RzRdc4R5FaiXdddpuwP1ahqXtb6pPKkinEJcdy3xbh4LcHuzBPF/9YTgHfYOLdbrf8QNVWpbmk6MVh9iVekbd0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L66KOqKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L66KOqKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0953AC4CEED;
	Mon, 23 Jun 2025 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714909;
	bh=qGdEpWbb3xxldjIdGMAZ7KiDddAnwRrv/yem41a3U4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L66KOqKYlWwTQP/nFLTS3xbubW+nLzoO7VisEUV427CVanWeYauSdL7zpCIiG3pj3
	 dH9le8ajsM07RC0T8p2UKBOpLZpG5bFek+G89OV1ACDRzVwuDPOTp7IQR4BQMBcCTX
	 UIgzXik4fBsageceV1wu+Abf/J5D+8s05A/NdQuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7d4444e7b6e743572f7@syzkaller.appspotmail.com,
	Kees Cook <kees@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 425/592] fbcon: Make sure modelist not set on unregistered console
Date: Mon, 23 Jun 2025 15:06:23 +0200
Message-ID: <20250623130710.546305905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit cedc1b63394a866bf8663a3e40f4546f1d28c8d8 ]

It looks like attempting to write to the "store_modes" sysfs node will
run afoul of unregistered consoles:

UBSAN: array-index-out-of-bounds in drivers/video/fbdev/core/fbcon.c:122:28
index -1 is out of range for type 'fb_info *[32]'
...
 fbcon_info_from_console+0x192/0x1a0 drivers/video/fbdev/core/fbcon.c:122
 fbcon_new_modelist+0xbf/0x2d0 drivers/video/fbdev/core/fbcon.c:3048
 fb_new_modelist+0x328/0x440 drivers/video/fbdev/core/fbmem.c:673
 store_modes+0x1c9/0x3e0 drivers/video/fbdev/core/fbsysfs.c:113
 dev_attr_store+0x55/0x80 drivers/base/core.c:2439

static struct fb_info *fbcon_registered_fb[FB_MAX];
...
static signed char con2fb_map[MAX_NR_CONSOLES];
...
static struct fb_info *fbcon_info_from_console(int console)
...
        return fbcon_registered_fb[con2fb_map[console]];

If con2fb_map contains a -1 things go wrong here. Instead, return NULL,
as callers of fbcon_info_from_console() are trying to compare against
existing "info" pointers, so error handling should kick in correctly.

Reported-by: syzbot+a7d4444e7b6e743572f7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/679d0a8f.050a0220.163cdc.000c.GAE@google.com/
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index ac3c99ed92d1a..2df48037688d1 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -117,9 +117,14 @@ static signed char con2fb_map_boot[MAX_NR_CONSOLES];
 
 static struct fb_info *fbcon_info_from_console(int console)
 {
+	signed char fb;
 	WARN_CONSOLE_UNLOCKED();
 
-	return fbcon_registered_fb[con2fb_map[console]];
+	fb = con2fb_map[console];
+	if (fb < 0 || fb >= ARRAY_SIZE(fbcon_registered_fb))
+		return NULL;
+
+	return fbcon_registered_fb[fb];
 }
 
 static int logo_lines;
-- 
2.39.5



