Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DD28FFE7;
	Wed, 25 Feb 2026 01:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983856; cv=none; b=XUZ+yX3u8h1/UHDpRxHaAj5cnsOkqrfEOiAsrRRttmgCbHaQVpxxib3LMcPe9MrgXZ69aXGFnrufUL1qFYFSoVmNdZHVX7OHrmXAOKPM1MSY+Uvtb29P/rEzjTClZnJu6NKmvT63uVpvxohgLmj57HjhPKG7WriaJ/5Bn/m65WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983856; c=relaxed/simple;
	bh=wuJgUZ2qtUk1mcygCsaLTVDUfcQHCRnZVOtIcEvDU9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqEMulVSN7d+zkWQhM04/l8j9nyes5T38X9N8hVwipPyydMOwxw3Gs/h/TvqTI2+X/72Ofj3QSexdRlbO16rIN3VixczUqlNukiTsFuHQHXRabksQ0xfxvGMD9gZe5h6kRwWae0V/AOIbV4NQZ6OzOfOuVXPoG6ysAQ4SppkSoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcPxKnIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcPxKnIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AC2C19424;
	Wed, 25 Feb 2026 01:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983856;
	bh=wuJgUZ2qtUk1mcygCsaLTVDUfcQHCRnZVOtIcEvDU9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcPxKnITQHB+aMjZt2ChHlSQKhiQ80qVUe1vnWfNdH7Ng2or2Nb7tQegbYyxvE9Gu
	 rvUsnMHYy52SiRipNbFRUAe7MzkKIp+yHiBVEFFfF3iLtYxvnoM1DnslEI3+2g2AKV
	 oYz8v2bLvnM5RJ4Q6HIvrLiPSTKKT9yzV7cu1gRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/641] hwrng: airoha - set rng quality to 900
Date: Tue, 24 Feb 2026 17:16:57 -0800
Message-ID: <20260225012351.303799093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



