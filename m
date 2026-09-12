Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD71378828;
	Sat, 12 Sep 2026 19:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242358; cv=none; b=BkBGunhX3L1u6qUI0CzcS4lfVLL4ksFQ4VuM9MCly3yiPWbzXh5U058pcQTfDJ8jrbO59Yh7crKCgVQe43+5hqpVnH18gXADdrZnlIO0y9Mx5Mm1tLkL/e0AtaeIi+cBzTSoyL8VVB3y53fc2HW5L6b+D60LSpOj61XBLO4nsQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242358; c=relaxed/simple;
	bh=+iGI6SD+cSY10Lm+OPlOunqBkDfVrwQpWDCqfrwcT8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFflWs/NPz8DDXHwLulDRpbs/CGFrTL5zq4OqUzJteNEjOJBLqVOflDv9JZjiECKPRycaJJMFgv2aWAIg6/d2qw6WrIj2xr6/QMPJnScoOl0FpHPtYPAcpBF4h5Vtz6KdclmnR5fxhUf4CgjLIynaoRp7oALQ7aTIM1hyRiXAT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flmoddu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flmoddu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F821F000FF;
	Sat, 12 Sep 2026 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242357;
	bh=zGJUtOgzsZBwruB9P5pb48SX8b3e0pmGaYW0acor1Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flmoddu0dflr25S1sCWLRujpN7U1vV4bMiYm/UBaef6p5dJDpQQkTLhh29R/fvx5p
	 iPltNmhCoRM+5kNPBWKGyL/W14aD5jzGeVOcVSipptV4n+q8WlnOVLP/yPvlgy4sT/
	 8o4q9WILbQAUz0rvJgWyuL1wvW1QfgJnwSjmcqUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/798] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 09:00:01 +0200
Message-ID: <20260912065525.703108960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7950e635277a5..6fb1d02c2c30e 100644
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



