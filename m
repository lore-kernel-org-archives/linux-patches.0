Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499A0174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7051AC433C9;
	Wed,  9 Aug 2023 11:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579034;
	bh=TwGNz0X0C4GpqbawPe0TaK0tWYkpPcLCe7+J5RCPYB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pcp2oePMKUhVMqR/Cu+5S3eIAVAZ/0U71iWWnh9dTAy4QGYAUQWXa+e7Q7YMqYRJ
	 2yx07S9cuS+CKeuooork8OlSJ0IAPAkaMcv+/lFnV63vGTR810RiiieADS4lnBj9bf
	 G1K8Bp4oT5kQM9Qt5b5ojalEFKcymuG7CzjKdtbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/204] modpost: fix section mismatch message for R_ARM_{PC24,CALL,JUMP24}
Date: Wed,  9 Aug 2023 12:39:50 +0200
Message-ID: <20230809103644.334485942@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

[ Upstream commit 56a24b8ce6a7f9c4a21b2276a8644f6f3d8fc14d ]

addend_arm_rel() processes R_ARM_PC24, R_ARM_CALL, R_ARM_JUMP24 in a
wrong way.

Here, test code.

[test code for R_ARM_JUMP24]

  .section .init.text,"ax"
  bar:
          bx      lr

  .section .text,"ax"
  .globl foo
  foo:
          b       bar

[test code for R_ARM_CALL]

  .section .init.text,"ax"
  bar:
          bx      lr

  .section .text,"ax"
  .globl foo
  foo:
          push    {lr}
          bl      bar
          pop     {pc}

If you compile it with ARM multi_v7_defconfig, modpost will show the
symbol name, (unknown).

  WARNING: modpost: vmlinux.o: section mismatch in reference: foo (section: .text) -> (unknown) (section: .init.text)

(You need to use GNU linker instead of LLD to reproduce it.)

Fix the code to make modpost show the correct symbol name.

I imported (with adjustment) sign_extend32() from include/linux/bitops.h.

The '+8' is the compensation for pc-relative instruction. It is
documented in "ELF for the Arm Architecture" [1].

  "If the relocation is pc-relative then compensation for the PC bias
  (the PC value is 8 bytes ahead of the executing instruction in Arm
  state and 4 bytes in Thumb state) must be encoded in the relocation
  by the object producer."

[1]: https://github.com/ARM-software/abi-aa/blob/main/aaelf32/aaelf32.rst

Fixes: 56a974fa2d59 ("kbuild: make better section mismatch reports on arm")
Fixes: 6e2e340b59d2 ("ARM: 7324/1: modpost: Fix section warnings for ARM for many compilers")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f8bb964961b83..88f4586c35762 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1763,12 +1763,20 @@ static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 #define	R_ARM_THM_JUMP19	51
 #endif
 
+static int32_t sign_extend32(int32_t value, int index)
+{
+	uint8_t shift = 31 - index;
+
+	return (int32_t)(value << shift) >> shift;
+}
+
 static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
 	Elf_Sym *sym = elf->symtab_start + ELF_R_SYM(r->r_info);
 	void *loc = reloc_location(elf, sechdr, r);
 	uint32_t inst;
+	int32_t offset;
 
 	switch (r_typ) {
 	case R_ARM_ABS32:
@@ -1778,6 +1786,10 @@ static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 	case R_ARM_PC24:
 	case R_ARM_CALL:
 	case R_ARM_JUMP24:
+		inst = TO_NATIVE(*(uint32_t *)loc);
+		offset = sign_extend32((inst & 0x00ffffff) << 2, 25);
+		r->r_addend = offset + sym->st_value + 8;
+		break;
 	case R_ARM_THM_CALL:
 	case R_ARM_THM_JUMP24:
 	case R_ARM_THM_JUMP19:
-- 
2.39.2



