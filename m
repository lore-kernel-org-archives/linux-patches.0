Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F95E364EBD;
	Tue, 16 Dec 2025 12:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886999; cv=none; b=fgYnyvaICMM72poLFH7CqO/m1K9Uk86zJB7pRXHbEbTZNNXGtmcSdZgTSsUg23g3wMqWEhUScyfQxhxukYJpq04UUMCJ/lJm1FCSj8wGZIq0q+lw6XaPnjzbUG4F4zlynTeb3U7lVVg3BzJQYh+FqmpiaNeHnT0Jdq/IU/dEw50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886999; c=relaxed/simple;
	bh=IhZixa75pLUd27p/uMuGNTGf5vgy9g5bhrmVFBlingc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uosQtJMnfZXS9G5JpIbFIja3aRU1R1tp40ypIxeulIKiMTnC6W/a1iu7soqCWOH3QOFoSRAy6l7ToggCqK6xs/K2WB7n39J2LIO9fTHb6LHfn8wlAQlgMRHOAqiMwdfzBVVr/lTRep89//6tpJXQ2dIExx7rhne7qDOyBsefOz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnnDpYB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnnDpYB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808DBC4CEF1;
	Tue, 16 Dec 2025 12:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886999;
	bh=IhZixa75pLUd27p/uMuGNTGf5vgy9g5bhrmVFBlingc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnnDpYB2PMzQeCxLSO034AYDfR0hrZyq0qP0yg1pxhdHpiSDshtIwiN77FrRx38VV
	 i6sRHLxLXMl1CSl/dlaGLyE0tezorHJPLF3h6dQBOMiOcZZpaHA9GUYfcJUB8+NizH
	 eEnDBuNWajUI1GRZRTnT2R6YlRbrUfBJb40ysIJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/614] crypto: aead - Fix reqsize handling
Date: Tue, 16 Dec 2025 12:07:10 +0100
Message-ID: <20251216111403.595124578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: T Pratham <t-pratham@ti.com>

[ Upstream commit 9b04d8f00569573796dd05397f5779135593eb24 ]

Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
introduced cra_reqsize field in crypto_alg struct to replace type
specific reqsize fields. It looks like this was introduced specifically
for ahash and acomp from the commit description as subsequent commits
add necessary changes in these alg frameworks.

However, this is being recommended for use in all crypto algs
instead of setting reqsize using crypto_*_set_reqsize(). Using
cra_reqsize in aead algorithms, hence, causes memory corruptions and
crashes as the underlying functions in the algorithm framework have not
been updated to set the reqsize properly from cra_reqsize. [1]

Add proper set_reqsize calls in the aead init function to properly
initialize reqsize for these algorithms in the framework.

[1]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b

Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
Signed-off-by: T Pratham <t-pratham@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 5d14b775036ee..51ab3af691af2 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -120,6 +120,7 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
 	crypto_aead_set_flags(aead, CRYPTO_TFM_NEED_KEY);
+	crypto_aead_set_reqsize(aead, crypto_tfm_alg_reqsize(tfm));
 
 	aead->authsize = alg->maxauthsize;
 
-- 
2.51.0



