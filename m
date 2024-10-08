Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DCE3C0C;
	Tue,  8 Oct 2024 04:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728361355; cv=none; b=ZwL8Rjk/ptJ3jJYtaQHbqKPFyYuQNmB2s3eLNHmoBpUXL6H25RwrQyCAj3DAQQ5AP9QtmEo78x8LL9NFB5FbvdFpipalfaWCderWc9NPXPheF0cOKAj4csb7fF3aLk3LMV79D4R+D5dHHPBETwnhsz7ysykaSWiFtMCQuNprUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728361355; c=relaxed/simple;
	bh=CQpN5id32lq/DGrce8Pbuy5QP+ZsBWS9RkPNDANX6pw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vGmyRPlvWYDgeDt+YqKKroY3r0ceIVWDJvy6B3klly9QVSYq8heV1QdTVEmxe8v9ob+H1doTJ+eWB61ermWRPL3+QNlS8lEj22kBz4wu5+myBileeucsbWwUHYk2P5beMiMPM1u2eju6TPSlFqxlYKtLPWG2S30Vdiro6vGhOSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fgj7pJKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fgj7pJKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BF8C4CED1;
	Tue,  8 Oct 2024 04:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728361354;
	bh=CQpN5id32lq/DGrce8Pbuy5QP+ZsBWS9RkPNDANX6pw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Fgj7pJKtimCDmlvDt49Vq++mtqYmEG0QETyNzqgwVWrlPznHZLVLNcewsCCjigoAQ
	 i2o1nlN7ZmN/do38C9SVxcErFNEYE6IIFFCLvP5bkjkpINwHiAQJtzs2TUCqcsjgfs
	 me9TBp291n1J6pVoCvqcT/SY0evtCjeLWSDVgZIpg4ay3jg3T3T5Qhqp48716Vjk3W
	 WonNEeVsdbW5i/JsiuDtOn4SuC6hinbvDvRsEwV4EE9Rg94awK6OyK3sYhis/bi5Wl
	 mkvAIvvPOV/bCHnLCstiawrOb4iCV7JsHwPuL8RinrtKWqFH9/ddVOdw0d0nkN6wfY
	 rNgoVftm09B6w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 07 Oct 2024 21:22:04 -0700
Subject: [PATCH 2/3] powerpc: Adjust adding stack protector flags to
 KBUILD_CLAGS for clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-powerpc-fix-stackprotector-test-clang-v1-2-08c15b2694e4@kernel.org>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Keith Packard <keithp@keithp.com>, linuxppc-dev@lists.ozlabs.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2742; i=nathan@kernel.org;
 h=from:subject:message-id; bh=CQpN5id32lq/DGrce8Pbuy5QP+ZsBWS9RkPNDANX6pw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOksm9tfNopN8Alwn7wrreFtwtNGlX+XM+K/cOQn+vrbf
 lAvDb3ZUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACayO5Hhn4bRwTNsT95yL/A1
 mTj3sNDLlOkRln/F++1OaVWFvt7zXp+RYdti9qpJ9xZLLNPsX7kqMn9LQ9oPLfYPZm9ChPom1Mg
 nsgAA
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

Link: https://github.com/llvm/llvm-project/pull/110928 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/Makefile | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index bbfe4a1f06ef9db9b2f2e48e02096b1e0500a14b..8f9e387c4c7dd06d8756dca3eac808cc344a937d 100644
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
@@ -402,9 +395,13 @@ prepare: stack_protector_prepare
 PHONY += stack_protector_prepare
 stack_protector_prepare: prepare0
 ifdef CONFIG_PPC64
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls \
+				-mstack-protector-guard-reg=r13 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "PACA_CANARY") print $$3;}' include/generated/asm-offsets.h))
 else
-	$(eval KBUILD_CFLAGS += -mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
+	$(eval KBUILD_CFLAGS += -mstack-protector-guard=tls \
+				-mstack-protector-guard-reg=r2 \
+				-mstack-protector-guard-offset=$(shell awk '{if ($$2 == "TASK_CANARY") print $$3;}' include/generated/asm-offsets.h))
 endif
 endif
 

-- 
2.47.0

