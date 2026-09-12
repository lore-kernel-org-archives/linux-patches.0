Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7CE330B14;
	Sat, 12 Sep 2026 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222719; cv=none; b=axRsjHFBRISbVxe6d3peCXrfVQhu/AhsaeXQ4Gt4uevNctp8KhG9Jw+rYN5HKHEAs5/VDYOTlnPcgXzpTaATx8RmuV6drfhtrGwqDHeawacQ9oquKgn1kzC1m7IAhIPH2hxJLxVBNAFnKdNUP1yAQaDHp2HXyAfi/Z5CwN62Eic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222719; c=relaxed/simple;
	bh=zZSg3phRuQmIU4BJPdidfFJMiq+QSFJMm5eKNTyCoIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAZSjKvSJK9Pfy5BibpEviGXWzsSzm7bCId4v32EYWlzt5LR8oVWzOFwlqzAgwNGnjFXm5YYbcr4hgAkz87X5qGYoJJbxq1unZx0E6j6W8u0dGHPFq5+Q+C4YWiPQQmJnMOZqhM35J01XH+HWDPhg662mULf4Mgz47U2wtVwr64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBkWutw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBkWutw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3D81F00893;
	Sat, 12 Sep 2026 14:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222717;
	bh=pGPjSON+MCZINjMilXfzMP2POkDTblh4yg+ki9kYbLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBkWutw9RuB9KSgkZCIS3rNHcleQy8ZhDfDd8YEsZIiwnbiNFIN+/jAB2IMyfsxW1
	 Wlk0LvP4lp5hr01DCLk96MTaIW5selUzjsh6Sf4K6yjIeDbibMN/mv3qVlMD7eNwp4
	 mupfa9FxDljkbrZUY56rvBf4Mi4z+kAeWoxQwul4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0644/1424] crypto: keembay - Fix AEAD unregister count in error path
Date: Sat, 12 Sep 2026 08:51:16 +0200
Message-ID: <20260912065621.712393951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1e2fd9a754ec0..c8be35c7f000c 100644
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



