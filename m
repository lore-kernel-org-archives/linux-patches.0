Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B7E267B89;
	Tue,  8 Apr 2025 11:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113178; cv=none; b=AqRioOBCby6bl2KLNbOZQt+U3eVussLAsmQX0llj9/BnRKBSkC72lieYnegNpahksKSTUh31Hiuz1mKit0E3uryii67JLYFWmp9Hzcs016oPPocMd4f/oSZiGfpD4XeNGysqDXhgff7NSmaaO6cXXvT3L8NHh3TDC0q9V5tZcY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113178; c=relaxed/simple;
	bh=wOAbG6Te056qmI3mC6xym5eV527q4+sm/6WjbkQVOs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiYNI2C6YqQE4dGe5GfdGZYMo7Ico1zYe8b8zkNXb67knj6RjzA7IPRIRoPSP7hmEq63tgNOEAu9z530Sa3N7bA0UxQfOEHrCbjcVuQiNTk2f7LkocJhwRJ065qHazYT0hRfpXuXWw3kE0d3jygBna+geXwM4tckxw9+dkES2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsJ8s3cS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsJ8s3cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77922C4CEE5;
	Tue,  8 Apr 2025 11:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113177;
	bh=wOAbG6Te056qmI3mC6xym5eV527q4+sm/6WjbkQVOs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsJ8s3cSiXu6OJITw0SF6hvgCB/dwzzS7RrYo1J+9NjynkEE3PtGnfnBOjZ2oI7gA
	 LLNSkw0YK89m87BmUw9ptflVeOjJ2qdfBJYOzGqVYtqseoQ28Y5PKSY0mZRA6cmPJ9
	 I+hgPZ0niO4Ko+1fvAxgALWMY0bkkaeHKzZfe2cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/268] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:47:52 +0200
Message-ID: <20250408104830.144525483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65c799ac5604f..b9d72f368c6c6 100644
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



