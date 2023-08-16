Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6EF10949;
	Wed, 16 Aug 2023 17:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C38C433CA;
	Wed, 16 Aug 2023 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692207375;
	bh=m679p/qT6+EyvubNhxEO5K2mUWdE4N+P6efMLjeRxGw=;
	h=From:Date:Subject:To:Cc:From;
	b=HfNrC/VNXLU2zN7yz9ioqbbYI6MatQwhSss0CKArWGV0bLb53MhC2Kn+h63zcgnnQ
	 OaZ/LCaai2p+1nZtfOuojFokIT6y8ofycIxMPhbzOl8sm8tV/996S8V/UexSqerVZY
	 RGTXxgMANVI8jjVn0Ijlyp6FyHQ/8LzT9BBhiNvfc6byvFwkqVEBwV0Z6rwr5JMc7N
	 nqR4vYi4RIePFPxkmOjmK2e/LOvNyhKLhIfC3pKTNV7hvnKT5mxotP2LY7LAEVZT1m
	 si9DTo4nMo8DNkn3gv+8SBh2IFyyd72Z1c8ujqmVMVVIoBXgz79/oKZF7vDb75ciKF
	 xhOCoVH+zNJfA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 16 Aug 2023 10:35:43 -0700
Subject: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
X-B4-Tracking: v=1; b=H4sIAO4I3WQC/x3MSwqAMAwA0atI1haaih+8ikipNWpAqjQqgnh3i
 8u3mHlAKDIJtNkDkS4W3kIC5hn4xYWZFI/JYLQpdIOViiz+UiMN52w5TJuVfeVD6RqLskaHzht
 I8R5p4vsfd/37fgujfGNoAAAA
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 akpm@linux-foundation.org
Cc: conor@kernel.org, ndesaulniers@google.com, trix@redhat.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2086; i=nathan@kernel.org;
 h=from:subject:message-id; bh=m679p/qT6+EyvubNhxEO5K2mUWdE4N+P6efMLjeRxGw=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCl3OfkExD9F7fHcujvxoHro5+nPGv/lFzIzHs08Et660
 qvfptW3o5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzkDR/DH472fWeuhOS5cjye
 aX1hB2fRRe31btynWoT6ZoXvc+1t4GP4Z6P2VmhKnsbGngTdXzUGjAphT66kWt9Ma/Sefn3X04d
 XmAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for ARCH=riscv using LLVM < 14, there is an error with
CONFIG_DEBUG_INFO_SPLIT=y:

  error: A dwo section may not contain relocations

This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
'-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
with newer versions of LLVM:

  $ clang --target=riscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x c /dev/null
  clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxation (-mrelax)

GCC silently had a similar issue that was resolved with GCC 12.x.
Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
12.x to avoid these known issues.

Link: https://github.com/ClangBuiltLinux/linux/issues/1914
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Since this only impacts RISC-V, it seems reasonable that this would go
in via their tree but I have added Andrew in case he wants to take it.
---
 lib/Kconfig.debug | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d6798513a8c2..bd51274f4771 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
 config DEBUG_INFO_SPLIT
 	bool "Produce split debuginfo in .dwo files"
 	depends on $(cc-option,-gsplit-dwarf)
+	# RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM and GCC
+	# prior to 12.x:
+	# https://github.com/llvm/llvm-project/issues/56642
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
+	depends on !RISCV || GCC_VERSION >= 120000
 	help
 	  Generate debug info into separate .dwo files. This significantly
 	  reduces the build directory size for builds with DEBUG_INFO,

---
base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
change-id: 20230816-riscv-debug_info_split-0713571a1ac2

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

