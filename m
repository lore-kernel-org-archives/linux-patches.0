Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857DC8833
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F99C433C8;
	Sun, 16 Jul 2023 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540428;
	bh=1bI9VTkb064C9miAHigDSoX5dmCr6mkoMBRm9f4279A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uef7UscPt76LBKzADKaytT9F42ntWO2+E0OVhQGWYacJddEoHID0AaOQlqhVBHLWk
	 edrky77guGkv9FPF44svG2fDKHAewvyjtrxGJjvPGTBMCaYqdeuTMoS6FRcNZzpnEA
	 gOfp9W+PBvCI8O6j6+4gOFsgWBNRGXD+qqyLWvr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/591] ARC: define ASM_NL and __ALIGN(_STR) outside #ifdef __ASSEMBLY__ guard
Date: Sun, 16 Jul 2023 21:48:01 +0200
Message-ID: <20230716194932.757549128@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 92e2921eeafdfca9acd9b83f07d2b7ca099bac24 ]

ASM_NL is useful not only in *.S files but also in .c files for using
inline assembler in C code.

On ARC, however, ASM_NL is evaluated inconsistently. It is expanded to
a backquote (`) in *.S files, but a semicolon (;) in *.c files because
arch/arc/include/asm/linkage.h defines it inside #ifdef __ASSEMBLY__,
so the definition for C code falls back to the default value defined in
include/linux/linkage.h.

If ASM_NL is used in inline assembler in .c files, it will result in
wrong assembly code because a semicolon is not an instruction separator,
but the start of a comment for ARC.

Move ASM_NL (also __ALIGN and __ALIGN_STR) out of the #ifdef.

Fixes: 9df62f054406 ("arch: use ASM_NL instead of ';' for assembler new line character in the macro")
Fixes: 8d92e992a785 ("ARC: define __ALIGN_STR and __ALIGN symbols for ARC")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/linkage.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
index c9434ff3aa4ce..8a3fb71e9cfad 100644
--- a/arch/arc/include/asm/linkage.h
+++ b/arch/arc/include/asm/linkage.h
@@ -8,6 +8,10 @@
 
 #include <asm/dwarf.h>
 
+#define ASM_NL		 `	/* use '`' to mark new line in macro */
+#define __ALIGN		.align 4
+#define __ALIGN_STR	__stringify(__ALIGN)
+
 #ifdef __ASSEMBLY__
 
 .macro ST2 e, o, off
@@ -28,10 +32,6 @@
 #endif
 .endm
 
-#define ASM_NL		 `	/* use '`' to mark new line in macro */
-#define __ALIGN		.align 4
-#define __ALIGN_STR	__stringify(__ALIGN)
-
 /* annotation for data we want in DCCM - if enabled in .config */
 .macro ARCFP_DATA nm
 #ifdef CONFIG_ARC_HAS_DCCM
-- 
2.39.2



