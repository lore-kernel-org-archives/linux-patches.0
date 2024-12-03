Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58451F669E;
	Tue,  3 Dec 2024 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239283; cv=none; b=bp7FxOhvCejxbbF2yPqxbmMek8F9QQBAOmPpIJrLYQ1kxSZax8PitRPpoei/68+fdEsg1l4BnOSmhy2uYuMo/QivNtjbSplEPS2wyIBEXMgqN/6wqblhGwBtwOY7/hAm5uZVS91z1GipixS/QCNZ834vTLBD4RTWT+Bjv1qbyX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239283; c=relaxed/simple;
	bh=N92WNBRrbF4+bA/CHPXqi3q/2wP7qJ7ujJbRNGSnyiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCYOEkCbXrHh4HGX3NKYNGd50MnatArnWayPUai+vc31TIVm48N0VvMEU+6kTNnvDPSxs4EY62kNz+hpmZgyaRJPdnvwtBfkDDMpQptPiy94d8m4b6CsdZ2zIflaZOwIRfT8uykgqd1jejWdO+ybMPibBu2DDlemlswABHQYCIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OP9CLI7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OP9CLI7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F77C4CECF;
	Tue,  3 Dec 2024 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239282;
	bh=N92WNBRrbF4+bA/CHPXqi3q/2wP7qJ7ujJbRNGSnyiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OP9CLI7/EIzNSjAmrlgxjLDN9kll8iN4oJbq+LA5cXT4MVlRzEZPn57w3Tuo2gUZK
	 hfCjuvTbRIfA21wSpsG8TslawDTOND+tq8Fvix8j26DdLLofQiYTWbDIFblfGqByFj
	 HksV+dB0D0PFoi3CpMRUGYXRD7Vb96VPNmzbgvWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 560/817] LoongArch: Fix build failure with GCC 15 (-std=gnu23)
Date: Tue,  3 Dec 2024 15:42:12 +0100
Message-ID: <20241203144017.769527726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 947d5d036c788156f09e83e7f16322ffe8124384 ]

Whenever I try to build the kernel with upcoming GCC 15 which defaults
to -std=gnu23 I get a build failure:

  CC      arch/loongarch/vdso/vgetcpu.o
In file included from ./include/uapi/linux/posix_types.h:5,
                 from ./include/uapi/linux/types.h:14,
                 from ./include/linux/types.h:6,
                 from ./include/linux/kasan-checks.h:5,
                 from ./include/asm-generic/rwonce.h:26,
                 from ./arch/loongarch/include/generated/asm/rwonce.h:1,
                 from ./include/linux/compiler.h:317,
                 from ./include/asm-generic/bug.h:5,
                 from ./arch/loongarch/include/asm/bug.h:60,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/mm.h:6,
                 from ./arch/loongarch/include/asm/vdso.h:10,
                 from arch/loongarch/vdso/vgetcpu.c:6:
./include/linux/stddef.h:11:9: error: expected identifier before 'false'
   11 |         false   = 0,
      |         ^~~~~
./include/linux/types.h:35:33: error: two or more data types in declaration specifiers
   35 | typedef _Bool                   bool;
      |                                 ^~~~
./include/linux/types.h:35:1: warning: useless type name in empty declaration
   35 | typedef _Bool                   bool;
      | ^~~~~~~

The kernel builds explicitly with -std=gnu11 in top Makefile, but
arch/loongarch/vdso does not use KBUILD_CFLAGS from the rest of the
kernel, just add -std=gnu11 flag to arch/loongarch/vdso/Makefile.

By the way, commit e8c07082a810 ("Kbuild: move to -std=gnu11") did a
similar change for arch/arm64/kernel/vdso32/Makefile.

Fixes: c6b99bed6b8f ("LoongArch: Add VDSO and VSYSCALL support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index d724d46b07c84..3e5e30125b212 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -18,7 +18,7 @@ ccflags-vdso := \
 cflags-vdso := $(ccflags-vdso) \
 	-isystem $(shell $(CC) -print-file-name=include) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
-	-O2 -g -fno-strict-aliasing -fno-common -fno-builtin \
+	-std=gnu11 -O2 -g -fno-strict-aliasing -fno-common -fno-builtin \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \
 	$(call cc-option, -fno-asynchronous-unwind-tables) \
 	$(call cc-option, -fno-stack-protector)
-- 
2.43.0



