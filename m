Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE11171B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8287DC433C7;
	Mon, 11 Sep 2023 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444520;
	bh=xdAC+CB+DVIujqqC77yA8Jx93bjq20TbOUPVJeIvjqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaBi+LxINcj7iJQhrib72GEKmoG2dx4Svudhw9+BA7Y1p161SuPekfJD8U5bDzbdd
	 6yHrukG+/hoy0+lU2ICP78yhBT6VLqdqvG50pX57F4sTExCdsWKsxOsa6Oela7Borh
	 zBtCQtkP4hQdnMwxH4LYA5NQvf2XrHIo5dFNpDkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/600] powerpc/boot: Disable power10 features after BOOTAFLAGS assignment
Date: Mon, 11 Sep 2023 15:40:40 +0200
Message-ID: <20230911134633.838090880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2b694fc96fe33a7c042e3a142d27d945c8c668b0 ]

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

Fixes: 648a1783fe25 ("powerpc/boot: Fix boot wrapper code generation with CONFIG_POWER10_CPU")
Link: https://github.com/ClangBuiltLinux/linux/issues/1839
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230427-remove-power10-args-from-boot-aflags-clang-v1-1-9107f7c943bc@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 13fad4f0a6d8f..b13324b1a1696 100644
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
-- 
2.40.1



