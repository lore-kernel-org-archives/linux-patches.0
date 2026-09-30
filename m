Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEAC37D11A;
	Wed, 30 Sep 2026 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784133; cv=none; b=XENJE0ndS5ZSqes+Y7Ijv1pcV47kJofI5F5CtOoxXFUE6c2prynacXmiInYhY0/FbYexw5FLzx7/V3galG8iZ/vS9DVEJCCDM+jWXGxj6hyhbHUlxSeq+sOFOv8zyE2hmYkeickdA+ER7NreHSamxnA7V4385lIv4zK36rSRWL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784133; c=relaxed/simple;
	bh=iKZybPVv/hvYxJs5TSEzGJ6Qjm9W7UnzoY1CAz4ZLoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf6bRQGoWqhECKtI2qzc3HsW/O1re2NkJzv10hABSrwdqr1FLTRSSIvv+dkuUI8UOR5KZ3upBIiQ8s7scplvNqBqYIQiw6qUueCsd61Qhf+3slPRH+I7GM6vu5rehN1ab+nupNovpLE59ZHUThvVcyeNpkjce8LsiYcF5A2tKCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcsxw4cZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcsxw4cZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F211F00893;
	Wed, 30 Sep 2026 16:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784128;
	bh=RXFxg7Li+kpcjZWrR2r+3BdIyp/+Ah93Taq70R5WDuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcsxw4cZrsuhb0Uq1J17eUSTSqtULsTiLexyKrFe3ZqmEzaX7BYXbqSGeSv0ogbIY
	 X78tiFZIrGUdGZgcjHwhsPIf88lNkmkeHzcANGcaGzsFwwlfv670Pra8BT6K33Zzc4
	 s2zY1MwSpVSInLhe8sp48dnUmrFECZirOVs6/Efo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/982] crypto: atmel-ecc - add support for atecc608b
Date: Wed, 30 Sep 2026 17:13:02 +0200
Message-ID: <20260930152417.786102907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b668edaf8dcc8d09f6f1e71797422b44d4bd22a3 ]

Tested on hardware with an ATECC608B at 0x60. The device binds
successfully, passes the driver's sanity check, and registers the
ecdh-nist-p256 KPP algorithm.

The hardware ECDH path was also exercised using a minimal KPP test
module, covering private key generation, public key derivation, and
shared secret computation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index d2c830cb20eed..b9c5832cf6fcc 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -366,6 +366,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{
 		.compatible = "atmel,atecc508a",
+	}, {
+		.compatible = "atmel,atecc608b",
 	}, {
 		/* sentinel */
 	}
@@ -375,6 +377,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
+	{ "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
-- 
2.53.0



