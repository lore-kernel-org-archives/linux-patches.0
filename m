Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBED3C1400;
	Tue, 21 Jul 2026 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673710; cv=none; b=qaHJ1l9vEudO0jvPL4YT+qgw1gucEV2cU9vk7Vx7WgANeloj9/RyIAp57tmeDwf8Jmg9BUrVNBdYWnXmq760ovy6izSHacH4Qj6/D1izF3XemmSu780KgqdhpRv7GKpW6lfln57o4QqxEA17It9YI3CmOp+QdompF5oASpb8F4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673710; c=relaxed/simple;
	bh=3vk/spsgy+WxPSFua9BcmwuUYlsPBJw8moEa5fdLVMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHs9QxE+K8jifd8YwxKzYLB+x38XqxMC2t6YKt9RzCE/bJJvi0XzYxZmdpoJ/UpzROkpFknjj7NEWCJkk675ZNJ9E0DfhNHcoMTEdh897jBRn4wqLtr0R7/DmLVnZ5GfQJfdqidXYXkhD5Z11CxNJrOFUZybq/4vnWioqUjaZyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfzJNi4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfzJNi4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925121F00ACF;
	Tue, 21 Jul 2026 22:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673709;
	bh=3oxqKiebx2HWSO2C2iAhSlICZglXeBA4GdZDGBc0XJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfzJNi4phi0G40JD7S4sLxxxmNo8IWPuq1dow/bnqdfsEpXQVFJiQXkzMgwVCrQQ9
	 ojX3LAV3WslYyyDApl0l0dEfn7YPOWSavMdnmrM2Uas64GVq2Bc6WfDcGQq1cHOAZh
	 j7BSA9db476EHX1kpFA9u2kynRVgDqPhCmloVBOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/699] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152401.633626579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2bf2efb7937f9..5992cdb392c50a 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -232,5 +232,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
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



