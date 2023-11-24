Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A44639FFD;
	Fri, 24 Nov 2023 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDAXdqfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19735C433C8;
	Fri, 24 Nov 2023 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850152;
	bh=H5hzRci9Q65Evl66gFRqCZD28X7VzTE/PUgtV5/GKrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDAXdqfXdvvgqpeRjoOXvovWkCoYf98+EqLLfsEiW8alqdXaiEgPCt9Aao41D316o
	 MmTmWd2qxyeFt63dZaOSOVpic7wcTvrl8+gLfmfqPYlyx6bXiPZs23FI7r7kzrtFrf
	 R2NAr7TkATwxXF/OPHuJQ3rauXnqUiV5LCEgRs2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 466/530] LoongArch: Mark __percpu functions as always inline
Date: Fri, 24 Nov 2023 17:50:32 +0000
Message-ID: <20231124172042.258192652@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

commit 71945968d8b128c955204baa33ec03bdd91bdc26 upstream.

A recent change to the optimization pipeline in LLVM reveals some
fragility around the inlining of LoongArch's __percpu functions, which
manifests as a BUILD_BUG() failure:

  In file included from kernel/sched/build_policy.c:17:
  In file included from include/linux/sched/cputime.h:5:
  In file included from include/linux/sched/signal.h:5:
  In file included from include/linux/rculist.h:11:
  In file included from include/linux/rcupdate.h:26:
  In file included from include/linux/irqflags.h:18:
  arch/loongarch/include/asm/percpu.h:97:3: error: call to '__compiletime_assert_51' declared with 'error' attribute: BUILD_BUG failed
     97 |                 BUILD_BUG();
        |                 ^
  include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
     59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
        |                     ^
  include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^
  include/linux/compiler_types.h:425:2: note: expanded from macro 'compiletime_assert'
    425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^
  include/linux/compiler_types.h:413:2: note: expanded from macro '_compiletime_assert'
    413 |         __compiletime_assert(condition, msg, prefix, suffix)
        |         ^
  include/linux/compiler_types.h:406:4: note: expanded from macro '__compiletime_assert'
    406 |                         prefix ## suffix();                             \
        |                         ^
  <scratch space>:86:1: note: expanded from here
     86 | __compiletime_assert_51
        | ^
  1 error generated.

If these functions are not inlined (which the compiler is free to do
even with functions marked with the standard 'inline' keyword), the
BUILD_BUG() in the default case cannot be eliminated since the compiler
cannot prove it is never used, resulting in a build failure due to the
error attribute.

Mark these functions as __always_inline to guarantee inlining so that
the BUILD_BUG() only triggers when the default case genuinely cannot be
eliminated due to an unexpected size.

Cc:  <stable@vger.kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1955
Fixes: 46859ac8af52 ("LoongArch: Add multi-processor (SMP) support")
Link: https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c607313a566eebb16e
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/percpu.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/loongarch/include/asm/percpu.h
+++ b/arch/loongarch/include/asm/percpu.h
@@ -32,7 +32,7 @@ static inline void set_my_cpu_offset(uns
 #define __my_cpu_offset __my_cpu_offset
 
 #define PERCPU_OP(op, asm_op, c_op)					\
-static inline unsigned long __percpu_##op(void *ptr,			\
+static __always_inline unsigned long __percpu_##op(void *ptr,		\
 			unsigned long val, int size)			\
 {									\
 	unsigned long ret;						\
@@ -63,7 +63,7 @@ PERCPU_OP(and, and, &)
 PERCPU_OP(or, or, |)
 #undef PERCPU_OP
 
-static inline unsigned long __percpu_read(void *ptr, int size)
+static __always_inline unsigned long __percpu_read(void *ptr, int size)
 {
 	unsigned long ret;
 
@@ -100,7 +100,7 @@ static inline unsigned long __percpu_rea
 	return ret;
 }
 
-static inline void __percpu_write(void *ptr, unsigned long val, int size)
+static __always_inline void __percpu_write(void *ptr, unsigned long val, int size)
 {
 	switch (size) {
 	case 1:
@@ -132,8 +132,8 @@ static inline void __percpu_write(void *
 	}
 }
 
-static inline unsigned long __percpu_xchg(void *ptr, unsigned long val,
-						int size)
+static __always_inline unsigned long __percpu_xchg(void *ptr, unsigned long val,
+						   int size)
 {
 	switch (size) {
 	case 1:


