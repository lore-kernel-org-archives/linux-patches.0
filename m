Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78633B2FC0;
	Tue, 21 Jul 2026 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666142; cv=none; b=SbCxb5qfd1N1f9RFLm7zoEpDMfiRs5oh02yLqirYx7wPpoE1sFK5vZDdg9AuhTrz3YCAh/o5aOh2vSegC02TtHcZf0Xaa5lZ6EqcE3kzbjWlK/wAAD3xZPMvhphV/EQWMJu1Ra7sxuee4By+ZaSXqDlnQ4ZzGin/GnQmVASK2MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666142; c=relaxed/simple;
	bh=WqtBYlq08hYx/dS7DwHBXgmkcwqudSE+/nQx2/k+xKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR9TbQ1YqQAoLKtjfEhWdSibKP3ucjtIJx+IpufszbfCHtHRP36S2YDZzusDfNRlrwWQq5NCHSvQ+Vn1ylM7Q/lK6hASYG3fo+yL/ZF3tN27k/EqXZred0108mwMni7qp27qsZ/Ej2yT+9/bZLF2BraTrcjX1xVu7lqA1JyylOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kp4oi/IH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kp4oi/IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184141F000E9;
	Tue, 21 Jul 2026 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666140;
	bh=2NBSaqQyviaIA9dp6sNfETI5O2g7gK5LENyuczCkUGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp4oi/IHeo0rWg8ZIIFFBpoW+UwIS4POmcDfA1o1vaibB3fU0kXQq5L8TGjWZc0z9
	 9ZMeCC+XC24nIjlacJxGdrMVvOlaahc+2NVLSjB+ZaULZlmh+jWpac7pHoOXhg0qCO
	 op1Nxd+DSvp1FjxbzUjfp56om84EseWaX8lzh3pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0570/1266] crypto: rng - Free default RNG on module exit
Date: Tue, 21 Jul 2026 17:16:47 +0200
Message-ID: <20260721152454.620832005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e462031fef68c6..c49115a5b2668d 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -259,5 +259,16 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
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



