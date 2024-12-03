Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B11F76B5;
	Tue,  3 Dec 2024 16:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241949; cv=none; b=E0zuXzztQvXxoXH+IR+4ztxB1sNva6/ObZicv3CvRAHIwQeUEB4THoljm44JoqjsygpnXAsIhTgXOw/BuPsLPKPmH6cJJGx9Ln4TwwJH9iGtCL/kUjWxxkFsd1epMVksFFR1jmsUqip5QA5K1ZKI3V83/WxyaWxlTtBrKJ08yFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241949; c=relaxed/simple;
	bh=vfXTd2RT0WnqIL0FOq6OrbPC3y0j3M4VlKfoLaSegUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECpgYj8iJsVCQZBWb3SamkSFiG7f86Kw08vGM/0vCpo8sZmT7a8gqPkh9dS0/dcsKrUN+vAeuIKS4rFqepOQNbPc6l9pT94ox68MRkPmCT3XJi3muHRbIrW2HsFp1tJZ9hbUP+tSAiTU5Sa6M4cP+Gg2F0c8/psTwuUO/NYFkKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHb4k7/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHb4k7/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B377C4CECF;
	Tue,  3 Dec 2024 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241949;
	bh=vfXTd2RT0WnqIL0FOq6OrbPC3y0j3M4VlKfoLaSegUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHb4k7/dBMBkDt2JMQtylDAHvHV6M2Dr5QejS7rd+n3UqrzobNF6Ryzvw9ecTj4eB
	 iSqUd23A28oofkj5Fn+e4e3yno7VbcD7THnYKuEBZ+63Ikbsi7U8BPPuCjiMyYEaI/
	 1LX/e4KFrjfQ/fdlRPcA4GB/lD7+kHrVyObhpSGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 546/826] LoongArch: Fix build failure with GCC 15 (-std=gnu23)
Date: Tue,  3 Dec 2024 15:44:33 +0100
Message-ID: <20241203144805.049764788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 40c1175823d61..fdde1bcd4e266 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -19,7 +19,7 @@ ccflags-vdso := \
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



