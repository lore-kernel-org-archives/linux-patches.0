Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DEB748C
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A31DC433C7;
	Sun, 16 Jul 2023 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537191;
	bh=yMDW8IhSgAO9rglIFLE4uReLKt9ufgZmD6SWgslRtCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdPOt1ezifu7kJN8qZBW3d/gHFfbuJeIEWNoamENKv2BzIjhuE/0cVAcBDY4AJ8d8
	 h8O+EnYBxc/gK7MHo4S/H1wTWtc8gM+rpLEb8uHU96uVbbHTt9djayDLd2wnSQGLUo
	 25O2dd+uRiyteijd+LkiAFX9aOJLduZTQgOQGui8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.4 001/800] start_kernel: Add __no_stack_protector function attribute
Date: Sun, 16 Jul 2023 21:37:34 +0200
Message-ID: <20230716194949.144206741@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ndesaulniers@google.com <ndesaulniers@google.com>

commit 514ca14ed5444b911de59ed3381dfd195d99fe4b upstream.

Back during the discussion of
commit a9a3ed1eff36 ("x86: Fix early boot crash on gcc-10, third try")
we discussed the need for a function attribute to control the omission
of stack protectors on a per-function basis; at the time Clang had
support for no_stack_protector but GCC did not. This was fixed in
gcc-11. Now that the function attribute is available, let's start using
it.

Callers of boot_init_stack_canary need to use this function attribute
unless they're compiled with -fno-stack-protector, otherwise the canary
stored in the stack slot of the caller will differ upon the call to
boot_init_stack_canary. This will lead to a call to __stack_chk_fail()
then panic.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94722
Link: https://lore.kernel.org/all/20200316130414.GC12561@hirez.programming.kicks-ass.net/
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230412-no_stackp-v2-1-116f9fe4bbe7@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: ndesaulniers@google.com <ndesaulniers@google.com>
---
 arch/powerpc/kernel/smp.c           |    1 +
 include/linux/compiler_attributes.h |   12 ++++++++++++
 init/main.c                         |    3 ++-
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1605,6 +1605,7 @@ static void add_cpu_to_masks(int cpu)
 }
 
 /* Activate a secondary processor. */
+__no_stack_protector
 void start_secondary(void *unused)
 {
 	unsigned int cpu = raw_smp_processor_id();
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -256,6 +256,18 @@
 #define __noreturn                      __attribute__((__noreturn__))
 
 /*
+ * Optional: only supported since GCC >= 11.1, clang >= 7.0.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
+ *   clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
+ */
+#if __has_attribute(__no_stack_protector__)
+# define __no_stack_protector		__attribute__((__no_stack_protector__))
+#else
+# define __no_stack_protector
+#endif
+
+/*
  * Optional: not supported by gcc.
  *
  * clang: https://clang.llvm.org/docs/AttributeReference.html#overloadable
--- a/init/main.c
+++ b/init/main.c
@@ -877,7 +877,8 @@ static void __init print_unknown_bootopt
 	memblock_free(unknown_options, len);
 }
 
-asmlinkage __visible void __init __no_sanitize_address __noreturn start_kernel(void)
+asmlinkage __visible __init __no_sanitize_address __noreturn __no_stack_protector
+void start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;


