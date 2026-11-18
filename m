Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047879;
	b=wxlVyByqajxziy1XQZp73DElavvIaUfwSRSkDn3lqIdi+2y7nW5w6NCNrOEpeVD616jy
	 Xgc90EueR17G81Tiuvu2ljKYxXpY20tzS10DVh6vqH7gP5b9wcVW58DFFaU2OpK4G7cIo
	 /Bz8SEN+ENbpfnBAJAPDmdJWUkuWLEL0nZasZ6vkFnsFrlDHIYI+dSJPDj/611BuuhRqO
	 L1pQFfweyYnu8XbwDpju9Ap5mhCynIZB3KKblmg8Lfy/vv20DIayeC5nf54FSi1nyedGo
	 wTkTmojrfA6OOT33dryrf148jPvx6NK48Dk6Jo7yrE9OeIaJTHaEgGBhsFk36pfrjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZpZ2PJM65U41XfQl9T1YNOUjyRnk8JAfc8YPL2OSgk=;
	b=2zBPF8iuMB9iqmUHVKrcAMLlO07EuvltsyKvoVv5ny2KHziOn34Dqt+Jp1fULm27IW2k
	 YdRNFLdLLtJBh2/d1p8r0Ad08L67vj5RUYnTey9Ebp0nBfLoX1nGNTHZZmQ7H9RvtsN64
	 o7zl5ljJrBxMZnJl0RTepxIGNUH/4u5bzhCLSvllQxx/Ifdvly8651VePESls762DafmQ
	 vlUrjr6sFv7f0gDYH7W2hpFFubIWBnKQzDw2lQKSm2yyCoFZyktRlk/407/06ubzUQGvV
	 A5PWhtPZMtwYeZoZjMDO9WmjBmnI0yEhTHPEcWH0jzE58iucvyI6qcqXf/bKIojgZgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciHSrMm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B36E606A31C;
	Thu, 19 Nov 2026 00:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciHSrMm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860211F000C4;
	Thu, 19 Nov 2026 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047879;
	bh=cZpZ2PJM65U41XfQl9T1YNOUjyRnk8JAfc8YPL2OSgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciHSrMm8KoEsYjziVAEJH9da2EDBsbZSI7g7SvSynXy0Ux3ZqaIx2sFajCl9iFVVb
	 pHeSNZtfsWbtdzUJ1fV67raLIUMXzLk2G4UEPXOBSvL69IzyJ9ENzTnUaG1Mrs3WXF
	 1nSet/epMc3rZPQ98mwO/huYVIobS6kWweTHqcPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1796/2857] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150305.930034839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2ab38a92778de..d24c384097dc4 100644
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



