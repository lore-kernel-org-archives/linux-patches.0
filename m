Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD691E7C1A;
	Wed,  6 Nov 2024 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898432; cv=none; b=MWcbQQ6+rlPL0zETrW/ydLqSzNWQr7iWw+PUtm6yQnjsvKSRlmAtA3a29+xacYgvgoUFVztaZsjYRB0njnrr//zdU+pJESBr31lZ3qpNgibgHDv9o4IeAuvVOWq7IHAB/7qz4d938+w/H5NUihp00bObG0fQMdl8QClu45CgF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898432; c=relaxed/simple;
	bh=Rmmrn2U8OlulyhJUFqYl8wwe23V92GxEnzeL1WSH48g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhtjUNQmpz7VjEIA4jweoeoymJaNmahnYlhEIa/znpWUcHoVN9a+CK/4LrAt0twReCtHIkAB/BIZAqrMA+6ws0yC/yEVfnnv5LX4G6juL+jZ4MYMv5W/xHrbNQF23MgU6o/z/j1lpTn7V4fsc2fDiZwC5lEIja5y1OVezkqm6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTWhFCyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTWhFCyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FB5C4CECD;
	Wed,  6 Nov 2024 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898432;
	bh=Rmmrn2U8OlulyhJUFqYl8wwe23V92GxEnzeL1WSH48g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTWhFCyf1Ew/HjxttrCwtdJih6GQmthWFOc4AcE+mz0FlhNj5Om0ukcvhI/x+Ta6I
	 BVonCeLb1IHgY1CpHK2uBua2YA3tw8SlQsQswEcv8D5nMS6vb20esMqTVZE8DJwF1s
	 kwq1umT7+ajQTf8dgfT3n10foqU7ORUIuycC0QVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/462] selftests: vDSO: fix vDSO symbols lookup for powerpc64
Date: Wed,  6 Nov 2024 13:02:10 +0100
Message-ID: <20241106120337.377093034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit ba83b3239e657469709d15dcea5f9b65bf9dbf34 ]

On powerpc64, following tests fail locating vDSO functions:

  ~ # ./vdso_test_abi
  TAP version 13
  1..16
  # [vDSO kselftest] VDSO_VERSION: LINUX_2.6.15
  # Couldn't find __kernel_gettimeofday
  ok 1 # SKIP __kernel_gettimeofday
  # clock_id: CLOCK_REALTIME
  # Couldn't find __kernel_clock_gettime
  ok 2 # SKIP __kernel_clock_gettime CLOCK_REALTIME
  # Couldn't find __kernel_clock_getres
  ok 3 # SKIP __kernel_clock_getres CLOCK_REALTIME
  ...
  # Couldn't find __kernel_time
  ok 16 # SKIP __kernel_time
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:16 error:0

  ~ # ./vdso_test_getrandom
  __kernel_getrandom is missing!

  ~ # ./vdso_test_gettimeofday
  Could not find __kernel_gettimeofday

  ~ # ./vdso_test_getcpu
  Could not find __kernel_getcpu

On powerpc64, as shown below by readelf, vDSO functions symbols have
type NOTYPE, so also accept that type when looking for symbols.

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
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000524    84 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     2: 00000000000005f0    36 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     3: 0000000000000578    68 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     4: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LINUX_2.6.15
     5: 00000000000006c0    48 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     6: 0000000000000614   172 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     7: 00000000000006f0    84 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     8: 000000000000047c    84 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
     9: 0000000000000454    12 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
    10: 00000000000004d0    84 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15
    11: 00000000000005bc    52 NOTYPE  GLOBAL DEFAULT    8 __[...]@@LINUX_2.6.15

Symbol table '.symtab' contains 56 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
...
    45: 0000000000000000     0 OBJECT  GLOBAL DEFAULT  ABS LINUX_2.6.15
    46: 00000000000006c0    48 NOTYPE  GLOBAL DEFAULT    8 __kernel_getcpu
    47: 0000000000000524    84 NOTYPE  GLOBAL DEFAULT    8 __kernel_clock_getres
    48: 00000000000005f0    36 NOTYPE  GLOBAL DEFAULT    8 __kernel_get_tbfreq
    49: 000000000000047c    84 NOTYPE  GLOBAL DEFAULT    8 __kernel_gettimeofday
    50: 0000000000000614   172 NOTYPE  GLOBAL DEFAULT    8 __kernel_sync_dicache
    51: 00000000000006f0    84 NOTYPE  GLOBAL DEFAULT    8 __kernel_getrandom
    52: 0000000000000454    12 NOTYPE  GLOBAL DEFAULT    8 __kernel_sigtram[...]
    53: 0000000000000578    68 NOTYPE  GLOBAL DEFAULT    8 __kernel_time
    54: 00000000000004d0    84 NOTYPE  GLOBAL DEFAULT    8 __kernel_clock_g[...]
    55: 00000000000005bc    52 NOTYPE  GLOBAL DEFAULT    8 __kernel_get_sys[...]

Fixes: 98eedc3a9dbf ("Document the vDSO and add a reference parser")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/parse_vdso.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vDSO/parse_vdso.c b/tools/testing/selftests/vDSO/parse_vdso.c
index 9ef3ad3789c17..540f9a284e9f0 100644
--- a/tools/testing/selftests/vDSO/parse_vdso.c
+++ b/tools/testing/selftests/vDSO/parse_vdso.c
@@ -238,7 +238,8 @@ void *vdso_sym(const char *version, const char *name)
 		ELF(Sym) *sym = &vdso_info.symtab[chain];
 
 		/* Check for a defined global or weak function w/ right name. */
-		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC &&
+		    ELF64_ST_TYPE(sym->st_info) != STT_NOTYPE)
 			continue;
 		if (ELF64_ST_BIND(sym->st_info) != STB_GLOBAL &&
 		    ELF64_ST_BIND(sym->st_info) != STB_WEAK)
-- 
2.43.0



