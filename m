Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD5D200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D15C433C8;
	Fri, 21 Jul 2023 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966177;
	bh=83chOLz1xwA9ENQKxHerclny42/4UnK8Q/Ay/i/ykCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnj7bEO6PIKDBOiw7Z7r9ZSZ0+sfvElFm81HWJlrMCxCzKgNdL41asvwMRlVbdCxH
	 4TkSQwNvZmRrAufsNiJHgY4f7DCLdMs4d4f2qga/BW2ETC4OD+RxA/iX4QiiEd+Rh9
	 MU64O9dhH3Ek/+qP1e3FTRGDdzDCwRA1DwVq+llQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/532] modpost: remove broken calculation of exception_table_entry size
Date: Fri, 21 Jul 2023 18:02:08 +0200
Message-ID: <20230721160626.531128466@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit d0acc76a49aa917c1a455d11d32d34a01e8b2835 ]

find_extable_entry_size() is completely broken. It has awesome comments
about how to calculate sizeof(struct exception_table_entry).

It was based on these assumptions:

  - struct exception_table_entry has two fields
  - both of the fields have the same size

Then, we came up with this equation:

  (offset of the second field) * 2 == (size of struct)

It was true for all architectures when commit 52dc0595d540 ("modpost:
handle relocations mismatch in __ex_table.") was applied.

Our mathematics broke when commit 548acf19234d ("x86/mm: Expand the
exception table logic to allow new handling options") introduced the
third field.

Now, the definition of exception_table_entry is highly arch-dependent.

For x86, sizeof(struct exception_table_entry) is apparently 12, but
find_extable_entry_size() sets extable_entry_size to 8.

I could fix it, but I do not see much value in this code.

extable_entry_size is used just for selecting a slightly different
error message.

If the first field ("insn") references to a non-executable section,

    The relocation at %s+0x%lx references
    section "%s" which is not executable, IOW
    it is not possible for the kernel to fault
    at that address.  Something is seriously wrong
    and should be fixed.

If the second field ("fixup") references to a non-executable section,

    The relocation at %s+0x%lx references
    section "%s" which is not executable, IOW
    the kernel will fault if it ever tries to
    jump to it.  Something is seriously wrong
    and should be fixed.

Merge the two error messages rather than adding even more complexity.

Change fatal() to error() to make it continue running and catch more
possible errors.

Fixes: 548acf19234d ("x86/mm: Expand the exception table logic to allow new handling options")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 60 +++----------------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b284ee01fdebb..b29af4ad08321 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1612,43 +1612,6 @@ static int is_executable_section(struct elf_info* elf, unsigned int section_inde
 	return ((elf->sechdrs[section_index].sh_flags & SHF_EXECINSTR) == SHF_EXECINSTR);
 }
 
-/*
- * We rely on a gross hack in section_rel[a]() calling find_extable_entry_size()
- * to know the sizeof(struct exception_table_entry) for the target architecture.
- */
-static unsigned int extable_entry_size = 0;
-static void find_extable_entry_size(const char* const sec, const Elf_Rela* r)
-{
-	/*
-	 * If we're currently checking the second relocation within __ex_table,
-	 * that relocation offset tells us the offsetof(struct
-	 * exception_table_entry, fixup) which is equal to sizeof(struct
-	 * exception_table_entry) divided by two.  We use that to our advantage
-	 * since there's no portable way to get that size as every architecture
-	 * seems to go with different sized types.  Not pretty but better than
-	 * hard-coding the size for every architecture..
-	 */
-	if (!extable_entry_size)
-		extable_entry_size = r->r_offset * 2;
-}
-
-static inline bool is_extable_fault_address(Elf_Rela *r)
-{
-	/*
-	 * extable_entry_size is only discovered after we've handled the
-	 * _second_ relocation in __ex_table, so only abort when we're not
-	 * handling the first reloc and extable_entry_size is zero.
-	 */
-	if (r->r_offset && extable_entry_size == 0)
-		fatal("extable_entry size hasn't been discovered!\n");
-
-	return ((r->r_offset == 0) ||
-		(r->r_offset % extable_entry_size == 0));
-}
-
-#define is_second_extable_reloc(Start, Cur, Sec)			\
-	(((Cur) == (Start) + 1) && (strcmp("__ex_table", (Sec)) == 0))
-
 static void report_extable_warnings(const char* modname, struct elf_info* elf,
 				    const struct sectioncheck* const mismatch,
 				    Elf_Rela* r, Elf_Sym* sym,
@@ -1705,22 +1668,9 @@ static void extable_mismatch_handler(const char* modname, struct elf_info *elf,
 		      "You might get more information about where this is\n"
 		      "coming from by using scripts/check_extable.sh %s\n",
 		      fromsec, (long)r->r_offset, tosec, modname);
-	else if (!is_executable_section(elf, get_secindex(elf, sym))) {
-		if (is_extable_fault_address(r))
-			fatal("The relocation at %s+0x%lx references\n"
-			      "section \"%s\" which is not executable, IOW\n"
-			      "it is not possible for the kernel to fault\n"
-			      "at that address.  Something is seriously wrong\n"
-			      "and should be fixed.\n",
-			      fromsec, (long)r->r_offset, tosec);
-		else
-			fatal("The relocation at %s+0x%lx references\n"
-			      "section \"%s\" which is not executable, IOW\n"
-			      "the kernel will fault if it ever tries to\n"
-			      "jump to it.  Something is seriously wrong\n"
-			      "and should be fixed.\n",
-			      fromsec, (long)r->r_offset, tosec);
-	}
+	else if (!is_executable_section(elf, get_secindex(elf, sym)))
+		error("%s+0x%lx references non-executable section '%s'\n",
+		      fromsec, (long)r->r_offset, tosec);
 }
 
 static void check_section_mismatch(const char *modname, struct elf_info *elf,
@@ -1871,8 +1821,6 @@ static void section_rela(const char *modname, struct elf_info *elf,
 		/* Skip special sections */
 		if (is_shndx_special(sym->st_shndx))
 			continue;
-		if (is_second_extable_reloc(start, rela, fromsec))
-			find_extable_entry_size(fromsec, &r);
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
 }
@@ -1931,8 +1879,6 @@ static void section_rel(const char *modname, struct elf_info *elf,
 		/* Skip special sections */
 		if (is_shndx_special(sym->st_shndx))
 			continue;
-		if (is_second_extable_reloc(start, rel, fromsec))
-			find_extable_entry_size(fromsec, &r);
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
 }
-- 
2.39.2



