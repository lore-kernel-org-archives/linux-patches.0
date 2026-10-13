Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E34F405E;
	Tue, 13 Oct 2026 12:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892828; cv=none; b=qaLIaoBJtVXq2n+8F1QE+48X5yXnLoqm4aNvEo4e/kO7/W8Am79Po5CmVHQ9m118DxgjtiFJ3XgVaFC1szXEu1yALragkOLMGASBM3CdzjwzIu2WU8vwCY4iUP/86jn0PZShW4//wxVwMxlT2jSvsClkVhy3CfXLiVIZ8v4+480=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892828; c=relaxed/simple;
	bh=zIohuqILxAAoZJO8Fk4ADTpjHY2Aik1br9GkGht2nZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx4yAH12a53TG9tvlkMeGMQJ0nZq3Xu/LlpxBIhSJLp2P50hBsoB8uRsAoD4C7SMboIXNbcVUyhOSLHkraWlnBn/M6HGn2Nw4Qw81GqJkfT6SYbBR3HfSdGB0Svl4pKkCBokvpZeVB8ChOJhzZJ6cLF+suNQGo/4PZ7MTHCEuko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBQoTII0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBQoTII0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5EE1F00893;
	Tue, 13 Oct 2026 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892827;
	bh=VHpW/O/bOp49Uq5KQzu2vAEN2QoDYjJw8kCipdMZ6bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBQoTII0nE4LvcxujSH8WqoH08A7Ja0eCYE72G9PXJ4EDXRXboOx1ud9/gNfQaAh+
	 XsggI0DgIsVlfwfgov3H01OQNghAAmh2gsyehMJSI8dbJQGDQdWHtIYEkye1lJKZ6d
	 /hRnC8f3sFgicdF5EIXzVc07Jxh2O52rdbSNKyug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/621] crypto: drbg - Fix ineffective sanity check
Date: Tue, 13 Oct 2026 13:30:09 +0200
Message-ID: <20261013112921.202605743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 040ad83b0e8aa065fd2fc641cacba8491a8b186d upstream.

Fix drbg_healthcheck_sanity() to correctly check the return value of
drbg_generate().  drbg_generate() returns 0 on success, or a negative
errno value on failure.  drbg_healthcheck_sanity() incorrectly assumed
that it returned a positive value on success.

This didn't make the sanity check fail, but it made it ineffective.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/drbg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index dc8996789da67..51c36cfa8eff5 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1986,7 +1986,6 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
@@ -2030,12 +2029,12 @@ static inline int __init drbg_healthcheck_sanity(void)
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
-	/* overflow addtllen with additonal info string */
-	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
-	BUG_ON(0 < len);
+	/* overflow addtllen with additional info string */
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
+	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
 	ret = drbg_seed(drbg, &addtl, false);
-- 
2.53.0



