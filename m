Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057601;
	b=xR+2OvfpnNwk+gkFoVF7aVNpXYSUiZewGd/lISfarWalpONiZkypg7uMqyjBFHUZ/JKI
	 TgBiCfmFOMuqUB3PyaAXLMy9+lrcjovtsNY8oxj5RnJCgrg9mOb1ns8txz8rg+ZJStxZG
	 Up41PncqIUKQNSfi4O7i39JzIQ/IsV9mhlYZfYeIEqrVra1LToSXJpxFxGgN6t8asnDWW
	 6TJ9dbelQrIhumrLF3cYruryITrYf48DEOZzVrwZq9MrIsaPVLhW8R/GZk89uKQ+OriL5
	 x20P5scRtH/HXUj3k5v2GlikiQ9Y7OlADShOoaxCLwcbaayMbqGofzM9SCH/skRv3pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AO62nRvGUW0XSBxQPu/o1/VseMcplppW4VcQ5+DygdQ=;
	b=2wS8s+IiogXZcL30QPmb7dWX0R/XkkxD4HWJmrQXtA+5pPqpAiatFr8XdWUcVNX62aYv
	 zPZR3hOLt5YA7INUs1uZqpIQNF0Wv+ihIHqmpzqvqmmpo5yp5BlT5shbofF2A5J6d5L+7
	 ehLIoUWyIjBYuN8fxyMCp1gE1AXn0GpcgzBvSHMPfH4wQeUAq0+uxaT408rEADAPufWME
	 ym563WPMpkquCFoyp/11kML4NIFaUopio/EsIXXe+8PzUMlGjkNc2HgiAucA5m/ewc1XY
	 3QYvXLgP4nbMlRXKQzyg+83cma1NZ3jn4Uj4GxJ0gMrMYWh02SuwrJNCW2ggRikK83Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rk8I7Q0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50A606A33E;
	Thu, 19 Nov 2026 03:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rk8I7Q0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDA61F000C9;
	Thu, 19 Nov 2026 03:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057601;
	bh=AO62nRvGUW0XSBxQPu/o1/VseMcplppW4VcQ5+DygdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk8I7Q0qI7f/TAWKmsni91SfH7Oi1qUrEUqJGiTbqDgrZWN/lUIkB3xjf9iAUoQnF
	 EDozRT06Sh8qp7JRY6T6PMwMumLplcTNeIPybTo68LvFRiMFEgqGljXp86LiC6ux8o
	 Zq25ZyrfYPOwYdnaeeURIFeThGygMLmZIuAi0Ito=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0189/1848] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Wed, 18 Nov 2026 15:37:07 +0100
Message-ID: <20261118145919.611395237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 94e6a058b16820e02f25e1221a4c4e713ba23550 ]

Ensure the logo will not exceed the screen size, which then should
fix a reported KASAN: slab-out-of-bounds Read in fbcon_prepare_logo.

Reported-by: syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index b72d7bf448793..41720de26eee4 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -602,6 +602,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, ops->rotate);
 	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
+	logo_lines = min(logo_lines, rows);
+	logo_lines = min(logo_lines, new_rows - 1);
+	if (logo_lines <= 0) {
+		logo_lines = 0;
+		logo_shown = FBCON_LOGO_DONTSHOW;
+		return;
+	}
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
-- 
2.53.0



