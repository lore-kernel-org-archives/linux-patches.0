Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10684350D4D;
	Tue, 26 Aug 2025 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217433; cv=none; b=ry+EwM1vWLMzcrkkjK3feegEQNnGrfqjGfvH8Pzsns1CiBUM2bThsO/PaDBLj/2N5+BLkm0409G5/tk1zwpDHXiKncWtxkNRZX61LuGm4dvUAbZWtPmc+/l9kLqa9qUbNC9NoieNpNt1ymUtnkCeqSl93HITk/OZPF0U+qzwbt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217433; c=relaxed/simple;
	bh=ninqi6EdfPmGWQ9eaIjEvGYt4Xkq6QnUe7sxOdPpcyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOp/6PEwtf1eMoX5pHWyr7GNXPOS1p4CZ2JHlLpJfN0mc4N5d2cbWrBkwN/nPMfIaNf2FIcNOuhnF9fXpPNgDt82nDYPSZ+uE1OJAek71qpeNm2mHkHuD2CI4V+QwvYGIL7k2/g2vfV+MjP0IKrZU9XLdHLK4Jf7+7qn5/uo2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RARZR1JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RARZR1JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CF3C4CEF1;
	Tue, 26 Aug 2025 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217432;
	bh=ninqi6EdfPmGWQ9eaIjEvGYt4Xkq6QnUe7sxOdPpcyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RARZR1JEYxRh57iUxyEHg4VgM8UlG2+hPsDnbSAu3yNIqjJz07mFOzyUbHw67PSmR
	 6X8ob5yNrgs4MnVY2N6k/UF1fg72iSVR3Hove0tXUOOJZLuJDh6udHTp3UIlFlvSlu
	 Nwf/9AELts7fHPYwj/Eqm246xLmXLBeXGL2s2Hmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/523] fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref
Date: Tue, 26 Aug 2025 13:05:52 +0200
Message-ID: <20250826110927.999131185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
index d663e080b157..91f041f3a56f 100644
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



