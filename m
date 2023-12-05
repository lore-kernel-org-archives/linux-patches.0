Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DDD41220;
	Tue,  5 Dec 2023 23:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEZz+mee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF2C433CB;
	Tue,  5 Dec 2023 23:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701820440;
	bh=TkH9rrJU+gOQ6DZ9Djq7O32daD6bFD+fz9RSUAZrNm0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JEZz+meehPGefxwsXQFCanCu2FwqpSVitp2XhhtQRG+aYTEa7aTpulJXmkePFgs1M
	 IDyxDy/xA9P/xW9CNW71LolbjbVZ03hrHFus2lDLKj1Nf9uFRJOSeOWcvkfSAiRIwW
	 TBYtdko3Anj47SUCkJucFLXXqejnGJvRVIItTosY7YYofPT1mckiDF6mznOJ5v9Lf/
	 3TGugEotvQVvpNS0ktKbJIrECIjyUZFPeDDmmAZ5RblNAKeHkSSzuah4iIftMh1YvD
	 nXo+GaNYWQJTFRyrHrFT7FmQPuPEHcnIMv004RXJcL5q1tmK5XOSjCNRlcXhI0Jj/3
	 EQy2Zwx1MgtNg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Dec 2023 16:53:50 -0700
Subject: [PATCH v2 1/3] riscv: Hoist linker relaxation disabling logic into
 Kconfig
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231205-riscv-restrict-dwarf5-llvm-v2-1-aedf00a382ac@kernel.org>
References: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1713; i=nathan@kernel.org;
 h=from:subject:message-id; bh=TkH9rrJU+gOQ6DZ9Djq7O32daD6bFD+fz9RSUAZrNm0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5O8RC9Iu1FtvquTzJc+OevOzWqcKG/5vfa+2zZT89W
 aK6zKyho5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExkZREjw+dZq96YVt3+kjHF
 M5btqvdEFSm1Fu0L/yZ4cOVwqBwyMmFk2FU175DqT0+vk/oHrwfKq0VKhXjcUXLeeXTa9JzGuWW
 SzAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Certain configurations may need to be disabled if linker relaxation is
in use, such as DWARF5 with ld.lld < 18. Hoist the logic of whether or
not linker relaxation is in use into Kconfig so decisions can be made at
configuration time.

Reviewed-by: Fangrui Song <maskray@google.com>
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

