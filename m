Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0F2DF3C9;
	Tue, 17 Jun 2025 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174535; cv=none; b=PCa0PPeskKA5tqCQnY7XAJWIzl1L3xwoqQuTWVSfb6R/tZJGkoFi9Cz9bMR+G/wQMQx2cMEc8WdrAC+Yyocoh2Tnnd8DoxOvSyJqmDgcUQ2z1eQ790HyGmlKmKUQ6Aa8j0l91lt0wqn0Xro/HqYpMZ3G2JM1xCW5kdOD8kdT0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174535; c=relaxed/simple;
	bh=ojRFUsqfczFwui7yvFFXbI1psU9gJdBxBxiGcrpFnDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6d6p7zMO9/ocwT6g86KvfxsR0aSJtFpCLRUL+C7FpfYdzJM91iPyfJp4xfe9uZMXFplwUczwAbTeuhHcBGXzn2D0N7dpMTET3zqOX+0j3ng+UL7o6I0XKcY6bBU1iAoF//NZCpzrJcKacU52OjsjQpYI4ys6B3FrVxiKCLOlXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYIIUOMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYIIUOMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212B0C4CEE3;
	Tue, 17 Jun 2025 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174535;
	bh=ojRFUsqfczFwui7yvFFXbI1psU9gJdBxBxiGcrpFnDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYIIUOMdFkQs9FQbORmQTx2LzLQFSRoSftWCfhdkK6a0W2DcpUbBfwbBSQDcCa6ft
	 sm4vGeXNCT/mdKuWZKV+Y+mokR+vTWIvMtP6vBQoK/yid8yF/Iw+xRUEwEmsrOTOpy
	 NGQ0YqZrL7poDwJIcaV3JXVIyJNpydOkq6+Bo8pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/512] crypto: lrw - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:19:57 +0200
Message-ID: <20250617152420.820231160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e216fbf2b7866..4bede0031c63c 100644
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



