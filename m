Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B2943DA2C;
	Tue, 16 Jun 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623066; cv=none; b=RikgeMBLM2s5VyJhx4WUiwmMuN+mrlAKjN5bt+rfnU16mLEkdzeheEEafq75KR8ZqE9UjZTM8Z4LV+FKVZK/krNYA79G2JrEhLgmW2/WnPLq7ddyHoT7An1uN49HmBmNEYlkF3k9tWV5tlhJmkh4w5FijtMRcKH+HDHPfi72jME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623066; c=relaxed/simple;
	bh=1S5q7Y33rQpLKUPrzG8db3bqmrnWeaOpIqis/dz4+cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkBGSab+oJ82WXoSLUCxAJNg7LYZaJxL22OVUIqtJDET+UBaGOhOaRwCrwUuP8BGOd9RktstxWX56m6D6qsS8CS7FC34YXjETe8uFfqMuNJt1H6l1hrA0b1eBy24yIsaq1b7mBpIUTXtymVQRcVZ/tKDAYNBcQTMmlvQzDxDgHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka2dGyUW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka2dGyUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5781F000E9;
	Tue, 16 Jun 2026 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623065;
	bh=LISTWS0GTmJ9ikyhhZJClVF9WHKjgzbFSwsfj3AZAdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka2dGyUWaBmMZQNXOD8Gamw0LNurEyQjs9cPj+iLnyCAXAvTIBhoPzT95rWyKK3su
	 pAA+k6ySkd9Wt2xjNAunrrKXa6bYtYfLc6WCWvnENJw6QUt/cTNIh3K6Afm6L5FLle
	 8rfpSpGZYuUZ3j8GF1JIMA0pyplCmNKE284QvPpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 082/378] crypto: s390 - add select CRYPTO_AEAD for aes
Date: Tue, 16 Jun 2026 20:25:13 +0530
Message-ID: <20260616145114.535243780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ecf3edd349dfabee9bc8a46c5ff91c9ebd858d48 ]

The aes driver registers both skcipher and aead algorithms,
but when aead is not enabled this causes a link failure:

s390-linux-ld: arch/s390/crypto/aes_s390.o: in function `aes_s390_fini':
arch/s390/crypto/aes_s390.c:969:(.text+0x115e): undefined reference to `crypto_unregister_aead'
s390-linux-ld: arch/s390/crypto/aes_s390.o: in function `aes_s390_init':
arch/s390/crypto/aes_s390.c:1028:(.init.text+0x294): undefined reference to `crypto_register_aead'

Add the missing 'select' statement.

Fixes: bf7fa038707c ("s390/crypto: add s390 platform specific aes gcm support.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 79a2d0034258b6..1b12856acfbcb7 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -14,6 +14,7 @@ config CRYPTO_GHASH_S390
 
 config CRYPTO_AES_S390
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, XTS, GCM"
+	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-- 
2.53.0



