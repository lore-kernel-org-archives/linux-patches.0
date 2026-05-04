Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5011C68F;
	Mon,  4 May 2026 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904736; cv=none; b=a9YRxwtqfGOxYtObQn3EnRPE3JYJYyINtOVII5W9tmYZpoc7OfRqEnvC+nY3R3IDA3spKXoQdXOqUgMhLdD/5IhDm0J++mWair8sGXkc8aDZVjMtHQKCPfx5rGQw7gzZ1DcJcE2hFMP9wI2/JF6tQpGeCnYcAvWI7FF2HB78XLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904736; c=relaxed/simple;
	bh=hduqueCWaS+dQljBjklAypekTKvTRJwyTM0Csvun7Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/vxpuN4o5kK6E35HZUsOroYcfoy5yDGM3TzASrIqrSn1w3a1FbOi3Oy2Eqom80N61dE3yDaeEYco+dNssTNEENcMMb51nWbB5wqej3WbYZMGYFydaDWfq6rMlyIKf4pILYiEwJi6/1LfEMlefrJYdhaE6DPqw/Tv01hZEGIMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2QALsSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2QALsSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B5CC2BCB8;
	Mon,  4 May 2026 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904736;
	bh=hduqueCWaS+dQljBjklAypekTKvTRJwyTM0Csvun7Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2QALsSH4ZEl2eUNh1BHydg4FMYgFH1ZeFRaR0MczaRqfFpzuCrGaIVofaftPbZT4
	 Oih+Gg8/4WkNuNmSEWWqpwJy2OOPS6VWMVzO381Nz2VNFysJgFfAfEXwExWov1Cauv
	 Lv1ZWwvZKs7gQpxb7k9klhLm81Y99EHmkjh4x8Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 154/215] crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
Date: Mon,  4 May 2026 15:52:53 +0200
Message-ID: <20260504135135.802291463@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


