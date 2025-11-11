Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4F91F09B3;
	Tue, 11 Nov 2025 01:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824688; cv=none; b=EmqTV9aOvf5EHCpiW/Dr8q8cz/+3yDuIljLXK5qMHFFwI9vUZcTr2xFnrRDDcHG8vuhp3UyUenfRpZhoryVotzDj7hae1fqbKcAj6kXs9Tshqntan+Bx5R5op7ZvVYgAyFxQIezO6zcUiE6iE/LTM5G1RhHZX2alHP6Balnyo2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824688; c=relaxed/simple;
	bh=A9trkFZqlWLfSXw+t41/1k7/+VjMO8gGjuEGscMhw0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsoeQJmzjaind7g1LI+R4S8Q/apjKs5q9Z8THsd2+nA/QeEyE63JjT8aZvqSrhl79lGoHKku2pSnBF98XH4bZWW2zXKPCxjvrl7KIC1cvPK5VgfmUZxsCZZvPOa83H82sQt4hBVro8AUFFkTg7NQYyciXr5cjTlnnRAyJy4yVj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2DBd2s9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2DBd2s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F321C4CEFB;
	Tue, 11 Nov 2025 01:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824688;
	bh=A9trkFZqlWLfSXw+t41/1k7/+VjMO8gGjuEGscMhw0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2DBd2s9WFi8GBHa1/45YlCAMmkHQE4OFho3JC8PUWiYWSsN0UvuhTVQRs02Ksdqh
	 ehZNemCgpBZKo73G/DwOS+cZLxYuOtgqf7+ei3GMiWpU568Qpyh3aD5mvyIi5h3yi2
	 FtczIjgw4V8wqX/ar+qZbtfgdx+vORKE7X14upm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 6.12 498/565] x86: uaccess: dont use runtime-const rewriting in modules
Date: Tue, 11 Nov 2025 09:45:54 +0900
Message-ID: <20251111004538.141805709@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 284922f4c563aa3a8558a00f2a05722133237fe8 ]

The runtime-const infrastructure was never designed to handle the
modular case, because the constant fixup is only done at boot time for
core kernel code.

But by the time I used it for the x86-64 user space limit handling in
commit 86e6b1547b3d ("x86: fix user address masking non-canonical
speculation issue"), I had completely repressed that fact.

And it all happens to work because the only code that currently actually
gets inlined by modules is for the access_ok() limit check, where the
default constant value works even when not fixed up.  Because at least I
had intentionally made it be something that is in the non-canonical
address space region.

But it's technically very wrong, and it does mean that at least in
theory, the use of 'access_ok()' + '__get_user()' can trigger the same
speculation issue with non-canonical addresses that the original commit
was all about.

The pattern is unusual enough that this probably doesn't matter in
practice, but very wrong is still very wrong.  Also, let's fix it before
the nice optimized scoped user accessor helpers that Thomas Gleixner is
working on cause this pseudo-constant to then be more widely used.

This all came up due to an unrelated discussion with Mateusz Guzik about
using the runtime const infrastructure for names_cachep accesses too.
There the modular case was much more obviously broken, and Mateusz noted
it in his 'v2' of the patch series.

That then made me notice how broken 'access_ok()' had been in modules
all along.  Mea culpa, mea maxima culpa.

Fix it by simply not using the runtime-const code in modules, and just
using the USER_PTR_MAX variable value instead.  This is not
performance-critical like the core user accessor functions (get_user()
and friends) are.

Also make sure this doesn't get forgotten the next time somebody wants
to do runtime constant optimizations by having the x86 runtime-const.h
header file error out if included by modules.

Fixes: 86e6b1547b3d ("x86: fix user address masking non-canonical speculation issue")
Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Triggered-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/all/20251030105242.801528-1-mjguzik@gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/runtime-const.h |  4 ++++
 arch/x86/include/asm/uaccess_64.h    | 10 +++++-----
 arch/x86/kernel/cpu/common.c         |  6 +++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/runtime-const.h b/arch/x86/include/asm/runtime-const.h
index 8d983cfd06ea6..e5a13dc8816e2 100644
--- a/arch/x86/include/asm/runtime-const.h
+++ b/arch/x86/include/asm/runtime-const.h
@@ -2,6 +2,10 @@
 #ifndef _ASM_RUNTIME_CONST_H
 #define _ASM_RUNTIME_CONST_H
 
+#ifdef MODULE
+  #error "Cannot use runtime-const infrastructure from modules"
+#endif
+
 #ifdef __ASSEMBLY__
 
 .macro RUNTIME_CONST_PTR sym reg
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index c52f0133425b9..3f843369f4097 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -12,12 +12,12 @@
 #include <asm/cpufeatures.h>
 #include <asm/page.h>
 #include <asm/percpu.h>
-#include <asm/runtime-const.h>
 
-/*
- * Virtual variable: there's no actual backing store for this,
- * it can purely be used as 'runtime_const_ptr(USER_PTR_MAX)'
- */
+#ifdef MODULE
+  #define runtime_const_ptr(sym) (sym)
+#else
+  #include <asm/runtime-const.h>
+#endif
 extern unsigned long USER_PTR_MAX;
 
 #ifdef CONFIG_ADDRESS_MASKING
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bc51fccba4cb6..b54717e6fc606 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -76,6 +76,10 @@
 DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+/* Used for modules: built-in code uses runtime constants */
+unsigned long USER_PTR_MAX;
+EXPORT_SYMBOL(USER_PTR_MAX);
+
 u32 elf_hwcap2 __read_mostly;
 
 /* Number of siblings per CPU package */
@@ -2473,7 +2477,7 @@ void __init arch_cpu_finalize_init(void)
 	alternative_instructions();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
-		unsigned long USER_PTR_MAX = TASK_SIZE_MAX;
+		USER_PTR_MAX = TASK_SIZE_MAX;
 
 		/*
 		 * Enable this when LAM is gated on LASS support
-- 
2.51.0



