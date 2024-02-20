Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212AF1FDB;
	Tue, 20 Feb 2024 20:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708461899; cv=none; b=Ewl0lGQtcnuj5D6+i/QSMYjAp/BIlUO/DJ+AR7TwBurDJulbim6LfEsz7hsPS78xP4bw/7bqWLGUqHNyvUN5QG8VVfRovKmp3vMSvX5NapQjC2z9ReZeWvZNJ1pvd5j8IdiE99aQK1TJxZQ6qV7220fqSxmG8vJ2+12/6YDlv+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708461899; c=relaxed/simple;
	bh=OlPlBXfeiIiilwpBpvXgoBdAmfQVCnZRvZ/9m9sPvyg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=qXvn0hn5wWlINlrh4wUzUoXWePOIQaeeyhkeMLSK2a+uuBvvCV31yd/jdWPIk+aTRit7cfL/wSw2d6CHn72f4G1o7lgfs1q3l14dMvZTA7be2ZfLGM+I7cVlHTp0uBj+vkdvQZPrzCRHIo7HSl5RmH9alzcnwYrDdq4zj1VOnDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLZ9AkMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLZ9AkMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDD6C433F1;
	Tue, 20 Feb 2024 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708461898;
	bh=OlPlBXfeiIiilwpBpvXgoBdAmfQVCnZRvZ/9m9sPvyg=;
	h=From:Date:Subject:To:Cc:From;
	b=FLZ9AkMyZiZ38MqIQThs5/Y9gkE61pEhYH8tnAsMssL5enLjtwL/oat7iF2Nk7b6s
	 xclO05FuoFJ3Lz8UbtTudq8mkj0k98K1kpqs8GwPwzvZ4s3Bzuv6uhsiUpPV3h4Z8l
	 XfH9TnmTYrJVhzXIItCugWLHOgbRafUJYCjHcdPymhANjjJBk7T8BgZB1qRBy+f2Vt
	 eE4GlmNqJ+hbu76NoJuEWTbC5/ztKnmbGIRVqhiX/cL8AnWLWxewmpw6J5loAfGRGv
	 0dxriJ1YxnNB2cONDBFsb6b0ijP6fEO0TrELyTqOlbyFMmNIhr6PR3zFP6HqdCG/aG
	 zTacgvnIrmTJQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 20 Feb 2024 13:44:48 -0700
Subject: [PATCH] s390/boot: Workaround current 'llvm-objdump -t -j ...'
 behavior
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240220-s390-work-around-llvm-objdump-t-j-v1-1-47bb0366a831@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD8P1WUC/x3NPQ6DMAxA4asgz7UUXIbSq1QdIHZaU0iQU34kx
 N0bdfyW9w7IYioZ7tUBJqtmTbGgvlTg3118CSoXAzlqHJHDfG0dbsk+2FlaIuM4rhOmfuBlmvG
 LA/bhxp59E6itoXRmk6D7//F4nucPyQ+KOHMAAAA=
To: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, morbo@google.com, 
 justinstitt@google.com, linux-s390@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3960; i=nathan@kernel.org;
 h=from:subject:message-id; bh=OlPlBXfeiIiilwpBpvXgoBdAmfQVCnZRvZ/9m9sPvyg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKlX+T1nSYgumrn2mEpeR5L9k3OnhHtVFhie2qXwb82bh
 xtqNurd7ihlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATWbqDkeFLT09Yw1Uu1XVV
 /CHsOvpNvJfWHE537j7yrS391rF/Uf8Z/vuke74RiTI2r/OXMTs7e89kue/Ty1YusIqWP/FN8vm
 6K8wA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with OBJDUMP=llvm-objdump, there are a series of warnings
from the section comparisons that arch/s390/boot/Makefile performs
between vmlinux and arch/s390/boot/vmlinux:

  llvm-objdump: warning: section '.boot.preserved.data' mentioned in a -j/--section option, but not found in any input file
  llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file
  llvm-objdump: warning: section '.boot.preserved.data' mentioned in a -j/--section option, but not found in any input file
  llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file

The warning is a little misleading, as these sections do exist in the
input files. It is really pointing out that llvm-objdump does not match
GNU objdump's behavior of respecting '-j' / '--section' in combination
with '-t' / '--syms':

  $ s390x-linux-gnu-objdump -t -j .boot.data vmlinux.full

  vmlinux.full:     file format elf64-s390

  SYMBOL TABLE:
  0000000001951000 l     O .boot.data     0000000000003000 sclp_info_sccb
  00000000019550e0 l     O .boot.data     0000000000000001 sclp_info_sccb_valid
  00000000019550e2 g     O .boot.data     0000000000001000 early_command_line
  ...

  $ llvm-objdump -t -j .boot.data vmlinux.full

  vmlinux.full:   file format elf64-s390

  SYMBOL TABLE:
  0000000000100040 l     O .text  0000000000000010 dw_psw
  0000000000000000 l    df *ABS*  0000000000000000 main.c
  00000000001001b0 l     F .text  00000000000000c6 trace_event_raw_event_initcall_level
  0000000000100280 l     F .text  0000000000000100 perf_trace_initcall_level
  ...

It may be possible to change llvm-objdump's behavior to match GNU
objdump's behavior but the difficulty of that task has not yet been
explored. The combination of '$(OBJDUMP) -t -j' is not common in the
kernel tree on a whole, so workaround this tool difference by grepping
for the sections in the full symbol table output in a similar manner to
the sed invocation. This results in no visible change for GNU objdump
users while fixing the warnings for OBJDUMP=llvm-objdump, further
enabling use of LLVM=1 for ARCH=s390 with versions of LLVM that have
support for s390 in ld.lld and llvm-objcopy.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/20240219113248.16287-C-hca@linux.ibm.com/
Link: https://github.com/ClangBuiltLinux/linux/issues/859
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
s390 llvm-objcopy support may be backported to LLVM 18.1.0 in time for
the final release.

https://github.com/llvm/llvm-project/pull/82324

s390 ld.lld has already made it into release/18.x:

https://github.com/llvm/llvm-project/commit/0a44c3792a6ff799df5f100670d7e19d1bc49f03

If the objcopy change makes 18.1.0 final, features + this change should
build cleanly with LLVM 18.1.0+ using LLVM=1 :)
---
 arch/s390/boot/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index aecafabc2054..294f08a8811a 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -60,9 +60,9 @@ clean-files += vmlinux.map
 
 quiet_cmd_section_cmp = SECTCMP $*
 define cmd_section_cmp
-	s1=`$(OBJDUMP) -t -j "$*" "$<" | sort | \
+	s1=`$(OBJDUMP) -t "$<" | grep "\s$*\s\+" | sort | \
 		sed -n "/0000000000000000/! s/.*\s$*\s\+//p" | sha256sum`; \
-	s2=`$(OBJDUMP) -t -j "$*" "$(word 2,$^)" | sort | \
+	s2=`$(OBJDUMP) -t "$(word 2,$^)" | grep "\s$*\s\+" | sort | \
 		sed -n "/0000000000000000/! s/.*\s$*\s\+//p" | sha256sum`; \
 	if [ "$$s1" != "$$s2" ]; then \
 		echo "error: section $* differs between $< and $(word 2,$^)" >&2; \

---
base-commit: 778666df60f0d96f215e33e27448de47a2207fb3
change-id: 20240220-s390-work-around-llvm-objdump-t-j-bf8dcdc4f291

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

