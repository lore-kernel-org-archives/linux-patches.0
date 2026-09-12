Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13413911A2;
	Sat, 12 Sep 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238335; cv=none; b=fpjRgq4oTLyWBa/J09cWMoC7ERl9BcP+7n2Ucmd4XiRNMmmfW6mUUIq82+dtwPiRkfSpic+y73bLmLqL40M+ymmIKPKmEJtvDp+kBGKTbist4wd7o1O6sAWwSc98HfXI9vAsDnxo86ShikR6hzgNuUjar0XpR0lznux+isSU6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238335; c=relaxed/simple;
	bh=OU8yp/H5oX1yMzscGgKIzrcLV6FDpaRc/Bt/CV5KcHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNQxxkZPFEG+MoU5Rm43lIZTnvF4iTQA6k6vLCkY++H7CafcFqAPBRIQsI/rf6zmZhKllKpb2DH4JDaU7aDXcf8EyKN3tUVqFJTx+A+Vm822r5luQqXxlTMxzX3wCEH/AA1fcGYuey82TGxFO7JNxTqs6LClg709TxwESNZR1mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O7d4QAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O7d4QAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1A51F000FF;
	Sat, 12 Sep 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238334;
	bh=ZThw5z7/TErFPeY9jIAbmeSb8G/EThta7XhSPKhTr+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1O7d4QAk2hV629Khd2K6WnllWzEtfZxJYC4U83Mx3KckvEcU924t1mA2pirLOVi5B
	 YcgIasyfzl89AW7VUDhr0x7ZSLGsTS56XbJb4dUPbQTe1bJCVax4hYWoOexZf9RxYs
	 vwNlO/R1Nz2gMIptIjJoMmeyhUlz2+//ZfGf4EPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/935] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Sat, 12 Sep 2026 08:57:49 +0200
Message-ID: <20260912065536.899534591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



