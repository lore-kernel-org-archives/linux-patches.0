Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D15683;
	Fri, 21 Apr 2023 16:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1ABC4339E;
	Fri, 21 Apr 2023 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682093500;
	bh=K01BJyd9NrPkimTz2b/EJwIzah+Nwo0RWYciK9dPAaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Fmkj5pVeH3qoz8EpdebM3UziJLXLTNAuMdT/8pLs5OmOvX54CRvTGVKyOTJlBLN3/
	 /TXZAmGA+Efu3nLn6mAkVYAoECGPDVRbKgtAn4MaGc/7c6nNhqpdqrjtjVIOfe80di
	 z/gT5nGK5sjLviMw1FiGXPlxItrEYoTNISGCc93OOUAR0FaWvvBzYDn5Urttmhe/8b
	 MxkfcHXj2h3lNQS3I+WY/+mIwNfWTFygBHbsIiO4xnobBhv0zZKgogQw75RIbDe1Tb
	 JpNgeHWlda+1bCanVRGtkL+DaLB+WMYyO5FJBIxHvUj2ZGDSWX06jXwGiKQ5t4MX4L
	 be5kXdkBRt8sQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 21 Apr 2023 09:11:27 -0700
Subject: [PATCH v2 2/2] MIPS: Sink body of check_bugs_early() into its only
 call site
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-mips-check_bugs-init-attribute-v2-2-60a7ee65d4bf@kernel.org>
References: <20230419-mips-check_bugs-init-attribute-v2-0-60a7ee65d4bf@kernel.org>
In-Reply-To: <20230419-mips-check_bugs-init-attribute-v2-0-60a7ee65d4bf@kernel.org>
To: tsbogend@alpha.franken.de
Cc: ndesaulniers@google.com, linux-mips@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1706; i=nathan@kernel.org;
 h=from:subject:message-id; bh=K01BJyd9NrPkimTz2b/EJwIzah+Nwo0RWYciK9dPAaI=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDClOW3e96+H7r5GxYvqiLZbK7r6vRR+qdiWxSqUwKb1uT
 z61r0Kio5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExETYaRoXHKtRLJiyunc364
 /lqFeb8Kv9Ta7MBz1mmnvrjuZEyYH8zIsOr/uhwOHfE1Bv9Tzac4fZu+1mat9qKKR62znJq6/0w
 P5gAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

If check_bugs_early() is not inlined, which a compiler is free to do
after commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly"), modpost would warn that check_bugs_early(), a non-init
function, refers to check_bugs64_early(), which is marked __init. This
would not result in any run time issues, as check_bugs_early() is only
called from setup_arch(), which is marked __init.

To avoid this potential warning, just sink the body of
check_bugs_early() into its single call site in setup_arch().

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/include/asm/bugs.h | 6 ------
 arch/mips/kernel/setup.c     | 3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/bugs.h b/arch/mips/include/asm/bugs.h
index 047e14227c45..653f78f3a685 100644
--- a/arch/mips/include/asm/bugs.h
+++ b/arch/mips/include/asm/bugs.h
@@ -24,12 +24,6 @@ extern void check_bugs64_early(void);
 extern void check_bugs32(void);
 extern void check_bugs64(void);
 
-static inline void check_bugs_early(void)
-{
-	if (IS_ENABLED(CONFIG_CPU_R4X00_BUGS64))
-		check_bugs64_early();
-}
-
 static inline void __init check_bugs(void)
 {
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index f1c88f8a1dc5..febdc5564638 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -786,7 +786,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_early_printk();
 #endif
 	cpu_report();
-	check_bugs_early();
+	if (IS_ENABLED(CONFIG_CPU_R4X00_BUGS64))
+		check_bugs64_early();
 
 #if defined(CONFIG_VT)
 #if defined(CONFIG_VGA_CONSOLE)

-- 
2.40.0

