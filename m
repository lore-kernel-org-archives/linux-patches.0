Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32801ADFE9;
	Mon, 14 Oct 2024 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919849; cv=none; b=fraKMRxSElxqJpMJDod+8MZuRFIYk8GCYIeGCLlpg3YSYSpdrS4q7WpF7SDAlFgcLmQdA6Kq/YxSmAbUym7Jw8llRSSOTZeOX0FS437d1T512odmMSz7yAOVx0ZGUBWZLKOH1wN1BNrP0HnJnN39D9hdwwOXThO8DvTXaH0NrzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919849; c=relaxed/simple;
	bh=Of5pn25vDING94u+wEWcCijrc8SaA2gGOkJ/2mZIhsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdQal2V7ySKHmgicikFmxWMhkk/RCKxHaSFfHeyeMTsjL23HnEhYuLYFMdTvxaqHYs2r/q0lOpF2qWtEK8bIW5HgN83BDxDWofc0+JoFZPorNuO2Hu1TZ/vXn2LMLq0LfsjNr4Zs4tkFRshpreXhPOftd3V9/FulE3arjCOBK6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAeGQW55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAeGQW55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71850C4CED0;
	Mon, 14 Oct 2024 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919848;
	bh=Of5pn25vDING94u+wEWcCijrc8SaA2gGOkJ/2mZIhsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAeGQW55QoVqeUObs7Hk27K6kpu+21ZOEOh+O6foYzvtBIGae05pMIRoByJvvRK3b
	 AWL8EyFkJTzkFgxKirf0p3fjqfP6uDaL93C60PJXMWg6eh5jVE0XPW3yQGJV0F49zz
	 YNdJmOHbJlhV4Wxv9nCY6EyrHx8dBNMnv/oHP2q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 724/798] fbdev: sisfb: Fix strbuf array overflow
Date: Mon, 14 Oct 2024 16:21:18 +0200
Message-ID: <20241014141246.514475118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Andrey Shumilin <shum.sdl@nppct.ru>

[ Upstream commit 9cf14f5a2746c19455ce9cb44341b5527b5e19c3 ]

The values of the variables xres and yres are placed in strbuf.
These variables are obtained from strbuf1.
The strbuf1 array contains digit characters
and a space if the array contains non-digit characters.
Then, when executing sprintf(strbuf, "%ux%ux8", xres, yres);
more than 16 bytes will be written to strbuf.
It is suggested to increase the size of the strbuf array to 24.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Shumilin <shum.sdl@nppct.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/sis_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index fe8996461b9ef..7b83d73eb0a04 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -184,7 +184,7 @@ static void sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
-	char strbuf[16], strbuf1[20];
+	char strbuf[24], strbuf1[20];
 	char *nameptr = name;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
-- 
2.43.0



