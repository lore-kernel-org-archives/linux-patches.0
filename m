Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB061714A4;
	Wed,  9 Oct 2024 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501979; cv=none; b=mID+h0DbQ8O6pWQlW+6Y9xNWGhj5ONI1dc2MKrRY8508YIs5hOPsYubLpuoHsdbPSMUOnq7opu2i9jfaTAGXbkLAx+JC5pZzUV67RT2zMuMqxHmOpfWYBdkRLktnuqUY8cl++E2lMBvgJ32CZRiBGNQLp64jBe2NxP4PqTdv83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501979; c=relaxed/simple;
	bh=uORjfL4WuGqTOF2X8sPKum4spOOJIstRjqK9q3eytvE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=utiEJNhwLYGNzjXtsqWswPDIxo5M9iAXhuuGf/XK5+H5faSNtBQkxB2yWYPURBxTXUE/j8LtTjXsHx+tN0Qztbf6ZqWqNGtyadxuBHrgBuKGDDYABgAKN5Sd8ue8tk2RCl2V7SCvlHga4ARITOnyj1P0t9q9E5cXi9RsqSPZP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYt6bc5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYt6bc5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB489C4CECF;
	Wed,  9 Oct 2024 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728501978;
	bh=uORjfL4WuGqTOF2X8sPKum4spOOJIstRjqK9q3eytvE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LYt6bc5iO+k49Z/dCb/PqFUKjDJERR8xN3cGKwH+gMFXbV0de42CDElI7NHuS0F/m
	 w1QSWTG6L1uo8F3Ml4/Zlcn+kxiI1tRqzPlQ3kmx/65aoQX21Z7C/JaqF3O101bax0
	 3CNzOxikqLs1kBdk9imJsIDDwEDYuSFzbjkJMzkFFt2Jh/g/NCjOaIXkC9pK1/lRfp
	 /aEIIa51+9S96SRGZn3JnzP1gHwymrlE0LEhoBtmC42VotGLlTDPYeCgKMTyieWPpd
	 3MS2uZccUf7L3twyIS7ZkCymSePehpkjNJ/wPqC1m4+850F37+94I4hTNu4jeI8pDw
	 v6IHqbr0Y0Slg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 09 Oct 2024 12:26:08 -0700
Subject: [PATCH v2 1/2] powerpc: Fix stack protector Kconfig test for clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241009-powerpc-fix-stackprotector-test-clang-v2-1-12fb86b31857@kernel.org>
References: <20241009-powerpc-fix-stackprotector-test-clang-v2-0-12fb86b31857@kernel.org>
In-Reply-To: <20241009-powerpc-fix-stackprotector-test-clang-v2-0-12fb86b31857@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3493; i=nathan@kernel.org;
 h=from:subject:message-id; bh=uORjfL4WuGqTOF2X8sPKum4spOOJIstRjqK9q3eytvE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlsN24ot0yf93LGt8lzD5xTvzZZqUrZcqdp0YZ5e/q8F
 v5ouhDl3lHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmInaPkWG9uN09g9Wr/zPe
 fejDKrm42ZNbrjhtr9iBo7faVzmWvj7PyPBbQNL2V73qwg/3xa58E+mTDvtiH5n9lfVYkoy539S
 lDUwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang's in-progress per-task stack protector support [1] does not work
with the current Kconfig checks because '-mstack-protector-guard-offset'
is not provided, unlike all other architecture Kconfig checks.

  $ fd Kconfig -x rg -l mstack-protector-guard-offset
  ./arch/arm/Kconfig
  ./arch/riscv/Kconfig
  ./arch/arm64/Kconfig

This produces an error from clang, which is interpreted as the flags not
being supported at all when they really are.

  $ clang --target=powerpc64-linux-gnu \
          -mstack-protector-guard=tls \
          -mstack-protector-guard-reg=r13 \
          -c -o /dev/null -x c /dev/null
  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default

This argument will always be provided by the build system, so mirror
other architectures and use '-mstack-protector-guard-offset=0' for
testing support, which fixes the issue for clang and does not regress
support with GCC.

Even with the first problem addressed, the 32-bit test continues to fail
because Kbuild uses the powerpc64le-linux-gnu target for clang and
nothing flips the target to 32-bit, resulting in an error about an
invalid register valid:

  $ clang --target=powerpc64le-linux-gnu \
          -mstack-protector-guard=tls
          -mstack-protector-guard-reg=r2 \
          -mstack-protector-guard-offset=0 \
          -x c -c -o /dev/null /dev/null
  clang: error: invalid value 'r2' in 'mstack-protector-guard-reg=', expected one of: r13

While GCC allows arbitrary registers, the implementation of
'-mstack-protector-guard=tls' in LLVM shares the same code path as the
user space thread local storage implementation, which uses a fixed
register (2 for 32-bit and 13 for 62-bit), so the command line parsing
enforces this limitation.

Use the Kconfig macro '$(m32-flag)', which expands to '-m32' when
supported, in the stack protector support cc-option call to properly
switch the target to a 32-bit one, which matches what happens in Kbuild.
While the 64-bit macro does not strictly need it, add the equivalent
64-bit option for symmetry.

Cc: stable@vger.kernel.org # 6.1+
Link: https://github.com/llvm/llvm-project/pull/110928 [1]
Reviewed-by: Keith Packard <keithp@keithp.com>
Tested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8094a01974cca1d27002720e706f66bec2a2d035..6aaca48955a34b2a38af1415bfa36f74f35c3f3e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -275,8 +275,8 @@ config PPC
 	select HAVE_RSEQ
 	select HAVE_SETUP_PER_CPU_AREA		if PPC64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
-	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2)
-	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13)
+	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,$(m32-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r2 -mstack-protector-guard-offset=0)
+	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,$(m64-flag) -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 -mstack-protector-guard-offset=0)
 	select HAVE_STATIC_CALL			if PPC32
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING

-- 
2.47.0

