Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB692F6160;
	Tue, 17 Mar 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768519; cv=none; b=KRiLixf8ShOUV4JpoTlFl8wZ0V7e4TeGwwSQc5XcUUmrgCUEKstNXEpbyW6hbP+8cL1X7BAzj2brjgLqb9ALyE+rfnJK7/UeW1RdTnB6ks92eSSy4JNXoqrX7MtGo/G7HtG2oF+mNAkxZAiP0IT+A4ixb1l9suXAqmXTex9CVC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768519; c=relaxed/simple;
	bh=jjjMoeBKnc7uLSJGxUROKRyWPK6HSlPyaGwZIpTjoYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRS/PJ4EC1hABUkCtt5770T62Nll5Y0hrm5dTQtLFXpiiOadrUpSApaQnDxJT0+WxMd/RLJ/U2KX1iIq7aqWA7PRr8Mm15fI1Pdl/8jrWkS20aS7/eBclykLAxSvcWRHJdzOw6XgPm2VhY6tXK/MhJQjQCXSzuXSVjgMQmPbHLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAOHXjh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAOHXjh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F5AC4CEF7;
	Tue, 17 Mar 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768519;
	bh=jjjMoeBKnc7uLSJGxUROKRyWPK6HSlPyaGwZIpTjoYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAOHXjh1SjpyjDhh//ra49rHal9lPaTkjT2zx5xIfu63atMX/Q+xYQRxcWAXsXZ76
	 N7jVge2URjLbgj4UqlPUw6FiuVyOWok9C90np1lMrHmfBWTXpVjhSFIu6o7NHmxaUD
	 QuUTm6ioc+xeaT2YK8xAygLdD5TzFd6f9dYqKfnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Gow <david@davidgow.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 329/333] lib/crypto: tests: Depend on library options rather than selecting them
Date: Tue, 17 Mar 2026 17:35:58 +0100
Message-ID: <20260317163011.607582266@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

commit 4478e8eeb87120c11e90041864c2233238b2155a upstream.

The convention for KUnit tests is to have the test kconfig options
visible only when the code they depend on is already enabled.  This way
only the tests that are relevant to the particular kernel build can be
enabled, either manually or via KUNIT_ALL_TESTS.

Update lib/crypto/tests/Kconfig to follow that convention, i.e. depend
on the corresponding library options rather than selecting them.  This
fixes an issue where enabling KUNIT_ALL_TESTS enabled non-test code.

This does mean that it becomes a bit more difficult to enable *all* the
crypto library tests (which is what I do as a maintainer of the code),
since doing so will now require enabling other options that select the
libraries.  Regardless, we should follow the standard KUnit convention.
I'll also add a .kunitconfig file that does enable all these options.

Note: currently most of the crypto library options are selected by
visible options in crypto/Kconfig, which can be used to enable them
without too much trouble.  If in the future we end up with more cases
like CRYPTO_LIB_CURVE25519 which is selected only by WIREGUARD (thus
making CRYPTO_LIB_CURVE25519_KUNIT_TEST effectively depend on WIREGUARD
after this commit), we could consider adding a new kconfig option that
enables all the library code specifically for testing.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/r/CAMuHMdULzMdxuTVfg8_4jdgzbzjfx-PHkcgbGSthcUx_sHRNMg@mail.gmail.com
Fixes: 4dcf6caddaa0 ("lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256")
Fixes: 571eaeddb67d ("lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512")
Fixes: 6dd4d9f7919e ("lib/crypto: tests: Add KUnit tests for Poly1305")
Fixes: 66b130607908 ("lib/crypto: tests: Add KUnit tests for SHA-1 and HMAC-SHA1")
Fixes: d6b6aac0cdb4 ("lib/crypto: tests: Add KUnit tests for MD5 and HMAC-MD5")
Fixes: afc4e4a5f122 ("lib/crypto: tests: Migrate Curve25519 self-test to KUnit")
Fixes: 6401fd334ddf ("lib/crypto: tests: Add KUnit tests for BLAKE2b")
Fixes: 15c64c47e484 ("lib/crypto: tests: Add SHA3 kunit tests")
Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
Fixes: ed894faccb8d ("lib/crypto: tests: Add KUnit tests for ML-DSA verification")
Fixes: 7246fe6cd644 ("lib/crypto: tests: Add KUnit tests for NH")
Cc: stable@vger.kernel.org
Reviewed-by: David Gow <david@davidgow.net>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260226191749.39397-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/tests/Kconfig |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -5,45 +5,41 @@ config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 	depends on KUNIT
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	# No need to select CRYPTO_LIB_BLAKE2S here, as that option doesn't
+	# No need to depend on CRYPTO_LIB_BLAKE2S here, as that option doesn't
 	# exist; the BLAKE2s code is always built-in for the /dev/random driver.
 	help
 	  KUnit tests for the BLAKE2s cryptographic hash function.
 
 config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_CURVE25519
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_CURVE25519
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
 
 config CRYPTO_LIB_MD5_KUNIT_TEST
 	tristate "KUnit tests for MD5" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_MD5
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_MD5
 	help
 	  KUnit tests for the MD5 cryptographic hash function and its
 	  corresponding HMAC.
 
 config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_POLY1305
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_POLY1305
 	help
 	  KUnit tests for the Poly1305 library functions.
 
 config CRYPTO_LIB_SHA1_KUNIT_TEST
 	tristate "KUnit tests for SHA-1" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA1
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA1
 	help
 	  KUnit tests for the SHA-1 cryptographic hash function and its
 	  corresponding HMAC.
@@ -52,10 +48,9 @@ config CRYPTO_LIB_SHA1_KUNIT_TEST
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA256).
 config CRYPTO_LIB_SHA256_KUNIT_TEST
 	tristate "KUnit tests for SHA-224 and SHA-256" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA256
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA256
 	help
 	  KUnit tests for the SHA-224 and SHA-256 cryptographic hash functions
 	  and their corresponding HMACs.
@@ -64,10 +59,9 @@ config CRYPTO_LIB_SHA256_KUNIT_TEST
 # included, for consistency with the naming used elsewhere (e.g. CRYPTO_SHA512).
 config CRYPTO_LIB_SHA512_KUNIT_TEST
 	tristate "KUnit tests for SHA-384 and SHA-512" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && CRYPTO_LIB_SHA512
 	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
-	select CRYPTO_LIB_SHA512
 	help
 	  KUnit tests for the SHA-384 and SHA-512 cryptographic hash functions
 	  and their corresponding HMACs.


