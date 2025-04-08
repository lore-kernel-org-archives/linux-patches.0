Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F64A94A;
	Tue,  8 Apr 2025 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114004; cv=none; b=jv1UMhltsM+qgVLu10LfgS4xpcQh1l5Bf0CZbF3a3Fv7V2ZQnrPdUvMqN1jEn5EgoWml9/Ko/o/fCFaXwmpax2RezXJEShMeiMAN198O3Ay8fZR6qg0HtacIk3GtTcoTp3C9BA9H8JTN/8yULWjm59fFi+4nvR87tkLiOuWSfqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114004; c=relaxed/simple;
	bh=ZQDul53xiOQQjlEfA6uMstHv811WeGIgpiiYOP0Tdy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzJMop+pdlE7RPV0Wxw7yVfd9r5y8Rl24it165NYRAwZoZs6QvKNW7Z2gP2VD8Xj/nEpyohip3+yGtVA9PoLz+av9P17vngcShCY29DGHn7Q0Kjz1omJZBAhCMujGyTW3Tf954MKHQW6u/0CMvzc6VpGHGYrHNHPH6QsZhR34CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K98vYPYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K98vYPYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2162EC4CEE5;
	Tue,  8 Apr 2025 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114004;
	bh=ZQDul53xiOQQjlEfA6uMstHv811WeGIgpiiYOP0Tdy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K98vYPYFaFLmJ0gSwmYwSixEJUuAn2VF9vbLGSROKvPAg9u14U6V6DN9SataDEFYG
	 h5poAkuZIskZGVtvTOArbvXGrHXnBRsb0/tpP6o0QjvaI3o2LCzGFrmPRZex5i2iVb
	 mEgJNONfpa93dYKMNl/QR8/ug0QjpklVGVG7ozZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/154] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:50:41 +0200
Message-ID: <20250408104818.532700368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit aee50bd88ea5fde1ff4cc021385598f81a65830c ]

Added checks for xoffset, yoffset settings.
Incorrect settings of these parameters can lead to errors
in sm501fb_pan_ functions.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5fc404e47bdf ("[PATCH] fb: SM501 framebuffer driver")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm501fb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501fb.c
index 3dd1b1d76e983..a7acf0acd3e92 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -326,6 +326,13 @@ static int sm501fb_check_var(struct fb_var_screeninfo *var,
 	if (var->xres_virtual > 4096 || var->yres_virtual > 2048)
 		return -EINVAL;
 
+	/* geometry sanity checks */
+	if (var->xres + var->xoffset > var->xres_virtual)
+		return -EINVAL;
+
+	if (var->yres + var->yoffset > var->yres_virtual)
+		return -EINVAL;
+
 	/* can cope with 8,16 or 32bpp */
 
 	if (var->bits_per_pixel <= 8)
-- 
2.39.5



