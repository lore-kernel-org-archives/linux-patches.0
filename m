Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85B11CBA;
	Tue, 17 Jun 2025 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174266; cv=none; b=KkVo3j9IUlsm+UMROoiqtIQAqXI714UTc76IPnzv/GcpnazSpOzIut59HA/fB+EU8TYNXodv0DdzaUe6b0skYRnEeJ5hptTeURcV4gpfsZHHRblfg+LOeKc8pfADNSc7IrQxzhUKeTNeH4wnI68M/7TjpwR8e3e7cUuBbufPKKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174266; c=relaxed/simple;
	bh=jFziql9/VNpYV1BioJycdxYGXuVZq0/RCgAX1tURWt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIK78HrH8DLr/91xHCt5i6fnAx5AZTavkefUVSHscwNxtA0RE73CB7sCMqstofI44weR68e0AHxDldx2YqCpackiR0uQGehkVieLcYfZsvPaWgA0T36JsfWWJ85p34dp12wKFjLKrkZY3Ii1pEFnVkDpl/2qAvudHFdalLM5OkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Szz3NQmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Szz3NQmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F701C4CEE7;
	Tue, 17 Jun 2025 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174265;
	bh=jFziql9/VNpYV1BioJycdxYGXuVZq0/RCgAX1tURWt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Szz3NQmHADWs1qZe1Q27HDZsb1e4HaNEyFBnsXIqQ1iriqtWaJyGBW4e0Q6XwYoZY
	 O5aJuzvXMW0NNMiOdRQ6k6kxMyU3lHhqzIMIDHyiYRB9iUnN2PF9UueaXMrk9VdF+q
	 Hf2eLiafLD+4mFgEFWryxowMUuspE/pboGHb/3xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/356] crypto: lrw - Only add ecb if it is not already there
Date: Tue, 17 Jun 2025 17:22:29 +0200
Message-ID: <20250617152339.596872158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 59260aefed280..5536ec7bf18f1 100644
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



