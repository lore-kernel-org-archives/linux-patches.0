Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A6F31283A;
	Mon, 29 Dec 2025 16:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025617; cv=none; b=ucobOdhYJf9B3tWtL9VJxVc4nlBejWnKtFg3bABu3YnCfMvQIujcAe/TQfXvnTjz+6Hx27HlokSGKk/yWdcvYt0WZP9RbZAJDG1R0P1vuDm5F5j3mp1kAJMMN0jY5cO4eA+cas39QvKTxp23tgJoz9e0JTXBR7gyElYZlsCTNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025617; c=relaxed/simple;
	bh=i3fSccT1gK08V/U6UmGi05EasAZda7WilXJunmLqhfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp7KxH42DI+6Mn2jmHT+l/OSVFk0cvELHjuijf6lnmWKCVCmepTFhK0TtVs/FtfRkJJfwjlY4ctiQH4o2LW+kJi7dwV1GoxULTL1D4iC66EWK5R5zbTl5cVxNptCSskPxHA85mVTVjt9zHx0WXwaY4dVICQkkYFNzqVDeGktuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kyS+2tN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kyS+2tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF7BC4CEF7;
	Mon, 29 Dec 2025 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025617;
	bh=i3fSccT1gK08V/U6UmGi05EasAZda7WilXJunmLqhfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kyS+2tNLZBHHozxOfar2Bla/3/3UcQaazKekdXbfCIv2bmiaNlmOgMwR0kF0vdB4
	 PdsBYTcBOXT0YX553B/1V0I87OTTjEVB+D29kCIKicH4PV3zuJiNrGJa49eGhnmvTZ
	 GxbtJgoV+S7I57p2QJPJtq2GEO68g6xyKPA+XtU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 243/430] lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
Date: Mon, 29 Dec 2025 17:10:45 +0100
Message-ID: <20251229160733.296926491@linuxfoundation.org>
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

commit 2f22115709fc7ebcfa40af3367a508fbbd2f71e9 upstream.

In the C code, the 'inc' argument to the assembly functions
blake2s_compress_ssse3() and blake2s_compress_avx512() is declared with
type u32, matching blake2s_compress().  The assembly code then reads it
from the 64-bit %rcx.  However, the ABI doesn't guarantee zero-extension
to 64 bits, nor do gcc or clang guarantee it.  Therefore, fix these
functions to read this argument from the 32-bit %ecx.

In theory, this bug could have caused the wrong 'inc' value to be used,
causing incorrect BLAKE2s hashes.  In practice, probably not: I've fixed
essentially this same bug in many other assembly files too, but there's
never been a real report of it having caused a problem.  In x86_64, all
writes to 32-bit registers are zero-extended to 64 bits.  That results
in zero-extension in nearly all situations.  I've only been able to
demonstrate a lack of zero-extension with a somewhat contrived example
involving truncation, e.g. when the C code has a u64 variable holding
0x1234567800000040 and passes it as a u32 expecting it to be truncated
to 0x40 (64).  But that's not what the real code does, of course.

Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251102234209.62133-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/x86/blake2s-core.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/crypto/x86/blake2s-core.S
+++ b/lib/crypto/x86/blake2s-core.S
@@ -52,7 +52,7 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	movdqa		ROT16(%rip),%xmm12
 	movdqa		ROR328(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
-	movq		%rcx,%xmm15
+	movd		%ecx,%xmm15
 	leaq		SIGMA+0xa0(%rip),%r8
 	jmp		.Lbeginofloop
 	.align		32
@@ -176,7 +176,7 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
 	vmovdqu		0x10(%rdi),%xmm1
 	vmovdqu		0x20(%rdi),%xmm4
-	vmovq		%rcx,%xmm5
+	vmovd		%ecx,%xmm5
 	vmovdqa		IV(%rip),%xmm14
 	vmovdqa		IV+16(%rip),%xmm15
 	jmp		.Lblake2s_compress_avx512_mainloop


