Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D77C2EBDE9;
	Sat, 12 Sep 2026 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197520; cv=none; b=BMuhJ3qq4u5x5i0JmE22TW3gVCz1icus+TNjUleMNmAAYirN1l49+ATrFpBE3rGG6+z03jKTA5dDxbcdDZMbNALMLclX723SmVg0KmhfFA8tGVqAXjnf48zS4Xsmdjk4wG89KB2HmEdKQ+iwjNSe3H9LeIVyohksqxxqrsjq400=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197520; c=relaxed/simple;
	bh=A2fajSirtlid6XRhG25nUzRpgVX+wejaSDxdw7t6PbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMarx6ij89b+56evyjm4PNuWb/As/XMRGaBH4Nju7MXd5Hygz8jFmXRa03RGwqo4FfptG8NsnpZsmQLMmYi2dzWTRoEfDrPqVNccdJX80hADF64H8YEorYU1Ck0CylYs3UNaODWgPMHNQfsuxzTLi5TS1WkdkYIKhNeAlnV2uLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUip3G4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUip3G4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0FA1F000FF;
	Sat, 12 Sep 2026 07:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197519;
	bh=bSaL9RAetUJ47DUinWWWSqXZLBalZEBRh1YD/HkEA9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUip3G4KPSOMkPIipTi7PYJqrQylY9wIegrR9+y7ETXl7vDIH4EKCzVhgZMnc1CBo
	 fOXqfCSmU+1/CXcY/tgtI7s8pMPomxwI2yyHES7B0t9xNlhM4F3C7wZIwm5BbiPiu+
	 Wa88Tf49roQ/jKpw9M1PL28nUs1kAGXGS95U4Wbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0192/1815] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:32:22 +0200
Message-ID: <20260912065653.508030203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d03f980a25853f6a380895119a572a3bb1194e8d ]

sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
security context buffers, but ignores its return value. If pool creation
fails, probe still continues with DMA setup, algorithm registration and
child population even though later request setup depends on that pool.

Stop probing when sa_init_mem() fails, and route that failure to the PM
cleanup path without attempting to destroy an uncreated DMA pool.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 965a03d5b27ae..d865fd4a098cb 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2395,7 +2395,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sa_init_mem(dev_data);
+	ret = sa_init_mem(dev_data);
+	if (ret)
+		goto disable_pm;
+
 	ret = sa_dma_init(dev_data);
 	if (ret)
 		goto destroy_dma_pool;
@@ -2430,6 +2433,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



