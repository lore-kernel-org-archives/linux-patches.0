Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F62226540;
	Thu, 12 Dec 2024 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020557; cv=none; b=KKae+7WiaDe0Ry32ZWFZbWDEDoh5vwiMwNtqjFy9C5ePx8245bzeHuYCVt3QZ7M+hMAdqaUJZe92bz4d4XUWp6BZvPNPvF56rQXtscJZfmobrZ8GZSrcVBwnLnEyoOsMn7qPvitiH5laeY6pJc869omu+wQganDVe1NCXMUy3fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020557; c=relaxed/simple;
	bh=nmfyu8jEt+m3f0HDFMvTVA6G6ZmSfPuAP51XwSCj6cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkmPEVEv89DUI1BSUQ+QQ6ns6T6vGORH2wDNK5mkBWYbI9x6R1Qi5LMGJhFtZ+i/2aM41mUX21KZIFm5IVRWoSy9coeZRe58ErvesIVYXn+4B3VfL109m4lPAaO41dsrvAHSfqqBbnfBWqHzhTV4GQ264NYVLby3gKzNOv9Wx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8AAnJrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8AAnJrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BA6C4CECE;
	Thu, 12 Dec 2024 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020557;
	bh=nmfyu8jEt+m3f0HDFMvTVA6G6ZmSfPuAP51XwSCj6cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8AAnJrGO8hPC88u93bzJ5MbNTBtBxI7KQV66K+LboSad7uVenm5D+6SDbxrRcwZo
	 gWFFBLscZG8FVLL6hZIUwN9p8bnqr+mEDm3SeRMe9kBp49y3HIj2iyMn3QyivCah5s
	 j5GJyAp/UIjmH2puPLVRc4ErA4P/KdqB+GSa/bXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Packard <keithp@keithp.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 499/772] powerpc: Fix stack protector Kconfig test for clang
Date: Thu, 12 Dec 2024 15:57:24 +0100
Message-ID: <20241212144410.581807002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -253,8 +253,8 @@ config PPC
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


