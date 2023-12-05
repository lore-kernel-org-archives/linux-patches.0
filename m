Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8F6AC2;
	Tue,  5 Dec 2023 03:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0qa+b/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BB0C433C9;
	Tue,  5 Dec 2023 03:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746589;
	bh=GnVZ64xjuFKBeK1845AkCLgWAAYMDS6zNOEkEuruoJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0qa+b/DXXTVlLXDRYFnnHAx+07+TyrZJYkPbbSGNRwALquBN+2tNwxLa12mvqlLr
	 LbULp/veui3j60ha0/r9KYwx3LyTFK8xxv35QGKMbcoJoMmIxD+gxQHci830wGjluM
	 IvWvBIrDBBn9jR2TZJSgJiKwW7aBWHxVlBJG8z3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 058/134] parisc: Use natural CPU alignment for bug_table
Date: Tue,  5 Dec 2023 12:15:30 +0900
Message-ID: <20231205031539.203038372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit fe76a1349f235969381832c83d703bc911021eb6 upstream.

Make sure that the __bug_table section gets 32- or 64-bit aligned,
depending if a 32- or 64-bit kernel is being built.
Mark it non-writeable and use .blockz instead of the .org assembler
directive to pad the struct.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/bug.h |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/arch/parisc/include/asm/bug.h
+++ b/arch/parisc/include/asm/bug.h
@@ -28,13 +28,15 @@
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
-			     "\t.pushsection __bug_table,\"aw\"\n"	\
+			     "\t.pushsection __bug_table,\"a\"\n"	\
+			     "\t.align %4\n"				\
 			     "2:\t" ASM_WORD_INSN "1b, %c0\n"		\
-			     "\t.short %c1, %c2\n"			\
-			     "\t.org 2b+%c3\n"				\
+			     "\t.short %1, %2\n"			\
+			     "\t.blockz %3-2*%4-2*2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (0), "i" (sizeof(struct bug_entry)) ); \
+			     "i" (0), "i" (sizeof(struct bug_entry)),	\
+			     "i" (sizeof(long)) );			\
 		unreachable();						\
 	} while(0)
 
@@ -51,27 +53,31 @@
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
-			     "\t.pushsection __bug_table,\"aw\"\n"	\
+			     "\t.pushsection __bug_table,\"a\"\n"	\
+			     "\t.align %4\n"				\
 			     "2:\t" ASM_WORD_INSN "1b, %c0\n"		\
-			     "\t.short %c1, %c2\n"			\
-			     "\t.org 2b+%c3\n"				\
+			     "\t.short %1, %2\n"			\
+			     "\t.blockz %3-2*%4-2*2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
 			     "i" (BUGFLAG_WARNING|(flags)),		\
-			     "i" (sizeof(struct bug_entry)) );		\
+			     "i" (sizeof(struct bug_entry)),		\
+			     "i" (sizeof(long)) );			\
 	} while(0)
 #else
 #define __WARN_FLAGS(flags)						\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
-			     "\t.pushsection __bug_table,\"aw\"\n"	\
+			     "\t.pushsection __bug_table,\"a\"\n"	\
+			     "\t.align %2\n"				\
 			     "2:\t" ASM_WORD_INSN "1b\n"		\
-			     "\t.short %c0\n"				\
-			     "\t.org 2b+%c1\n"				\
+			     "\t.short %0\n"				\
+			     "\t.blockz %1-%2-2\n"			\
 			     "\t.popsection"				\
 			     : : "i" (BUGFLAG_WARNING|(flags)),		\
-			     "i" (sizeof(struct bug_entry)) );		\
+			     "i" (sizeof(struct bug_entry)),		\
+			     "i" (sizeof(long)) );			\
 	} while(0)
 #endif
 


