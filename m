Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741B2227EA7;
	Mon, 23 Jun 2025 22:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716786; cv=none; b=FJ2J0QKq3rtFQ6d6I+/llBTKiI0dtDpqsuQWxyNUBNQsW0D1vNB3XfLm1H8YZ+BAO2rmOgY8qAtiAL/cwImoYa1U9i/rqxHBBO3sb46/cQuQC5EcJ5TVCUemgZ/G1E1r7Ld9A0dVuNKTbFdeKb7OM2YzN9AwZXfNcrzJn5+Lx8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716786; c=relaxed/simple;
	bh=Fe9jTjFLPcbxyiH2Zw7zswBElq4tikRVfHDtwm/eWkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEifkoSaiahljCOa6IADqVE4RwESqwXSdCamIPQN71sje2YtPjQTkYLRTUZofrdf6yX/MDV2ym831KHG3CVXLk55c02SWy99FoJZNYCehxz4HGkeBSLBXvkrCpXUYWfml6zqqc1qKVzF8bAM/EKIjLVIDdHGrE4LvFx5Wo1U1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxH4xale; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxH4xale"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF44C4CEEA;
	Mon, 23 Jun 2025 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716786;
	bh=Fe9jTjFLPcbxyiH2Zw7zswBElq4tikRVfHDtwm/eWkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxH4xalekCtfCAWhtVrZNaJb3aVlSS8AYXlNqJLYSp/4Y2odw4CvnaivqlsjDUoVg
	 XmBRDSkRDDmZ+aKacPQ5JBa6mU4NHZ4YNA+gaf3T1ZF7aGuiXVdJFaZwP87/EBq5W5
	 IJtMy6mP+mmsW5G4aMqFjaPuhVEz6L8zymzzwmqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7d4444e7b6e743572f7@syzkaller.appspotmail.com,
	Kees Cook <kees@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/414] fbcon: Make sure modelist not set on unregistered console
Date: Mon, 23 Jun 2025 15:06:59 +0200
Message-ID: <20250623130649.070731066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07d127110ca4c..c98786996c647 100644
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



