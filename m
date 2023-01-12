Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ADB79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CDFC433D2;
	Thu, 12 Jan 2023 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533993;
	bh=GEEXVvNRAm7MZ3lw0ySkOPoTb1f3k61wKC2pg9kZMMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6XtJIWgbncNJiXg6lENvfAxl3wMlHqnIhhCJyp0FNIsBfeQq/alFp2t+ihFYKYrK
	 pLK+RvYPS81So+eOXRsNEVtNtJNEW+/6et7YZOZf9Aw2fq8O5ke9dmAiEcgJ1WDMzJ
	 IxFAJppiOb2qiUUxX84tttbpnwU9rGk0gDdaEKc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eike-kernel@sf-tec.de>,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	stable@kernel.org
Subject: [PATCH 5.10 659/783] crypto: n2 - add missing hash statesize
Date: Thu, 12 Jan 2023 14:56:15 +0100
Message-Id: <20230112135554.896067750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Corentin Labbe <clabbe@baylibre.com>

commit 76a4e874593543a2dff91d249c95bac728df2774 upstream.

Add missing statesize to hash templates.
This is mandatory otherwise no algorithms can be registered as the core
requires statesize to be set.

CC: stable@kernel.org # 4.3+
Reported-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Fixes: 0a625fd2abaa ("crypto: n2 - Add Niagara2 crypto driver")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/n2_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1228,6 +1228,7 @@ struct n2_hash_tmpl {
 	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1259,6 +1260,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1267,6 +1269,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1275,6 +1278,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1283,6 +1287,7 @@ static const struct n2_hash_tmpl hash_tm
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1423,6 +1428,7 @@ static int __n2_register_one_ahash(const
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);


