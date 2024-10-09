Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDAE2629D;
	Wed,  9 Oct 2024 19:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728501981; cv=none; b=pwkHOCyZt9ZdDTkimIyKhK5Ts1uZ19yv2ptrVUetEYBy38jgucu1Jlqkzmk0bciTvs+JUuwtE8O5g4n2Qw9Sz03Zd1TxlgQKgwBPY2bUWGL4Vx5t4sbfhJSoNuSs9BSCZZ5YNMHA+j8ECf+9Yz74Vqup+2JGQt2AvN0LDxwJgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728501981; c=relaxed/simple;
	bh=mj4tC05Afjr4W0qf5XiO9k6e8T16uFW78MQG6sHQpQY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TtD/JLXWIbsevH90pSuKhKnh/QnB0QIQX+WeZvf/znBH9Is9pkHwBV7HHMQnZz3GpPmWn7K5YLn0wYGeZ1K4Se8zpTqRJdMO9l3+oYssHUYLiynokZRe0HSFOTD5zD3W5Sr/jUBADa/z58tDRaCnEUbXW5YMa9TuWJiM7GIC7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+uUmnmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+uUmnmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B69C4AF0B;
	Wed,  9 Oct 2024 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728501979;
	bh=mj4tC05Afjr4W0qf5XiO9k6e8T16uFW78MQG6sHQpQY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t+uUmnmxQyKFIlYgKdT/7gd9p9P+vVf4557pYJH7PGvuMA4HZT4tYoCelXRWBtiPV
	 Ma8dkiV4TgVqWkh5qveUQdivE+oWm3hcPLZ5GxzZg2nJ943izEkBsq5c+cE8JEht3t
	 iU+2nWgi2Fn3AvAZ1MPiBYxr38w+tEUM3iciSTljg7+OuiIu5jikpSB1sYX/N0X+f3
	 sV5cxYMfTZ6Jxh221V+QLS/pLuGETNFU3izpHjsQS/RhcFeQ+MRQL6iL4QnNrpUV/g
	 uLd3C3EJDonD+LpxJAy5xs+dHD4gXiF+2vaDZK6TH0qI2eg720eEiehWP0OGRw4ylF
	 EZeYdipUcgR2w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 09 Oct 2024 12:26:09 -0700
Subject: [PATCH v2 2/2] powerpc: Adjust adding stack protector flags to
 KBUILD_CLAGS for clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241009-powerpc-fix-stackprotector-test-clang-v2-2-12fb86b31857@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2853; i=nathan@kernel.org;
 h=from:subject:message-id; bh=mj4tC05Afjr4W0qf5XiO9k6e8T16uFW78MQG6sHQpQY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlsN26saTolY5mtmWK72uQd3081W2El+2R99xcT/7hIW
 7pn3DvXUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACaixcjIcGr639tKLc56+6Rc
 xC6WJOd43T7wNFX5efS76ZK3Jd7M02b4p1w0cXf35f9uNZf3fTymkSP2XWy9TtCp4lMv7BXvXJ2
 4hhEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After fixing the HAVE_STACKPROTECTER checks for clang's in-progress
per-task stack protector support [1], the build fails during prepare0
because '-mstack-protector-guard-offset' has not been added to
KBUILD_CFLAGS yet but the other '-mstack-protector-guard' flags have.

  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
  clang: error: '-mstack-protector-guard=tls' is used without '-mstack-protector-guard-offset', and there is no default
  make[4]: *** [scripts/Makefile.build:229: scripts/mod/empty.o] Error 1
  make[4]: *** [scripts/Makefile.build:102: scripts/mod/devicetable-offsets.s] Error 1

Mirror other architectures and add all '-mstack-protector-guard' flags
to KBUILD_CFLAGS atomically during stack_protector_prepare, which
resolves the issue and allows clang's implementation to fully work with
the kernel.

Cc: stable@vger.kernel.org # 6.1+
Link: https://github.com/llvm/llvm-project/pull/110928 [1]
Reviewed-by: Keith Packard <keithp@keithp.com>
Tested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Makefile | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index bbfe4a1f06ef9db9b2f2e48e02096b1e0500a14b..cbb353ddacb7adc5de28cd1fde893de3efdd8272 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -100,13 +100,6 @@ KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard=tls
-ifdef CONFIG_PPC64
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r13
-else
-cflags-$(CONFIG_STACKPROTECTOR)	+= -mstack-protector-guard-reg=r2
-endif
-
 LDFLAGS_vmlinux-y := -Bstatic
 LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) := -pie
 LDFLAGS_vmlinux-$(CONFIG_RELOCATABLE) += -z notext
@@ -402,9 +395,11 @@ prepare: stack_protector_prepare
 PHONY += stack_protector_prepare
 stack_protector_prepare: prepare0
 ifdef CONFIG_PPC64
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls -mstack-protector-guard-reg=r13 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
 else
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls -mstack-protector-guard-reg=r2 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
 endif
 endif
 

-- 
2.47.0

