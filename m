Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBE32C92F;
	Fri, 17 Oct 2025 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715150; cv=none; b=sgo4lJhrcabOOjC59sluHfY1t4qa/u7idhWCKDpXHdchJyI60QILzh63wLlrdDbQXpU7X587D5g9VP4pCrzQlfxQz1g3CWLKQ6W77x+uBgoFx7LjpIco4BcTOe5EE6UackS75MYKditNQsvXt2Xl0DvbEico0KOYuLOz/HTZ9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715150; c=relaxed/simple;
	bh=psbUfIyhL647v7u7+iAdVKmRMR7etGqegPGP3VQRFps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyDPt5AYP92uxd/jCfjn65EyqNkvNar/xaCBZmWxH7hL5tJ30OV9Cm5yiS+QiMVksltr6pG8tan06o437EAp3wZit8hyumJZeTVUSEVxQP0wkrZo3JnJQZsppwH16vNCpTSnHu0iWhiOmChArwLrYBR32wnHIR9e0idIpVYh+MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD2CW8xF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD2CW8xF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30384C113D0;
	Fri, 17 Oct 2025 15:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715150;
	bh=psbUfIyhL647v7u7+iAdVKmRMR7etGqegPGP3VQRFps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD2CW8xFxNgtZTXU5hIxsf7mcnHpVwUEFezXs1obIYvLJMvYB9QrjEhFcrkxoN0vT
	 HkHeFs5SHtIzYqSboVmR/0nqNsmGJG7rA9ctRMlTlnZg1vBDBBf9CpXDPCzPVfHpaD
	 KdPFCBLfJExdWp77z21zuYfElU6r2qm2cxYvcYxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 115/371] crypto: skcipher - Fix reqsize handling
Date: Fri, 17 Oct 2025 16:51:30 +0200
Message-ID: <20251017145206.097092869@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T Pratham <t-pratham@ti.com>

[ Upstream commit 229c586b5e86979badb7cb0d38717b88a9e95ddd ]

Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
introduced cra_reqsize field in crypto_alg struct to replace type
specific reqsize fields. It looks like this was introduced specifically
for ahash and acomp from the commit description as subsequent commits
add necessary changes in these alg frameworks.

However, this is being recommended for use in all crypto algs [1]
instead of setting reqsize using crypto_*_set_reqsize(). Using
cra_reqsize in skcipher algorithms, hence, causes memory
corruptions and crashes as the underlying functions in the algorithm
framework have not been updated to set the reqsize properly from
cra_reqsize. [2]

Add proper set_reqsize calls in the skcipher init function to
properly initialize reqsize for these algorithms in the framework.

[1]: https://lore.kernel.org/linux-crypto/aCL8BxpHr5OpT04k@gondor.apana.org.au/
[2]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b

Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index de5fc91bba267..8fa5d9686d085 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -294,6 +294,8 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 		return crypto_init_lskcipher_ops_sg(tfm);
 	}
 
+	crypto_skcipher_set_reqsize(skcipher, crypto_tfm_alg_reqsize(tfm));
+
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
-- 
2.51.0



