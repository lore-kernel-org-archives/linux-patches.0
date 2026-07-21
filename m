Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2EE46D57B;
	Tue, 21 Jul 2026 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659766; cv=none; b=KbabXn+iY1yeg57A+5q2ls5rUEmSG599wf6iWVLK/tDh6NH861/RT6RfmIa9ld75z7NW/0OemzGrdAgDPS37S/uUxHmi7M1m1y+Hy05aecTqHpUUqolF8BCqWdidJ78E3+wwREEpxCvdQ08KCWGUxtpFnSLznMIKVWzXmS8cOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659766; c=relaxed/simple;
	bh=Ch5L9OS7gRDQP+CXYFG1dpeZxf4j9tHDJZDPl4VYQ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja5M75o4tZ9Tv6AAKVwcXbSOkADGLFw7869rx8PIoboZuXRW3LOTEz4x4nojlCAJqMGWaFrf24ieD7hG+N029aD9w8qiTqE+M3RTcXtER2ITpEuBwjoALqNpaAUQ4lFGgRiTabk9nSdbiuAvxITDXFOAGdoPHdFmoO63PUMc2L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATchaCWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATchaCWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD81F01559;
	Tue, 21 Jul 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659765;
	bh=kA1SOLVsiqXz+ycUkgN7Xne+VrZ37aU+o1iLGpTZtyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATchaCWmAESlokYKLAX/ysBGKO1vwACbvuFKQPZXrix63dA8M0SKt94ZCytEKNvgI
	 M9aZ6eUn7Ywhvyt+0lvkID68HjtOKrWuHEWY4rXX4nRAupvFz3sBUYuwRtdpi724AP
	 GjxxNKJdBa4vOXC/A/1FmOua+FB6HSGWuJ61E/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0724/2077] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:06:37 +0200
Message-ID: <20260721152609.878051193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d4b9177bad4d4..a07569ed1e5e0e 100644
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



