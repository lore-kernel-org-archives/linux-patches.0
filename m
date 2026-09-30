Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1050C50B433;
	Wed, 30 Sep 2026 16:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786258; cv=none; b=HXgXC0zTCNcQogegbtHGG2dM5Tdbt9qsGsg+Rx0MTd6dZ14EytHsfpwO/HXW2Oj6Ipqu0Xpuh3TGh5ZperGO73EtAffwOL69qKpDdhphgSJdip3KbARyltxgvMtFMeQozdj28MpoEAkfjdoOcZWwO71ZCXZdbvRCx5OnJZst7rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786258; c=relaxed/simple;
	bh=NnKZ/wOH7uBdCbcAeZAJwdthQKTP+blunBhXHqy9rMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QF5mdPOxSTPYXYJuuCWUHu5eT0svw+L/aPcXsU6sG49J5dt8ow6SJ2mNYH1VokOJcsMLK3QUkIp08hqiBUwpvCBDNwfiEhYze3GqGu+OwsEqUxzwQYeuYaALyzYuMwvBkwb2QEl7NV48218fcvhOhstaXCdB0VG9wEY9rgZBbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MchIvF0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MchIvF0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFB71F000FF;
	Wed, 30 Sep 2026 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786257;
	bh=vEBOzGwK0CQORC++ZnveIzZGDyLi2cHpU0qA3CtRe4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MchIvF0RwZunKFrLZLWNR/KRG3tNwKUi0Xdk1WBQX7gUmhp5SD+Th+2s8ZUCCIoTA
	 6yaRSE0itBGYuEydXvXdPkDt7lApqLIQebKYpB6vBXV6MRn4TgAjRn4mHK8eubnjDY
	 qH6KLa5nHcfDJ6Qc3U8mbo3NP0v7pxvPSNTLgEeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 799/982] start_kernel: Add __no_stack_protector function attribute
Date: Wed, 30 Sep 2026 17:25:35 +0200
Message-ID: <20260930152433.917443719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: ndesaulniers@google.com <ndesaulniers@google.com>

[ Upstream commit 514ca14ed5444b911de59ed3381dfd195d99fe4b ]

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

Signed-off-by: ndesaulniers@google.com <ndesaulniers@google.com>

[ Backport to 6.1.y: retain this tree's start_kernel() signature, which
  predates its upstream __noreturn annotation, and add
  __no_stack_protector. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c           |  1 +
 include/linux/compiler_attributes.h | 12 ++++++++++++
 init/main.c                         |  3 ++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 980f2bc832d98..fa17fdcc55a3d 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1608,6 +1608,7 @@ static void add_cpu_to_masks(int cpu)
 }
 
 /* Activate a secondary processor. */
+__no_stack_protector
 void start_secondary(void *unused)
 {
 	unsigned int cpu = raw_smp_processor_id();
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index ab1fe28162b5e..b9778e13b0a08 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -277,6 +277,18 @@
  */
 #define __noreturn                      __attribute__((__noreturn__))
 
+/*
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
 /*
  * Optional: not supported by gcc.
  * Optional: not supported by icc.
diff --git a/init/main.c b/init/main.c
index 50b84f1f9ff38..6acfd5a78bd7a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -908,7 +908,8 @@ static void __init print_unknown_bootoptions(void)
 	memblock_free(unknown_options, len);
 }
 
-asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
+asmlinkage __visible __init __no_sanitize_address __no_stack_protector
+void start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;
-- 
2.53.0



