Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6C3A59A3;
	Thu,  2 Jul 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010862; cv=none; b=Qs11gOsiB+gSkESyP/gg3YVRo6W5PTe85qnNYDoSQiKtZR/Ez/5vQzDqHEAzIKjvSyk0BvETIZL4MLIRq5Hm7Rt5Qc1YQtB3IPYLN6Wk6e6aJ20eQpj6hw252mWEIZFs1PPx+pAxk6p+GrLOiSm6PJsE0+lp9kRMrIMUNVJ+cVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010862; c=relaxed/simple;
	bh=GvywutXAupahoYgPnGZ1pMmPoh3tjXyA9vgdRbcanPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp15W/R5MKJ9+Huxe9NWe0vDRQvX7HcIFPDl03sW2UHdzBjnxIClIbcCXnQtt9/bsvahWHcTjUfqL/u553PzatMLw/OrvkshWQu7ppG9J70UYk2uOAQVW0yLn71h3tJlOxuTlIYjfemdoOwJmFokYsBb0y5nJFZSaA/sgUy68PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FAV6Mqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FAV6Mqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B701F000E9;
	Thu,  2 Jul 2026 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010861;
	bh=z+xmveiCxvPMr5kA1UNUK6DWf9DK+vvjoATufpk28kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FAV6Mqfc40Nd+/MM50kWOeTN4XIV7MwQ3mbqCbDTTEjiQ4WDFEsfiKMyqk8UyjYY
	 5ePl91IVI+evzEQATV7fNSgU/0nCKOjpP/35RKbFiuMWUIklZog85xmCW6mHOBIK1m
	 DwD2lNqa1nS+io0QU8JUwzN4YO6hteYt4vcTQgYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bpf <bpf@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 048/175] scripts/sorttable: Make compare_extable() into two functions
Date: Thu,  2 Jul 2026 18:19:09 +0200
Message-ID: <20260702155116.809305994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 7ffc0d0819f438779ed592e2e2e3576f43ce14f0 ]

Instead of having the compare_extable() part of the sorttable.h header
where it get's defined twice, since it is a very simple function, just
define it twice in sorttable.c, and then it can use the proper read
functions for the word size and endianess and the Elf_Addr macro can be
removed from sorttable.h.

Also add a micro optimization. Instead of:

    if (a < b)
        return -1;
    if (a > b)
        return 1;
    return 0;

That can be shorten to:

   if (a < b)
      return -1;
   return a > b;

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin  Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/20250105162344.945299671@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |   20 ++++++++++++++++++++
 scripts/sorttable.h |   14 --------------
 2 files changed, 20 insertions(+), 14 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -173,6 +173,26 @@ static inline unsigned int get_secindex(
 	return r(&symtab_shndx_start[sym_offs]);
 }
 
+static int compare_extable_32(const void *a, const void *b)
+{
+	Elf32_Addr av = r(a);
+	Elf32_Addr bv = r(b);
+
+	if (av < bv)
+		return -1;
+	return av > bv;
+}
+
+static int compare_extable_64(const void *a, const void *b)
+{
+	Elf64_Addr av = r8(a);
+	Elf64_Addr bv = r8(b);
+
+	if (av < bv)
+		return -1;
+	return av > bv;
+}
+
 /* 32 bit and 64 bit are very similar */
 #include "sorttable.h"
 #define SORTTABLE_64
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -23,7 +23,6 @@
 #undef sort_mcount_loc
 #undef elf_mcount_loc
 #undef do_sort
-#undef Elf_Addr
 #undef Elf_Ehdr
 #undef Elf_Shdr
 #undef Elf_Sym
@@ -38,7 +37,6 @@
 # define sort_mcount_loc	sort_mcount_loc_64
 # define elf_mcount_loc		elf_mcount_loc_64
 # define do_sort		do_sort_64
-# define Elf_Addr		Elf64_Addr
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
 # define Elf_Sym		Elf64_Sym
@@ -52,7 +50,6 @@
 # define sort_mcount_loc	sort_mcount_loc_32
 # define elf_mcount_loc		elf_mcount_loc_32
 # define do_sort		do_sort_32
-# define Elf_Addr		Elf32_Addr
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
 # define Elf_Sym		Elf32_Sym
@@ -160,17 +157,6 @@ static void *sort_orctable(void *arg)
 }
 #endif
 
-static int compare_extable(const void *a, const void *b)
-{
-	Elf_Addr av = _r(a);
-	Elf_Addr bv = _r(b);
-
-	if (av < bv)
-		return -1;
-	if (av > bv)
-		return 1;
-	return 0;
-}
 #ifdef MCOUNT_SORT_ENABLED
 pthread_t mcount_sort_thread;
 


