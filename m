Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F2B3AA1A8;
	Thu, 15 Jan 2026 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498326; cv=none; b=vGN7FsF8ujLbUqOLlT4YNKJy1/bj7dlHh8V4+1K80og0FBX5e+AMRzkLpXQT6k3e4cAOBA3OMbo2CejgfHmF1d0oKmxfxq/MTZvX4u8uu1VhJYjib6sV3AzT3br3yXkmI7IgDNaGaA3SItDh0KFDCpqe2ClNFSWVI+baCxTKUFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498326; c=relaxed/simple;
	bh=BZaiOfHPUSwWG8SQ7mYOuNpgJPnJDPfFsvQcKSr3byk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xpp/IXt2mJCZ4SHx8Zz4ejQHcw9WtLhJuGBoRmTvngLM60UZkZdN2FV+C4LCTt5hlpwUrz9K5OuYAp51yu47MgRXu4s0xCfjiIBdCvqENDr9uJx7Wo88cyWE60on8X6TJHY7bXNZufJ9Cv+lTHpISV9FkJ+gVVqzu0b5b60PjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKS6ED6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKS6ED6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C471FC116D0;
	Thu, 15 Jan 2026 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498326;
	bh=BZaiOfHPUSwWG8SQ7mYOuNpgJPnJDPfFsvQcKSr3byk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKS6ED6BOVOe+cb4vDJ2/gtwtNdgYDMLFvEuiUafXK6V/QO3vmuey1NcsUcZDIfRy
	 UEMMey9jy/8AJN7bLDE08IUbZ+IxpK242uSvVYX+Zga1nn4j1HHDsgZYcMgIA1Uwwn
	 B1ZbnReqcn/Vn6vHvwlq/+xDV65SN2OTKT6NJOrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 393/554] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Thu, 15 Jan 2026 17:47:39 +0100
Message-ID: <20260115164300.461029071@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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


