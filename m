Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF1B359FA0;
	Fri,  9 Jan 2026 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960947; cv=none; b=DDq4HKt/L8Chvivudc8eJDkCPMTojA5dN4IJlkTtldX9qxmq9IcGnRdHstO/P34ffmzS7ncekMRxwm9doY3kT1fQUewIBScwa1YClWJhzYs3bGECQq0a/HCmWwMkLA2pXvee46xp8ezwV0xBNXVtjZzZ+p/PW3Ip/tPkHdVZNGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960947; c=relaxed/simple;
	bh=IbEaz+Kto29xcLqFPvv9GblF+foZGqb9Fz9t8x59mOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvDr3aoRJccgn6aeeoNpnqepIpuJbNyRr0rhbkV+eMEYIHdhMJWAG0z93tgPalWFp59BPOle0Zjy48WGCdxfIZbmZrmk39XKIw/7t7IAPy0UgcaSeLfdD38+e4V6cxNTets+f3IF5hJ+KrQPdAx8RNVxrFdGWErgV2TZoscb9a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOOCZ02k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOOCZ02k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409F7C4CEF1;
	Fri,  9 Jan 2026 12:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960945;
	bh=IbEaz+Kto29xcLqFPvv9GblF+foZGqb9Fz9t8x59mOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOOCZ02kBUvb4BXmx4tlYSSsQuTq5IV0CCBIzw6oFB3PqwYjgarThqx7BV5nUH0i9
	 Nfrb4W/4J8AH4Q0icAUJlw23VZDeBAxAUkChy29p9z0rSnc/J8wvIibrL/1LuGRY6h
	 8DFeHqlidlPtUFjmLw3kyUHlVV7tO8maGvOp0Jvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 581/737] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Fri,  9 Jan 2026 12:42:00 +0100
Message-ID: <20260109112155.856224501@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 0155e868cbc111846cc2809c1546ea53810a56ae upstream.

The variables were never clamped because the return value of clamp_val()
was not used. Fix this by assigning the clamped values, and use clamp()
instead of clamp_val().

Cc: stable@vger.kernel.org
Fixes: 3f16ff608a75 ("[ARM] pxafb: cleanup of the timing checking code")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pxafb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -418,12 +418,12 @@ static int pxafb_adjust_timing(struct px
 	var->yres = max_t(int, var->yres, MIN_YRES);
 
 	if (!(fbi->lccr0 & LCCR0_LCDT)) {
-		clamp_val(var->hsync_len, 1, 64);
-		clamp_val(var->vsync_len, 1, 64);
-		clamp_val(var->left_margin,  1, 255);
-		clamp_val(var->right_margin, 1, 255);
-		clamp_val(var->upper_margin, 1, 255);
-		clamp_val(var->lower_margin, 1, 255);
+		var->hsync_len = clamp(var->hsync_len, 1, 64);
+		var->vsync_len = clamp(var->vsync_len, 1, 64);
+		var->left_margin  = clamp(var->left_margin,  1, 255);
+		var->right_margin = clamp(var->right_margin, 1, 255);
+		var->upper_margin = clamp(var->upper_margin, 1, 255);
+		var->lower_margin = clamp(var->lower_margin, 1, 255);
 	}
 
 	/* make sure each line is aligned on word boundary */


