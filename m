Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16EC1465AB;
	Fri,  6 Dec 2024 15:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498772; cv=none; b=eODXUicLUMgFtn064+672LOqswAhmB34zxweblynzGt2eKByplfemdGUlXcjjtQ4ghKIpz+UDfOSCL/0Lr6k/Ojy4Pi0JNoc8kuV4a5eCtcfPOBdKhmKtxCppaVQJGGpkcjFSJye4DmyLu60k0P5z3vS65hM2ssn9/cJU66A4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498772; c=relaxed/simple;
	bh=le7T2cfpLPHooxLTetQGbN+niTjmoardsw8qa5wNwZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSazmtGzdvOxaGyuQ+P3M06YwkTY5TkHVyoENRbS71kDkmechWRX143VWD6TE0Ksf5d7R4X6Hy0P79xJgA0ZcgJAt+K+GuELWCVbj4VCeuhWqxIYDizrhcEYsdz4Rw1AktnkpnPxg7ASJ2uPSC4WY2s69zJJzZBz97GVqHlXi6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w74k3owv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w74k3owv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D7BC4CED1;
	Fri,  6 Dec 2024 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498772;
	bh=le7T2cfpLPHooxLTetQGbN+niTjmoardsw8qa5wNwZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w74k3owv/tVagVs4D1hg0IbMtLzV9220fgIDLt5zaYlZZ9ItJVfcMx7XV7rEcYkO3
	 KCsi2jBvcV/NrTQZCZk7v0EfLr5d8J7I9Oq5DZSxrdbZ5mkVDufgp3rEoKRwohJlQd
	 /6u2LdziiSrOGVPoCfpe9xViHNrxw/mfCOxwfiKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Packard <keithp@keithp.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 662/676] powerpc: Fix stack protector Kconfig test for clang
Date: Fri,  6 Dec 2024 15:38:01 +0100
Message-ID: <20241206143719.226477402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 46e1879deea22eed31e9425d58635895fc0e8040 upstream.

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
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241009-powerpc-fix-stackprotector-test-clang-v2-1-12fb86b31857@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -271,8 +271,8 @@ config PPC
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


