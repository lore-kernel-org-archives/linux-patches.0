Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07769C2CB;
	Thu, 27 Apr 2023 19:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24230C4339B;
	Thu, 27 Apr 2023 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682624111;
	bh=I6bjmJKyg+OsI5C9yWHH3qaPQ1SmKzUJt4SHAnBFRZI=;
	h=From:Date:Subject:To:Cc:From;
	b=XierVmVdpa9Cp39YuWLeh+yshOeehlTOz9gNsgUitHVikKGFTxIiAKZkigJbZrsrg
	 vgQa+Q3Ck2JIRvcGCVf3wpvIWrAypEQdMXGq1d1TO+aixd+IJz/1+t1VFZyja6lkkM
	 MyoDXHe54cW6Tg9mh9XJ060LVRxv1g7MZMunUP5XiW6dIOZNp7+H4dBL9gwCtU6h+/
	 Qg3IGXNqxWg5xgmmNvPpl+LSW9OUfesBRR/jjrB2ZTx7ori0yCkmb3fldCh/4J2gPe
	 Ai+yXz746miKIZ6kO6lUawp5qy9F5179DlH2rfO5zvywSC/rpSwUudk3SS1HDoSanB
	 wr23RJp6sCcPQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 27 Apr 2023 12:34:53 -0700
Subject: [PATCH] powerpc/boot: Disable power10 features after BOOTAFLAGS
 assignment
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-remove-power10-args-from-boot-aflags-clang-v1-1-9107f7c943bc@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFzOSmQC/x2OwQqDMBBEf0Vy7kKM0kp/pfSwSTcaMFnZFS2I/
 97Y45thHnMYJUmk5tkcRmhLmrhUaG+NCROWkSB9KhtnXWd79wChzBvBwjtJawFlVIjCGTzzChh
 nrEGY6xTcfQh9R0NoYzBV6FEJvGAJ06XMqCvJVSxCMX3/L17v8/wBDfVlOJUAAAA=
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, ndesaulniers@google.com, 
 trix@redhat.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2693; i=nathan@kernel.org;
 h=from:subject:message-id; bh=I6bjmJKyg+OsI5C9yWHH3qaPQ1SmKzUJt4SHAnBFRZI=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCle5/I47l3VVrhda/xi+qvzUqkHPLpLjyWoL7h32nDxZ
 0XFY7urOkpZGMQ4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEUl8z/OF2N5n/qTdontgL
 j/9b712ou3PowoKTqg/552x/apAX9DCekeF31rJjPwrXT1okOJnber27/ht53bCIeqOQgo7b8Wv
 3TuQDAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building the boot wrapper assembly files with clang after
commit 648a1783fe25 ("powerpc/boot: Fix boot wrapper code generation
with CONFIG_POWER10_CPU"), the following warnings appear for each file
built:

  '-prefixed' is not a recognized feature for this target (ignoring feature)
  '-pcrel' is not a recognized feature for this target (ignoring feature)

While it is questionable whether or not LLVM should be emitting a
warning when passed negative versions of code generation flags when
building assembly files (since it does not emit a warning for the
altivec and vsx flags), it is easy enough to work around this by just
moving the disabled flags to BOOTCFLAGS after the assignment of
BOOTAFLAGS, so that they are not added when building assembly files.
Do so to silence the warnings.

Cc: stable@vger.kernel.org
Fixes: 648a1783fe25 ("powerpc/boot: Fix boot wrapper code generation with CONFIG_POWER10_CPU")
Link: https://github.com/ClangBuiltLinux/linux/issues/1839
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I do not think that 648a1783fe25 is truly to blame for this but the
Fixes tag will help the stable team ensure that this change gets
backported with 648a1783fe25. This is the minimal fix for the problem
but the true fix is separating AFLAGS and CFLAGS, which should be done
by this in-flight series by Nick:

https://lore.kernel.org/20230426055848.402993-1-npiggin@gmail.com/
---
 arch/powerpc/boot/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 85cde5bf04b7..771b79423bbc 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -34,8 +34,6 @@ endif
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 -fno-strict-aliasing -O2 -msoft-float -mno-altivec -mno-vsx \
-		 $(call cc-option,-mno-prefixed) $(call cc-option,-mno-pcrel) \
-		 $(call cc-option,-mno-mma) \
 		 $(call cc-option,-mno-spe) $(call cc-option,-mspe=no) \
 		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 $(LINUXINCLUDE)
@@ -71,6 +69,10 @@ BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -nostdinc
 
 BOOTARFLAGS	:= -crD
 
+BOOTCFLAGS	+= $(call cc-option,-mno-prefixed) \
+		   $(call cc-option,-mno-pcrel) \
+		   $(call cc-option,-mno-mma)
+
 ifdef CONFIG_CC_IS_CLANG
 BOOTCFLAGS += $(CLANG_FLAGS)
 BOOTAFLAGS += $(CLANG_FLAGS)

---
base-commit: 169f8997968ab620d750d9a45e15c5288d498356
change-id: 20230427-remove-power10-args-from-boot-aflags-clang-268c43e8c1fc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

