Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56A91DF25E;
	Wed,  6 Nov 2024 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895546; cv=none; b=dAhUBiF6cjucK/4vHxumEmKKJdiHH+L4NskwLkj5l3+f6aZMJv7MHxBcVZBQChpSZZ/oqbq+qbJQBTSlKurca2DY6wqCO6fuMpYzLyJXty52NW2iIiN/uks6w05qp4Ojk+dnQMFfHLC3RLPEpom5j/oqg8VjbKyeKs1TqcdFhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895546; c=relaxed/simple;
	bh=L0WeL7+SHLAN7rNH4ZWvxm7kbd53f2+9L+fdkd4ffQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRiqFGE7b213wJpmJFnHp04JbOdXURVmf1KvnPqBcmFn6jAsXkXMmPTHeiJR+qtb5goXTM+JKrdw3sWoFKJ7G+7Rd+S/cAvBXWFUEy1AjoJXa2acB7pXSrIq5oNGseNR9cAZ5z9XVjZf7Pag7EeoMl3c63hrIDwdCtB5zCOZkgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecmcsb7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecmcsb7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF8DC4CECD;
	Wed,  6 Nov 2024 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895546;
	bh=L0WeL7+SHLAN7rNH4ZWvxm7kbd53f2+9L+fdkd4ffQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecmcsb7yh2woxtCmWHdnwu+ZVkhLM1FsXnU3jbeLQgM3fn6s71oI5fXbaLvnoflwA
	 qYoB6Bst0k/aXUV7zsdJ5yGn4D6AnwfBIieeq5bjJdcF+8pcQj5K7VrBfJFKRJWZwU
	 Ipm8QIR7jv0+QJA6eHwAgEJZ6/RK1AGZssHB2CLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/350] fbdev: sisfb: Fix strbuf array overflow
Date: Wed,  6 Nov 2024 13:02:55 +0100
Message-ID: <20241106120327.029504458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b7f9da690db27..38a772582bc3e 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -197,7 +197,7 @@ static void sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
-	char strbuf[16], strbuf1[20];
+	char strbuf[24], strbuf1[20];
 	char *nameptr = name;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
-- 
2.43.0



