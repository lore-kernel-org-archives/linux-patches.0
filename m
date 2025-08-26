Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEFE3451CD;
	Tue, 26 Aug 2025 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215953; cv=none; b=S6af2ephyAV/bCUvQ2wBiJPyleH32Nlhw2gtZ4AS93U0IW9Obn1JWWH3AhHKVPqiwCg/0oVn78DxLfAbd98ngRbzgKACPhKvTiFa8fZoUMHufoAFkBcXlDiBd0OLAxMUf1IDI97pKkwD3ZbdHbRLCeXL/UdvZ2jVWGU9sbLrEi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215953; c=relaxed/simple;
	bh=56dLoeES3j5ZXUFAV9oUEVWuAFmEOwmokC0KL4r/c1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVmoHqIEayyaQLI65YJZopGvjZnASVowvcmVWKh1HWCOIogZ3r3IzkvpU90c4zKU19H8TsOAuyN/C4hO/jYsetv36mOduRpaEnQbD38KlnfEE7I4ulIYPgSvrl6eObmQCS6HU4HyU9Oqr/2ha02/ZPxO4KUy2vJsUg06THqG1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmJ8dsPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmJ8dsPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240A7C4CEF1;
	Tue, 26 Aug 2025 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215953;
	bh=56dLoeES3j5ZXUFAV9oUEVWuAFmEOwmokC0KL4r/c1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmJ8dsPjwJcKRYZEB/m6VUhOCl2dVd9AraCdDyHWG3cQL0XzyrqW3WddhBDzi94Xo
	 C86iPTeKMSKMy76o/XIGuZtho/kFSOy1cQsV6V/B8FI1T4xf3EBB1CjvxYFJkGAEx1
	 PXHktNCVzc1llkt+HIiTllgQpOpfbY3ZQqaYuTvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/644] fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref
Date: Tue, 26 Aug 2025 13:04:48 +0200
Message-ID: <20250826110951.329066050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit da11e6a30e0bb8e911288bdc443b3dc8f6a7cac7 ]

fb_add_videomode() can fail with -ENOMEM when its internal kmalloc() cannot
allocate a struct fb_modelist.  If that happens, the modelist stays empty but
the driver continues to register.  Add a check for its return value to prevent
poteintial null-ptr-deref, which is similar to the commit 17186f1f90d3 ("fbdev:
Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var").

Fixes: 1b6c79361ba5 ("video: imxfb: Add DT support")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index cd376a9bfe1b..f9af2b1a91ab 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -1007,8 +1007,13 @@ static int imxfb_probe(struct platform_device *pdev)
 
 
 	INIT_LIST_HEAD(&info->modelist);
-	for (i = 0; i < fbi->num_modes; i++)
-		fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+	for (i = 0; i < fbi->num_modes; i++) {
+		ret = fb_add_videomode(&fbi->mode[i].mode, &info->modelist);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to add videomode\n");
+			goto failed_cmap;
+		}
+	}
 
 	/*
 	 * This makes sure that our colour bitfield
-- 
2.39.5



