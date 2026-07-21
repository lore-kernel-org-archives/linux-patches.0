Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8641F46DFF2;
	Tue, 21 Jul 2026 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656731; cv=none; b=Dv4JntjFgX5Th7gRRNHEHQEE8vSsnIVRwvWRzdpLBLw1GKTq6xAUGtbnmXfh33Jp0kzeHh2EwyA75ESbDy6d4zQj83Vcnc3JuBMMqcMx0gR27Do7WybTowJgOuauzgKiW/CbVZgt9UvltMu39HvFiZMRlLGeTZL9Vsc0Yx/LbHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656731; c=relaxed/simple;
	bh=mjmGKDzNJuBdJSg2TYYDcmP5F9eETlrjDzgQSDBJcG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuL31mLHH6xHfc9LZnVWclmCv/2pffR7dim45eh+X2wwmq0QvCF6+9UO5XhVsL89mzdji6TCXnxzDzDnRSsjza/3LbheLHGjhkNt1KsRvUzxVOmQkmSzbRdK+FWpPESPuwdjdF5i6braLL8XReWMZ20Dpo6H2bRDdfyTseKNTRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZOw1fcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZOw1fcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4441F000E9;
	Tue, 21 Jul 2026 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656726;
	bh=1gqP7ZHGCyZcmLnHoGo3YeM+J28XZ50FCyiA2YCDLvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZOw1fcxxMKAaDa4JVAom02YBs+lwFaadF9V6G7Rqc4m6WEhvXESiHycV3PLauEWE
	 sU9oi7xblzY7sDwR7Ox9sEnkzpes0W2zAGrq0PlirfMG107tAHNhb53epmDg0BFfri
	 87AOa0PiORKsX8v1cm1stiTb3Uyn0FR3NwDDcO7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0495/1611] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:10:11 +0200
Message-ID: <20260721152526.475721696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index ee1768c5a4005b..b021936094b077 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -226,5 +226,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
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



