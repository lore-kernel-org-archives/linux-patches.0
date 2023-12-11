Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E4C2D0;
	Mon, 11 Dec 2023 18:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiZRqSO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F8EC433C7;
	Mon, 11 Dec 2023 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319505;
	bh=DUzAA6y4oyZ38/jmF5tm7FKtTRM+kOaizVzBmYzwDJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiZRqSO97C7uXucM3Nb4Dc/8vX1l5dqkSTwEwkfW0CRfE2meAH37jXgZKJVs2Tfyr
	 gTEJEpcsefdlgL6D0tRcI6g+iJg5njslntF6xRyLbSwOOoit0SkXXdfoE7PCJYLjKg
	 LEv2ratdcZefYnaGICw2Vdc29vFvLTNGWvYQvocM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Eric DeVolder <eric_devolder@yahoo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/244] kernel/Kconfig.kexec: drop select of KEXEC for CRASH_DUMP
Date: Mon, 11 Dec 2023 19:20:23 +0100
Message-ID: <20231211182051.638939905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Baoquan He <bhe@redhat.com>

[ Upstream commit dccf78d39f1069a5ddf4328bf0c97aa5f2f4296e ]

Ignat Korchagin complained that a potential config regression was
introduced by commit 89cde455915f ("kexec: consolidate kexec and crash
options into kernel/Kconfig.kexec").  Before the commit, CONFIG_CRASH_DUMP
has no dependency on CONFIG_KEXEC.  After the commit, CRASH_DUMP selects
KEXEC.  That enforces system to have CONFIG_KEXEC=y as long as
CONFIG_CRASH_DUMP=Y which people may not want.

In Ignat's case, he sets CONFIG_CRASH_DUMP=y, CONFIG_KEXEC_FILE=y and
CONFIG_KEXEC=n because kexec_load interface could have security issue if
kernel/initrd has no chance to be signed and verified.

CRASH_DUMP has select of KEXEC because Eric, author of above commit, met a
LKP report of build failure when posting patch of earlier version.  Please
see below link to get detail of the LKP report:

    https://lore.kernel.org/all/3e8eecd1-a277-2cfb-690e-5de2eb7b988e@oracle.com/T/#u

In fact, that LKP report is triggered because arm's <asm/kexec.h> is
wrapped in CONFIG_KEXEC ifdeffery scope.  That is wrong.  CONFIG_KEXEC
controls the enabling/disabling of kexec_load interface, but not kexec
feature.  Removing the wrongly added CONFIG_KEXEC ifdeffery scope in
<asm/kexec.h> of arm allows us to drop the select KEXEC for CRASH_DUMP.
Meanwhile, change arch/arm/kernel/Makefile to let machine_kexec.o
relocate_kernel.o depend on KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231128054457.659452-1-bhe@redhat.com
Fixes: 89cde455915f ("kexec: consolidate kexec and crash options into kernel/Kconfig.kexec")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Tested-by: Ignat Korchagin <ignat@cloudflare.com>	[compile-time only]
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/kexec.h | 4 ----
 arch/arm/kernel/Makefile     | 2 +-
 kernel/Kconfig.kexec         | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kexec.h b/arch/arm/include/asm/kexec.h
index e62832dcba760..a8287e7ab9d41 100644
--- a/arch/arm/include/asm/kexec.h
+++ b/arch/arm/include/asm/kexec.h
@@ -2,8 +2,6 @@
 #ifndef _ARM_KEXEC_H
 #define _ARM_KEXEC_H
 
-#ifdef CONFIG_KEXEC
-
 /* Maximum physical address we can use pages from */
 #define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
 /* Maximum address we can reach in physical address mode */
@@ -82,6 +80,4 @@ static inline struct page *boot_pfn_to_page(unsigned long boot_pfn)
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* CONFIG_KEXEC */
-
 #endif /* _ARM_KEXEC_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index d53f56d6f8408..771264d4726a7 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_FUNCTION_TRACER)	+= entry-ftrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o patch.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o patch.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 # Main staffs in KPROBES are in arch/arm/probes/ .
 obj-$(CONFIG_KPROBES)		+= patch.o insn.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 9bfe68fe96762..143f4d8eab7c0 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,7 +97,6 @@ config CRASH_DUMP
 	depends on ARCH_SUPPORTS_KEXEC
 	select CRASH_CORE
 	select KEXEC_CORE
-	select KEXEC
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
-- 
2.42.0



