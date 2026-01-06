Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C1354AF6;
	Tue,  6 Jan 2026 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720182; cv=none; b=G8b159lFCF8h3gAtVJqs2iMJpFKh+TrbGZkp5equnmpN0lFNA8FkibtYF5BM/LIcYQXePU/3wjHE2NKylocQeikx2EDg4DluuMyl9y+ea+vqcYJ/2kWYrvIKxyaowesWYddPBnYrwwBXA6hP+E2pOw98X2NcvclqrWgzNU+9VZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720182; c=relaxed/simple;
	bh=G9fVfBKF2kk5vzqV/LZ1mix89UUpixYwmtb0EwyJJBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWAXlIPu4A/d40PIRg77zNADRDRfUoHKeFHub5EQVtZUKvPp0eYC6gCpGYCVcuhfe4ZuF3yobqQd5pFGd4034Nzj8gLCTt5sklbIYTmlFVjtCFaNaUJPI6pAdV2KCyajmpsMgsNUA1/AWXO3NnvcXi4iZ36fBaTcRuB/ScronT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEk8oC7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEk8oC7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C0AC116C6;
	Tue,  6 Jan 2026 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720181;
	bh=G9fVfBKF2kk5vzqV/LZ1mix89UUpixYwmtb0EwyJJBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEk8oC7wfl6VF3+o6Fvh2PHUBtLz3eX/bG0XpODBYzyCG9MelK+CLqMol2Y1iCExJ
	 PX2sQvD9ZtPwVawgPDCuEX1Tr3JnN7/qGc8veVQJXkwWMv1RePjWTCb+roOqoolF7I
	 QVZHNGoXZM+q4OObVrdNX2F+5QzetcnblSrF/YHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 158/567] lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
Date: Tue,  6 Jan 2026 17:59:00 +0100
Message-ID: <20260106170457.174088770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
 arch/x86/crypto/blake2s-core.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/blake2s-core.S
+++ b/arch/x86/crypto/blake2s-core.S
@@ -54,7 +54,7 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	movdqa		ROT16(%rip),%xmm12
 	movdqa		ROR328(%rip),%xmm13
 	movdqu		0x20(%rdi),%xmm14
-	movq		%rcx,%xmm15
+	movd		%ecx,%xmm15
 	leaq		SIGMA+0xa0(%rip),%r8
 	jmp		.Lbeginofloop
 	.align		32
@@ -179,7 +179,7 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		(%rdi),%xmm0
 	vmovdqu		0x10(%rdi),%xmm1
 	vmovdqu		0x20(%rdi),%xmm4
-	vmovq		%rcx,%xmm5
+	vmovd		%ecx,%xmm5
 	vmovdqa		IV(%rip),%xmm14
 	vmovdqa		IV+16(%rip),%xmm15
 	jmp		.Lblake2s_compress_avx512_mainloop


