Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B635C6A6;
	Tue, 21 Jul 2026 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669143; cv=none; b=ueQQ8u+9ZLu9vGbM0mWkB7XnfODVVosn3ZMMsl2aJdHaxEpjo1YkZzOP5fmkum6ajE130NNGYT4RwVMLTbjJPkM6rg+CzSam+1LX9EqMG2pnqQjK0UYiALUnuNbbmfewRs4L3gx/XDebO5O3BM6NiEEXUj5gz4u74hkjYcRoS8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669143; c=relaxed/simple;
	bh=c3j3wL3AG47OlU1Q1p8K6aTPuK6+XPyy4w6QUWxO5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPNaWouqyCJkqdPYoIx1WOGBVAO906UANsNYwyqZ6zX37fMu5E+16X8d5k4+pQAviB+luJEyL1dBPODDxhuYjsqbtchfqgdoDZUHV9B8DEMlMhOdmqzgqWhIpz+SSiMOBvcv1WfHV6tTULazZtp8nSNzvBr37YdaHAbb7NObJ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teckF7jG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teckF7jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146E81F000E9;
	Tue, 21 Jul 2026 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669142;
	bh=IISaCdTsCYUh/9s2neGZUtwAgLpz/SE9nWjOgESkIX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teckF7jGt8+dHopIqsQYwm57I42e3chcOLBSo6VO4t1JgRyWjSvD+ekf7uoScwY2X
	 ZNz9oQqOgACgdgHCz6GFLpcFwZhoF68hgqFgcxLvTSc9QoBEQrbCIrnQrlHSw5ZE++
	 k1bQ53nmbX5ap+3NWMIVkisDLruTmTL7M6aK7nqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0443/1067] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:17:24 +0200
Message-ID: <20260721152434.526821201@linuxfoundation.org>
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



