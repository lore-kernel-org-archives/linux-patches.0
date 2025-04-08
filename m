Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85A264FB6;
	Tue,  8 Apr 2025 11:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110030; cv=none; b=Z876md+aPo4z75BugR/ufpAz/BqK947m3Pz5CgWYKryC4C6Hnx+FWTkUDRSFAYrqCCtKYB0qpaPWzz4/AE3cYUhifHA9uvOofNAcMLkGLlJcOFAu4Mo7ihYOt1uLJ7AgXmhRbDNhmZYynzG//wPGyvoZPyaiYSTzVqivXDz2oHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110030; c=relaxed/simple;
	bh=cRLTUpm9aXlqfAaL5CPX3DKbqXCFHRrFPZ2fhgGgv/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0EfKmhh17VE/7TZrE6s9h2+lmfZDDDobD7B0SVjOujI7cx4t7cUuS8SEv/ozAY8gcrqsnZiVW9J8lHOBy6ZqPA+5hM+JXaNvlg5LZyyYRzCnZHLIEwY6YJqyNcoQktfqIL+aibKpsaqPXY6+ZEkZ5KemDtqxTsKVmvhDCG6Vq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azvJs5zW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azvJs5zW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAC2C4CEE5;
	Tue,  8 Apr 2025 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110030;
	bh=cRLTUpm9aXlqfAaL5CPX3DKbqXCFHRrFPZ2fhgGgv/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azvJs5zWpHdZ6woDaiUPajqkW79HVGZpLkRfYieK5bwiuOXNohPSybnAw3LDsfDCb
	 21oX+g7Wy9wdYduOGRfxjrPe2HrKC9ENjNeWDg9CSsvB4/VXQnEZu0MtY+8AZ/gfLj
	 Qg9eA0mKkm93RKidFVVta/tF6xJAoWKQlb+8gisU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/227] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:48:41 +0200
Message-ID: <20250408104824.592847385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6a52eba645596..3c46838651b06 100644
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



