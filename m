Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52452566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3794CC433EF;
	Tue, 18 Apr 2023 12:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821453;
	bh=99KVA1pyi/31gM2Ys5xODUxM6Ekz4q/O+uSLZ6UzONo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HCPP16RvmjN3JzXzvKvyrAzuhC+rArfhBmZdQVT7JjtcIjafGOsU3MjNUafAoIuB
	 u1ELhcAdF8q/lWpa8TygvbOLUUM/dit55MY3Swe+GQEjMuXME+jIQxXA1XFcIHi3wT
	 LjhMJv0pGSttoNRxUwKjSZ4yHhV7WClYIAjtixu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 118/124] kbuild: Switch to f variants of integrated assembler flag
Date: Tue, 18 Apr 2023 14:22:17 +0200
Message-Id: <20230418120314.063599991@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 2185a7e4b0ade86c2c57fc63d4a7535c40254bd0 upstream.

It has been brought up a few times in various code reviews that clang
3.5 introduced -f{,no-}integrated-as as the preferred way to enable and
disable the integrated assembler, mentioning that -{no-,}integrated-as
are now considered legacy flags.

Switch the kernel over to using those variants in case there is ever a
time where clang decides to remove the non-'f' variants of the flag.

Also, fix a typo in a comment ("intergrated" -> "integrated").

Link: https://releases.llvm.org/3.5.0/tools/clang/docs/ReleaseNotes.html#new-compiler-flags
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: Backport to 5.10]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile              |    4 ++--
 scripts/as-version.sh |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -581,9 +581,9 @@ ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
 ifeq ($(LLVM_IAS),1)
-CLANG_FLAGS	+= -integrated-as
+CLANG_FLAGS	+= -fintegrated-as
 else
-CLANG_FLAGS	+= -no-integrated-as
+CLANG_FLAGS	+= -fno-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
--- a/scripts/as-version.sh
+++ b/scripts/as-version.sh
@@ -21,14 +21,14 @@ get_canonical_version()
 	echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
 }
 
-# Clang fails to handle -Wa,--version unless -no-integrated-as is given.
-# We check -(f)integrated-as, expecting it is explicitly passed in for the
+# Clang fails to handle -Wa,--version unless -fno-integrated-as is given.
+# We check -fintegrated-as, expecting it is explicitly passed in for the
 # integrated assembler case.
 check_integrated_as()
 {
 	while [ $# -gt 0 ]; do
-		if [ "$1" = -integrated-as -o "$1" = -fintegrated-as ]; then
-			# For the intergrated assembler, we do not check the
+		if [ "$1" = -fintegrated-as ]; then
+			# For the integrated assembler, we do not check the
 			# version here. It is the same as the clang version, and
 			# it has been already checked by scripts/cc-version.sh.
 			echo LLVM 0


