Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869E134A5
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC16C433C9;
	Thu, 29 Jun 2023 18:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064452;
	bh=jGuwhosPqR+8otm7NNUjp6JfVxgUTuY+fcRDuzgsDJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrnfFL3mBHnfEr1cfGgnACLO3KQxMf6oyOJPATBmYdw/8Qs/qesbszOhQCtyEGL6t
	 tCaJBcyPTwfCIUkbbqy0T2JhSUlQf7I4B5fCV/h/jcY3tNz2AYuxrjK7pr9Rjq7zuA
	 SiRqMtQ3oYh8Gjpr6lqlBD6Fs++UKbyl/EN19lUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.3 25/29] fbdev: fix potential OOB read in fast_imageblit()
Date: Thu, 29 Jun 2023 20:43:55 +0200
Message-ID: <20230629184152.738910643@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit c2d22806aecb24e2de55c30a06e5d6eb297d161d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/sysimgblt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/sysimgblt.c
+++ b/drivers/video/fbdev/core/sysimgblt.c
@@ -189,7 +189,7 @@ static void fast_imageblit(const struct
 	u32 fgx = fgcolor, bgx = bgcolor, bpp = p->var.bits_per_pixel;
 	u32 ppw = 32/bpp, spitch = (image->width + 7)/8;
 	u32 bit_mask, eorx, shift;
-	const char *s = image->data, *src;
+	const u8 *s = image->data, *src;
 	u32 *dst;
 	const u32 *tab;
 	size_t tablen;


