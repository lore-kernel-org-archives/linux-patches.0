Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027AD19A86F;
	Tue, 16 Jul 2024 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144561; cv=none; b=beekVdlFDvV6e4olir5SDcfL6UXs8/0BaN0soeN1FDMh2PwU3eN0cAkgY+soqWaGxJ5pqpXE6u7dKHCALV9Yw2tZ6rbIJ/ZrN5ISufM7T838GvrvbF893EUlnYDOkdxp91oNo/AJlnBpu16l7AndQ1zf3ZsIFaRDlAlmGXZ/rj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144561; c=relaxed/simple;
	bh=6V42mseGbtkhSCD3/KF4i+NUjAFT8jVL2Nes9KyYUBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNDF52vA5JgoHkBQg0qmoRZtjWfpLW/VBKiIq8lYhC+GKXCK1xtEadNB5uFrtVAyMm9y8kEpbZWLSTa1GJcfz25XDOwcsgs8IT7YpzY/unzdt9YGSRXND6h3+C0AChJEmKiR9SY6gzd7laOB6yq12vfRFroSXaopEJv+L5+CBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhfgYg+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhfgYg+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70096C116B1;
	Tue, 16 Jul 2024 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144560;
	bh=6V42mseGbtkhSCD3/KF4i+NUjAFT8jVL2Nes9KyYUBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhfgYg+NLzKuVrYfLc10gYyDz7ghQTv/lEnLB9Ud/53hzx63Inh3UDrr0DY1TTq4q
	 9ovYlIG0YbdT/LnfmhyiCaMbkS2+MxEAW3xG2lDLVkG+aOhf5RxCoy+Uu5+e3bB9cJ
	 OEO0qu/DbjGyH6Hb9XTk1fE8bNOv9+w1axOtw++0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hailey Mothershead <hailmo@amazon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/108] crypto: aead,cipher - zeroize key buffer after use
Date: Tue, 16 Jul 2024 17:30:21 +0200
Message-ID: <20240716152746.240710039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hailey Mothershead <hailmo@amazon.com>

[ Upstream commit 23e4099bdc3c8381992f9eb975c79196d6755210 ]

I.G 9.7.B for FIPS 140-3 specifies that variables temporarily holding
cryptographic information should be zeroized once they are no longer
needed. Accomplish this by using kfree_sensitive for buffers that
previously held the private key.

Signed-off-by: Hailey Mothershead <hailmo@amazon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/aead.c   | 3 +--
 crypto/cipher.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 16991095270d2..c4ece86c45bc4 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -35,8 +35,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 }
 
diff --git a/crypto/cipher.c b/crypto/cipher.c
index fd78150deb1c1..72c5606cc7f81 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -33,8 +33,7 @@ static int setkey_unaligned(struct crypto_cipher *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = cia->cia_setkey(crypto_cipher_tfm(tfm), alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kfree_sensitive(buffer);
 	return ret;
 
 }
-- 
2.43.0



