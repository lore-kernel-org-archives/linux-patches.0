Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2689A2DB7B8;
	Sat, 12 Sep 2026 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222699; cv=none; b=dfXr83wikd+okfY7d9Az5imdmeiJIw0cEFQKDgqjfV2B90wFzEIAtmAlfuILhtU/5XHa2k5NYCYBC1UZKW4p5DLwzwnNy7a+8bfUAnhJbA8/6XCvqA6WC+x1faY14Pm06qy4VMyGsrGaDqq0lULTIgg32JvE9y3OnbVLlPhDU7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222699; c=relaxed/simple;
	bh=7geGLu31SPUj5MgyTSz7dZnblXWG680vBpUg5TEWLtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOzaH60HSCr+wPfg4q8VhlKE7Nz04n03xOPX08PMe45Nx3i3wVXCInb6WpXDeJ6HuOUjnUUMMKlYrwa/z1S3/m5rGQggsqkR6RMPR+mCN+ClP+cvlhuW8Mgs8CJEGbgidRkFZ/4v5//NPPsu4NpwWa0eiZoLDT6CGcPDX9jOwaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGBQ4zx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGBQ4zx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D447E1F000FF;
	Sat, 12 Sep 2026 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222698;
	bh=qOznBUWbzumInn7ztAPtZkeRv+s928gtPFCaSKHSUvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGBQ4zx74WOegw9PmrrnSJa/YnmqZTipthTVAgQdzSS8/MtB9X3c3o2JZ53K7FWOy
	 E2mifQCxS3W0XLDVQIMGPCsvsQ5oniqPYAMnJg7LqArQ9wpKFKnpot84fuH0/pUy4c
	 sEvzyp6ohFtjWsa6US3HaVkOQ1oLcYEujnAe1hK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0640/1424] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 08:51:12 +0200
Message-ID: <20260912065621.624344219@linuxfoundation.org>
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
index efb346e5550e8..c64431380d303 100644
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



