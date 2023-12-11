Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3561951C2D;
	Mon, 11 Dec 2023 18:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2db1py2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE668C433C7;
	Mon, 11 Dec 2023 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320744;
	bh=Gyx/WvZzF/M81o3qRD5XzzigMbt+XBTmJaV+8WrT7yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2db1py2ZybayCCkflRXKJ7jjO6PHQQune9Ld8hIYQXE9SeHOZQZRbzXXcUXW2HZg
	 m5k8QJDBs9GiyUdbxbZ4M/wAxtxTxN2E8OjO0+8zDHGyqWG1G3B7Msi9V258VTVPPj
	 RveekYrPUDIFd0QUvSHmTICXbFcinU3WANQfBOlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/194] parisc: Reduce size of the bug_table on 64-bit kernel by half
Date: Mon, 11 Dec 2023 19:22:16 +0100
Message-ID: <20231211182043.142178626@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 43266838515d30dc0c45d5c7e6e7edacee6cce92 ]

Enable GENERIC_BUG_RELATIVE_POINTERS which will store 32-bit relative
offsets to the bug address and the source file name instead of 64-bit
absolute addresses. This effectively reduces the size of the
bug_table[] array by half on 64-bit kernels.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 487635756198 ("parisc: Fix asm operand number out of range build error in bug table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/Kconfig           |  7 +++++--
 arch/parisc/include/asm/bug.h | 34 +++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 67c26e81e2150..345d5e021484c 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -105,9 +105,12 @@ config ARCH_HAS_ILOG2_U64
 	default n
 
 config GENERIC_BUG
-	bool
-	default y
+	def_bool y
 	depends on BUG
+	select GENERIC_BUG_RELATIVE_POINTERS if 64BIT
+
+config GENERIC_BUG_RELATIVE_POINTERS
+	bool
 
 config GENERIC_HWEIGHT
 	bool
diff --git a/arch/parisc/include/asm/bug.h b/arch/parisc/include/asm/bug.h
index b9cad0bb4461b..1641ff9a8b83e 100644
--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -17,26 +17,27 @@
 #define	PARISC_BUG_BREAK_ASM	"break 0x1f, 0x1fff"
 #define	PARISC_BUG_BREAK_INSN	0x03ffe01f  /* PARISC_BUG_BREAK_ASM */
 
-#if defined(CONFIG_64BIT)
-#define ASM_WORD_INSN		".dword\t"
+#ifdef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
+# define __BUG_REL(val) ".word " __stringify(val) " - ."
 #else
-#define ASM_WORD_INSN		".word\t"
+# define __BUG_REL(val) ".word " __stringify(val)
 #endif
 
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 #define BUG()								\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
 			     "\t.pushsection __bug_table,\"a\"\n"	\
-			     "\t.align %4\n"				\
-			     "2:\t" ASM_WORD_INSN "1b, %c0\n"		\
+			     "\t.align 4\n"				\
+			     "2:\t" __BUG_REL(1b) "\n"			\
+			     "\t" __BUG_REL(%c0)  "\n"			\
 			     "\t.short %1, %2\n"			\
-			     "\t.blockz %3-2*%4-2*2\n"			\
+			     "\t.blockz %3-2*4-2*2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (0), "i" (sizeof(struct bug_entry)),	\
-			     "i" (sizeof(long)) );			\
+			     "i" (0), "i" (sizeof(struct bug_entry)) );	\
 		unreachable();						\
 	} while(0)
 
@@ -54,15 +55,15 @@
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
 			     "\t.pushsection __bug_table,\"a\"\n"	\
-			     "\t.align %4\n"				\
-			     "2:\t" ASM_WORD_INSN "1b, %c0\n"		\
+			     "\t.align 4\n"				\
+			     "2:\t" __BUG_REL(1b) "\n"			\
+			     "\t" __BUG_REL(%c0)  "\n"			\
 			     "\t.short %1, %2\n"			\
-			     "\t.blockz %3-2*%4-2*2\n"			\
+			     "\t.blockz %3-2*4-2*2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
 			     "i" (BUGFLAG_WARNING|(flags)),		\
-			     "i" (sizeof(struct bug_entry)),		\
-			     "i" (sizeof(long)) );			\
+			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #else
 #define __WARN_FLAGS(flags)						\
@@ -71,13 +72,12 @@
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
 			     "\t.pushsection __bug_table,\"a\"\n"	\
 			     "\t.align %2\n"				\
-			     "2:\t" ASM_WORD_INSN "1b\n"		\
+			     "2:\t" __BUG_REL(1b) "\n"			\
 			     "\t.short %0\n"				\
-			     "\t.blockz %1-%2-2\n"			\
+			     "\t.blockz %1-4-2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (BUGFLAG_WARNING|(flags)),		\
-			     "i" (sizeof(struct bug_entry)),		\
-			     "i" (sizeof(long)) );			\
+			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #endif
 
-- 
2.42.0



