Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0173635BDD0;
	Fri,  9 Jan 2026 12:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962756; cv=none; b=qRO+ocInqAP+TjxSMc2o1CMCW5+dZWzfSCb2Lm81Phiz93hHvFRVjKX7iZ/chYNT/cOQWJ2qT0Cmo0cVJh6+X83MJBhWqlbGCGtSjVmK8hVJLVJ6fbh52Ijoiu/UCPfMCj/pl7UafYmueGSLiZMY4KQFXfaBHGlV659kdH5SZDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962756; c=relaxed/simple;
	bh=QhvDSUaL9wxt3TkXV1FL0SC6FVWqDOHNHbh1fqR5POU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbFqXqoC9zTSSIhdJlPy1kcFq1ovFGQGpQzH6XMtl0eBg+TqdYyte2IKekybxI/nlCjX6Smdofqopbmy2Ssoxh9feL2zmrIPjLQnSGvJzOFBmOjFZ5nfXXq1rm54/ODs+IBx2XgLYRIkMEbmzA+xFHA1lXXZzHl/l+1gh+l6cvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfdW0VMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfdW0VMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B555C4CEF1;
	Fri,  9 Jan 2026 12:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962755;
	bh=QhvDSUaL9wxt3TkXV1FL0SC6FVWqDOHNHbh1fqR5POU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfdW0VMASbGqi2L/7tRsUA3sBmnKlfUz9KuIs1qf+3u0sf5bqhl9OZ51BIcSuSrwB
	 3iSG1xC0OcORMtH2EC31R8P3gdSsv36NHXWt+UyRz0tmlphaM3PaCV2ilgH2XhUfGM
	 Chn+CYSZWiRkFQPZjJtQrFip8RGtP1IOomCWf6SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 476/634] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Fri,  9 Jan 2026 12:42:34 +0100
Message-ID: <20260109112135.459779240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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


