Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FE168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE60C433D2;
	Mon,  8 May 2023 11:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544378;
	bh=JJC5MjBV8lpgp/Q8c9FLB/NnPE+kU9YVY1zWbSiuN+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5gIsOArm9JcztlxnX+Zx3RZU0bwoRdIOJkgU8Na2QhJ/ACI6xuQfpoZWhKY7//Mp
	 Z8CnViGYHG7n2Wub7dpkL7DrWl+iuS5DpgGiXOrFp9xfTJFbtNmoWVGlmqYX9dHNL2
	 5Wo3GWtujHbjl573yUvvbStD0qq3vUZluHqoHtVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 391/694] crypto: drbg - Only fail when jent is unavailable in FIPS mode
Date: Mon,  8 May 2023 11:43:46 +0200
Message-Id: <20230508094445.743983949@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 686cd976b6ddedeeb1a1fb09ba53a891d3cc9a03 ]

When jent initialisation fails for any reason other than ENOENT,
the entire drbg fails to initialise, even when we're not in FIPS
mode.  This is wrong because we can still use the kernel RNG when
we're not in FIPS mode.

Change it so that it only fails when we are in FIPS mode.

Fixes: 57225e679788 ("crypto: drbg - Use callback API for random readiness")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 982d4ca4526d8..ff4ebbc68efab 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1546,7 +1546,7 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 		const int err = PTR_ERR(drbg->jent);
 
 		drbg->jent = NULL;
-		if (fips_enabled || err != -ENOENT)
+		if (fips_enabled)
 			return err;
 		pr_info("DRBG: Continuing without Jitter RNG\n");
 	}
-- 
2.39.2



