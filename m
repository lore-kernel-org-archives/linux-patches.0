Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACC02690EC;
	Tue,  8 Apr 2025 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116424; cv=none; b=Ny+ZdJauFl8qZkzACmvH6xpRcrBtaOE6d7AE88uJVsDkL1c8S6phrzFqqfaqMXbsLVNtP78oxsuYvP3EA74fqE7xmrdIKXkaImHmApm5mieD4T+PPVr8S+Tcj3bMliD3IxGShy3tP/LBZ9DoqQ4MYpJjUSVI2BVgSyf5kAvPmE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116424; c=relaxed/simple;
	bh=/LeXGP7LyZvqdzP/WT36nBlntGUEynJZTu8I5QDEW5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvpc5suHX1ESALnOO7pYfXZsRCw0FSqyQLr7pJDXgFne1B2FYUEfVA6wgZdqCCnb1KQRshbwDWc+WArk7H2dDYJO5kXOXk6V1x2rc5sQGZhktF/BIci7JJsrJ8mRNKdrruOT+fkJ8Mme3+QfQdtHNmau/x0JjTU9crz0NT2ynLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9o/Q5Nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9o/Q5Nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BE5C4CEE5;
	Tue,  8 Apr 2025 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116423;
	bh=/LeXGP7LyZvqdzP/WT36nBlntGUEynJZTu8I5QDEW5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9o/Q5Nw4SCkAdIiW7F4oN02BMxAgv8N5jXAvy0b3goZLDiv/FNUQ87VperAJNN4H
	 INuwaCYyDC9SmGe0MK7OZ/FnIzIYCqtngTh77tcIm8cyr/5xdXUrfSFuGfnS/qwXar
	 s02z//Bsw0o/DyKC1IysNtRI1ih/qyAlszeHMhXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/423] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:47:02 +0200
Message-ID: <20250408104847.975328745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



