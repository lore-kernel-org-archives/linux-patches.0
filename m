Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8D7423A72;
	Sat, 12 Sep 2026 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214843; cv=none; b=EOKcefPOciMbZ5TXFG6xPW6r8uPtwHvMz3goQuToRCkBZazJFvFzQv4JiiJSs4PAQJKG3QovZx1fvVyOPvHauhcM4YvRFDgvL8YpDF/BFVQRUZc2x+tGDgnHeZ5tA3WSQ/DOM8fW0R2+g/Q5iO/LppCvWPzgpy+W2u8QHZF/Ri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214843; c=relaxed/simple;
	bh=YyQIQh2+/6soN4kR0RtOTLAlbUkdijZox/1e7EYUBFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5138YV4CE+qnXFw4tg19yXzOE5nuOvBmGN0zAaP/ZlXP5PYtAH2vnzisWjiWudbsuPusld+S3NaGtNJzpxaQD3OkTlBVu9eGZdGPq/Sj9ce126jIInDXDbbernTSOdCOVW/78bn60vjLvddgu8Md0bNXoJZAdW9kzrqg21opgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffTy2Vbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffTy2Vbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1451F000FF;
	Sat, 12 Sep 2026 12:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214842;
	bh=fF5TXNz0ZmTbyN5Byt5Nq5RvQVqZ19h/jHw4pWOUCag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffTy2VbjOGWsq88+VHSG7HcKkDNSqSmzE3+1Idv5lhXuH5hX2OUvIaXtC50BStIQF
	 axA7igGnXxl4Yl0W77JOUeoDZjIhFZ5YIsi33qdyPVXeasGDTS0o+O/NTh6pua1YWJ
	 b5ojbRiNmAqXKogQ8OIoCvTzyDFnSMZbO3loTGO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0408/1376] crypto: keembay - Fix AEAD unregister count in error path
Date: Sat, 12 Sep 2026 08:47:14 +0200
Message-ID: <20260912065616.636096859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit e264401ce4776a288524e5b87593d4d864147115 ]

register_aes_algs() registers the AEAD algorithms before registering the
skcipher algorithms.  If skcipher registration fails, the function unwinds
the earlier AEAD registration with crypto_engine_unregister_aeads(), but it
passes ARRAY_SIZE(algs), which is the skcipher table size.

Use ARRAY_SIZE(algs_aead) for the AEAD unwind path so the unregister helper
iterates over the same table that was registered.  Also clarify the nearby
comment: the crypto registration helpers clean up algorithms registered
within the same call, while this function must still unwind earlier
successful registration steps.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 9b2d098e5eb2c..a02a75bd29860 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1541,7 +1541,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	/*
 	 * If any algorithm fails to register, all preceding algorithms that
-	 * were successfully registered will be automatically unregistered.
+	 * were registered in the same call are automatically unregistered.
 	 */
 	ret = crypto_engine_register_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 	if (ret)
@@ -1549,7 +1549,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	ret = crypto_engine_register_skciphers(algs, ARRAY_SIZE(algs));
 	if (ret)
-		crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs));
+		crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 
 	return ret;
 }
-- 
2.53.0



