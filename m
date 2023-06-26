Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7CB134C0
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA5BC433C0;
	Mon, 26 Jun 2023 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803233;
	bh=cu7YdInQVwlBR8BC09ytCG19a+Ch8gkY/lmCKo8J1k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVEULmpnBu338cE7Z52mXA1UoHym73oagSZ/0QFh4EqKhSaM6akNkbV9ZVR8k2qdC
	 pZpxMfewrRVsMDqXH4+mj6p6opZaUrqmz4EP+XH9urvBkKTK+S/i91AyE2WGKs4q36
	 Tk5sqIggfccQZeiQCvjiAZmuBZ5wPy8vGbMIcJbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/26] fbdev: imsttfb: Release framebuffer and dealloc cmap on error path
Date: Mon, 26 Jun 2023 20:11:21 +0200
Message-ID: <20230626180734.413046667@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180733.699092073@linuxfoundation.org>
References: <20230626180733.699092073@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 5cf9a090a39c97f4506b7b53739d469b1c05a7e9 ]

Add missing cleanups in error path.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index ecdcf358ad5ea..6589d5f0a5a40 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1452,9 +1452,13 @@ static void init_imstt(struct fb_info *info)
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
 		return;
 	}
-- 
2.39.2



