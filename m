Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023057;
	b=1zCP96bdM8fl3ZUHSInEZhYzVZFf5rBwOjrMCAxD3JFdVM24jGO09XiCCPU6o+fgVCUD
	 ijbtQmf/L3oSH0wW+GxqpYuXUHpB2XteEDFBd5KM0V/wi4bBNAdoxupOpdanrvxpuoM3Q
	 Ex+1Cl2xtfcGsaDsyyIg2rGm0Lx3iQr97yb8dET3lC4R1h4G4cX2koCm2kLcGF6mgq2aX
	 RH1yxVIdXxQ2tVBs5XoonQBSf7AqeQDiy705Okeiu6dGjxAGXa+ktxCUKbUwwNWUN3lvn
	 T9WQGiFcO7bQFSxNLBRpXvh4fcrC0sycgikKyfCcOF9qJk+WN2zHZvSRRrNE0+IhTjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHuI8+JqG7nTwn6Q6pYuZpOlguvZstx23w789slFFlg=;
	b=ENDtqU0x4PaUVpLd6LJI7xx4/cx5myVhU2/X6FmYmDRl2o5wLKp094tiS0RGn02x4DVj
	 9zbZ1d/jyyEe/Ta68JM6y0pRjheHvCAnzIvxdIQ/P+t8R6mm4jn11YVq82bdcsgBP43e2
	 UcpiR22w+ZFNJNzP0Fcq+GhekkvTAPX5Bn+yXcv9tHuMk3Jtgt1trIeqsAdFAp/L8pZxs
	 NOUcVuOrTgkH8eFte3UZ+FXqTpnCekVynlEThjlsrW0VEgCYGRm5EsXMo9D+G2DyzdB2y
	 KvESf/+gVa2Rt8CeNUZO3bgITu8RnFwIAPetrcw0HQk9nUFrqaa8+ZvSVaxvynwYgew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihAyNA7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D8606A330;
	Wed, 18 Nov 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihAyNA7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E211F000C4;
	Wed, 18 Nov 2026 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023056;
	bh=YHuI8+JqG7nTwn6Q6pYuZpOlguvZstx23w789slFFlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihAyNA7SAdM4TR1eQgadI1qrCbHG1WfBd5pZKJsqLvvpGktysrIiGnB93Ewv6Pu5v
	 l151P52VnySyrcNb+y/BUilLt6P2vS8zPXk9d5grNtVX/d5ETifJYiE/ITR9lB/WbT
	 4NxYvgVMzzha91MB1j4obEggEd0ucxPUtudnb8G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0231/2151] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:32:46 +0100
Message-ID: <20261118150130.192579314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a5be9258037f8..41c338a768ce9 100644
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



