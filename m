Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216669;
	b=KMf/DPJ/j3PqbLGybEi3Ugmlr2WMp6yV7K03rNE6E/fDSsF9kak3Xy4q/6mt61n9xMlJ
	 yZArj2p447QaJRascOLALAbvBnQpipED+MOmUpp+RdTJ/CfwJ+orrXRIBZSaU37eWqt6l
	 qieMXrlewQ7PHkkPTugjBTmoA9MnsFo3kBMPne5uMuhcskUkbMpHCXWvwoDu385BdqJZi
	 4hc22+jQyQQfrHwn7xWUf5u/2OgfrcF8om9SmYt4hnM/RmPZEKq1TpIbbP9dl6FtFttv1
	 t6RMjcRIf6khPIS0i6a3HE9mJwtUqbCOE7e6J+QJyk4VFmzzL/ZaUxZkeyQBoqJe4TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86hvvIihQrroRMOv3gf5GItDh+eIW4tdZNyUBEFZfK0=;
	b=yEJ9Hctu8wdxjOQTDJg7wfwyPnV8Umv+OLDbhJ90fmdX2lQPztZqISz0ARA2Ql8jeaov
	 JqdirXOMk2IwuFuSb8ARnNW/reV7gZFvi2Bt809eST+Nxf/7W69LS3LvnZ5gLZ+Sg3UOm
	 66ukmLp7wD68isgDCq7mwxhL4tnQbFcDujCXBKUNk1TJWR8WgYyFyJ8QDCVOq52UmDEoP
	 /rWGyDDs7oLmsoFa6kfXh8y1Wvb+yhnAdbl40PxaX1EtUE6yjRIlYZ/+/ZcHSwsTkNSij
	 eL2HA/Vp2I9hBKxe2teTQVs1KpDBhB5/z3kNBhxCEd5RG0bpt3ONZfv3kWSTXeJTAgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjyAzKSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6719606A325;
	Wed, 28 Oct 2026 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjyAzKSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1B71F031E0;
	Wed, 28 Oct 2026 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216668;
	bh=86hvvIihQrroRMOv3gf5GItDh+eIW4tdZNyUBEFZfK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjyAzKSHAMr2RJ75zdBA6Xtyh91huDauQjdoIH9u9KVkTzGk+8sc2dsS65NC3QPB1
	 AmKX/PXI7dU3Iuh+HdB3T55PziWmY86vDUoMZGRm0fnsSKniBOZ1aJceRcGd+ek8lV
	 dpCQOYLyhIxB2Jk9/OVrFFjsJpocKx43PbtJy8a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1636/1887] crypto: keembay - Fix AEAD unregister count in error path
Date: Wed, 28 Oct 2026 18:02:12 +0100
Message-ID: <20261028170536.695229455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index 2a96fedc8d639..83c2bf9d25961 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1554,7 +1554,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	/*
 	 * If any algorithm fails to register, all preceding algorithms that
-	 * were successfully registered will be automatically unregistered.
+	 * were registered in the same call are automatically unregistered.
 	 */
 	ret = crypto_register_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 	if (ret)
@@ -1562,7 +1562,7 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 
 	ret = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 	if (ret)
-		crypto_unregister_aeads(algs_aead, ARRAY_SIZE(algs));
+		crypto_unregister_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 
 	return ret;
 }
-- 
2.53.0



