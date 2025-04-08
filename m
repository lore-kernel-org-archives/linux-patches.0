Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D81126E15A;
	Tue,  8 Apr 2025 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115646; cv=none; b=VUJMruM8bzo0Gpg4FB76kVMWXHTGl20eHwBvBjMvTumAKmaiCK1Gg/Ful9GxXKz5XAH+OgA09dJhN1gDVzZmAIhozMJ0b+W3V0/dQnRBnZo/mp4SxP9F4N7Yh5qFE0mst2iOXFErpY7hDPy5ZICdtMF8dvWBKyPwgj7M8Gn5qXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115646; c=relaxed/simple;
	bh=1idl4ZrlHMg/Wqyvs/aNSqE3wZgiWJ+FkKsN+qDu2i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpzvw2dXxku06btEPpMwOekbHcJGmyNZVJpe7K2iNJYprmw+0upugvqr4b4ukhaIprfsczN63nxnyuiS20s+BZkhN7eF1ISSXct6ayXIY9sEPUbWeJHy9oBR+T3IyoYWpFEIQMcXtkhUXr7kTZr86PqfEOYzY5NK2e1yiN5AKnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdMojFcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdMojFcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91467C4CEE5;
	Tue,  8 Apr 2025 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115645;
	bh=1idl4ZrlHMg/Wqyvs/aNSqE3wZgiWJ+FkKsN+qDu2i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdMojFcwBbYuinIWmsmKzmvmNZP4Q7UiWuyU78VhH1h5I6aw6TqS6tpDwimLADFyl
	 b8XwQ7mus4HcG4qz6J8neaMNb0fAW/CiP0kr2L18rRI9QB+WTmIMKWf8ijc1e+TtRj
	 3Zcwr8ik/tsbpX+H23JrL8Lco1cZDGaGWvQ6JlK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/204] fbdev: sm501fb: Add some geometry checks.
Date: Tue,  8 Apr 2025 12:49:41 +0200
Message-ID: <20250408104821.840589542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f743bfbde2a6c..bbbc9de06a81b 100644
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



