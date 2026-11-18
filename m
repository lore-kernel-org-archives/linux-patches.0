Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015549;
	b=fOL0isRfmeO9duETzzIdZbyrNr1DgGv9ejdHQZzJPnP2RLGdBI/SIz0NZkQOMGnNp18t
	 853/6G4I/iIHngCHf0qtpWlK1YVROFQn16i1fzd8CZy1naElHLZkVTIN+6TOvZj532pQ3
	 s7ctuTAoASToN7NAvvkfzTtfTb/dyW7VJCk1AueNa/TXAjvXkFZxRWYfLTLDUnHs9/t1v
	 phpp3hFjPknKhF/F3mf2sGY4dWH/N/BQjb543KE9I4sR5XSPO9E+ShA3bK+fOreGNR2+2
	 tJ5FB1c1o3GuvSnYNRW5x6+Ue+EQM2R6AmRtlvHKHwapQJOV4SifbclmeQGm5FydMEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHC3UYPXYwDHCZCQ142HUlrrED+j3BkgWJqNVn6FaWk=;
	b=1kKuoG2rwCfsKH3TZn7cun2Dm6yPwrE+FF/Q60oDjEKoiauPQRGHjKxXh2Shqxv8W/bj
	 +gH4/WTF88rbDtUUl3Jpmq6IhHFQ2pQhPss9cD7/e331iEgC/zdQ3vVzcPjN8700SCrdh
	 WfNR41E4nAAQpxwvvNETDwN7dTNscllgBZU80HE4vkCUoiOePTbewlpMw9VQkCDjui9s3
	 Yg5KImZmeELO75wXR3jcDxDT04IHGJBuPlshKhj37b+RL6G/V0aGPKbkIPpf5LUGWeJP+
	 ukaI4GgZRqRlCG7P05UYa/uFj30F781g4UlOQpV1spCe1xhy1dVTcBlgjGHlhBymV/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wxcKeb+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3875B60A2603;
	Wed, 18 Nov 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wxcKeb+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4F51F000C4;
	Wed, 18 Nov 2026 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015548;
	bh=CHC3UYPXYwDHCZCQ142HUlrrED+j3BkgWJqNVn6FaWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxcKeb+6RfMpEC4B9uxk0I6s1rG67e16bpvnvuZQd6HmFlOXRSVSVlEoHpT/cahSq
	 xW5eSqJ/y/+AQGx34gO4bNGvoECGx7is5rbKCOwEI5pBdprlVKrvwF4vJaagCAx6ps
	 0Q/ShOYaTGFUqLfsuJUolquGvJxeX+GMM1SJeTKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0214/2651] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:24:14 +0100
Message-ID: <20261118150255.577685752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a6925211c3b50..51290ea345c32 100644
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



