Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140CD14F9F4;
	Fri,  6 Dec 2024 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498505; cv=none; b=iDFmgBDoGeRPwi+UlvEnCf9FlioJrjVwsHPYPyViWt6I4ybI76hXdCG9+YimAnczVOMCNH64IqruHeJI4nBM9IQbFfuW4aazcVjXyzj1LmChX29AjK7JUGMDmXLHfybrhBxzaE8/TTDjjOSC6kD/TrjPobuL1DOAyPrIpe1P9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498505; c=relaxed/simple;
	bh=moQWHEdNr/Ik9oX4MHhPwqzeQRrrbIznkYlhzxRAfYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnoOEgqg6mFiKJ7DXoytrZFo9U2XO1/Nv8/Qjye6nENaToGzzNYsEpmX/d91GDcop6BAqWzsGoSdECGwF0auxjnK9Ki04IEetoikMInlOwTQIUpXge9veY2jQrpdk7xD1epxOXesH520qDuj58pQRKfSgipJYyl/HeTltk3ZlM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAMnA/Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAMnA/Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E4C4CED1;
	Fri,  6 Dec 2024 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498504;
	bh=moQWHEdNr/Ik9oX4MHhPwqzeQRrrbIznkYlhzxRAfYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAMnA/NleqTSasMOf33LsZFidq2Jfm85Z76r38ZEJXJPi+KOY2sHY+yNyj1QScQ5t
	 amHUScF317oCruIQUn2Zfi2JZrpZxjwFoQxQyc2iXOC9nNOiXmGeyj4z4xq8xCEzZr
	 n3xXk4qOl7kr3922FPf6op6H2lDf0VhnogfzFK8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 587/676] init/modpost: conditionally check section mismatch to __meminit*
Date: Fri,  6 Dec 2024 15:36:46 +0100
Message-ID: <20241206143716.299396274@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 73db3abdca58c8a014ec4c88cf5ef925cbf63669 ]

This reverts commit eb8f689046b8 ("Use separate sections for __dev/
_cpu/__mem code/data").

Check section mismatch to __meminit* only when CONFIG_MEMORY_HOTPLUG=n.

With this change, the linker script and modpost become simpler, and we
can get rid of the __ref annotations from the memory hotplug code.

[sfr@canb.auug.org.au: remove MEM_KEEP from arch/powerpc/kernel/vmlinux.lds.S]
  Link: https://lkml.kernel.org/r/20240710093213.2aefb25f@canb.auug.org.au
Link: https://lkml.kernel.org/r/20240706160511.2331061-2-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S |  2 --
 include/asm-generic/vmlinux.lds.h | 18 ++----------------
 include/linux/init.h              | 14 +++++++++-----
 scripts/mod/modpost.c             | 19 ++++---------------
 4 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index f420df7888a75..7ab4e2fb28b1e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -123,8 +123,6 @@ SECTIONS
 		 */
 		*(.sfpr);
 		*(.text.asan.* .text.tsan.*)
-		MEM_KEEP(init.text)
-		MEM_KEEP(exit.text)
 	} :text
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 63029bc7c9dd0..5793aedb24c6d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -139,14 +139,6 @@
  * often happens at runtime)
  */
 
-#if defined(CONFIG_MEMORY_HOTPLUG)
-#define MEM_KEEP(sec)    *(.mem##sec)
-#define MEM_DISCARD(sec)
-#else
-#define MEM_KEEP(sec)
-#define MEM_DISCARD(sec) *(.mem##sec)
-#endif
-
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
 #define KEEP_PATCHABLE		KEEP(*(__patchable_function_entries))
 #define PATCHABLE_DISCARDS
@@ -355,7 +347,6 @@
 	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	MEM_KEEP(init.data*)						\
 	*(.data.unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
@@ -519,7 +510,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		MEM_KEEP(init.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -570,8 +560,7 @@
 		*(.text.unknown .text.unknown.*)			\
 		NOINSTR_TEXT						\
 		*(.ref.text)						\
-		*(.text.asan.* .text.tsan.*)				\
-	MEM_KEEP(init.text*)						\
+		*(.text.asan.* .text.tsan.*)
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -678,7 +667,6 @@
 #define INIT_DATA							\
 	KEEP(*(SORT(___kentry+*)))					\
 	*(.init.data .init.data.*)					\
-	MEM_DISCARD(init.data*)						\
 	KERNEL_CTORS()							\
 	MCOUNT_REC()							\
 	*(.init.rodata .init.rodata.*)					\
@@ -686,7 +674,6 @@
 	TRACE_SYSCALLS()						\
 	KPROBE_BLACKLIST()						\
 	ERROR_INJECT_WHITELIST()					\
-	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	RESERVEDMEM_OF_TABLES()						\
 	TIMER_OF_TABLES()						\
@@ -704,8 +691,7 @@
 
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
-	*(.text.startup)						\
-	MEM_DISCARD(init.text*)
+	*(.text.startup)
 
 #define EXIT_DATA							\
 	*(.exit.data .exit.data.*)					\
diff --git a/include/linux/init.h b/include/linux/init.h
index 01b52c9c75268..63d2ee4f1f0e0 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -84,11 +84,15 @@
 
 #define __exit          __section(".exit.text") __exitused __cold notrace
 
-/* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(".meminit.text") __cold notrace \
-						  __latent_entropy
-#define __meminitdata    __section(".meminit.data")
-#define __meminitconst   __section(".meminit.rodata")
+#ifdef CONFIG_MEMORY_HOTPLUG
+#define __meminit
+#define __meminitdata
+#define __meminitconst
+#else
+#define __meminit	__init
+#define __meminitdata	__initdata
+#define __meminitconst	__initconst
+#endif
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index bd559361ecd27..4110d559ed688 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -792,17 +792,14 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 
 #define ALL_INIT_DATA_SECTIONS \
-	".init.setup", ".init.rodata", ".meminit.rodata", \
-	".init.data", ".meminit.data"
+	".init.setup", ".init.rodata", ".init.data"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
 	".pci_fixup_enable", ".pci_fixup_resume", \
 	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
-#define ALL_XXXINIT_SECTIONS ".meminit.*"
-
-#define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
+#define ALL_INIT_SECTIONS ".init.*"
 #define ALL_EXIT_SECTIONS ".exit.*"
 
 #define DATA_SECTIONS ".data", ".data.rel"
@@ -813,9 +810,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"
 
-#define INIT_SECTIONS      ".init.*"
-
-#define ALL_TEXT_SECTIONS  ".init.text", ".meminit.text", ".exit.text", \
+#define ALL_TEXT_SECTIONS  ".init.text", ".exit.text", \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
 
 enum mismatch {
@@ -867,12 +862,6 @@ static const struct sectioncheck sectioncheck[] = {
 	.bad_tosec = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = TEXTDATA_TO_ANY_EXIT,
 },
-/* Do not reference init code/data from meminit code/data */
-{
-	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
-	.bad_tosec = { INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_SOME_INIT,
-},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
@@ -887,7 +876,7 @@ static const struct sectioncheck sectioncheck[] = {
 },
 {
 	.fromsec = { ALL_PCI_INIT_SECTIONS, NULL },
-	.bad_tosec = { INIT_SECTIONS, NULL },
+	.bad_tosec = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = ANY_INIT_TO_ANY_EXIT,
 },
 {
-- 
2.43.0



