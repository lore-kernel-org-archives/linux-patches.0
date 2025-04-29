Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3921883E;
	Tue, 29 Apr 2025 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947968; cv=none; b=DTbBJ3MNgj/TvUC8uohPYcWsvst0Pa8jJzOfZp6l/2ib4UEFZp9eQLwHjewBZIWpRNV5Eg2hasyXKiapmRxg2ETsvZsaGuFgcYNuy2dIy7ZXbzbOjmm1Ga8s1oNic9Uy10aKRpmz4URJwKZg5E1G6xDUqwEeTO49I0k6PeQBvHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947968; c=relaxed/simple;
	bh=ePuhJrN2sqqbnOFVyR2U7d5rVUymoF3Wm0CFfeVBIuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdHvRXT1j1Bx+sQpbc5j/je4lnl0k4zwCEqxmzN3Xxzk1BZ6nXrQo3cnw8sVU/gb/4El8Y9H4h1oMxpnSamJlsJ5rSKdDdtTntrf9L+X7pt9y6crDYBrcu+OD6jp00+74RJ33OHrbvA7bHQhGTbXwzo2AGVBl3k2u/srdvQUyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZVue1bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZVue1bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1172EC4CEE3;
	Tue, 29 Apr 2025 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947968;
	bh=ePuhJrN2sqqbnOFVyR2U7d5rVUymoF3Wm0CFfeVBIuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZVue1bvyiTcZJ6/tiCd+YQvXbX3DiaYe552mu57GayaH4hKxoMGiyhuqfgfCKI5W
	 J4pvAesAek/iBvPmERSKZyg4v7n1xAmbwawSs9RmzGOXwuccUqfQ9BAMkXnGwaq1+f
	 5gIpdZEoNAB6C8ri3jLGO5vGjyFPhE7i42fLha24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/280] crypto: lib/Kconfig - Fix lib built-in failure when arch is modular
Date: Tue, 29 Apr 2025 18:41:38 +0200
Message-ID: <20250429161121.544236522@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1047e21aecdf17c8a9ab9fd4bd24c6647453f93d ]

The HAVE_ARCH Kconfig options in lib/crypto try to solve the
modular versus built-in problem, but it still fails when the
the LIB option (e.g., CRYPTO_LIB_CURVE25519) is selected externally.

Fix this by introducing a level of indirection with ARCH_MAY_HAVE
Kconfig options, these then go on to select the ARCH_HAVE options
if the ARCH Kconfig options matches that of the LIB option.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501230223.ikroNDr1-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/Kconfig     |  6 +++---
 arch/powerpc/crypto/Kconfig |  4 ++--
 arch/x86/crypto/Kconfig     |  6 +++---
 lib/crypto/Kconfig          | 26 ++++++++++++++++++--------
 4 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 5ff49a5e9afc9..8af59c1735ea4 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_NEON
 	tristate "Public key crypto: Curve25519 (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -47,7 +47,7 @@ config CRYPTO_NHPOLY1305_NEON
 config CRYPTO_POLY1305_ARM
 	tristate "Hash functions: Poly1305 (NEON)"
 	select CRYPTO_HASH
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
@@ -214,7 +214,7 @@ config CRYPTO_AES_ARM_CE
 config CRYPTO_CHACHA20_NEON
 	tristate "Ciphers: ChaCha20, XChaCha20, XChaCha12 (NEON)"
 	select CRYPTO_SKCIPHER
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 46a4c85e85e24..2a2615e35fdb5 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_PPC64
 	tristate "Public key crypto: Curve25519 (PowerPC64)"
 	depends on PPC64 && CPU_LITTLE_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -128,7 +128,7 @@ config CRYPTO_CHACHA20_P10
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 7b1bebed879df..d87b268d17d39 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_X86
 	tristate "Public key crypto: Curve25519 (ADX)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -352,7 +352,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
@@ -420,7 +420,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Hash functions: Poly1305 (SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_POLY1305_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index b01253cac70a7..c542ef1d64d03 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -42,12 +42,17 @@ config CRYPTO_LIB_BLAKE2S_GENERIC
 	  of CRYPTO_LIB_BLAKE2S.
 
 config CRYPTO_ARCH_HAVE_LIB_CHACHA
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the ChaCha library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA if CRYPTO_LIB_CHACHA=m
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA if CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA=y
+
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
 	select CRYPTO_LIB_UTILS
@@ -60,7 +65,6 @@ config CRYPTO_LIB_CHACHA_GENERIC
 
 config CRYPTO_LIB_CHACHA
 	tristate "ChaCha library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
 	  Enable the ChaCha library interface. This interface may be fulfilled
@@ -68,12 +72,17 @@ config CRYPTO_LIB_CHACHA
 	  is available and enabled.
 
 config CRYPTO_ARCH_HAVE_LIB_CURVE25519
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the Curve25519 library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519 if CRYPTO_LIB_CURVE25519=m
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519 if CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519=y
+
 config CRYPTO_LIB_CURVE25519_GENERIC
 	tristate
 	help
@@ -85,7 +94,6 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 
 config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
-	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	select CRYPTO_LIB_UTILS
 	help
@@ -104,12 +112,17 @@ config CRYPTO_LIB_POLY1305_RSIZE
 	default 1
 
 config CRYPTO_ARCH_HAVE_LIB_POLY1305
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the Poly1305 library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305 if CRYPTO_LIB_POLY1305=m
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305 if CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305=y
+
 config CRYPTO_LIB_POLY1305_GENERIC
 	tristate
 	help
@@ -121,7 +134,6 @@ config CRYPTO_LIB_POLY1305_GENERIC
 
 config CRYPTO_LIB_POLY1305
 	tristate "Poly1305 library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
 	  Enable the Poly1305 library interface. This interface may be fulfilled
@@ -130,8 +142,6 @@ config CRYPTO_LIB_POLY1305
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
-- 
2.39.5



