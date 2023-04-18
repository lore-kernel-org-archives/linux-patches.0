Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CA62566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15EC433D2;
	Tue, 18 Apr 2023 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821437;
	bh=Jx4AB8hoth22SJr2+al2uqhbZ2wbHM2ATm9tXM8vP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BM4L8njGaMjPPU7Sh9CEPVUWf0ComHvDqo8uKNQ5O3vo/voJuJu63rxuu/W9HZHOj
	 G0i0gnlm2H26x+wjApRvFgy5CtsjjSxYWTP+U4j7tStCHpC1qAqYZrrjGoS0iwy2Ii
	 9DB07IMPUlL8WGoJGFNDWF1Q1ze3ktQFeXAr0KAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 119/124] kbuild: check CONFIG_AS_IS_LLVM instead of LLVM_IAS
Date: Tue, 18 Apr 2023 14:22:18 +0200
Message-Id: <20230418120314.094549503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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

commit 52cc02b910284d6bddba46cce402044ab775f314 upstream.

LLVM_IAS is the user interface to set the -(no-)integrated-as flag,
and it should be used only for that purpose.

LLVM_IAS is checked in some places to determine the assembler type,
but it is not precise.

For example,

 $ make CC=gcc LLVM_IAS=1

... will use the GNU assembler (i.e. binutils) since LLVM_IAS=1 is
effective only when $(CC) is clang.

Of course, 'CC=gcc LLVM_IAS=1' is an odd combination, but the build
system can be more robust against such insane input.

Commit ba64beb17493a ("kbuild: check the minimum assembler version in
Kconfig") introduced CONFIG_AS_IS_GNU/LLVM, which is more precise
because Kconfig checks the version string from the assembler in use.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
[nathan: Backport to 5.10]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile            |    2 +-
 arch/riscv/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -851,7 +851,7 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifeq ($(LLVM_IAS),1)
+ifdef CONFIG_AS_IS_LLVM
 KBUILD_AFLAGS	+= -g
 else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -40,7 +40,7 @@ ifeq ($(CONFIG_LD_IS_LLD),y)
 ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
-ifneq ($(LLVM_IAS),1)
+ifndef CONFIG_AS_IS_LLVM
 	KBUILD_CFLAGS += -Wa,-mno-relax
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif


