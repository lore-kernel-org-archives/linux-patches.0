Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB24D46F4A9;
	Tue, 21 Jul 2026 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662178; cv=none; b=WVvtV4dD3ap5INf+Alow/1uVZStYWtFpOGD/XcVCo36No9IG40bQ2ons2oB8vUXarWrEy++36L+/soWkD4mA4BoyGdhBxjE/440TZfYoT1DCxpsW+nGOuax9tQGNMLd9/8wPiBQKqgJAwQZnsgx2LFirNpQByRm+1igU5K68yJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662178; c=relaxed/simple;
	bh=4Zh2VkBB2Z0U2pAo4wShbluw6mPbM1mCEEez0yaqWhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdRYlO9kdm+lyw9BJkSu5arZtXvIKP2N5Jq1k+6wYV3AHZumD475zBSb1j93duJRIFD7s2Woop2DHGYO/2WOJ4ySmhwb3+fwDfK1WUvNsj36r4dDeViuYUiqNGB4aV1ttI8ldyHBRKnlgyqW2P3Lj79VdrI3UPPc43DHuMWLmpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFELCMAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFELCMAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B291F000E9;
	Tue, 21 Jul 2026 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662177;
	bh=vrTBE7SoHuH67rdAlh2CVv6oRyRkbzZC5T3utu54PXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFELCMAWyUVfgVht2uc0UJASM6noK01Gh8AbAe7bTur5LGG8h+7/V7WKzp/EdKPBp
	 eg4m9RIJh5RHpLh4HR88venUAHeUv+ojveuX4NnBO85EaTfNFDtEgc0Ryh0SVyoCOH
	 FzKH1iyhWBl7i0OB7R2yZbV7Hc4BVxaTpvk3NMTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0346/1276] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:13:09 +0200
Message-ID: <20260721152453.852653447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 606ba888b98e0d26a2c4e5c8dc0542e3ad8f0f3a ]

When the rng module is removed the default RNG will be leaked.
Call crypto_del_default_rng to free it if possible.

Fixes: 7cecadb7cca8 ("crypto: rng - Do not free default RNG when it becomes unused")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rng.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index 72da96fdfb5ddc..b0bc13d14db5f2 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -225,5 +225,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
+static void __exit rng_exit(void)
+{
+	int err;
+
+	err = crypto_del_default_rng();
+	if (err)
+		pr_err("Failed delete default RNG: %d\n", err);
+}
+
+module_exit(rng_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
-- 
2.53.0



