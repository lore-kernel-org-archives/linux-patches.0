Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCF21EBFF5;
	Tue, 15 Oct 2024 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994262; cv=none; b=k6IPUGcbnVTnFhGDdmqbKd30Xy0Cwvb/yf8QjwyR3F6/fP5Nvn9eVqEQqUI/u+68hhrEhG0mrhgum4BT4kOjw+nxgA/PGIOSfYtWEjwYWZHoMn0jm7rwjmy0AD55XSW+AWCqcvFTcKfX68XVUQYo7LCkIddvCBwSZs284LEIBe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994262; c=relaxed/simple;
	bh=eY5qRxaaEuCUigt3MI5l4LnggFpqhZk6LuNV0jBTTDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqYqvjmuTT22HuFfOf3f1IsuYz3236RdzjwULR59RlmsLERZWtyURHxu4GtDKpfVreN2n0jsMvVnNK9W+G2l7W6f/69JF7xXPYcjs0NhXZOP32uKzWZgo9u3a2BuuK27csj+wm4RKCB20aFmrYvH+Ub8hu6fdor6R7Q5EgeAfSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imEVORq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imEVORq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E748C4CEC6;
	Tue, 15 Oct 2024 12:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994262;
	bh=eY5qRxaaEuCUigt3MI5l4LnggFpqhZk6LuNV0jBTTDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imEVORq0hZzAUtSubUY5Cdj8xglofQgsWcijSsbl5HY/nlLdhk8g+eSqjbfRI3h+h
	 yvKvPsbLDpGusTReiny5Rl0DfgzNh8sDNJMve/NqqiwzDoUp40ILv21AvnHL2shmTV
	 Nfq8Au/fuci0D+AFMgtfwX0y4PrSNTrAPbqrnOdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Shumilin <shum.sdl@nppct.ru>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 622/691] fbdev: sisfb: Fix strbuf array overflow
Date: Tue, 15 Oct 2024 13:29:30 +0200
Message-ID: <20241015112505.019030151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6e21ba008953..ce9dc1e8bcdca 100644
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



