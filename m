Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062869;
	b=Xrat+81oqDfg/PRqebwT9DeVsA33XjrhNQMFNZbqpDSU6MVfnQtCHdZsvIdCMTPU5qfj
	 Y73bRxsccyVvHlrhIeE8qt2414TXUfSK1v2gz928Us3VKUcepV7tc+v4pX2QaESmBqECP
	 8pj1+mapKeiJm4Zq1lvGT4jVJrYCFA7bBPcQLCi+jHDsu+dt0xZPfRNwkAFQglZTOLxal
	 SiBmXQO4n8fJFmSmNI6Wf9bcteYUO+6y8ANU6/aqLtVmpJpjkCw9YNZajouW+6ijSU/mt
	 ckHCbm7Cxny4325ePbH9anv4HY/8rPO7rD5GxbFcgZ7zkiE5VlRoRUYDY5rbeQwSADw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NEx6KOtxUTp0zvQXoGz7qLV7yueClt06U10oIN7nuF8=;
	b=UTorXxCUr/qy409AS3W486rBinaGbwNzVcCRFz2p96oml0sKszLS1RQi9LBBrhrfi/RX
	 kA+YRvhVu195TIEkf2tIJkfeapHwNXBbuW+e03mwqbtgjBonjPTrG5OeiC2ds6K1tz0yj
	 tfOlNHp3MeobvpG92oRFb0LlceMQ+2AJr6RxMxu+KGx0BbiKv9Om/H7xDtAWE/m+/QsqF
	 bOOw1fXcs1Eb5OKI0JFA11n33WnQUnB/ZvV45e8n+80bO74LZX2cwCKmUuo8pbLUAs5qn
	 D9/mupUHfTcMZkaEpC82rfuBsM04fJj4sjKS8reOtJpUDpTpzoiIpdSJsBvUIrlo4ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nuDjEIM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9F606A32E;
	Sat,  7 Nov 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nuDjEIM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFC61F0089F;
	Sat,  7 Nov 2026 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062869;
	bh=NEx6KOtxUTp0zvQXoGz7qLV7yueClt06U10oIN7nuF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuDjEIM/tG5TGz3rcoAEavfEvybC9tnqctn2916NqJDybA8YlhzovRjQqkRItP7cI
	 qqLWhDlViZlLqXSGidS2u9vfsaPq6zeDSVuMAmhpWkVQ/TxXiTjV9qaJ0A1zkiP4UH
	 t5w2yZXqLm8DQq0Ivz3p2gd7zLlLCWkCu6O2fRXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/869] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Sat,  7 Nov 2026 08:46:49 -0500
Message-ID: <20261107134856.788480829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0dd8cded0e6f8c9635fe1d79d60dc7b2599b099b ]

atmel_aes_gcm_ghash_init() writes dd->total, the request's text length,
to AES_AADLENR.  But the GHASH it runs hashes the dd->datalen bytes passed
in: the 16-byte length block, or the padded IV when the IV is not 96 bits.
The data sheet requires AES_AADLENR to hold the length of that input.

With empty plaintext and empty AAD, dd->total is 0 and the tag comes out
wrong.  Later requests only pass because dd->total still holds the
previous request's length.

This is testmgr's first gcm(aes) vector, so CONFIG_CRYPTO_SELFTESTS=y
fails at boot:

  alg: aead: atmel-gcm-aes encryption test failed (wrong result) on test
  vector 0, cfg="in-place (one sglist)"

Without selftests the broken atmel-gcm-aes is preferred at priority 300.
Seen on a SAM9X75 Curiosity with 6.18 and current mainline.

Write dd->datalen instead.

Fixes: d4419548dba9 ("crypto: atmel-aes - add support to GCM mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b393689400b4c..e057be7fc7130 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1272,7 +1272,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.53.0



