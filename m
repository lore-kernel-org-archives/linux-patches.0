Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FAE2836D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odUSEkTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30706C433C7;
	Wed, 15 Nov 2023 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076645;
	bh=uSPw/T9NDAtX4CEYANBNwKi6AWiFH1KmARJsCCqq6jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odUSEkTU7sNfDV6gAiPFSwCQSXXjhADQKfPfTfcEB5Nd9ND0InNBfC+SCnqUHCh2t
	 bV0bYBi1zjgdH4SCBRQ1xnI56zvtQYyea1RRykHOTM64xlvRl4JBjt9tttfs+QEd4+
	 iKMnc0IzFb5QjUiwtch+OdwU1JIrjqQeAr6TDCK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 324/550] crypto: caam/qi2 - fix Chacha20 + Poly1305 self test failure
Date: Wed, 15 Nov 2023 14:15:08 -0500
Message-ID: <20231115191623.223983058@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit 7b8c6aee0d5b864e70c0da82583f9862e374eaf3 ]

key buffer is not copied in chachapoly_setkey function,
results in wrong output for encryption/decryption operation.

fix this by memcpy the key in caam_ctx key arrary

Fixes: c10a53367901 ("crypto: caam/qi2 - add support for Chacha20 + Poly1305")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 9156bbe038b7b..a148ff1f0872c 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -641,7 +641,8 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keylen != CHACHA_KEY_SIZE + saltlen)
 		return -EINVAL;
 
-	ctx->cdata.key_virt = key;
+	memcpy(ctx->key, key, keylen);
+	ctx->cdata.key_virt = ctx->key;
 	ctx->cdata.keylen = keylen - saltlen;
 
 	return chachapoly_set_sh_desc(aead);
-- 
2.42.0



