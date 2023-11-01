Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB49134BC;
	Wed,  1 Nov 2023 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rna+fo/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8133C433C7;
	Wed,  1 Nov 2023 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698867834;
	bh=iWWsfVS+rpKy6OxoYr/8+r3ZrokHZiq9cZGVvMK8dcc=;
	h=From:Date:Subject:To:Cc:From;
	b=rna+fo/LNh/XVBYP5kckUPBwWVWrAimsosLF7qlmVIYjFi3ake97U+Jo9Oc1QC2Q6
	 nLVNAEMRRyqtV/rX/L5Er4F0YISxAYj1yvSQ6pjXau/eoQNL8v8pc0JxCPh0Dr5qr/
	 kLWEz2fxsWrzOdhQe+NCiREtXWFi60GWDmWJH3JwsPfm0HFU7vbeUEHh9aKJco0SG9
	 gZPoZxabk/81cbaXwHLZBOD3q0IphAVutG6rhE6YKmw81WMOMm44stD3B8VTsBhP+k
	 mV2YeoYTI5eb+ebxpTG4Sfco6ouUS9OyKajsHuDQczMuNu1A100bYmmMaJ3dtH1YzK
	 KejYfKEMx718g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 01 Nov 2023 12:43:29 -0700
Subject: [PATCH] LoongArch: Mark __percpu functions as always inline
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231101-loongarch-always-inline-percpu-ops-v1-1-b8f2e9a71729@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGCqQmUC/x3NwQrCMAyA4VcZORtYJqziq4iHEtMtUNqSoE7G3
 t2y43f5/x1cTMXhPuxg8lHXWjroMgCvsSyC+uqGaZyuRCNhrrUs0XjFmL/x56glaxFsYtzeWJs
 jpxCYZroFStBDzSTpdk4ez+P4AxEhNfN0AAAA
To: chenhuacai@kernel.org, kernel@xen0n.name
Cc: ndesaulniers@google.com, trix@redhat.com, jiaxun.yang@flygoat.com, 
 loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3635; i=nathan@kernel.org;
 h=from:subject:message-id; bh=iWWsfVS+rpKy6OxoYr/8+r3ZrokHZiq9cZGVvMK8dcc=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKlOqyoNpfgPu/hFLDxbyyC4P3Gvq1vzPdeko34OylULH
 cwOx2d1lLIwiHEwyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgImwaDAybBH4qWnmVuB55cik
 z+9PWeh+WHJ/d5HWzdUlQgzhtfOe8DEy9G4RDTnAMXer8K/ZMio104Ubd+5lOxnBKHYqbuV0efk
 NTAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

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

If these functions are not inlined, the BUILD_BUG() in the default case
cannot be eliminated since the compiler cannot prove it is never used,
resulting in a build failure due to the error attribute.

Mark these functions as __always_inline so that the BUILD_BUG() only
triggers when the default case genuinely cannot be eliminated due to an
unexpected size.

Cc:  <stable@vger.kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1955
Fixes: 46859ac8af52 ("LoongArch: Add multi-processor (SMP) support")
Link: https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c607313a566eebb16e
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/loongarch/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/include/asm/percpu.h
index b9f567e66016..8fb857ae962b 100644
--- a/arch/loongarch/include/asm/percpu.h
+++ b/arch/loongarch/include/asm/percpu.h
@@ -32,7 +32,7 @@ static inline void set_my_cpu_offset(unsigned long off)
 #define __my_cpu_offset __my_cpu_offset
 
 #define PERCPU_OP(op, asm_op, c_op)					\
-static inline unsigned long __percpu_##op(void *ptr,			\
+static __always_inline unsigned long __percpu_##op(void *ptr,			\
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
 

---
base-commit: 278be83601dd1725d4732241f066d528e160a39d
change-id: 20231101-loongarch-always-inline-percpu-ops-cf77c161871f

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

