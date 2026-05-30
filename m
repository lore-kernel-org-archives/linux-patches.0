Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC19332919;
	Sat, 30 May 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160138; cv=none; b=WmS2wfn7zIfOHLRu3k5Ts1D2nfnHmkYCtmaFGKsGxLrrmutL34cTdBusXVpMcxcq8mFGTLvG52C+axEMqoQnw+MlSUXTA5C04hIMQ2sRjo/sLBGoMvCzcWaOBcujmtUuCG6z2JEVfJFU1edHN5bgtu5CUaHmx5Uonc2myXXTFjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160138; c=relaxed/simple;
	bh=DbPQF0blhkhrGQ9m0mEoXEkkyxgX5S4pkKRYzhr4L+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zj7Dr/fJecwsVJOYGOwbmioMz/QeacvaqnhivKhER2I1K0O5ovSxpWk76SpODYsYOHXiguPl481fyNcFni/CJkdFD6AOBnOgRHJj/DcW2/Rcyx2c+Dp1ay4qH2qeyxp+NYsHZuAI49SXHrb0uUmnHX7aOn+l7ZqCCoxP0fn9MRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hIuK7S1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hIuK7S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF571F00893;
	Sat, 30 May 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160137;
	bh=yXy9/9oSLSwGuef/4KCeNQyprUNqehJZA+AdWleGQxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hIuK7S1hMpR9WJtpZipJ8acmPETl1Zt0XRxZG8rFSqJuIWfSk9PrBrLO5F/084Eb
	 5u9mqOm70EEDNhTZuthcINTzNfuq0R1txRW7UXUesLRTR0nuwyg08x61XjnkHG0awB
	 t9PnpFPY4F19rIENHkXrMshz5Vtbo/eCY1nGXVx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 255/969] crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
Date: Sat, 30 May 2026 17:56:19 +0200
Message-ID: <20260530160307.516920700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -848,7 +848,7 @@ AES_FUNC_START(aes_mac_update)
 	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v4.16b
 	cmp		w3, wzr
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
@@ -862,7 +862,7 @@ AES_FUNC_START(aes_mac_update)
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
 
 	subs		w3, w3, #1
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 
 .Lmacenc:


