Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEAC8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C821BC433C9;
	Sun, 16 Jul 2023 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538747;
	bh=seFkwHfovXlqN6zLMnKQGR6B2zS52l9j10g99w64Aro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrBQzRIuXLwX5l51Xt0NaAHh7+pwIKVI7MebF1VC+Kt2BRhyiQmuOFV3mUrcNCcGP
	 mtplQ1U4kjjtwZa+xDuNonvURGDToqgTTSO94/TCzE64f22PCGs3Weag0cv7GbPDVs
	 5ONBosRYA7c0+xSOkM6eBfWdD6R7lBEZTjOD+NMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Fradley <joefradley@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 532/800] kbuild: Fix CFI failures with GCOV
Date: Sun, 16 Jul 2023 21:46:25 +0200
Message-ID: <20230716195001.452204120@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit ddf56288eebd1fe82c46fc9f693b5b18045cddb6 ]

With GCOV_PROFILE_ALL, Clang injects __llvm_gcov_* functions to
each object file, and the functions are indirectly called during
boot. However, when code is injected to object files that are not
part of vmlinux.o, it's also not processed by objtool, which breaks
CFI hash randomization as the hashes in these files won't be
included in the .cfi_sites section and thus won't be randomized.

Similarly to commit 42633ed852de ("kbuild: Fix CFI hash
randomization with KASAN"), disable GCOV for .vmlinux.export.o and
init/version-timestamp.o to avoid emitting unnecessary functions to
object files that don't otherwise have executable code.

Fixes: 0c3e806ec0f9 ("x86/cfi: Add boot time hash randomization")
Reported-by: Joe Fradley <joefradley@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Makefile            | 1 +
 scripts/Makefile.vmlinux | 1 +
 2 files changed, 2 insertions(+)

diff --git a/init/Makefile b/init/Makefile
index 26de459006c4e..ec557ada3c12e 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -60,3 +60,4 @@ include/generated/utsversion.h: FORCE
 $(obj)/version-timestamp.o: include/generated/utsversion.h
 CFLAGS_version-timestamp.o := -include include/generated/utsversion.h
 KASAN_SANITIZE_version-timestamp.o := n
+GCOV_PROFILE_version-timestamp.o := n
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 10176dec97eac..3cd6ca15f390d 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -19,6 +19,7 @@ quiet_cmd_cc_o_c = CC      $@
 
 ifdef CONFIG_MODULES
 KASAN_SANITIZE_.vmlinux.export.o := n
+GCOV_PROFILE_.vmlinux.export.o := n
 targets += .vmlinux.export.o
 vmlinux: .vmlinux.export.o
 endif
-- 
2.39.2



