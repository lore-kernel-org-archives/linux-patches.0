Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4B82F5E;
	Tue, 12 Aug 2025 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022665; cv=none; b=odREEwnMDgdiXzyxanTtAMpmO4p8WHllJZ/4SSZklKHMTixGbd/WNQlcpULZK4u2ZInEUvuM9BriuQeeClcBCC59IAt3iUdT9xxhGPWBROSAc+71YrLG7yqLHMk2V2nBgkmEbBVTHcfWsnCxVQ7aZxlvMYyCAWwW/YWkfTHldfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022665; c=relaxed/simple;
	bh=sGugAO7oRNjXEs3T/MHg8DdzGOzOl6u00SpZIeMh1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF6brpdGOeHHNk46uK12CModjfveY2JzHpi2amKUsBUztCI5I5kPPOazBa7O5kl6BldmsiLjzPPTi08QZmjj0sUrLWnBYqMfGp5T0d/u32NoTY144fSa5B9C01t0tPWv2HgpXyHxwqt7YucLA/p/IZmz5zo8lK8AvHnZg/olgng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igI6KsRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igI6KsRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A4AC4CEF0;
	Tue, 12 Aug 2025 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022664;
	bh=sGugAO7oRNjXEs3T/MHg8DdzGOzOl6u00SpZIeMh1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igI6KsRrgHtkQa66fSbJd/JzRcJOHTDcqK2wLR6NwTizpurMM7JEA4GQM9PN909tm
	 HX8G+U+IyUpfY3YR1eqOFupqZESZfgljfIG2Y5Q8fimYmCRF2+4wopTfg/70+XW0jv
	 Ew1Cd3f1V/4OIYNiVRXHszFDjthprNewqoYD3wck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/369] fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref
Date: Tue, 12 Aug 2025 19:28:40 +0200
Message-ID: <20250812173023.148140454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index ff343e4ed35b..c0bdfb10f681 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -1007,8 +1007,13 @@ static int imxfb_probe(struct platform_device *pdev)
 	info->fix.smem_start = fbi->map_dma;
 
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



