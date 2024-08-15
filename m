Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956C18D627;
	Thu, 15 Aug 2024 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729257; cv=none; b=ff9DW0zyyMuhjrh1Cn/hzOrhcm577BfV0H10RiJ8N33yFqzL0UP6sJkRYMQddfwfWqGHn8wFiphp5GIX9M8AHI0iOMnzbSXk2uyNLpmCl6HemLTzaFuOxHQoZyyfFfoSSIIqxUP6ygKlHakUX5I3dHj4yOaxivRJWf9JFaJcvtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729257; c=relaxed/simple;
	bh=hZ7T9b1DLCSLaMkbYFjqXhfGFEu3SbNI4tMiEBNKyfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwWcGzUKpdveJ8pTdALZbB0V0zAi2KMzk7CwllRmFI7rFAaOockkqpUkPWfn3qjmk3Org592EH+4aG1QkMftNsIOS0+jKw5LO2gcoczMegAVPLVHJUXJpKibCGvsESsa/9QSeTvOv90hlqQIWVbawcf3kLzai9akJkfT1a1Ajlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEfTirL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEfTirL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E254C32786;
	Thu, 15 Aug 2024 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729256;
	bh=hZ7T9b1DLCSLaMkbYFjqXhfGFEu3SbNI4tMiEBNKyfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEfTirL8SHJiCP3hpu02n66A0gh25B1pZZeAsBlC2hj0wazg52NPxWDp7eXFhMUyr
	 +vhIVjwopipC41BKG0tqPkmz/Md565MgmO5Ze9TrhTth+dgucwIThEJ5IAoDx8eh2l
	 TwHa3g5d/yEUPT0uRk2O0tyPr2dmWhHWX6y/zJ2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/484] vmlinux.lds.h: catch .bss..L* sections into BSS")
Date: Thu, 15 Aug 2024 15:18:19 +0200
Message-ID: <20240815131942.867872448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd9ea351bc02e..4132a76a3e2e4 100644
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



