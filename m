Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625080;
	b=a3Z99o2i+SGnUQciYsgwmGDrFae9pMJvl8uwZ//+/YVrmcTqpuxRS6lhWooEdYiy5xtp
	 u9WgZ4Z7jjMXapwAyQLV0mK7QH7w5fR9KkysnM44Ye4zHYSOx322dgSjiTR8UV3WFhNg2
	 2UJSAFwucmSfUvjQN8sv7nf77Qve9uyZHOnnFkr14N0RWT1pzZiAznRGF8IZdtg3QQJ3N
	 hJdD+Wk/C+zynrzpMorkwLh0UIsnVhLQtmHgiTLTJcOJbj2L9bdWsZwbJywJctqWCUWWR
	 TtepJniMAlNL0nwjVagVZRUnFCHfCqthAyMN1iVMKWbsW3Wkl735nrAyQqC2wzT/xqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JoIGYo2gXj5oZca2jahLoV/ICfm45+pyKSEBYcluaQU=;
	b=Wb31PprFQQVvgemRJoBfd1c178GkyUiLbT15hBmBiCMc/PmetmPG/2EV6bq2wzADzRNe
	 3bKUwaYx4QMyqsZ6SFtjZo/akej4JawBIq3P0cleXxMkwoA3tg71JtXW/pZr5H6jCE+BX
	 sLoXZvjNpxWlvzcuVqqJlFB9rUxZe+qKtlocdO3m+4EFIg0yyVeENVOKu6TyJJmH1FBZ6
	 995QPBiegOwOFBCkt44XRhODq01XVYIwTbkECNgXleHlM4btMWdIZojwClw5D6zc5gb2c
	 YEX9X9I6t3PqrqRM8i6FJSH6GBFIE681Hlf9WeJ0N2N6qBmoz52vrvJBR1OUqMoGm2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxVCflro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B1E606A31E;
	Wed, 25 Nov 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxVCflro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD941F000C4;
	Wed, 25 Nov 2026 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625080;
	bh=JoIGYo2gXj5oZca2jahLoV/ICfm45+pyKSEBYcluaQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxVCflrojxP7Zlcbl07FrEaX+tfvRN1QU3EqXucARkhMNSTT9/jWPUphoFIaQLbIR
	 GjLQNknD7IxWJ5iMHnvJBK7edAKZRRti1922Gw5xhn4PTScePZDGPgPvkcVVyRZjbf
	 x3AxeHAlUdaLBFpTkVZGbTS7R0icfMjVYYBIaSXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 399/816] crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data
Date: Wed, 25 Nov 2026 15:32:27 +0100
Message-ID: <20261125143858.434326230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 5c87bcb2f98dbfe08efa016af037b0f9701ba381 ]

key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
safexcel_cmac_setkey() contain crypto key material that should not
get exposed to the outside once the function is done. Scrub the
arrays with memzero_explicit() to avoid that the data could leak
via the stack.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: Replaced the newer aes_prepareenckey() context line with this tree's aes_expandkey() call in the xcbcmac hunk; the added memzero_explicit() lines match upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index af4b978189e51..af2b97fcb27f4 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2081,6 +2081,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ret = aes_expandkey(ctx->aes,
 			    (u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
 			    AES_MIN_KEY_SIZE);
+	memzero_explicit(key_tmp, sizeof(key_tmp));
 	if (ret)
 		return ret;
 
@@ -2192,6 +2193,8 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 	ctx->cbcmac = false;
 
+	memzero_explicit(consts, sizeof(consts));
+	memzero_explicit(_const, sizeof(_const));
 	return 0;
 }
 
-- 
2.53.0



