Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45204CB3D;
	Wed, 29 Nov 2023 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYZz+QBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD30C433C8;
	Wed, 29 Nov 2023 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701300604;
	bh=zsE7SX0g2vjeQkJDJuTcq0Y0j0eQ3wWtetQ4VKglZQk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fYZz+QBIMFmpmpYy4fFVG+7hRNcZCJ07pdSZhHJuAVWnKxV2ZuMgJOb63FbYwZ1gP
	 Lc6VPD0l2+9rH6pir8fcPq/kAiEzcOuhB899+xRoUaJthE5dUsdY4lWU/DQ2o8YdiM
	 N0XnfwkpchTb1azx2uFVALyCE7MRWR92+mxPLM6oHnENMfqaN8WGmQAKmVACmkVJAj
	 JODfwpLgNBLzShP0mSzUQgg5oBA2XfBMK3fFTcXlnU7Slm8L5jwlN5tb5vV/XNVr4M
	 2KuJfwMQ1mQcW3VBu0XIDr3oIyk/cRrKXhZi1HcNskUSdJojzl+QjJifppyosKNqUv
	 b/minoy0f/Wew==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 Nov 2023 16:29:47 -0700
Subject: [PATCH 1/2] riscv: Hoist linker relaxation disabling logic into
 Kconfig
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231129-riscv-restrict-dwarf5-llvm-v1-1-ec0d368fb538@kernel.org>
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
In-Reply-To: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1665; i=nathan@kernel.org;
 h=from:subject:message-id; bh=zsE7SX0g2vjeQkJDJuTcq0Y0j0eQ3wWtetQ4VKglZQk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnpJ6sd9f7fiWc6sav8zfStjCWH+mV8XsX9l7z3S8By3
 n7ZY05HO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEdPgYGZ4fvVg8+fTx/LPf
 l5e5r/0d92bV5S9prmucHEUmccm4uTUw/A8rr5GdfW3/TPeO7UkTXi4xdFl9auJtfSY13haNZOk
 KNVYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Certain configurations may need to be disabled if linker relaxation is
in use, such as DWARF5 with ld.lld < 18. Hoist the logic of whether or
not linker relaxation is in use into Kconfig so decisions can be made at
configuration time.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/Kconfig  | 5 +++++
 arch/riscv/Makefile | 4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 95a2a06acc6a..72be1d8122a3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -181,6 +181,11 @@ config HAVE_SHADOW_CALL_STACK
 	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
 	depends on $(ld-option,--no-relax-gp)
 
+config RISCV_USE_LINKER_RELAXATION
+	def_bool y
+	# https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
+	depends on !LD_IS_LLD || LLD_VERSION >= 150000
+
 config ARCH_MMAP_RND_BITS_MIN
 	default 18 if 64BIT
 	default 8
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index a74be78678eb..e383aa9e2757 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -43,8 +43,7 @@ else
 	KBUILD_LDFLAGS += -melf32lriscv
 endif
 
-ifeq ($(CONFIG_LD_IS_LLD),y)
-ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 150000),y)
+ifndef CONFIG_RISCV_USE_LINKER_RELAXATION
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
 ifndef CONFIG_AS_IS_LLVM
@@ -52,7 +51,6 @@ ifndef CONFIG_AS_IS_LLVM
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
 endif
-endif
 
 ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
 	KBUILD_LDFLAGS += --no-relax-gp

-- 
2.43.0

