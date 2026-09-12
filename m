Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF18364038;
	Sat, 12 Sep 2026 09:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206409; cv=none; b=NBtcyiqRkNXBKqS34eLy1N/DlvloSbSN/2ACyUl+8enIHRMkIssz+eYk/IMNIXLmY2O8IXJR04hPsMKwIB7BgEG2ZtJ9OzYmKigBnuxOzKLpDxChbCNlGmvGs6eYRpc6EKaKpc9nE83ZNbE8fezD7qDGbu+maEQKyyEqB4Rj5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206409; c=relaxed/simple;
	bh=uXA5h9EAx9ywX14s7aqOc4lhLvmletINOflInky6Nnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5OOBC36mxvOMXIbuqNhjG5MKp9T+ZRwNKRfE4VM+kEyd489gw3MoeKzoLW+D53lFcoJUbkNkOLKWLrE+0bH1ASmb42f9TkBiLz3aUsK4ODYmZsnwEiJ90gCaPZwYL2nqG5MRttlxonAS0Ikwn1cE8L8dOdcQeTituFZ4m/luyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCR5Blgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCR5Blgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12B61F000FF;
	Sat, 12 Sep 2026 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206406;
	bh=4Y6dQt1lBlWXntFG9Wddx6AE0fxd/Lvq26eX2qVgBc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCR5BlgyDKEI860sPBgycUcgYrZlbu2a0fyH9hQbE8XRdLMpFibbQt/JRTvdvHMsT
	 WKfXSue2j/8jsBpagHkTBTTShdevWxBU3AaA4HTlbFyj+UwtXBYrgoPIZnXlMFOtBx
	 DQpFWZx5RhYt0mR08kJJj5fb9KcYIQc7627gPya8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0201/1518] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 08:39:30 +0200
Message-ID: <20260912065628.035602510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 91edb42aba4af..93e3513541c7d 100644
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



