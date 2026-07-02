Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285F342CBA;
	Thu,  2 Jul 2026 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010365; cv=none; b=Rhfm0ynYJpZHqsD7n3bXhYpyF2Mpef9ZTSxbv4CzQB53XbwGRSYiz6lngjCxNzmPzQ2ZPOZRVt5fhnhhd6cCQq6bVFUtkUrhZUR5O/9iwzEPL7XmJ9QMLype4Efw3eaCLiQSmP1cvGb6EtInoXGVwGjJ8aKmlT8ebYOcKxBsyqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010365; c=relaxed/simple;
	bh=lW2rMU5N6ycDow28miiDQ68xDAHr7PYaMSFA6+j5e2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWg7FJW4XurTHh7cQSbPip4mgbmzBRKMu4D6d2lu2Gwzx7Opg4Z7hRW9XMjIxVeiKhDWEzuhQpR9F972bCCd5ei0laxp4420j4JF0iNlmifis7Oj7AFxTdfTrAOQXgoyeD2gARQJiS/Wf8oP2VRGSuhyBcBAUJwtf0xwwa+J+SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFAmchz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFAmchz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4291F000E9;
	Thu,  2 Jul 2026 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010363;
	bh=If3hx+pWVH5aZnt8i0f2xxv2bqhzjkF6t9HJbX5wAWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFAmchz6CnhUHURcxaVvfCis0JQWNg8KynlaVraGfho46oGgY8HJuRBOSl/iaiewj
	 Ub6RTktR6Bxjyu6W4Nn8mp12WNAQJ+XyCSesuvOkxNehA0vUvpbxvtq/4rijDYVCSI
	 l8Pf9cKHf/x4sYeZ+oQeXJLjHkJNT5p0OZyYN5ng=
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
Subject: [PATCH 6.12 064/204] scripts/sorttable: Convert Elf_Sym MACRO over to a union
Date: Thu,  2 Jul 2026 18:18:41 +0200
Message-ID: <20260702155120.004421499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 200d015e73b4da69bcd8212a7c58695452b12bad ]

In order to remove the double #include of sorttable.h for 64 and 32 bit
to create duplicate functions for both, replace the Elf_Sym macro with a
union that defines both Elf64_Sym and Elf32_Sym, with field e64 for the
64bit version, and e32 for the 32bit version.

It can then use the macro etype to get the proper value.

This will eventually be replaced with just single functions that can
handle both 32bit and 64bit ELF parsing.

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
Link: https://lore.kernel.org/20250105162345.528626969@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    5 +++++
 scripts/sorttable.h |   25 ++++++++++++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -74,6 +74,11 @@ typedef union {
 	Elf64_Shdr	e64;
 } Elf_Shdr;
 
+typedef union {
+	Elf32_Sym	e32;
+	Elf64_Sym	e64;
+} Elf_Sym;
+
 static uint32_t (*r)(const uint32_t *);
 static uint16_t (*r2)(const uint16_t *);
 static uint64_t (*r8)(const uint64_t *);
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -23,7 +23,6 @@
 #undef sort_mcount_loc
 #undef elf_mcount_loc
 #undef do_sort
-#undef Elf_Sym
 #undef ELF_ST_TYPE
 #undef uint_t
 #undef _r
@@ -36,7 +35,6 @@
 # define sort_mcount_loc	sort_mcount_loc_64
 # define elf_mcount_loc		elf_mcount_loc_64
 # define do_sort		do_sort_64
-# define Elf_Sym		Elf64_Sym
 # define ELF_ST_TYPE		ELF64_ST_TYPE
 # define uint_t			uint64_t
 # define _r			r8
@@ -48,7 +46,6 @@
 # define sort_mcount_loc	sort_mcount_loc_32
 # define elf_mcount_loc		elf_mcount_loc_32
 # define do_sort		do_sort_32
-# define Elf_Sym		Elf32_Sym
 # define ELF_ST_TYPE		ELF32_ST_TYPE
 # define uint_t			uint32_t
 # define _r			r
@@ -230,10 +227,13 @@ static int do_sort(Elf_Ehdr *ehdr,
 	Elf_Sym *sort_needed_sym = NULL;
 	Elf_Shdr *sort_needed_sec;
 	uint32_t *sort_needed_loc;
+	void *sym_start;
+	void *sym_end;
 	const char *secstrings;
 	const char *strtab;
 	char *extab_image;
 	int sort_need_index;
+	int symentsize;
 	int shentsize;
 	int idx;
 	int i;
@@ -376,12 +376,15 @@ static int do_sort(Elf_Ehdr *ehdr,
 	}
 
 	/* find the flag main_extable_sort_needed */
-	for (sym = (void *)ehdr + _r(&symtab_sec->etype.sh_offset);
-	     sym < sym + _r(&symtab_sec->etype.sh_size) / sizeof(Elf_Sym);
-	     sym++) {
-		if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
+	sym_start = (void *)ehdr + _r(&symtab_sec->etype.sh_offset);
+	sym_end = sym_start + _r(&symtab_sec->etype.sh_size);
+	symentsize = _r(&symtab_sec->etype.sh_entsize);
+
+	for (sym = sym_start; (void *)sym + symentsize < sym_end;
+	     sym = (void *)sym + symentsize) {
+		if (ELF_ST_TYPE(sym->etype.st_info) != STT_OBJECT)
 			continue;
-		if (!strcmp(strtab + r(&sym->st_name),
+		if (!strcmp(strtab + r(&sym->etype.st_name),
 			    "main_extable_sort_needed")) {
 			sort_needed_sym = sym;
 			break;
@@ -395,13 +398,13 @@ static int do_sort(Elf_Ehdr *ehdr,
 		goto out;
 	}
 
-	sort_need_index = get_secindex(r2(&sym->st_shndx),
-				       sort_needed_sym - symtab,
+	sort_need_index = get_secindex(r2(&sym->etype.st_shndx),
+				       ((void *)sort_needed_sym - (void *)symtab) / symentsize,
 				       symtab_shndx);
 	sort_needed_sec = get_index(shdr_start, shentsize, sort_need_index);
 	sort_needed_loc = (void *)ehdr +
 		_r(&sort_needed_sec->etype.sh_offset) +
-		_r(&sort_needed_sym->st_value) -
+		_r(&sort_needed_sym->etype.st_value) -
 		_r(&sort_needed_sec->etype.sh_addr);
 
 	/* extable has been sorted, clear the flag */


