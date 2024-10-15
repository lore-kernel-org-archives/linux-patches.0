Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD941B2184;
	Tue, 15 Oct 2024 13:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998555; cv=none; b=Z266XozMrHzgQsZchcGt2rkUVKW3pk6Nt2JY/wOMWMb1IBEUH+TWdmsxy6MXTU7EfoPIX3YJk8d5snJYkv2QfsizyEW5e+KRg2M/h6amBbTVO/O05dtRBkjXyjXnZIA2HZz6CTgSaMH+kqIZbzJwzUjpVcQrt7lU49ADgPyWLXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998555; c=relaxed/simple;
	bh=w+72BWu3yFhTHSNhYeifKho20lLYvQGgxDGEyvjvQPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4EcKSsj86PMw6i8xgc+h7T1HBCpz5z8aNhjnIFTzHGSyYeEdE8xViHQ+rNXx1AZOBc8Qf77VpHfTeBSjU71DFJgvvrfvwyvslYC2m7lsls/VfeY+CS2t/8uP5QbW2ZuhS1A3W9un7pp/nquRva+fpbFnfgfTzjwtpRy8zw7TZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkOTstQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkOTstQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13BDC4CEC6;
	Tue, 15 Oct 2024 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998555;
	bh=w+72BWu3yFhTHSNhYeifKho20lLYvQGgxDGEyvjvQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkOTstQCPhZjVHJh7v4GOFl1BL5DW92ceM2tyfPBqr5N8/LrDQ3Hj/NJDMn1/rfOU
	 u2WM/FnuGhlDNerZK/OaGWaZssHKtxx0MylV2LXkm86t9qcVSgj3IqbTYTE87pHlY4
	 E2i/R1dxVFFzRvXzHfK5bzdBiDevfuDNZfS5aJEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/518] fbdev: sisfb: Fix strbuf array overflow
Date: Tue, 15 Oct 2024 14:46:14 +0200
Message-ID: <20241015123935.145472443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e540cb0c51726..7787fd21932cb 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -183,7 +183,7 @@ static void sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
-	char strbuf[16], strbuf1[20];
+	char strbuf[24], strbuf1[20];
 	char *nameptr = name;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
-- 
2.43.0



