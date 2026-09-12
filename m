Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01372D5C68;
	Sat, 12 Sep 2026 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229091; cv=none; b=fri2F6O9clsV6XgWbzvBGJCaokwtL1FavhH5QUeeAQMGCSCFv95s3dbxTRN4JoEMQjsiCeESKTJ54LgzCn5uKeX7doq1GeCMfjBnR4QSNreYUayyCqd4R7Sr+xwsd9wDNsRN1ye4mElijuNCeBryU+bUje1J7xQ9MWH46Alrrtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229091; c=relaxed/simple;
	bh=GGaWXbUHkrJwpQaC+wxboPyCg2EJjkm855kKuSWaPNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/lsh1xQcCa7D4BgQiDpRGkmfMUD68dNDnorRGipBY+KnIp4MoX7QOdKHxrkEBo8G17jpkBXwb0Dan8zGbkUnxy0qyr1fmbyTWnxqoJEubpV4Gyu7Z7ff+pXpPWJOQGwOt8qnWf4cDKq40BVljvjGE8yWAjJfsmJqiu5cll6Nc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQDjkzME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQDjkzME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59231F000FF;
	Sat, 12 Sep 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229090;
	bh=O20IderpeuyZgQy1GGstu9XxACtlZT8IWdfhQUGObLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQDjkzMEfzIAhTRZu6cE2VZFhhb9uK1kmJpA6Zvrg7bn3SUSZWp577eGaMAsfWMzV
	 bQXROeH/ICXi1vANJZVXZ1sW1UUjUiHRr1mUtU/gg9z0f9QajnXAQTH4hVDkVUa63F
	 J0w1vYNP3jBDTpxCXI3xtiWGII8nNNoorvRdOlAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0520/1191] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 08:54:08 +0200
Message-ID: <20260912065559.929780881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

[ Upstream commit f240f9b588f4e2de89822adebf560a96b5d263ed ]

The hardware ECDH path in atmel_ecdh_compute_shared_secret() uses the
private key stored in the device. However, the public key is cached only
after atmel_ecdh_set_secret() successfully generated that private key
for the current tfm.

atmel_ecdh_generate_public_key() already rejects requests when no public
key is cached. Add the same check to atmel_ecdh_compute_shared_secret()
to prevent the device from using a private key that was not generated
for the current tfm.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 8bc22af2c3c50..d2c830cb20eed 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -165,6 +165,9 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 		return crypto_kpp_compute_shared_secret(req);
 	}
 
+	if (!ctx->public_key)
+		return -EINVAL;
+
 	/* A P-256 public key must contain two 32-byte coordinates */
 	if (req->src_len != ATMEL_ECC_PUBKEY_SIZE)
 		return -EINVAL;
-- 
2.53.0



