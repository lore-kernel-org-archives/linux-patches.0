Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F521EB5E1;
	Wed, 25 Feb 2026 01:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982921; cv=none; b=GdcZ+uPpWjdmRZ9jxJvokjuL69cR66Ma6jl5i0ZQH77ddsflY18CcIHOqir2f0tFU9+/mtgeZ2/BeVh0tM0Vhosbg/8ZVHZO21am30d1d3QcMxv2XmSKNwhg5a6+O/ETuM2O/3Gpl/0k5ADsid5xeIoPceX5wdCVLZ2ODS8ZYOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982921; c=relaxed/simple;
	bh=CceuJZTjWpI0S4rZSvVWVOc7H/UeCIXpIKrH4YELCeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAU0CYHBcPSVCztcMd0XTda4f092h+tWKTncuKjlgI2xLVRCmKnHxwIh7swp6r1GDnBaMlFpwlRITAM9GhPTLbzxoENk5MCG9Zdgub7fUpG/bqrGIalSXaYjM9XH0K3yc9qdBYbPY+HKq8WBCCHXwZRxSd15sJS/6S7a/EUfVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/oWwv1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/oWwv1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9488C116D0;
	Wed, 25 Feb 2026 01:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982921;
	bh=CceuJZTjWpI0S4rZSvVWVOc7H/UeCIXpIKrH4YELCeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/oWwv1DR8r7cHJUUuh9+cHEYNA0gBEo3YLvO/2UYd/2JFTpOQlqKNpdNbCOx8iTC
	 HKCx5cIAfXa9FgzqE1LfmVckwySz9uViVBIOpOHTAVyOCQoKXt8/lv6rky0+CFeRJi
	 a8rd0A9sQvaMm5pPTFKexJjIOE7gYNPVefB8mj0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 100/781] hwrng: airoha - set rng quality to 900
Date: Tue, 24 Feb 2026 17:13:29 -0800
Message-ID: <20260225012402.139389950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit c0008a29a006091d7f9d288620c2456afa23ff27 ]

Airoha uses RAW mode to collect noise from the TRNG. These appear to
be unprocessed oscillations from the tero loop. For this reason, they
do not have a perfect distribution and entropy. Simple noise compression
reduces its size by 9%, so setting the quality to 900 seems reasonable.
The same value is used by the downstream driver.

Compare the size before and after compression:
$ ls -l random_airoha*
-rw-r--r-- 1 aleksander aleksander 76546048 Jan  3 23:43 random_airoha
-rw-rw-r-- 1 aleksander aleksander 69783562 Jan  5 20:23 random_airoha.zip

FIPS test results:
$ cat random_airoha | rngtest -c 10000
rngtest 2.6
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 200000032
rngtest: FIPS 140-2 successes: 0
rngtest: FIPS 140-2 failures: 10000
rngtest: FIPS 140-2(2001-10-10) Monobit: 9957
rngtest: FIPS 140-2(2001-10-10) Poker: 10000
rngtest: FIPS 140-2(2001-10-10) Runs: 10000
rngtest: FIPS 140-2(2001-10-10) Long run: 4249
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=953.674; avg=27698.935; max=19073.486)Mibits/s
rngtest: FIPS tests speed: (min=59.791; avg=298.028; max=328.853)Mibits/s
rngtest: Program run time: 647638 microseconds

In general, these data look like real noise, but with lower entropy
than expected.

Fixes: e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/airoha-trng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
index 1dbfa9505c214..9a648f6d9fd40 100644
--- a/drivers/char/hw_random/airoha-trng.c
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -212,6 +212,7 @@ static int airoha_trng_probe(struct platform_device *pdev)
 	trng->rng.init = airoha_trng_init;
 	trng->rng.cleanup = airoha_trng_cleanup;
 	trng->rng.read = airoha_trng_read;
+	trng->rng.quality = 900;
 
 	ret = devm_hwrng_register(dev, &trng->rng);
 	if (ret) {
-- 
2.51.0



