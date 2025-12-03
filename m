Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B3830C37A;
	Wed,  3 Dec 2025 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776508; cv=none; b=bEkJhKOGfI/rLBf0bD4twYJyjUfJemzhCNpEOKk2gcp3a51tsLcqNU9eQtdsQKj3HJD0frqkm8tmSaWU9/WbD2qSU22Y/f62VQW+XjdNwB4lJL6v1GEo40j1gwr7j+2ssXB4WbDKh7jqOB8XQqMSV83PNPrWjiyAltlvmSu9u+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776508; c=relaxed/simple;
	bh=0mdgHva55B0ufUZJryJV4MjBI/X2jRZv4RS62yemxsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVtfFrNoRiwfGxZIEMCXnj6Brk5ly2phtQLJzd7+QYA0vtJ6A+tic09xAGXAyVtynSMBYoDgU3ZyIw/QSzrlkYpm70YRSLeZZhfUhYrW3ZFOEKSHesBjez5gxvchHfbm3rHLKd19udldVZkCg/TWVndtfwShEHC+S0hZjNePi+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mccNDI0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mccNDI0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9A6C4CEF5;
	Wed,  3 Dec 2025 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776507;
	bh=0mdgHva55B0ufUZJryJV4MjBI/X2jRZv4RS62yemxsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mccNDI0IbXGGCKheT7mRYB1iQHXpBis7NtxqkyGBUMwuliV9je0f7sg8yV5X6ek+B
	 yvS+OzOGhMCpgaiZJcdAq10W57R27ulifMN58U4QlaSKVH5dOC8ABDzXzaUrWKU27P
	 EDKE0L4dL1jGQoZW22/gRH7D7VmfCtWiSO0seaec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/300] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Wed,  3 Dec 2025 16:26:46 +0100
Message-ID: <20251203152408.108923884@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index c46c05548080a..c5d676e7f16be 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -147,7 +147,7 @@ config CRYPTO_NHPOLY1305_NEON
 
 config CRYPTO_CURVE25519_NEON
 	tristate "NEON accelerated Curve25519 scalar multiplication library"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 
-- 
2.51.0



