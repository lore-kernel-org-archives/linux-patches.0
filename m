Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6400200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46223C433C7;
	Fri, 21 Jul 2023 19:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966185;
	bh=oNlslbprFhtVLOZgF9FC8a8ep3fLaEA/XfoZlI9UMWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X42bkC8aWqr+tO/6SMOXzBJqh23QhwVce9qXUBZojeJj66pEdj8ST9nNrR7uw+LeS
	 Y07k+/f1thElPzvLJ2R7nxamH70MJ9GU3HwhBrogItLlsTs7zNnf9LfiOaxbY7b97+
	 Ezg+or4LN5N6eNKCNPE9VqqDVU7MiEuVFIRspUyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/532] modpost: fix section mismatch message for R_ARM_ABS32
Date: Fri, 21 Jul 2023 18:02:10 +0200
Message-ID: <20230721160626.644258468@linuxfoundation.org>
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

[ Upstream commit b7c63520f6703a25eebb4f8138fed764fcae1c6f ]

addend_arm_rel() processes R_ARM_ABS32 in a wrong way.

Here, test code.

  [test code 1]

    #include <linux/init.h>

    int __initdata foo;
    int get_foo(void) { return foo; }

If you compile it with ARM versatile_defconfig, modpost will show the
symbol name, (unknown).

  WARNING: modpost: vmlinux.o: section mismatch in reference: get_foo (section: .text) -> (unknown) (section: .init.data)

(You need to use GNU linker instead of LLD to reproduce it.)

If you compile it for other architectures, modpost will show the correct
symbol name.

  WARNING: modpost: vmlinux.o: section mismatch in reference: get_foo (section: .text) -> foo (section: .init.data)

For R_ARM_ABS32, addend_arm_rel() sets r->r_addend to a wrong value.

I just mimicked the code in arch/arm/kernel/module.c.

However, there is more difficulty for ARM.

Here, test code.

  [test code 2]

    #include <linux/init.h>

    int __initdata foo;
    int get_foo(void) { return foo; }

    int __initdata bar;
    int get_bar(void) { return bar; }

With this commit applied, modpost will show the following messages
for ARM versatile_defconfig:

  WARNING: modpost: vmlinux.o: section mismatch in reference: get_foo (section: .text) -> foo (section: .init.data)
  WARNING: modpost: vmlinux.o: section mismatch in reference: get_bar (section: .text) -> foo (section: .init.data)

The reference from 'get_bar' to 'foo' seems wrong.

I have no solution for this because it is true in assembly level.

In the following output, relocation at 0x1c is no longer associated
with 'bar'. The two relocation entries point to the same symbol, and
the offset to 'bar' is encoded in the instruction 'r0, [r3, #4]'.

  Disassembly of section .text:

  00000000 <get_foo>:
     0: e59f3004          ldr     r3, [pc, #4]   @ c <get_foo+0xc>
     4: e5930000          ldr     r0, [r3]
     8: e12fff1e          bx      lr
     c: 00000000          .word   0x00000000

  00000010 <get_bar>:
    10: e59f3004          ldr     r3, [pc, #4]   @ 1c <get_bar+0xc>
    14: e5930004          ldr     r0, [r3, #4]
    18: e12fff1e          bx      lr
    1c: 00000000          .word   0x00000000

  Relocation section '.rel.text' at offset 0x244 contains 2 entries:
   Offset     Info    Type            Sym.Value  Sym. Name
  0000000c  00000c02 R_ARM_ABS32       00000000   .init.data
  0000001c  00000c02 R_ARM_ABS32       00000000   .init.data

When find_elf_symbol() gets into a situation where relsym->st_name is
zero, there is no guarantee to get the symbol name as written in C.

I am keeping the current logic because it is useful in many architectures,
but the symbol name is not always correct depending on the optimization.
I left some comments in find_tosym().

Fixes: 56a974fa2d59 ("kbuild: make better section mismatch reports on arm")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b29af4ad08321..789e0ddb41ae4 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1302,6 +1302,10 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf64_Sword addr,
 	if (relsym->st_name != 0)
 		return relsym;
 
+	/*
+	 * Strive to find a better symbol name, but the resulting name may not
+	 * match the symbol referenced in the original code.
+	 */
 	relsym_secindex = get_secindex(elf, relsym);
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		if (get_secindex(elf, sym) != relsym_secindex)
@@ -1734,12 +1738,14 @@ static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
+	Elf_Sym *sym = elf->symtab_start + ELF_R_SYM(r->r_info);
+	void *loc = reloc_location(elf, sechdr, r);
+	uint32_t inst;
 
 	switch (r_typ) {
 	case R_ARM_ABS32:
-		/* From ARM ABI: (S + A) | T */
-		r->r_addend = (int)(long)
-			      (elf->symtab_start + ELF_R_SYM(r->r_info));
+		inst = TO_NATIVE(*(uint32_t *)loc);
+		r->r_addend = inst + sym->st_value;
 		break;
 	case R_ARM_PC24:
 	case R_ARM_CALL:
-- 
2.39.2



