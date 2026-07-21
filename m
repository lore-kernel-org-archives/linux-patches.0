Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F446AA60;
	Tue, 21 Jul 2026 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648112; cv=none; b=GrYG/h+TdKJE7+XmyAGeNwwIiP0isVBrl04KHtLpTk4uXPVnVr8Qjr+OLal4c6PninhkjUeILbG0DmnKHRZyl8bOSfyJ2GFTEqh/PD+MXJj0//HfqIw2qlV1yEseGXmU37mLxcMS7n6x9EeN6TGpXOTWr/28OtvJCV8YfL20Mxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648112; c=relaxed/simple;
	bh=zjPF5G0KQEG5c8iJPHd8dUkAVViaZgtAQ3dY+MfOGI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOdoCfQBUlBnCDXsUheA0nGPU31p+OdJyUu2MdIf4CqiQ/wg6mb6ZSz6p9xyKV1sd+cLA54fIhFJwQmB4GQsrZKiAmZPaXflNA8GShpMEwpl4/8ERkhwlv5taGd+IdC4iu1p7ZiRi8y3e/ZT6LPdMDslT7j+OuT1SM+w9fxbIB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1kwqJ+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1kwqJ+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5041F000E9;
	Tue, 21 Jul 2026 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648110;
	bh=smkOcthVLyhxrHwrIRHiSuk0qGi0HzhnaKnyiu7XuGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1kwqJ+2iqBsmrIVH900EEsyE/F2IbEN6FSDXhU3SIs1l2mMaVGKtgnZA2ZNaAtne
	 hwzY79DflSZnkOQECZuzIOMRK0S/UCiKE+Vg/P/HeNKTd2LOBQWbHbXSAgNSiUDhgI
	 00kKdxN5+M6Gchg0xBCEujbSvOxRlO9CYoVKWK8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+42525d636f430fd5d983@syzkaller.appspotmail.com,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 0039/2077] fbcon: fix NULL pointer dereference for a console without vc_data
Date: Tue, 21 Jul 2026 16:55:12 +0200
Message-ID: <20260721152553.610865880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

commit 5fae9a928482d4845bca169a3a098789203a1ca4 upstream.

fbcon_new_modelist() runs when a framebuffer's modelist changes. For each
console mapped to it with fb_display[i].mode set, it reads vc_cons[i].d and
passes the vc_num to fbcon_set_disp(). This assumes a console with a mode
set has a vc_data, but it can be NULL. fbcon_set_disp() sets
fb_display[i].mode before it checks vc_data, and fbcon_deinit() leaves the
mode set after the vc_data is freed. fbcon_new_modelist() then dereferences
the NULL vc_data.

Keep fb_display[i].mode set only while the console has a vc_data. Check
vc_data before setting the mode in fbcon_set_disp(), and clear the mode in
fbcon_deinit(). The existing mode check in fbcon_new_modelist() then skips
such consoles.

Reported-by: syzbot+42525d636f430fd5d983@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=42525d636f430fd5d983
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1274,6 +1274,7 @@ static void fbcon_deinit(struct vc_data
 	int idx;
 
 	fbcon_free_font(p);
+	p->mode = NULL;
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1445,14 +1446,14 @@ static void fbcon_set_disp(struct fb_inf
 
 	p = &fb_display[unit];
 
-	if (var_to_display(p, var, info))
-		return;
-
 	vc = vc_cons[unit].d;
 
 	if (!vc)
 		return;
 
+	if (var_to_display(p, var, info))
+		return;
+
 	default_mode = vc->vc_display_fg;
 	svc = *default_mode;
 	t = &fb_display[svc->vc_num];


