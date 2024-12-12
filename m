Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6531F2381;
	Thu, 12 Dec 2024 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024032; cv=none; b=s0c7+SL60wcgghYrpemOYGPLVXcfEpV8zkLyXSaVWd4w5CBT70QfN0hPw0R8vwhO/Y7fDZjcCl1Ax/k0KY3N0WUK2UuBKKY3JE8829x+bPFJ2U+nOJXuqg0+pSbykcdKn6dYWp3KWZIUalRcEi00f7js2vQrzlyLCdu0Q1iZEJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024032; c=relaxed/simple;
	bh=39Yz5ekQlhvXy6S/P3SoMzgdcIRQridTVye0TJoTi28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3umkawxqTbsVtrAhNFY2+YA6q2PU6WFMbXLR07pNsgfgrVOe6lcjVox1CuiW0ML1KTUZ6uhXT8sA5gVNkyXn6NkN5lxN0qRVqenjAK3rnTffvrgDzDbxwJr/DTz29yeJ8RpUi2j3QSAO1NU6RzvapOs/hg85IxK95ea/FGBWA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtCazSaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtCazSaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B3C4CECE;
	Thu, 12 Dec 2024 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024032;
	bh=39Yz5ekQlhvXy6S/P3SoMzgdcIRQridTVye0TJoTi28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtCazSaFPtvnWD/ckrIBdwrmiLjZF4rc3NdSrpKaUtX7eG1cvWebKpn7Jxk9ZGA1f
	 psdno2b7dsvEqwb68+JDeM/aFybI4gPDOVhc6DEig9y0jOqEUdF9i/0/qsO5gUAKgz
	 5mysXhIWSG/0gq76wDnSQFbw2I3Mk8XX/SwTImVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/459] powerpc/vdso: Flag VDSO64 entry points as functions
Date: Thu, 12 Dec 2024 15:58:22 +0100
Message-ID: <20241212144259.994326765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 0161bd38c24312853ed5ae9a425a1c41c4ac674a ]

On powerpc64 as shown below by readelf, vDSO functions symbols have
type NOTYPE.

$ powerpc64-linux-gnu-readelf -a arch/powerpc/kernel/vdso/vdso64.so.dbg
ELF Header:
  Magic:   7f 45 4c 46 02 02 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, big endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           PowerPC64
  Version:                           0x1
...

Symbol table '.dynsym' contains 12 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
...
     1: 0000000000000524    84 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
...
     4: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LINUX_2.6.15
     5: 00000000000006c0    48 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15

Symbol table '.symtab' contains 56 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
...
    45: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LINUX_2.6.15
    46: 00000000000006c0    48 NOTYPE  GLOBAL DEFAULT    8 __kernel_getcpu
    47: 0000000000000524    84 NOTYPE  GLOBAL DEFAULT    8 __kernel_clock_getres

To overcome that, commit ba83b3239e65 ("selftests: vDSO: fix vDSO
symbols lookup for powerpc64") was applied to have selftests also
look for NOTYPE symbols, but the correct fix should be to flag VDSO
entry points as functions.

The original commit that brought VDSO support into powerpc/64 has the
following explanation:

    Note that the symbols exposed by the vDSO aren't "normal" function symbols, apps
    can't be expected to link against them directly, the vDSO's are both seen
    as if they were linked at 0 and the symbols just contain offsets to the
    various functions.  This is done on purpose to avoid a relocation step
    (ppc64 functions normally have descriptors with abs addresses in them).
    When glibc uses those functions, it's expected to use it's own trampolines
    that know how to reach them.

The descriptors it's talking about are the OPD function descriptors
used on ABI v1 (big endian). But it would be more correct for a text
symbol to have type function, even if there's no function descriptor
for it.

glibc has a special case already for handling the VDSO symbols which
creates a fake opd pointing at the kernel symbol. So changing the VDSO
symbol type to function shouldn't affect that.

For ABI v2, there is no function descriptors and VDSO functions can
safely have function type.

So lets flag VDSO entry points as functions and revert the
selftest change.

Link: https://github.com/mpe/linux-fullhistory/commit/5f2dd691b62da9d9cc54b938f8b29c22c93cb805
Fixes: ba83b3239e65 ("selftests: vDSO: fix vDSO symbols lookup for powerpc64")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-By: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/b6ad2f1ee9887af3ca5ecade2a56f4acda517a85.1728512263.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vdso.h           | 1 +
 tools/testing/selftests/vDSO/parse_vdso.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/vdso.h b/arch/powerpc/include/asm/vdso.h
index 2ff884853f975..e3768f1161d23 100644
--- a/arch/powerpc/include/asm/vdso.h
+++ b/arch/powerpc/include/asm/vdso.h
@@ -27,6 +27,7 @@ int vdso_getcpu_init(void);
 #ifdef __VDSO64__
 #define V_FUNCTION_BEGIN(name)		\
 	.globl name;			\
+	.type name,@function; 		\
 	name:				\
 
 #define V_FUNCTION_END(name)		\
diff --git a/tools/testing/selftests/vDSO/parse_vdso.c b/tools/testing/selftests/vDSO/parse_vdso.c
index d9ccc5acac182..4ae417372e9eb 100644
--- a/tools/testing/selftests/vDSO/parse_vdso.c
+++ b/tools/testing/selftests/vDSO/parse_vdso.c
@@ -216,8 +216,7 @@ void *vdso_sym(const char *version, const char *name)
 		ELF(Sym) *sym = &vdso_info.symtab[chain];
 
 		/* Check for a defined global or weak function w/ right name. */
-		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC &&
-		    ELF64_ST_TYPE(sym->st_info) != STT_NOTYPE)
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
 			continue;
 		if (ELF64_ST_BIND(sym->st_info) != STB_GLOBAL &&
 		    ELF64_ST_BIND(sym->st_info) != STB_WEAK)
-- 
2.43.0



