Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A54168C4;
	Mon, 27 May 2024 19:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837508; cv=none; b=G/QkHld+mFhad8AOheMh1wTtRuzGUSgnCq3xGnEUGe6OdqrLdE06vrhM1pq5MA3Av0NvzXTKxtyQPU97rIIKT7a06TrmS1jFq5tHi308XOVz72vwWp1/9rQ42c2Eui8qodtXSTEyspAm5Cxn6SjRqS/gIUm0/zZLmhNGJhusUv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837508; c=relaxed/simple;
	bh=O04dce0pToKb+q8z8zclICIArT/gRG0eCxcPHG4yxeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTGWMeuHPuFg9owsHpaU1spBBj4QbVNY+qn8IP3jmhBVrFHuMSUC0nchSE5PRYnZcAoXGy76ZJDb42tZHJETDuUAIn6jQ4XTp4g+JnTqytowaODTYN2D2u4K0rQPE+oiVixbf3XrU5X8Uxz81tMrJ57lB6zNlvgjHbCWCckv6aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFvwTT/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFvwTT/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4036BC2BBFC;
	Mon, 27 May 2024 19:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837508;
	bh=O04dce0pToKb+q8z8zclICIArT/gRG0eCxcPHG4yxeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFvwTT/LYxNqd1vsgqKDGcwKU5y3wkhirlkEQ+PWbvPatZoptaa6dc4BugzGbZObM
	 5oVly8CVHx9zPRcOpelSSUzGbKiZqyWfQ9DVQopvb+eR74XtyPrmnizJlLfG+hZJMa
	 YYYQY3dmRN81KKr3S5UmPnj0T2VaiTk8ZuS17yQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.8 037/493] KEYS: asymmetric: Add missing dependency on CRYPTO_SIG
Date: Mon, 27 May 2024 20:50:39 +0200
Message-ID: <20240527185629.871965475@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit dcaa86b904ea3761e62c849957dd0904e126bf4a upstream.

Make ASYMMETRIC_PUBLIC_KEY_SUBTYPE select CRYPTO_SIG to avoid build
errors like the following, which were possible with
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y && CONFIG_CRYPTO_SIG=n:

    ld: vmlinux.o: in function `public_key_verify_signature':
    (.text+0x306280): undefined reference to `crypto_alloc_sig'
    ld: (.text+0x306300): undefined reference to `crypto_sig_set_pubkey'
    ld: (.text+0x306324): undefined reference to `crypto_sig_verify'
    ld: (.text+0x30636c): undefined reference to `crypto_sig_set_privkey'

Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -15,6 +15,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	select MPILIB
 	select CRYPTO_HASH_INFO
 	select CRYPTO_AKCIPHER
+	select CRYPTO_SIG
 	select CRYPTO_HASH
 	help
 	  This option provides support for asymmetric public key type handling.


