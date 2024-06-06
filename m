Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AF21AB511;
	Thu,  6 Jun 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683254; cv=none; b=fJFHtA91hU59xyw+ZA4B4i6pfOAWUrmbezFjqAWx4Fk0913Tw7JtEKdcztyVSY/AaqXnbsHLGnS7JNjuvDHSbCGnhJmBaH3vSU+ZpJs95YMwLTQlf8tH5u4H7K1IyTOzdybPM0flcLc9qxtm2pfsOlKXQGzODqEZG51BR1ufLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683254; c=relaxed/simple;
	bh=yTsCybBN00c4f06nq5xfpLFdt2DWd3D4EcrxxGz9juc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+/CkQoNEtYxGGBhdz3oxTrotuE6w+UjdmlCX3+QL90ZLJwoV9zmrbyVsbl101sU2xsuBDu0YLhEqD/dm2EaQ9vKSqd9BYadUY2RGaRKnP0zr97P1Y375DZqDY8T/EfDqWvFetsymnJzDB0mrOhqSdoLThCJqzUvntX78F3S23A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4a2XDpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4a2XDpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC9DC2BD10;
	Thu,  6 Jun 2024 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683253;
	bh=yTsCybBN00c4f06nq5xfpLFdt2DWd3D4EcrxxGz9juc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4a2XDpTXkvJeTkdMElWErXmKkLrpTdIAJ7F+qvDH1kUMeTClwTuhgx5r+9S6mfej
	 hT3IaZDWEAT7UjRA9gbZxUnVYKdGp1KfUcxR1BugP6DVw2ZWOIxVjBMbcShOHgRWQO
	 K5UP2ltQv/R1AtelfRnyAtAsryBVlR/lyUL58lAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Fangrui Song <maskray@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/473] x86/purgatory: Switch to the position-independent small code model
Date: Thu,  6 Jun 2024 16:00:59 +0200
Message-ID: <20240606131704.229324617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit cba786af84a0f9716204e09f518ce3b7ada8555e ]

On x86, the ordinary, position dependent small and kernel code models
only support placement of the executable in 32-bit addressable memory,
due to the use of 32-bit signed immediates to generate references to
global variables. For the kernel, this implies that all global variables
must reside in the top 2 GiB of the kernel virtual address space, where
the implicit address bits 63:32 are equal to sign bit 31.

This means the kernel code model is not suitable for other bare metal
executables such as the kexec purgatory, which can be placed arbitrarily
in the physical address space, where its address may no longer be
representable as a sign extended 32-bit quantity. For this reason,
commit

  e16c2983fba0 ("x86/purgatory: Change compiler flags from -mcmodel=kernel to -mcmodel=large to fix kexec relocation errors")

switched to the large code model, which uses 64-bit immediates for all
symbol references, including function calls, in order to avoid relying
on any assumptions regarding proximity of symbols in the final
executable.

The large code model is rarely used, clunky and the least likely to
operate in a similar fashion when comparing GCC and Clang, so it is best
avoided. This is especially true now that Clang 18 has started to emit
executable code in two separate sections (.text and .ltext), which
triggers an issue in the kexec loading code at runtime.

The SUSE bugzilla fixes tag points to gcc 13 having issues with the
large model too and that perhaps the large model should simply not be
used at all.

Instead, use the position independent small code model, which makes no
assumptions about placement but only about proximity, where all
referenced symbols must be within -/+ 2 GiB, i.e., in range for a
RIP-relative reference. Use hidden visibility to suppress the use of a
GOT, which carries absolute addresses that are not covered by static ELF
relocations, and is therefore incompatible with the kexec loader's
relocation logic.

  [ bp: Massage commit message. ]

Fixes: e16c2983fba0 ("x86/purgatory: Change compiler flags from -mcmodel=kernel to -mcmodel=large to fix kexec relocation errors")
Fixes: https://bugzilla.suse.com/show_bug.cgi?id=1211853
Closes: https://github.com/ClangBuiltLinux/linux/issues/2016
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/all/20240417-x86-fix-kexec-with-llvm-18-v1-0-5383121e8fb7@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/purgatory/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index d28e0987aa85b..ebb1b786591d5 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -42,7 +42,8 @@ KCOV_INSTRUMENT := n
 # make up the standalone purgatory.ro
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
-PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss -g0
+PURGATORY_CFLAGS := -mcmodel=small -ffreestanding -fno-zero-initialized-in-bss -g0
+PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
 
-- 
2.43.0



