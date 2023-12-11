Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0623C51C5C;
	Mon, 11 Dec 2023 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0Dkgjq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE69C433C7;
	Mon, 11 Dec 2023 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321132;
	bh=AQU6NnDjI5LcAbXr3aHcvW2C/ioIbGfmnzG9WyLW/eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0Dkgjq3qhtJ7zzSdxjx0F02cDD/JRiQ2f/DRMDFyjQIQ1w4/9JwC1gCW27gYk3iX
	 heLxVIxgZg5pXGs/VeaBN6zMLXmQjEXT3xXS3u0bb7ZQnFUJItAo8D/w2xK9gcFpO2
	 vo1lUkMPGbyAAU7GeF1/3eTwEpOZQVi6nqseNM00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.15 121/141] Kbuild: use -Wdeclaration-after-statement
Date: Mon, 11 Dec 2023 19:23:00 +0100
Message-ID: <20231211182031.821388143@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 4d94f910e79a349b00a4f8aab6f3ae87129d8c5a ]

The kernel is moving from using `-std=gnu89` to `-std=gnu11`, permitting
the use of additional C11 features such as for-loop initial declarations.

One contentious aspect of C99 is that it permits mixed declarations and
code, and for now at least, it seems preferable to enforce that
declarations must come first.

These warnings were already enabled in the kernel itself, but not
for KBUILD_USERCFLAGS or the compat VDSO on arch/arm64, which uses
a separate set of CFLAGS.

This patch fixes an existing violation in modpost.c, which is not
reported because of the missing flag in KBUILD_USERCFLAGS:

| scripts/mod/modpost.c: In function ‘match’:
| scripts/mod/modpost.c:837:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
|   837 |   const char *endp = p + strlen(p) - 1;
|       |   ^~~~~

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[arnd: don't add a duplicate flag to the default set, update changelog]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang v13.0.0 (x86-64)
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: e8c07082a810 ("Kbuild: move to -std=gnu11")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                          | 3 ++-
 arch/arm64/kernel/vdso32/Makefile | 1 +
 scripts/mod/modpost.c             | 4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 678e712591f89..5976e71522607 100644
--- a/Makefile
+++ b/Makefile
@@ -440,7 +440,8 @@ endif
 HOSTPKG_CONFIG	= pkg-config
 
 export KBUILD_USERCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
-			      -O2 -fomit-frame-pointer -std=gnu89
+			      -O2 -fomit-frame-pointer -std=gnu89 \
+			      -Wdeclaration-after-statement
 export KBUILD_USERLDFLAGS :=
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERCFLAGS) $(HOST_LFS_CFLAGS) $(HOSTCFLAGS)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 83e9399e38368..50cb1ec092ae5 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -76,6 +76,7 @@ VDSO_CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                -fno-strict-aliasing -fno-common \
                -Werror-implicit-function-declaration \
                -Wno-format-security \
+               -Wdeclaration-after-statement \
                -std=gnu89
 VDSO_CFLAGS  += -O2
 # Some useful compiler-dependent flags from top-level Makefile
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c6e655e0ed988..945f9ecb34079 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -833,8 +833,10 @@ static int match(const char *sym, const char * const pat[])
 {
 	const char *p;
 	while (*pat) {
+		const char *endp;
+
 		p = *pat++;
-		const char *endp = p + strlen(p) - 1;
+		endp = p + strlen(p) - 1;
 
 		/* "*foo*" */
 		if (*p == '*' && *endp == '*') {
-- 
2.42.0



