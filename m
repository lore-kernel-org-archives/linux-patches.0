Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA87E4;
	Tue,  6 Jun 2023 22:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC8DC433D2;
	Tue,  6 Jun 2023 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686091249;
	bh=7ULdjUkdkkr+vu+/oiYN5S/oKq5p52x/BGvXGSKtQA8=;
	h=From:Date:Subject:To:Cc:From;
	b=CUso6cj4sWCjd3IHr9SOnT1MzY0q52hnzeOgY8b/Wam8mw1Xizs7ob1Z5kPstvvzi
	 4kxZBFIkml3VaoGrimFZMqGJ/kEYDFrzerXemdYyDLVfcUEI9gUq4X1fg4PSWKJjQ0
	 E7UAqrfcwU6q9up0ZF37rzOQB8dOIJORgyQ3hVugmQuDEsWvlt56zaO1ssrc/FKRcU
	 r9RAULcvNQfJmnQL8JDh+7foByANVLItqgYZOTOZtrg+cFN/D8QQ7FmNKVEnshV/q7
	 M2F8cmZUiuXNP0lFkPzyyogkfMGwRG2Sh4nqjjFY8kdZUIpuXgoHATGOgBtfpgJTdu
	 GInV+uJmiL19Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 06 Jun 2023 15:40:35 -0700
Subject: [PATCH] kbuild: Add KBUILD_CPPFLAGS to as-option invocation
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230606-fix-as-option-after-clang_flags-move-v1-1-a7f7b23a35e3@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOK1f2QC/1WOwQqDMBBEf0Vy7tJUi2h/pUjZpJsYsIlsghTEf
 ++aW48zvHnMrjJxoKweza6YtpBDihJul0bZGaMnCG/JqtVtp3vdgwtfwAxpLUICukIMdhHy5Rb
 0GT5pIzA0DDSOnTWISlQGs5SM0c6nzNyv/5oqgILsqVTDOVqZhKrfntNx/ACaqV1RqwAAAA==
To: masahiroy@kernel.org
Cc: naresh.kamboju@linaro.org, ndesaulniers@google.com, nicolas@fjasle.eu, 
 trix@redhat.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Linux Kernel Functional Testing <lkft@linaro.org>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2639; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7ULdjUkdkkr+vu+/oiYN5S/oKq5p52x/BGvXGSKtQA8=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCn1Wz8ccKgqU+TL4JT3k1OXmKLxJub2x5UmLzd+c7mma
 ZAgMnl+RykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIETcjw4xnpyL+NfFJcu37
 +Flsc35yup/q9b2vVn1OCGabIfdR9grDP3W3YDMH8Xnbf2b8Or5q49J5KWkl259vubpb4zZ3/Kc
 785kB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit feb843a469fb ("kbuild: add $(CLANG_FLAGS) to
KBUILD_CPPFLAGS"), there is an error while building certain PowerPC
assembly files with clang:

  arch/powerpc/lib/copypage_power7.S: Assembler messages:
  arch/powerpc/lib/copypage_power7.S:34: Error: junk at end of line: `0b01000'
  arch/powerpc/lib/copypage_power7.S:35: Error: junk at end of line: `0b01010'
  arch/powerpc/lib/copypage_power7.S:37: Error: junk at end of line: `0b01000'
  arch/powerpc/lib/copypage_power7.S:38: Error: junk at end of line: `0b01010'
  arch/powerpc/lib/copypage_power7.S:40: Error: junk at end of line: `0b01010'
  clang: error: assembler command failed with exit code 1 (use -v to see invocation)

as-option only uses KBUILD_AFLAGS, so after removing CLANG_FLAGS from
KBUILD_AFLAGS, there is no more '--target=' or '--prefix=' flags. As a
result of those missing flags, the host target
will be tested during as-option calls and likely fail, meaning necessary
flags may not get added when building assembly files, resulting in
errors like seen above.

Add KBUILD_CPPFLAGS to as-option invocations to clear up the errors.
This should have been done in commit d5c8d6e0fa61 ("kbuild: Update
assembler calls to use proper flags and language target"), which
switched from using the assembler target to the assembler-with-cpp
target, so flags that affect preprocessing are passed along in all
relevant tests. as-option now mirrors cc-option.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/CA+G9fYs=koW9WardsTtora+nMgLR3raHz-LSLr58tgX4T5Mxag@mail.gmail.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 scripts/Makefile.compiler | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
index 437013f8def3..e31f18625fcf 100644
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -32,7 +32,7 @@ try-run = $(shell set -e;		\
 # Usage: aflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
 
 as-option = $(call try-run,\
-	$(CC) -Werror $(KBUILD_AFLAGS) $(1) -c -x assembler-with-cpp /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(1) -c -x assembler-with-cpp /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
 # Usage: aflags-y += $(call as-instr,instr,option1,option2)

---
base-commit: feb843a469fb0ab00d2d23cfb9bcc379791011bb
change-id: 20230606-fix-as-option-after-clang_flags-move-be88e993cbaa

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

