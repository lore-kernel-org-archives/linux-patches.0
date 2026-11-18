Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029090;
	b=ha4RrFN89VK6YRdYXZyZwQd+qB5bhQDxK23dP005vrD22tcujYa4vXQs4dJ/f370Rrxi
	 G3JQKy66MFWNQLdjvCIQp3ou+eWr9IaSJMeIjbV1ubRqcVaZxz7k4c8jzfNZ2N4/4sXmj
	 SFuCoJ3qFPakv4kEAOxmgbAEs8CttaZawaUwBKK1dgw6kXLNU5X71v2HFhxsIl9usZO+K
	 TAXrzcafG29fHLIrcCiKTP5JWkU1zSRwyf1oS/EK76jzDOPm3XZ5utSrMcuvGXmq3WLdi
	 2639EVg/igNJCb0y07be+ehxhfsq5/VNdIVwyIVz7h4zJqOWXMQ4P8ol21lcm9reJQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrjFm7q29N2W9Qn3Tc89uHi11R1QtTjSSF8heNf2/c4=;
	b=jkHmtbPYfZs/dNFKnjbnIpHbzekNc0aZ1WmGIg+ubts9t2SEwc3j7YsjzSH+e2EgS5eN
	 EHS635HX86ZEd/XSTZ6tNFchM3S0Unu9fXuR07aPDeUkznM7cAInF8JHG8i7P5WLHvSxR
	 FVdd27IllOmxCQRlqGtGT/EGvm+wG0WaZkFatEtdNMjC1nz3Mhw8Nuf1OwgVenmSmnB12
	 MddnMzVgH5VDm7CPNA+X9TnLbtgAfK/bqNpwEeIZbPywkQxmW2dS9X5Phz/dVsI5OezN5
	 wNNiV6b46uy/OMmCi/l1k8hXzNQ9sYwYhX9mgEAYPppbCySNsAxZBu73jwtmhuxRzjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VR0puUrM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F3606A320;
	Wed, 18 Nov 2026 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VR0puUrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0F81F000C4;
	Wed, 18 Nov 2026 19:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029090;
	bh=hrjFm7q29N2W9Qn3Tc89uHi11R1QtTjSSF8heNf2/c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VR0puUrMTFfQp4EYUj95X1dwLi0E8TaXND3B9HDMrFRee3C7whrIL31jYobqImQCj
	 vjrg0Db+ldH8ZQiWlU8+CgVMvW8YY+5dW7y16vGFKUtlK/las5aKGZIYhMXhdRQC/K
	 8mWUpzk1qggfe6VAce+sicMEf6qT+ywCbgownC+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0227/1756] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118150017.319125037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4db198849695d..893f7d3a3d0ab 100644
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



