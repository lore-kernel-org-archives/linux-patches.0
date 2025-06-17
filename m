Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB48818A6AE;
	Tue, 17 Jun 2025 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174662; cv=none; b=R87K05fCPn+NVnItXCJ5tDUhI7quyHuqFzozVyNWr1Y3WtNCYwV6tfnaMLUP6fhqJr9IGBd3CUpvrc4V0/V/fx9L5oe5N6er6XhNlF82eRvXeOfLEmtIHhYZqZjot6qEmp1kHPVUQHbFWx/5QHSX7+MOxMgpitSS0iSdMzFaNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174662; c=relaxed/simple;
	bh=gftoO5w7UNPgM/H45IjTAejCLT5TA3eHmzKww86r9mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K30rzM0KGWYptTW9cUk79Na1b2gfzbVHB0XmA1Djh3o2f7zOYoPn0BVfsX4k3CpsMto5xGuTz8zwHRUkpdY9/ckY7PgrvNwGP2+omWQh45AX2GoswjjSp4trvlERBlQHHnEnuhs2QaNAUeXWXiFEdA9dZCGuYkfgA6mqkB6FMHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUUdUaFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUUdUaFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9EBC4CEE7;
	Tue, 17 Jun 2025 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174662;
	bh=gftoO5w7UNPgM/H45IjTAejCLT5TA3eHmzKww86r9mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUUdUaFDN7AqVcaDexkepabd793pN/usJ3yjXNRnIM3z0+nloYuOtjl/4Xi3eg4Iu
	 g3qKNCm1xCHeOjVJfaZ98lwHqOB6Jyy8zdntafZXH73xxvunusnUaKRsTTkGZwrzGc
	 0jKSPkoS0G4eZSR3ax0TcEs5jzgmvL2K2wrCixxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 006/780] crypto: ecdsa - Fix enc/dec size reported by KEYCTL_PKEY_QUERY
Date: Tue, 17 Jun 2025 17:15:14 +0200
Message-ID: <20250617152451.756523110@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3828485e1c7b111290122ab6e083c2a37132b5c2 ]

KEYCTL_PKEY_QUERY system calls for ecdsa keys return the key size as
max_enc_size and max_dec_size, even though such keys cannot be used for
encryption/decryption.  They're exclusively for signature generation or
verification.

Only rsa keys with pkcs1 encoding can also be used for encryption or
decryption.

Return 0 instead for ecdsa keys (as well as ecrdsa keys).

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 6b7f9397c98c ("crypto: ecdsa - Fix NIST P521 key size reported by KEYCTL_PKEY_QUERY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/public_key.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index bf165d321440d..dd44a966947fb 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -188,6 +188,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	ptr = pkey_pack_u32(ptr, pkey->paramlen);
 	memcpy(ptr, pkey->params, pkey->paramlen);
 
+	memset(info, 0, sizeof(*info));
+
 	if (issig) {
 		sig = crypto_alloc_sig(alg_name, 0, 0);
 		if (IS_ERR(sig)) {
@@ -211,6 +213,9 @@ static int software_key_query(const struct kernel_pkey_params *params,
 			info->supported_ops |= KEYCTL_SUPPORTS_SIGN;
 
 		if (strcmp(params->encoding, "pkcs1") == 0) {
+			info->max_enc_size = len;
+			info->max_dec_size = len;
+
 			info->supported_ops |= KEYCTL_SUPPORTS_ENCRYPT;
 			if (pkey->key_is_private)
 				info->supported_ops |= KEYCTL_SUPPORTS_DECRYPT;
@@ -232,6 +237,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		len = crypto_akcipher_maxsize(tfm);
 		info->max_sig_size = len;
 		info->max_data_size = len;
+		info->max_enc_size = len;
+		info->max_dec_size = len;
 
 		info->supported_ops = KEYCTL_SUPPORTS_ENCRYPT;
 		if (pkey->key_is_private)
@@ -239,8 +246,6 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	}
 
 	info->key_size = len * 8;
-	info->max_enc_size = len;
-	info->max_dec_size = len;
 
 	ret = 0;
 
-- 
2.39.5



