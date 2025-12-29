Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE33346BD;
	Mon, 29 Dec 2025 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026052; cv=none; b=CmztLy5+guNLe3IC3RWHz09q01BZsa97f6CUCYZD3aggd2Pxj2kpzF4/B3X7CjbXO5z9lNoKktf24JWB1As+Mv0lsdORIZqIuZ/vgrDvO5PFD0eNTK05JxF6o9vnL8Q3tlR68iJ6MITk8xAQss6vpYe/CjhgnoBBgLDJxpl2N2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026052; c=relaxed/simple;
	bh=OGFWPct3NVSFV9FimeVOKHnE+YjaYrnHhL9Bb53l17w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPEHbPUfQmBLZRpuCb+stI4j6bxkxLBNt1hynVyQE23XL1xNQljODV3jVA7vubjxmBOXT+BefExmreb+3Mwzp38vqRrMIH6By8OSgoVUrBDNKDKIa130aKjMoG928rpv203Tofid9qMOnlSjas8U/ylgJMTfLM0YxG931YtsF64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2OA5ZTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2OA5ZTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C582C4CEF7;
	Mon, 29 Dec 2025 16:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026052;
	bh=OGFWPct3NVSFV9FimeVOKHnE+YjaYrnHhL9Bb53l17w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2OA5ZTJ7YffTEKwAeaRrUV7XtVSIhKvZl4h+5UQDaUVI2TrVPazc5LSEYydACbqd
	 n815TmHDkeSqYNsCVzOzetqfnHRuGy1+k1rb3BTankZh8D04OoZs+j9EQdWFXSEgDT
	 LBbXz97XEVgkAzeOFFZLDl3wQIApOSpAG7JnOTpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Jerry Shih <jerry.shih@sifive.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 415/430] lib/crypto: riscv: Depend on RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
Date: Mon, 29 Dec 2025 17:13:37 +0100
Message-ID: <20251229160739.586511544@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 1cd5bb6e9e027bab33aafd58fe8340124869ba62 upstream.

Replace the RISCV_ISA_V dependency of the RISC-V crypto code with
RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS, which implies RISCV_ISA_V as
well as vector unaligned accesses being efficient.

This is necessary because this code assumes that vector unaligned
accesses are supported and are efficient.  (It does so to avoid having
to use lots of extra vsetvli instructions to switch the element width
back and forth between 8 and either 32 or 64.)

This was omitted from the code originally just because the RISC-V kernel
support for detecting this feature didn't exist yet.  Support has now
been added, but it's fragmented into per-CPU runtime detection, a
command-line parameter, and a kconfig option.  The kconfig option is the
only reasonable way to do it, though, so let's just rely on that.

Fixes: eb24af5d7a05 ("crypto: riscv - add vector crypto accelerated AES-{ECB,CBC,CTR,XTS}")
Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20")
Fixes: 600a3853dfa0 ("crypto: riscv - add vector crypto accelerated GHASH")
Fixes: 8c8e40470ffe ("crypto: riscv - add vector crypto accelerated SHA-{256,224}")
Fixes: b3415925a08b ("crypto: riscv - add vector crypto accelerated SHA-{512,384}")
Fixes: 563a5255afa2 ("crypto: riscv - add vector crypto accelerated SM3")
Fixes: b8d06352bbf3 ("crypto: riscv - add vector crypto accelerated SM4")
Cc: stable@vger.kernel.org
Reported-by: Vivian Wang <wangruikang@iscas.ac.cn>
Closes: https://lore.kernel.org/r/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/
Reviewed-by: Jerry Shih <jerry.shih@sifive.com>
Link: https://lore.kernel.org/r/20251206213750.81474-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/crypto/Kconfig |   12 ++++++++----
 lib/crypto/Kconfig        |    9 ++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -4,7 +4,8 @@ menu "Accelerated Cryptographic Algorith
 
 config CRYPTO_AES_RISCV64
 	tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XTS"
-	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
@@ -20,7 +21,8 @@ config CRYPTO_AES_RISCV64
 
 config CRYPTO_GHASH_RISCV64
 	tristate "Hash functions: GHASH"
-	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_GCM
 	help
 	  GCM GHASH function (NIST SP 800-38D)
@@ -30,7 +32,8 @@ config CRYPTO_GHASH_RISCV64
 
 config CRYPTO_SM3_RISCV64
 	tristate "Hash functions: SM3 (ShangMi 3)"
-	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SM3
 	help
@@ -42,7 +45,8 @@ config CRYPTO_SM3_RISCV64
 
 config CRYPTO_SM4_RISCV64
 	tristate "Ciphers: SM4 (ShangMi 4)"
-	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_ALGAPI
 	select CRYPTO_SM4
 	help
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -50,7 +50,8 @@ config CRYPTO_LIB_CHACHA_ARCH
 	default y if ARM64 && KERNEL_MODE_NEON
 	default y if MIPS && CPU_MIPS32_R2
 	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX
-	default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390
 	default y if X86_64
 
@@ -161,7 +162,8 @@ config CRYPTO_LIB_SHA256_ARCH
 	default y if ARM64
 	default y if MIPS && CPU_CAVIUM_OCTEON
 	default y if PPC && SPE
-	default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390
 	default y if SPARC64
 	default y if X86_64
@@ -179,7 +181,8 @@ config CRYPTO_LIB_SHA512_ARCH
 	default y if ARM && !CPU_V7M
 	default y if ARM64
 	default y if MIPS && CPU_CAVIUM_OCTEON
-	default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390
 	default y if SPARC64
 	default y if X86_64


