Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384C718452F;
	Tue, 30 Jul 2024 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356011; cv=none; b=UqhEy3YU0ztJb7tWwXTzN/KDcUUnImfQ3yLDjm9mMLIVl6Sj9RU5gtBgn35HxBJE0M9emrrHRcbUr8MYHM+kRmLFi/THq0tHJFmcAmKrdSlIKDOGgm0k76q13/cSVM5oS420Q/PnrzK7Jl7ToVk1+zbzCUfY08ApiGPv0golHrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356011; c=relaxed/simple;
	bh=nFDkpDjd2N3NGy2UBbnQtNDqSL3zZCnU/QV2b2DRa5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CieWRz6jFI17e45EFTLtNR8fWove9rK9+XJ0drrvw6YBs3v6MCBTcx9ZKmJFGZGBFret07IEgUGywb1UnPVE/gfE+/djmjOPSCFFe/euO8L2yp7aWk3BA7E/Ezjj5OlSacuAdjwx+TmxUHys615XyxGhzPPIlsPMmYAmw8qbQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm4dDAtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm4dDAtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55409C32782;
	Tue, 30 Jul 2024 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356010;
	bh=nFDkpDjd2N3NGy2UBbnQtNDqSL3zZCnU/QV2b2DRa5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm4dDAtMkkGarQjn3PH78Uq3jbwn4UK097HkIRAQGnumx9SNWIZx+PPjwwrCcSYF3
	 hcwQYL5XEjzbM/0eFHPbm5l/xCOcbIKcty23kdAVshcDQEUaGoCZ82Lhk+g6P9rX75
	 7M3Lu3teXFwmhauJQoK3R8ETo5mfKZXsXZrI1+r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/568] vmlinux.lds.h: catch .bss..L* sections into BSS")
Date: Tue, 30 Jul 2024 17:43:33 +0200
Message-ID: <20240730151644.017757845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 1a7b7326d587c9a5e8ff067e70d6aaf0333f4bb3 ]

Commit 9a427556fb8e ("vmlinux.lds.h: catch compound literals into
data and BSS") added catches for .data..L* and .rodata..L* but missed
.bss..L*

Since commit 5431fdd2c181 ("ptrace: Convert ptrace_attach() to use
lock guards") the following appears at build:

  LD      .tmp_vmlinux.kallsyms1
powerpc64-linux-ld: warning: orphan section `.bss..Lubsan_data33' from `kernel/ptrace.o' being placed in section `.bss..Lubsan_data33'
  NM      .tmp_vmlinux.kallsyms1.syms
  KSYMS   .tmp_vmlinux.kallsyms1.S
  AS      .tmp_vmlinux.kallsyms1.S
  LD      .tmp_vmlinux.kallsyms2
powerpc64-linux-ld: warning: orphan section `.bss..Lubsan_data33' from `kernel/ptrace.o' being placed in section `.bss..Lubsan_data33'
  NM      .tmp_vmlinux.kallsyms2.syms
  KSYMS   .tmp_vmlinux.kallsyms2.S
  AS      .tmp_vmlinux.kallsyms2.S
  LD      vmlinux
powerpc64-linux-ld: warning: orphan section `.bss..Lubsan_data33' from `kernel/ptrace.o' being placed in section `.bss..Lubsan_data33'

Lets add .bss..L* to BSS_MAIN macro to catch those sections into BSS.

Fixes: 9a427556fb8e ("vmlinux.lds.h: catch compound literals into data and BSS")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404031349.nmKhyuUG-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bae0fe4d499bc..63029bc7c9dd0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -101,7 +101,7 @@
 #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliteral* .data.$__unnamed_* .data.$L*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
-#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
+#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..L* .bss..compoundliteral*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
 #else
 #define TEXT_MAIN .text
-- 
2.43.0



