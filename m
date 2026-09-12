Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CE3364038;
	Sat, 12 Sep 2026 09:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206418; cv=none; b=mE7o64lbQ1+WKrAsDHGzW6VtQHrZ6nEXfj7fYj5QZ4w79isTmcbJlCGu38EOeF5TGfBcqBHxCbpHW2UUwXRQpcEjQnDR+XUjiR9+nLW9X9ri8yPOmrBuGE0nlw1dOaviw4McXKzJH9aGVYQcLGYdFKue7mJkZVjcND9A3CfCayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206418; c=relaxed/simple;
	bh=2XMl/LAjoPywDLXvZE6s96493naypXbdZ+GfljOdLvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLGjaBLduDHE2TrTI/Q0r+CCg/I8PVYHP8w/OpYqMrXX/CUeesD/vhtudJXn3jYIolV9gOSeelsnjgmx3OpUvom1VMKC5QqmkNuakUvbk01mV/kJ2ix2NuaQ0q1VoKMAT479rYa1ZnXWOg8mVl+9g+ZXNm6eUPZ/zQgzcS352Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWg6/5nz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWg6/5nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C288F1F000FF;
	Sat, 12 Sep 2026 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206416;
	bh=f7zNTjVPKFHdz0jPbLvQSaOB4f4CxNrOXHTVySnnnfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWg6/5nzf88TYf4e9E2kQ3qPLLaEbT+MqlcjmXM3ZoSIvJ38fmv0cC2ICIllb0jtr
	 xuGTj9l4jzMGkN166aVkCvxpwuCxjnq5whuPz3ERkbJ1mLXmuScZrtcZpzXtFsRkTU
	 96lKJl7c8Or3gBPcn76jaEZktQKWkoZy4dMBS9e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0203/1518] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:39:32 +0200
Message-ID: <20260912065628.080099570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 52fe4baeff934..73034aeb63862 100644
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



