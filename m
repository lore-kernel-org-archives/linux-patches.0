Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D99E3DA5C7;
	Mon,  4 May 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903498; cv=none; b=AGqQZqrKfEc4VZV8Vhv6U1ePuZArl+Hboz8E0naJFEEkzj1QEb1Q4px/9k18l30oF3DbZ12hx/F8N/Jo1rEWLQ+SPsUQiZW0qspbhzPu3TX9I6C5alhdTK9bp0pi5CosrqfRekuLIMBEkGaGxkdKOug4PHRO7ZLixHqlXV7yZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903498; c=relaxed/simple;
	bh=Ni6Snx2OFYxWEWKx7pDOzHuECx/qM7XtJgoNu42TLQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phUMwSem6nyvSAMxke5HD6D28tugUUDLKCSkZQfs98cZaNYz8uIKSgh3YHn69wqaI1ljTy36bjeF0NUPuQSFUQtFMb7lrskf0OzzCkPt/FH4tAbwcDdrJDRTFfeOzgfJZ1ZIVdsVvmzJ9O8aJBKZwdF08kZt0qGj3kdZmg7Z8go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w205EthB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w205EthB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311BC2BCB8;
	Mon,  4 May 2026 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903498;
	bh=Ni6Snx2OFYxWEWKx7pDOzHuECx/qM7XtJgoNu42TLQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w205EthBw12+HrrsQoLMMcP0EGcJL9YHMm3ptZCgp+qpKBE1VIChYWEiZ4iHG/UYv
	 9E64OXlC+hlIH/IN3bg8LbwMm5K1tuYRctEMSiVcMn6BcGaB4i22xGlzU4aI/2/Ykl
	 aPj93ku07rR8L6LRcEvm2PK/OHyK1aPzQENRUvic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.0 258/307] crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
Date: Mon,  4 May 2026 15:52:23 +0200
Message-ID: <20260504135152.525344242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit f8f08d7cc43237e91e3aedf7b67d015d24c38fcc upstream.

Since the 'enc_after' argument to neon_aes_mac_update() and
ce_aes_mac_update() has type 'int', it needs to be accessed using the
corresponding 32-bit register, not the 64-bit register.  The upper half
of the corresponding 64-bit register may contain garbage.

Fixes: 4860620da7e5 ("crypto: arm64/aes - add NEON/Crypto Extensions CBCMAC/CMAC/XCBC driver")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260218213501.136844-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/aes-modes.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -838,7 +838,7 @@ AES_FUNC_START(aes_mac_update)
 	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v4.16b
 	cmp		w3, wzr
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
@@ -852,7 +852,7 @@ AES_FUNC_START(aes_mac_update)
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
 
 	subs		w3, w3, #1
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 
 .Lmacenc:


