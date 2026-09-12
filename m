Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88337757A;
	Sat, 12 Sep 2026 07:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197539; cv=none; b=Q3DnGsfYrXfK6AOOPLcQsWPIX50TruzbBLEosF429Ot/REfNnvsmthG6QNeN49zKaaQdhU8syyyPxVoKAhGlfFlHhPKuoYw23c8dptBQX3I7dM1RACB/u5TZ/J1Ey2uxerOgMGm+7qX8pzzRQJneTp94J/49Smy1E21quCVfSCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197539; c=relaxed/simple;
	bh=KmvTmBpmskbk1cRa4AI43Xmr1lf88UVLCSgZIw3c70w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiDxdtSqNOGR1Ta2vnfOxGEk1r8wc3MNvcht2Yq1JnE5lTZsXTXt8h0UbUO6pFw6gQEpw7j7o9t0CqiZxYjKbheyr76dNhHDoyFQX9JETLJVzbMGI2LqeJbmr6cMj5uWuwvbsBj7H5cKCp7jIwqDHPxPCJ9DiIJApP0w4xSeedM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6UiL5nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6UiL5nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567881F000FF;
	Sat, 12 Sep 2026 07:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197538;
	bh=iAI3g9XPqtnhM9kU+rq6r2aBr6BO9ol9b5lzkhWQWgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6UiL5ndOOGNh6YfS3EelJcOklvmJdT1LdvsQra1KerDISr+oUdGwg3cGTdKoexc0
	 /rvTKX+HgP9kOvykiEPYkudoKuvSIhPUZY9gUveCn6h1iR6IV8wDQPDAdx3vKtJlkS
	 iw4dke3xMGlUeJ3Awl61BATN4JKoz4MSCinXseds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0196/1815] crypto: keembay - Fix AEAD unregister count in error path
Date: Sat, 12 Sep 2026 08:32:26 +0200
Message-ID: <20260912065653.599939828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8a8f6c81e010c..0e424024224e5 100644
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



