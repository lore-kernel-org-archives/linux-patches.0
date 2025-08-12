Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A41EF38C;
	Tue, 12 Aug 2025 18:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023440; cv=none; b=YZNa5Wyr0ldQR4dfAtPDs1LpbRT2Bfp2HioJl7PzEch+meDwcBdjsThy4Pqt3yEZzJxUhe00Q1KThTESQgd0rNEhiRaLOkcDb3uWuluWlrVaav7BUDauf42cNRl+2AGAWiW5Sis1D9+wrN0qlUE/U3x56PoJ3aSkW5/CxFvIEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023440; c=relaxed/simple;
	bh=W4hSqVJ2gyN08/mdJgaPGn7fTysXke3C+Nk7G2yt2GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIyYur8Np0967EFYLpgML9PpgYyzGxZj6IpmvGQu0g/G9H/oTDK81ELuTNto/ggcIeMfl2deOsvoDJuJe5kAi2zJI9AbyLePRtwYqayPHRLKbKmOm1NsvHF+Dg9qe4qoaLqZs6uC1bHgt0uqmCXw+1P0oYaFAMiwqs2anxmEi40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOBa68/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOBa68/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B90BC4CEF0;
	Tue, 12 Aug 2025 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023439;
	bh=W4hSqVJ2gyN08/mdJgaPGn7fTysXke3C+Nk7G2yt2GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOBa68/+FrB/sD1gInSW3s1K4onY4yyTg1a0hsikDNqsamlxb5mM2uXwFQ3zGKdUP
	 J7AjqMWS29e/UOPSd5j+bDJV8zeE2YffJwAv2pVIVsnrTmTkgW0ePWMcIajz00NCLw
	 WUiDKp9Xrbj6UhchXH27q9c+m+LKC45CXY8TrLi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 080/627] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 12 Aug 2025 19:26:15 +0200
Message-ID: <20250812173422.351875558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit eb2cb7dab60f9be0b435ac4a674255429a36d72c ]

In the error paths after fb_info structure is successfully allocated,
the memory allocated in fb_deferred_io_init() for info->pagerefs is not
freed. Fix that by adding the cleanup function on the error path.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250626172412.18355-1-abdun.nihaal@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index da9c64152a60..39bced400065 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -692,6 +692,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



