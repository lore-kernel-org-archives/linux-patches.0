Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5A35C6A8;
	Tue, 21 Jul 2026 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668540; cv=none; b=VFXzOFGwWa1hl2KM/fiHmAo56SjnNMKOTyLqzp9coeFPQP66XJYcwOg19hEuoPNnxOkFrH/M/mdiQx3E//432DMIgb1vi4lCpnxfPlWDn4jHVQ02zVdroVIEF+3ouCR17GdyaFE/0NDXfthQrdvnHMyAXZ14K+r6GDW/LI8tc4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668540; c=relaxed/simple;
	bh=rG5sBuUjeMuN79eiKeackBMq8syr7e9Sg/0F4+HRzh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBqWHoGkuPyVBHsHbGpaciRakjBc5L8hCF/uG6rxnC4Zsp2aFYhyg5hyPrmlvuzn2riS3x2dZ6FuikJbYyjdYHitVKPvNokD8F7pz6d4T3Yq9X35cOW85ufjlBxlctUCp1Arzk0ieSr7iGCeSJCf2lt65jKznwynf1YzNWPsqOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSrZQ9Uk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSrZQ9Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690431F000E9;
	Tue, 21 Jul 2026 21:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668538;
	bh=cWkWeU5i9/ZqnGWKnmlHZSZ9AfSJkbhsAe2+Y4JX3rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSrZQ9UkLZMGdiNnQy+IZ7Ehp87HXuqHGjteiTs8+09z+tQPVdJwwDIDrsP0+LYF+
	 m5E30cpb/6633IMK/Hl6mv4Gix4GDldwRMPG1AD3seTXjxvv7z2mud0fZHsQ8/bUO5
	 zVi7n9jB3vPQb3NQSc7C/hsQ8aGE94BbYZzHpBWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0214/1067] crypto: drbg - Fix the fips_enabled priority boost
Date: Tue, 21 Jul 2026 17:13:35 +0200
Message-ID: <20260721152429.384564157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a8a1f93080efc83a9ff8452954429ae379e9e614 upstream.

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2095,7 +2095,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;


