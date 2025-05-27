Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718F27E1CA;
	Tue, 27 May 2025 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366242; cv=none; b=cI6UWLfkyBTPF/KIZYduI7hoO90mNT69XDD/K7PHIQAtOlFaRyeLCngidXywTREIKl1uaoJVKh4SwM1bH3tu9b/zJKuE6zpsMJHy3vfq9Xo154EM5dRNJS1T6Zms/7ItHvMRKT+beADUpWqzPXhltDXhqdYNTIELuVWAjcKh63Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366242; c=relaxed/simple;
	bh=KlihN481lCfpGSHcOEd/CK968mPa/+3dLTFpAS9MvbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVPRNQafAYNFd4+j0/SyeVzF2k6Fug0gnaV0Fmk4HKhfru47Fgc8uQww2Dxw81Nu8w2JJwXeGwopb3FI5Nu0uYRLUXdeAnU/7sgc8Cdm6+GYbTnXj/2b+YCL4sGCwBrnPznBZMQAB+BOYmmP6GhHh/AUs56HmD8CyxwGjWpMFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIM2pduw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIM2pduw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77AAC4CEE9;
	Tue, 27 May 2025 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366241;
	bh=KlihN481lCfpGSHcOEd/CK968mPa/+3dLTFpAS9MvbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIM2pduwF+wTv6sns5/dKWmcyOd1/JIedwmo5jD8iWPAZW3ECzjCXyeMCZuqU+C1f
	 PAtvKsLrvS2TdbS/anqHoVBRYVeYTXqKT7ABeVtDKeK6TtNh48eVbjN8+85HyACnJ/
	 NB5JDq0Fo7dGOVmQg5icQmvVGFjyj44EefJXjtro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.12 616/626] Fix mis-uses of cc-option for warning disablement
Date: Tue, 27 May 2025 18:28:29 +0200
Message-ID: <20250527162510.027185527@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a79be02bba5c31f967885c7f3bf3a756d77d11d9 upstream.

This was triggered by one of my mis-uses causing odd build warnings on
sparc in linux-next, but while figuring out why the "obviously correct"
use of cc-option caused such odd breakage, I found eight other cases of
the same thing in the tree.

The root cause is that 'cc-option' doesn't work for checking negative
warning options (ie things like '-Wno-stringop-overflow') because gcc
will silently accept options it doesn't recognize, and so 'cc-option'
ends up thinking they are perfectly fine.

And it all works, until you have a situation where _another_ warning is
emitted.  At that point the compiler will go "Hmm, maybe the user
intended to disable this warning but used that wrong option that I
didn't recognize", and generate a warning for the unrecognized negative
option.

Which explains why we have several cases of this in the tree: the
'cc-option' test really doesn't work for this situation, but most of the
time it simply doesn't matter that ity doesn't work.

The reason my recently added case caused problems on sparc was pointed
out by Thomas Weißschuh: the sparc build had a previous explicit warning
that then triggered the new one.

I think the best fix for this would be to make 'cc-option' a bit smarter
about this sitation, possibly by adding an intentional warning to the
test case that then triggers the unrecognized option warning reliably.

But the short-term fix is to replace 'cc-option' with an existing helper
designed for this exact case: 'cc-disable-warning', which picks the
negative warning but uses the positive form for testing the compiler
support.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/all/20250422204718.0b4e3f81@canb.auug.org.au/
Explained-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                       |    4 ++--
 arch/loongarch/kernel/Makefile |    8 ++++----
 arch/loongarch/kvm/Makefile    |    2 +-
 arch/riscv/kernel/Makefile     |    4 ++--
 scripts/Makefile.extrawarn     |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -998,11 +998,11 @@ NOSTDINC_FLAGS += -nostdinc
 KBUILD_CFLAGS += $(call cc-option, -fstrict-flex-arrays=3)
 
 #Currently, disable -Wstringop-overflow for GCC 11, globally.
-KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-option, -Wno-stringop-overflow)
+KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-disable-warning, stringop-overflow)
 KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
 
 #Currently, disable -Wunterminated-string-initialization as broken
-KBUILD_CFLAGS += $(call cc-option, -Wno-unterminated-string-initialization)
+KBUILD_CFLAGS += $(call cc-disable-warning, unterminated-string-initialization)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -21,10 +21,10 @@ obj-$(CONFIG_CPU_HAS_LBT)	+= lbt.o
 
 obj-$(CONFIG_ARCH_STRICT_ALIGN)	+= unaligned.o
 
-CFLAGS_module.o		+= $(call cc-option,-Wno-override-init,)
-CFLAGS_syscall.o	+= $(call cc-option,-Wno-override-init,)
-CFLAGS_traps.o		+= $(call cc-option,-Wno-override-init,)
-CFLAGS_perf_event.o	+= $(call cc-option,-Wno-override-init,)
+CFLAGS_module.o		+= $(call cc-disable-warning, override-init)
+CFLAGS_syscall.o	+= $(call cc-disable-warning, override-init)
+CFLAGS_traps.o		+= $(call cc-disable-warning, override-init)
+CFLAGS_perf_event.o	+= $(call cc-disable-warning, override-init)
 
 ifdef CONFIG_FUNCTION_TRACER
   ifndef CONFIG_DYNAMIC_FTRACE
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,4 +19,4 @@ kvm-y += tlb.o
 kvm-y += vcpu.o
 kvm-y += vm.o
 
-CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
+CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -9,8 +9,8 @@ CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRAC
 CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
 endif
-CFLAGS_syscall_table.o	+= $(call cc-option,-Wno-override-init,)
-CFLAGS_compat_syscall_table.o += $(call cc-option,-Wno-override-init,)
+CFLAGS_syscall_table.o	+= $(call cc-disable-warning, override-init)
+CFLAGS_compat_syscall_table.o += $(call cc-disable-warning, override-init)
 
 ifdef CONFIG_KEXEC_CORE
 AFLAGS_kexec_relocate.o := -mcmodel=medany $(call cc-option,-mno-relax)
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -15,7 +15,7 @@ KBUILD_CFLAGS += -Werror=return-type
 KBUILD_CFLAGS += -Werror=strict-prototypes
 KBUILD_CFLAGS += -Wno-format-security
 KBUILD_CFLAGS += -Wno-trigraphs
-KBUILD_CFLAGS += $(call cc-disable-warning,frame-address,)
+KBUILD_CFLAGS += $(call cc-disable-warning, frame-address)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS += -Wmissing-declarations
 KBUILD_CFLAGS += -Wmissing-prototypes


