Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F38257E;
	Mon,  3 Oct 2022 19:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBCBC433C1;
	Mon,  3 Oct 2022 19:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664825895;
	bh=Z5uRFsHl6SPKbk0/WGTwqQLIH025+FbP7BaJo03laec=;
	h=From:To:Cc:Subject:Date:From;
	b=Ahabk80hG2D2R9f3jEm/UZHLcrRNXrBBZXdf+xFbTH6bZjGb/MXoxQkRJUWJmyryI
	 T0JWyTzP2ZAldRAEdGY+DmJ6LUPapLPOc5+fca2BY9Yzld1eI/4YtEX/AoGljmX+6I
	 cMUvj9+GT++0vGpBXH+HEJDehY33Q3RGUalTld27L35hIbOxulRxdISRb/1yxJZ0JY
	 JG3Hrmjj5ILE1/ivTOj73AUhmtx94MbAoJXfxegDX4l60eObWurL9Mb0jzX8EAEwQd
	 6kiUEz3j5rG5kTZrqhZWr9xIK0ONbcbj8gRjMKYUpmdhnLtRJqUSEqOFlTJDjzX5XH
	 bA7SET2mtPPYA==
From: Nathan Chancellor <nathan@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] arm64: alternatives: Use vdso/bits.h instead of linux/bits.h
Date: Mon,  3 Oct 2022 12:37:59 -0700
Message-Id: <20221003193759.1141709-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building with CONFIG_LTO after commit ba00c2a04fa5 ("arm64: fix the
build with binutils 2.27"), the following build error occurs:

  In file included from arch/arm64/kernel/module-plts.c:6:
  In file included from include/linux/elf.h:6:
  In file included from arch/arm64/include/asm/elf.h:8:
  In file included from arch/arm64/include/asm/hwcap.h:9:
  In file included from arch/arm64/include/asm/cpufeature.h:9:
  In file included from arch/arm64/include/asm/alternative-macros.h:5:
  In file included from include/linux/bits.h:22:
  In file included from include/linux/build_bug.h:5:
  In file included from include/linux/compiler.h:248:
  In file included from arch/arm64/include/asm/rwonce.h:71:
  include/asm-generic/rwonce.h:67:9: error: expected string literal in 'asm'
          return __READ_ONCE(*(unsigned long *)addr);
                ^
  arch/arm64/include/asm/rwonce.h:43:16: note: expanded from macro '__READ_ONCE'
                  asm volatile(__LOAD_RCPC(b, %w0, %1)                    \
                              ^
  arch/arm64/include/asm/rwonce.h:17:2: note: expanded from macro '__LOAD_RCPC'
          ALTERNATIVE(                                                    \
          ^

Similar to the issue resolved by commit 0072dc1b53c3 ("arm64: avoid
BUILD_BUG_ON() in alternative-macros"), there is a circular include
dependency through <linux/bits.h> when CONFIG_LTO is enabled due to
<asm/rwonce.h> appearing in the include chain before the contents of
<asm/alternative-macros.h>, which results in ALTERNATIVE() not getting
expanded properly because it has not been defined yet.

Avoid this issue by including <vdso/bits.h>, which includes the
definition of the BIT() macro, instead of <linux/bits.h>, as BIT() is the
only macro from bits.h that is relevant to this header.

Fixes: ba00c2a04fa5 ("arm64: fix the build with binutils 2.27")
Link: https://github.com/ClangBuiltLinux/linux/issues/1728
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm64/include/asm/alternative-macros.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index b5ac0b85c9bb..3622e9f4fb44 100644
--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -2,8 +2,8 @@
 #ifndef __ASM_ALTERNATIVE_MACROS_H
 #define __ASM_ALTERNATIVE_MACROS_H
 
-#include <linux/bits.h>
 #include <linux/const.h>
+#include <vdso/bits.h>
 
 #include <asm/cpucaps.h>
 #include <asm/insn-def.h>

base-commit: ba00c2a04fa5431d204a4183062b30372c062aa7
-- 
2.37.3

