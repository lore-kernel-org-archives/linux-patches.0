Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138CD238C19;
	Mon, 23 Jun 2025 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685729; cv=none; b=F4xMVsKJSm835A9dDQMp7M33eOny1PJCUrTlhqUgYnfj6eoEBI+XSTo5tyVslpuJNvVo3a6uece8Hex1Dh3hTpfs5doR7IWqGvuRIw5oPxuUueX3sH2fUDvhM1J3kXzlb6Dysk73x7QonPMFmUWIrBppoE3WA9YdAxeET6so688=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685729; c=relaxed/simple;
	bh=gWlCGWusZL2vjY161oldXb7G32q8Y9cYXsHU5chlcbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psK4JgGDJog0r/jQ6pKjvevJRGGZugWsPFH8DXJpg6GvUsNqsq/qevrh76o9oIbqpUbW7knuRj6AmHrfaPRohAhTenWaC/zGUBPkLykRw6Cmq3GnSkgYtWjqwjOO9e5UagQ3Btz1ZaZRKZkWO53ptPFU9XfY4fm5FGtA/Cyf0hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGmi7XMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGmi7XMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0BDC4CEF0;
	Mon, 23 Jun 2025 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685728;
	bh=gWlCGWusZL2vjY161oldXb7G32q8Y9cYXsHU5chlcbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGmi7XMWAG57mLbjIRR2lckmCYTDUvkmax8gPxAQdHTU+6le/WhObnNl+dzbdwkip
	 yEhqf2eMfLdgpmHqm8XwUdoC4aBt7ZZoVZV8tcRs55sCEciq8Pet2rJJylZcJjYdH5
	 p1l4FmJwYt0vSN4maVslmbnIEvCXR0oJpL8jthp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/355] fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()
Date: Mon, 23 Jun 2025 15:04:32 +0200
Message-ID: <20250623130628.962943880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 3f6dae09fc8c306eb70fdfef70726e1f154e173a ]

In fb_find_mode_cvt(), iff mode->refresh somehow happens to be 0x80000000,
cvt.f_refresh will become 0 when multiplying it by 2 due to overflow. It's
then passed to fb_cvt_hperiod(), where it's used as a divider -- division
by 0 will result in kernel oops. Add a sanity check for cvt.f_refresh to
avoid such overflow...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 96fe6a2109db ("[PATCH] fbdev: Add VESA Coordinated Video Timings (CVT) support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcvt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcvt.c b/drivers/video/fbdev/core/fbcvt.c
index 64843464c6613..cd3821bd82e56 100644
--- a/drivers/video/fbdev/core/fbcvt.c
+++ b/drivers/video/fbdev/core/fbcvt.c
@@ -312,7 +312,7 @@ int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb)
 	cvt.f_refresh = cvt.refresh;
 	cvt.interlace = 1;
 
-	if (!cvt.xres || !cvt.yres || !cvt.refresh) {
+	if (!cvt.xres || !cvt.yres || !cvt.refresh || cvt.f_refresh > INT_MAX) {
 		printk(KERN_INFO "fbcvt: Invalid input parameters\n");
 		return 1;
 	}
-- 
2.39.5



