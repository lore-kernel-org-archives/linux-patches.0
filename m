Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6A264612;
	Fri, 21 Nov 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731287; cv=none; b=Ty2DkwVXNQ/aQnMD1jBEDKdFGJ/gj2/PngmmWXV5lFK7CJVsVAwW5yCfWuIECV5wAS6eN/zQZIVf02hhbECXK5qZjvl2HsZGxQQr+H+dfJgtIAgmALsn/8/vzAxevl2CDclwYns7aLO5SAb0q44N2qcPEzEjTeipCbY+HyCWGrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731287; c=relaxed/simple;
	bh=DxK6KQ7I57YXZ9HbleXNB5DRXQj48g3hQ7kQMwSCuuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jyqhzj1dnYHs8qoC6ungwl/IHpSfx5XhtSWib59lmLKLO0uAAnIsZ7UPebdOqQvq7ZqsN1Mw4yYfaBF9sC+8wbpdyK/SE7zInw/Rlz4x61kt5Pxj/Y+suLSqBIqmdsXtgU0lVpJXr07iveZke/dGj9G9dSTt3gmzt+Nrb9xxcIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+vp3+Sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+vp3+Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31DEC4CEF1;
	Fri, 21 Nov 2025 13:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731287;
	bh=DxK6KQ7I57YXZ9HbleXNB5DRXQj48g3hQ7kQMwSCuuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+vp3+SzQ/qsaXwZhpeUV8Je4nIOEnKHMTFWPoIRggB1jPi7JLAmxpIW0HANO6ah8
	 t2nMe4v+HiBacdrC3Mwo/rXXpbY9oa01WoeTGUyjYJIHtt827Wu7+jJV+IEJ/zvE5W
	 1XFBeEF2KZhQS8B3pXdWAIXw6PPgkGHXdLto4D2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/247] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Fri, 21 Nov 2025 14:11:09 +0100
Message-ID: <20251121130158.962675596@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 44e8241c51f762aafa50ed116da68fd6ecdcc954 upstream.

On big endian arm kernels, the arm optimized Curve25519 code produces
incorrect outputs and fails the Curve25519 test.  This has been true
ever since this code was added.

It seems that hardly anyone (or even no one?) actually uses big endian
arm kernels.  But as long as they're ostensibly supported, we should
disable this code on them so that it's not accidentally used.

Note: for future-proofing, use !CPU_BIG_ENDIAN instead of
CPU_LITTLE_ENDIAN.  Both of these are arch-specific options that could
get removed in the future if big endian support gets dropped.

Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251104054906.716914-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 1e5f3cdf691c4..a00ab9265280f 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -4,7 +4,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (arm)"
 
 config CRYPTO_CURVE25519_NEON
 	tristate
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_KPP
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
-- 
2.51.0



