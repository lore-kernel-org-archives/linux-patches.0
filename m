Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8EB23A9BE;
	Mon, 23 Jun 2025 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684963; cv=none; b=FfRJqH58CrehsChGTPD5m5Fb/38W7PMBHduniek38a77OLoICqzORsI2e0cXXzkyfxBM18bomDSuqWU0Dc/usx7Ja3G7qXmeheZn47XKGm/oUi7OIizTMvmnG1Y/+43BvQHmwim0hnZ+QfQ4agYGACAoqSsCtPCmRKB2vEOf/b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684963; c=relaxed/simple;
	bh=kPxxsPloNAZIbsDAv7MT44M99zRONtWkPcJJU6KB7vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgxN0Nao+C8g1sF7BfJUb2eZ/HpGTxiQs5fUFKYkpggz7NL3I4iVTlUZkmXM57Zx8b6RsOLkAVk+s16zcQNv68XJBsPyCylFg2yL5qBskMag2/cZr92RUktccJ3l4t57dJ+zSLBdpyL9zAgp9gbFkr6a4cTR3igAeYmiTDAJY08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRXN4Hz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRXN4Hz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA7C4CEEA;
	Mon, 23 Jun 2025 13:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684962;
	bh=kPxxsPloNAZIbsDAv7MT44M99zRONtWkPcJJU6KB7vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRXN4Hz7eDhBib6odtylieRnB7uxG2AdV2pNausivVUMhtqXcshZvUG+jebNIr5jo
	 USKgHuhSeMb/sBoOgRIKs9tJLYaj+cX1HowpjbcLpCZnnxPLcmqoXRO+8UBRszYPTP
	 azBAG+7DmPG2UPn/CZ5EKjZDEd8d82UVhOeYKdtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/355] crypto: lrw - Only add ecb if it is not already there
Date: Mon, 23 Jun 2025 15:03:37 +0200
Message-ID: <20250623130627.267595543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3d73909bddc2ebb3224a8bc2e5ce00e9df70c15d ]

Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505151503.d8a6cf10-lkp@intel.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lrw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 80d9076e42e0b..7adc105c12f71 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -322,7 +322,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -356,7 +356,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
-- 
2.39.5



