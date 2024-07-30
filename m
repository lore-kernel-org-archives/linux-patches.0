Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002BC1D47A8;
	Tue, 30 Jul 2024 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355268; cv=none; b=dk95Dat+8zbMok7oSisaSwIxgubKV1wDj0714VmKjhwngCBZ+rZw+zuWC9OdGOTmI81TTSGVKaehdioxsC5fC1H30Y8U1YnBTuDfxy31Kqj1RJzwVYWHeyXPkg/61neqr9iEElj0VBkjNJAWhrtbArUWXb3M/gF6HQHDBJ+MyGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355268; c=relaxed/simple;
	bh=0LLS7xzpY2ArlCQtYIFPkZ0PZ09cC/euwzuwzjhagDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaBoqXTHqWYbSYuiqEo4F1mImQZa2Gok/PBrXOgGN2q328u2PGcsIW7iku5c7xCXXkOO3VaEwIA+BdbnqzJ/xH1JxI4ptRFEJnYMDZF5RTRFoXhQFe15vUVrWGA58aGUFRkMe79txDLg3tERTzzDDHLALsmdes2TI3t+nRGPk8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IocC8/mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IocC8/mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28096C4AF0E;
	Tue, 30 Jul 2024 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355267;
	bh=0LLS7xzpY2ArlCQtYIFPkZ0PZ09cC/euwzuwzjhagDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IocC8/mmpLh57WN5wTajz87OL+sfP17xcKIA7tvxFc1cfUasOzyPMc1SiuYw1TBtW
	 fpaiWzlSXJcAnrZRTjek6QYxUxaNXvzfCzyCJknwNGNnTENtfJKYogWBEHguQdmwT6
	 m0UrtiDYr+qM6aSxyIC+xGD/OLhNUzozH7pcSpX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/440] vmlinux.lds.h: catch .bss..L* sections into BSS")
Date: Tue, 30 Jul 2024 17:45:11 +0200
Message-ID: <20240730151618.807238573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 1d1f480a5e9e4..e7539dc024981 100644
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



