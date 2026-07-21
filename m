Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810BC470449;
	Tue, 21 Jul 2026 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655249; cv=none; b=gdCXgM8Chsz9JN1ieDMbEMM4HVXnZ1ip9CmkeY5pJh0Glw2vA+69Icfuuf7pxIVDoheMUj9Abfk/jlbxCYJwvRroxAoS8FaNUNaQZrWERzJaWFyCpALHicda+q9CqTwUD8oDtySdaIPt25plE/xEO5jsFzn0lqH+T1N+kmhteS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655249; c=relaxed/simple;
	bh=gLA6m46UqpxW3ecbvKdge12EU75DYnLPsWvLq0K3xfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3c6PdXiMgHC556fCDtSrQgSGQJ1GJH05Y0Tx1l+OO5OM/Yq3ue9kuu/ci42qVAaWqrkHJQrCGHVy9KN2uOSLH9G7ta6mq4Q+7aVdG3904j3E3B5s8Q6S4DuJotvBUBF8rN12T+9NphX30A61pOT3dUNhMfKDXmn67hIhVr5WOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha8d6/vZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha8d6/vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85961F00A3E;
	Tue, 21 Jul 2026 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655248;
	bh=QnesSfSgascawAOrYBX/OB5Llny33Aa+TOcoqFO29KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ha8d6/vZ0ov7SrcHCEQROH6qAbw82wi3c+7H6i0uCOJnEI4j0B1GQJBLhZo2ao0sw
	 nc/6o+zrYB5/Ex+1gRW0xpmVNL6ZXW5Eqf5d9mKuxjj8bOFFgWgbs4YgffoOIhJ31y
	 jY/KVA85N0oH2AnCY1eZI1y4kEbScFRvz+2kAEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 2012/2077] crypto: aes - Fix conditions for selecting MAC dependencies
Date: Tue, 21 Jul 2026 17:28:05 +0200
Message-ID: <20260721152640.162589868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit e073f1238ecaea366f53e98724c40b31856da56a upstream.

Starting in commit 7137cbf2b5c9 ("crypto: aes - Add cmac, xcbc, and
cbcmac algorithms using library"), the aes module (CRYPTO_AES) supports
CBC based MACs using the corresponding library functions.

To avoid including unneeded functionality, that support honors the
existing CRYPTO_CMAC, CRYPTO_XCBC, and CRYPTO_CCM kconfig options.  The
dependencies are selected if at least one of those is enabled.

However, the select statements don't correctly handle the case where
CRYPTO_AES=y and (for example) CRYPTO_CMAC=m.  In that case the
dependencies get selected at level 'm', due to how the kconfig language
works.  That causes a linker error.

Fix this by changing the selection conditions to use '!= n'.

A similar issue also exists for CRYPTO_LIB_AES's conditional selection
of CRYPTO_LIB_UTILS.  The same '!= n' would work, but instead just make
CRYPTO_LIB_AES always select CRYPTO_LIB_UTILS.  CRYPTO_LIB_UTILS is
lightweight, and it's needed by most AES modes and many other things.

Fixes: 7137cbf2b5c9 ("crypto: aes - Add cmac, xcbc, and cbcmac algorithms using library")
Fixes: 309a7e514da7 ("lib/crypto: aes: Add support for CBC-based MACs")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260709022954.45113-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/Kconfig     |    4 ++--
 lib/crypto/Kconfig |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -358,8 +358,8 @@ config CRYPTO_AES
 	tristate "AES (Advanced Encryption Standard)"
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_AES
-	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
-	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
+	select CRYPTO_HASH if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	help
 	  AES cipher algorithms (Rijndael)(FIPS-197, ISO/IEC 18033-3)
 
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,8 +8,7 @@ config CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES
 	tristate
-	# Select dependencies of modes that are part of libaes.
-	select CRYPTO_LIB_UTILS if CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES_ARCH
 	bool


