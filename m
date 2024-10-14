Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E261A0BE7;
	Mon, 14 Oct 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916086; cv=none; b=FflpRhs2m45flP96VS1nrCkLOr6IsE9yErU5pjEn8k/bzPyskFivUvl+Ka7brgpmwcwMNYKnPFoBKcGDwpRNhf1M6SXUHTo/++3peQ3kkI9uxDtWo+6C9rUOj4sNyyerkkB+zglBwb86fbtcRObYIqLB9ebiMcUeDSNd7pJ8mVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916086; c=relaxed/simple;
	bh=EO6SItZPy2HesITlpneR2q2PGsm8AqZYQKNQNcw1sAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaYnnPapUaB/jA7uH1ldOZyGVlkYMbcI+rPKz7Y3X96xkn6eri0PCNuAHlQp9ymlC/pAnHXgJ28nMh3QDwOwnphiosPcZ88UVgFHjRhQ2aY8tBgvM4/QFzouAtTvzxrJMaDPkbRXOq6rNXDgCVeSPNZxoyfFmoF/CBmND8aMY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbe2rj/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbe2rj/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A81C4CEC7;
	Mon, 14 Oct 2024 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916086;
	bh=EO6SItZPy2HesITlpneR2q2PGsm8AqZYQKNQNcw1sAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbe2rj/YqW/e93n4Mxw1V1jSaCxJvSLutuXUjS/zOmq8/IV5qvPkg1mE1+xV9WIbl
	 2HyKalLK4Nzm1Coh4Q3lVHPUQg0CuNUqDJqnTXv0UVktJRIleKJV1ZEh8871XYjRid
	 EwyDZEypIBmemsF2gHBwVDSMJxSOlQn0TuPvWQP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 080/214] fbdev: sisfb: Fix strbuf array overflow
Date: Mon, 14 Oct 2024 16:19:03 +0200
Message-ID: <20241014141048.109270996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 009bf1d926448..75033e6be15ab 100644
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



