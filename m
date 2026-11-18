Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039379;
	b=GhZoTe2MvcE9S/+4eRpzfiZ8kEFTECYL3qWVV7V3J/YOAM1kyOKKA048QQIxPFiCIM2p
	 ygmxhA6wLWKj3FiekXuXSDuD9XuQINO6mahdktY6bQiuL88AEyhxgSmk1/m8LvG/085bO
	 PLRS8MiVQiYIBkrTFrYd0IgyawNGcF3kESlntKQ2aorbvn9xbjMEJ8m9bGJyLFBoOg7aK
	 Qoga4+commfjud2kkEc0WXFEQH2i1Id1vB0hL/JSy64KktRGjXJU0g7pHszuJ9LGdWMKb
	 hrR1sf+VDxm0CUZenjabwwMXWsL0ENsG+T0fyrAH5MrAaNwYZG8If4zua0LLQXyDWiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uX7Li6ZSiA67xKKlgWBhfsGI7fzyXFqjQO/vTfkgYHY=;
	b=3Q4xGbPV8kegGrYzoKWznzvAtap4rU6Ss0/dX+ur0Ococ8FoYjsxTZMmI3YKcfLu9H2/
	 hlfzxsRKORv2VOSUEguT5rxGu4X94AvXteMTU1SVv0ELR4uMMnnwMTRxT/weRuq/EGOdZ
	 5CpDBGPjCKbiB1TATjqnBOujgRxqnVXDIG+vp/WUvuU/PgU5j3MjwF6/eKbXR3jjOwR7Z
	 1q9PFKYL0/wHta+RFXI8c/JQyoUo9hbOf3fsTXGvXQRYNXvqcNc1XYyqL4EpwGSfcDJfO
	 sl8r967plIQYlEiXWNZdDuXdpE4/VzHR3VEPAzc7FoLQ5SmnXJ7RLK6UzqAv1wF55vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVXSqL2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3603E606A31C;
	Wed, 18 Nov 2026 22:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVXSqL2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E401F000C4;
	Wed, 18 Nov 2026 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039379;
	bh=uX7Li6ZSiA67xKKlgWBhfsGI7fzyXFqjQO/vTfkgYHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVXSqL2A6ezIlhYyhEGu7jCu+7MJ+w3wJFO3bV7niCvnYJZcbnb4biwyBf2QT9tTR
	 xmQ2RxMPtTjO0PUQIVU3YTpLzYSx9FrjmwWVK8UHXkCoJjm26Z5GuNdXgj9oRGB6ny
	 CT+mjUPHLgbLOZAC1EzPOiz04/DPtJTDdXNO9vLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2052/3318] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118150423.616437889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 58d27c41542be6c40edac4f91f35a1dd8bf0d2c2 ]

pm_runtime_get_sync() increments the device usage counter even when
runtime resume fails. cctrng_read() propagates errors from
cc_trng_pm_get() without scheduling the work that later drops the
counter, so a clock or reset-completion failure in cctrng_resume()
leaves the counter elevated.

Use pm_runtime_resume_and_get(), which drops the usage counter when
resume fails and returns zero on success. This preserves the existing
success path while balancing the error path.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a55f5f2d35dff..d346e98f4dacd 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -86,12 +86,7 @@ static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
 
 static int cc_trng_pm_get(struct device *dev)
 {
-	int rc = 0;
-
-	rc = pm_runtime_get_sync(dev);
-
-	/* pm_runtime_get_sync() can return 1 as a valid return code */
-	return (rc == 1 ? 0 : rc);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void cc_trng_pm_put_suspend(struct device *dev)
-- 
2.53.0



