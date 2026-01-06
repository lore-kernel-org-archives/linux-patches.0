Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EA36B061;
	Tue,  6 Jan 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722121; cv=none; b=fU7AtAEI2cnLONYKuQws2Ve945IVBGurIW4oKlSFDaUEXJPLdRqkKGBdBt86Yfxm2tBEoGpN6CEH5w4Frj7Xs72vfO4bnWyTZLYjsBZTe2wcg91vi1Soojk5PmZoBJVFc140gsZux/GOejaC3sI/GjNBaUVvHCKYYhGVTuWVzGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722121; c=relaxed/simple;
	bh=uBTWjHIleGOrZU1EpTSufeCSsJvKQDratbg/vNf9q8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XakPEXjnekKHGFHJy3DU7XMF6DmlAcSkRIxCnhgRmQw5OVGX9+JDrpjosqF9AhlP2z3WpFQGrwIwwwVBcqpYvvzFl21tchSZfb4PjpEChl5rNlabTp7IPvS+nyLxArib5dlZWG47T66ZuBiTfAsjWjEIxVBm/SvVnAwM5B2nK78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv9I6obh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv9I6obh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47343C116C6;
	Tue,  6 Jan 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722120;
	bh=uBTWjHIleGOrZU1EpTSufeCSsJvKQDratbg/vNf9q8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv9I6obhDCVRxyTSWffh7Fy1wSyP6reVnHnT8XshLnjkxBqSQDMKhF6T3BkYIFY1l
	 28Vi6h5zX1yWLx6YJnBmvccna1PcT12dHHkWISk8iiTxhM3zLWiNSKzhBCwaf2GLLl
	 j8Lc3VnAgiXx2T3vW9mYkSZreqkdhUz2Kf1Dy6kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 172/312] fbdev: pxafb: Fix multiple clamped values in pxafb_adjust_timing
Date: Tue,  6 Jan 2026 18:04:06 +0100
Message-ID: <20260106170554.059405121@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -419,12 +419,12 @@ static int pxafb_adjust_timing(struct px
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


