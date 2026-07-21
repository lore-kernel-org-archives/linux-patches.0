Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C937473A;
	Tue, 21 Jul 2026 21:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671008; cv=none; b=qeQeG5V7kecW8IrzAmcvz9DW2mFmihhdCaUtC0++dEZx96HMeG2YI8SAm84HcT/gNRh/aED9LNtmC9gKkrbvMooN84tkYmwltHZKKqFnlwlXNBcdgJyDalbh5ce8vMTT+qZj1csJFH3Ge1csnO+LwBYPhFi3kNc9VCxbqtnBsgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671008; c=relaxed/simple;
	bh=sV74SkNblvIaH3HwpXqxb2IDtTq2I9uO3iHDdpJGZfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDGMF1DQnhDbhc7V/R7RuzAfKt4I1aCABplPhdj3nbxX7vk+4DG/ZDmL8YqsslSmxhOpFc47reltsECTxjJ+8rdH3O0WaqcmAYE0HE96QZb1+RguQ6ZIoo2nsvKqoHM6+C2DbTCok0y10s6EBZ+Xz7a96c2IdEoDPhRErKcreeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDtRpVnY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDtRpVnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7549A1F00A3A;
	Tue, 21 Jul 2026 21:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671005;
	bh=V3gwQkkHaN+kolzOYcywC+xvU5503SM9eRd+8JW2f9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDtRpVnYB7j5R85pxrtSYnkaQ+V3lfISDZcRf9gRYhn5DVreiqPdZ4G9oYwMKlPje
	 A5JmYvl6IAAAZ8ne47ZsoinpvIIocI4p8JlDyjWLQAcBIzTFGC+qzXxakYN1FdqfOE
	 Zb4ou1cvEn/8C0EKgS1762ern4sIaRPITZN9YBSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/843] fbdev: fbcon: fix out-of-bounds read in err_out of fbcon_do_set_font()
Date: Tue, 21 Jul 2026 17:14:35 +0200
Message-ID: <20260721152406.876885524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2381,6 +2381,7 @@ static int fbcon_do_set_font(struct vc_d
 	struct fbcon_display *p = &fb_display[vc->vc_num];
 	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	u8 *old_data = vc->vc_font.data;
+	unsigned short old_hi_font_mask = vc->vc_hi_font_mask;
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	vc->vc_font.data = (void *)(p->fontdata = data);
@@ -2434,6 +2435,12 @@ err_out:
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
 


