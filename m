Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E97611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29390C433C8;
	Mon, 28 Aug 2023 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219190;
	bh=qhnCPPjynsGwn4GjTYHijffYxlS9zduO5sU1Zr8LxQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emaSPj/qs7dtzFw3ZwbRD1WMUe6rKtcJOyh2NExdqxWtxKOm0MM2t3OG0Sw0NZ2EH
	 f9ApIdzNxDg/lPwWsBdP+DsTzacnpj9nXgm8pNKHNXpPMfdXtn6ct5HX1cbaNIY091
	 H8uhyz6P7Et0jUgALly8+ko05NVfT3xxYiaku6vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/158] fbdev: fix potential OOB read in fast_imageblit()
Date: Mon, 28 Aug 2023 12:13:23 +0200
Message-ID: <20230828101200.886937835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit c2d22806aecb24e2de55c30a06e5d6eb297d161d ]

There is a potential OOB read at fast_imageblit, for
"colortab[(*src >> 4)]" can become a negative value due to
"const char *s = image->data, *src".
This change makes sure the index for colortab always positive
or zero.

Similar commit:
https://patchwork.kernel.org/patch/11746067

Potential bug report:
https://groups.google.com/g/syzkaller-bugs/c/9ubBXKeKXf4/m/k-QXy4UgAAAJ

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/sysimgblt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/sysimgblt.c b/drivers/video/fbdev/core/sysimgblt.c
index 335e92b813fc4..665ef7a0a2495 100644
--- a/drivers/video/fbdev/core/sysimgblt.c
+++ b/drivers/video/fbdev/core/sysimgblt.c
@@ -189,7 +189,7 @@ static void fast_imageblit(const struct fb_image *image, struct fb_info *p,
 	u32 fgx = fgcolor, bgx = bgcolor, bpp = p->var.bits_per_pixel;
 	u32 ppw = 32/bpp, spitch = (image->width + 7)/8;
 	u32 bit_mask, eorx, shift;
-	const char *s = image->data, *src;
+	const u8 *s = image->data, *src;
 	u32 *dst;
 	const u32 *tab;
 	size_t tablen;
-- 
2.40.1



