Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2C35101D;
	Mon,  8 Jan 2024 15:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDx59J4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A1EC433C8;
	Mon,  8 Jan 2024 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728442;
	bh=A8z9ZfNKiFASK27oA0KF5syat9ZQNtKVghy6QVcUrGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDx59J4bsp8MrOXjuqNUhh7WhaW9lP8FUCIqZ+qo0/ihrYu0WdKkgR+BCIIGeGAsg
	 Vs2Tsu97wMBRgW3xJI60ZIUHu6lfPecaMfrWsMu6L/JeICBNhOzTt4xyyneD0G5pva
	 WfdIqHtFqd02KCiUwrKcse1tL5gU150SM70v0BRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/150] fbdev: imsttfb: Release framebuffer and dealloc cmap on error path
Date: Mon,  8 Jan 2024 16:35:28 +0100
Message-ID: <20240108153514.765331542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 5cf9a090a39c97f4506b7b53739d469b1c05a7e9 ]

Add missing cleanups in error path.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: e08c30efda21 ("fbdev: imsttfb: fix double free in probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index b194e71f07bfc..3d1ae5267a738 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1452,9 +1452,13 @@ static int init_imstt(struct fb_info *info)
 	              FBINFO_HWACCEL_FILLRECT |
 	              FBINFO_HWACCEL_YPAN;
 
-	fb_alloc_cmap(&info->cmap, 0, 0);
+	if (fb_alloc_cmap(&info->cmap, 0, 0)) {
+		framebuffer_release(info);
+		return -ENODEV;
+	}
 
 	if (register_framebuffer(info) < 0) {
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 		return -ENODEV;
 	}
-- 
2.43.0



