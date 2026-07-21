Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCC133A9FC;
	Tue, 21 Jul 2026 22:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673076; cv=none; b=QaTyEb7vHP6KEN/Twv30J339Ubc+lEgzRJ9UwpPqcdMW7IObc8yK+KKmBtmlJqm9Aj5VyOUYoX1iPH3M6nKkxVywrLJxgTKIPeC/1ORhBuJWViIvTigEkSuiJ+wP5Y5qSuvlbiafeOLqu1tedWx+eOCiClwei7GVWRez/WtlPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673076; c=relaxed/simple;
	bh=mXFHkvDKsdnfp4uyuCnuLObc5aAn1YtuiSMMioTwKTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1G7ZEIIM75DQXDiKvWiGj/+qqjpqxqmCcrdc4c99EsCKoimfHxC7/1BjORmACeNT73d4Zu0wEpXQYpQitWx21gxTSS7rcEGbOx3A8uAW28y+xuJDda2/XfYcb/tceUn5Y/Qqpg3bnaTD5/nqOJQYaTs4BzOdLnQd2ehgahP1fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8T9Cm61; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8T9Cm61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BF1F000E9;
	Tue, 21 Jul 2026 22:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673074;
	bh=2iAVNKN54uffeO8b7BlFdEr3Co6J52xe1q61Rie2UvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8T9Cm617HQytgJaYs3YU/5w8DQQz26iHUdT+t13rHWkUVvMqAYfEKD1fhTUuxxfK
	 AdpD0Px77u0ncJhwpbPZWnLfgazHnRu2d/faIuvtWqrjZwn75m2YI40GQa1MVPRQPV
	 IS0M2VRfT4+NW4ZpciZVlqCFwTlQwvOrqXlUd8d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/699] fbdev: fbcon: fix out-of-bounds read in err_out of fbcon_do_set_font()
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152356.266653977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

[ Upstream commit 8fdc8c2057eea08d40ce2c8eed41ff9e451c65c2 ]

When fbcon_do_set_font() fails (e.g., due to a memory allocation failure
inside vc_resize() under heavy memory pressure), it jumps to the `err_out`
label to roll back the console state. However, the current rollback logic
forgets to restore the `hi_font` state, leading to a severe state machine
corruption.

Earlier in the function, `set_vc_hi_font()` might be called to change
`vc->vc_hi_font_mask` and mutate the screen buffer. If `vc_resize()`
subsequently fails, the `err_out` path restores `vc_font.charcount`
but entirely skips rolling back the `vc_hi_font_mask` and the screen
buffer.

This mismatch leaves the terminal in a desynchronized state. Because
`vc_hi_font_mask` remains set, the VT subsystem will still accept
character indices greater than 255 from userspace and write them to the
screen buffer. Subsequent rendering calls (e.g., `fbcon_putcs()`) will
then use these inflated indices to access the reverted, 256-character
font array, leading to a deterministic out-of-bounds read and potential
kernel memory disclosure.

Fix this by adding the missing rollback logic for the `hi_font` mask
and screen buffer in the error path.

Fixes: a5a923038d70 ("fbdev: fbcon: Properly revert changes when vc_resize() failed")
Cc: stable@vger.kernel.org
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2426,6 +2426,7 @@ static int fbcon_do_set_font(struct vc_d
 	struct fbcon_display *p = &fb_display[vc->vc_num];
 	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	u8 *old_data = vc->vc_font.data;
+	unsigned short old_hi_font_mask = vc->vc_hi_font_mask;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	vc->vc_font.data = (void *)(p->fontdata = data);
@@ -2479,6 +2480,12 @@ err_out:
 	vc->vc_font.height = old_height;
 	vc->vc_font.charcount = old_charcount;
 
+	/* Restore the hi_font state and screen buffer */
+	if (old_hi_font_mask && !vc->vc_hi_font_mask)
+		set_vc_hi_font(vc, true);
+	else if (!old_hi_font_mask && vc->vc_hi_font_mask)
+		set_vc_hi_font(vc, false);
+
 	return ret;
 }
 


