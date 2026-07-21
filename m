Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6E444AB62;
	Tue, 21 Jul 2026 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668709; cv=none; b=IYTrTM7LGVDg7rYKznTFTX98SOixlFju1GWZVtH6iYllBxNYR/Wzo0XOWeqWrMW3VFqyYg90/bGAwZvTQh8V+AQYoEGo8SKND6vbdurP2Jjf5MWAGAXvrYbLO80nApGJEfUMSYNRc/vfqU5lmW4iwv8q4wh3GANWVUSrDT5HQkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668709; c=relaxed/simple;
	bh=6loyg1bSeKYdsxrGNECtfR42mSA2BN1pmxa8dLHm7nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy5niytliaAOnDjIcumg7z4OfBHEAAwyFItqKeFyU+2/uYTjaexa3XlPPJj1hENWn/ROAWKCzC+ZF2lJnAOh8qhnxh2Ipz3cMoVqIiHHUpwQgSS2SsVmQ8b7SVMiGCHpsSEQQ7ZSv77A3FUtS+E25WfHhP+36YrP4s9K/D+C3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUD/y1TI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUD/y1TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751EA1F000E9;
	Tue, 21 Jul 2026 21:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668708;
	bh=EsEglhreSuGS/3l18Dt1lYWXB/dHDrgHvhIG8uRXwbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUD/y1TIfNAv7mYGz/Abe1yyfJ5tmR9DKdVHCU6jHz2ZiXkkEmlvcXYhVwzwlOfx6
	 tlx8RX+vbEJ/7Ul5rsRUkfOtmLwa2nhnTlG8UH3onWfw/n+aAGmKWH7H99dIUsJ4ec
	 y5tLT3Izb/bVOH2lFrPtp5E8YYNFUgi/QXtsOCLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+42525d636f430fd5d983@syzkaller.appspotmail.com,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0277/1067] fbcon: fix NULL pointer dereference for a console without vc_data
Date: Tue, 21 Jul 2026 17:14:38 +0200
Message-ID: <20260721152430.793010140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1181,6 +1181,7 @@ static void fbcon_deinit(struct vc_data
 	int idx;
 
 	fbcon_free_font(p);
+	p->mode = NULL;
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1359,14 +1360,14 @@ static void fbcon_set_disp(struct fb_inf
 
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


