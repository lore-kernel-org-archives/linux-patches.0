Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89F622156D;
	Wed, 30 Jul 2025 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868451; cv=none; b=rtnHbyRY4b+Nf7OIjxvGrqUkEDlZo9EEV1Aq6rIgnBbN2Sl+jrn0sUC3BTwNevovr97ypC/vZFRjF3TaqDdfR2TMDUCXJDp/wBndERdwbXW32Qte6YZhJ5VKmuZmZwx65XIK5BdiYx0EeSa25ExEYflTaXK8NoFNuzMLMl+HGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868451; c=relaxed/simple;
	bh=JaqoMKYALp/VCy24AjQZKUGfzlCEMOZzXjXZt0NYXyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CblmwjvYtNh1TP3ji84L3/KAJkm7KiwD3bYxx8GfXS1TFRKmY4UGstE+zhnYjPOZ5/SccEqExUYFOV0JH5BV1/qu/qc5ufKlVfttUshGQfma7b3QCFEGqvLGfkpKaXNrRSzD0oeULqeOdm4/BjjmYmRU3ULSd/al8i3MrFkTraI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxB5p9NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxB5p9NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB90C4CEE7;
	Wed, 30 Jul 2025 09:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868451;
	bh=JaqoMKYALp/VCy24AjQZKUGfzlCEMOZzXjXZt0NYXyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxB5p9NEQCNQbLHk4dH3bArNhpNqkMalvQdrcl6kVPtH93D6Zc+3RB1KW1/M98Qgq
	 gxrCdA5sWpsxUZcQjHtj91khHnsEHifSr7Y5HwJwvxPltdy2xxTifcS8fN9idEweb9
	 mGjV+PpkJ9lshQOne3a5EUQYYKKCFUMohIxgd0Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/76] crypto: powerpc/poly1305 - add depends on BROKEN for now
Date: Wed, 30 Jul 2025 11:35:53 +0200
Message-ID: <20250730093229.194154351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit bc8169003b41e89fe7052e408cf9fdbecb4017fe ]

As discussed in the thread containing
https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
Power10-optimized Poly1305 code is currently not safe to call in softirq
context.  Disable it for now.  It can be re-enabled once it is fixed.

Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ applied to arch/powerpc/crypto/Kconfig ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -129,6 +129,7 @@ config CRYPTO_CHACHA20_P10
 config CRYPTO_POLY1305_P10
 	tristate "Hash functions: Poly1305 (P10 or later)"
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
+	depends on BROKEN # Needs to be fixed to work in softirq context
 	select CRYPTO_HASH
 	select CRYPTO_LIB_POLY1305_GENERIC
 	help


