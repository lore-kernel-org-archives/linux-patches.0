Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077A26156E;
	Tue,  8 Apr 2025 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114475; cv=none; b=nkZDV6ZFW4KUrruNXL7c8i+1d0w5R1L0QN2xla4Vl3ztldYQf6Oz4ajp7Gyi4ggFjjxiJthudsTx0qu8VC9r7HhRuU6L+QjqanDUgHYHHFuWgI1avxnn9YCpWcxjCTsTfFOh3OE3brXitzMpEfPDvRD0uPJ80DeiuPUimdGKqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114475; c=relaxed/simple;
	bh=WhYTx6R7l5saFgikFLPgcKDN/trRcrrVvLJcIBvE6QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+TI6fk261yvYOPls4FKMxHVKqGfiRGGRSN8atS56NfqaTL+/q2vemqEz8lRnbYiFkEvvYOyTV8CpTpyQrXOgOfLsMj+N/5q/acSAfG8j5H0PudtQ1A68HXvf9Ip1Gj9RvdL59wkxTR6qqj5AppD+ilMolEGRTFSl7gbQY2aHLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUPRstcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUPRstcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020D4C4CEE5;
	Tue,  8 Apr 2025 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114474;
	bh=WhYTx6R7l5saFgikFLPgcKDN/trRcrrVvLJcIBvE6QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUPRstcAwmKROZ+pxdFRxCVxIc7gqs7zUssfCyPqXrSHCr8f6YDOS2q+FJK1y14Qv
	 Bks/lyUbdJPfL3USg5v7Chl/eikTAEwm3UKAe6R2z2k4oDmVi5tZnsKw9rafCch+64
	 9PBlDdanwOvRbr3Ofs3W8qCgj8iCNqPgNUArnOZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 119/499] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:45:31 +0200
Message-ID: <20250408104854.168280951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 86ecbb2d86db8..2eb27ebf822e8 100644
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



