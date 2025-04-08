Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F29268FC2;
	Tue,  8 Apr 2025 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111210; cv=none; b=e0NPRLxXSwAopR5WUW74vfpgPJMyOJZdKDIaYYnVuRUdGdzEuDjJGr1BTxME3LYBSL5D6cYcLWVjEPbhbrtOQ0Ky2rRRnuV6yDCgg7fjQEP+ZnhA0WKvcwh8djQ/hbMo7gvwerOASKqBlq8UrDStCrySCNB4IMGFqS6nA2dLVdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111210; c=relaxed/simple;
	bh=6+CUFvqRfQ2Nkalb0Vnghjr8NlAZCslERHTXJiw+ULQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0+pDjgZ6l3wuxljp2VtoZVp4J9gkyrhYTv7o30srfzXfizIe8wrlThNaB7GpPykAX81WccLI6cxGqLEbworRoe9dQDmG+LxSFfxsccDQtIdfh44tsE+RAOzScC/xyM2gwwdWr8oqyz4THUanEJKuwi6zFHxMZb04/lLARUeHvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohTO1QcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohTO1QcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B674C4CEEA;
	Tue,  8 Apr 2025 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111210;
	bh=6+CUFvqRfQ2Nkalb0Vnghjr8NlAZCslERHTXJiw+ULQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohTO1QcE4B4BJs9wMATHqrag5nyPR+CRyfXWDsduqi0cMLngH8Jl4xSuyEEBDzQLQ
	 K5NFwb7z2Pc4m6WB+gjINrqo5SwHmQepTbbvTDGu5iA1/Zg62Qrxv5mIPu1N8NibXV
	 tr9xBVjS7z8pZ65BBYn1jiX/fdH/3Z7hp/skcBIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 350/731] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:44:07 +0200
Message-ID: <20250408104922.415833175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7734377b2d87b..ed6f4f43e2d52 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -327,6 +327,13 @@ static int sm501fb_check_var(struct fb_var_screeninfo *var,
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



