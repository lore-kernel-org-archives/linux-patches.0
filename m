Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFDA39FE1;
	Fri, 24 Nov 2023 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjTybfsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3942FC433C7;
	Fri, 24 Nov 2023 18:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850376;
	bh=jXgfh+v4s+GLL3PsgJdzetgf0zLjWkqqwVmE+CC9Itg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjTybfshgKN0zI7NNfUhWq+GsNZKqTsJ+CMsgtw30JdIo1P98E3vCPR59s2WjHStD
	 U79vL0n5bd4vholSbf7s6LHr4nr+n0vHtp4I6XnT82pcEfDQ7GbYcVHSHXjZ4HlrVH
	 8i8kyAZk3cuOJrjKEhvKcHKCqRPonv20CPUUxkE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 004/491] x86/retpoline: Make sure there are no unconverted return thunks due to KCSAN
Date: Fri, 24 Nov 2023 17:44:00 +0000
Message-ID: <20231124172024.801191548@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 2d7ce49f58dc95495b3e22e45d2be7de909b2c63 ]

Enabling CONFIG_KCSAN leads to unconverted, default return thunks to
remain after patching.

As David Kaplan describes in his debugging of the issue, it is caused by
a couple of KCSAN-generated constructors which aren't processed by
objtool:

  "When KCSAN is enabled, GCC generates lots of constructor functions
  named _sub_I_00099_0 which call __tsan_init and then return.  The
  returns in these are generally annotated normally by objtool and fixed
  up at runtime.  But objtool runs on vmlinux.o and vmlinux.o does not
  include a couple of object files that are in vmlinux, like
  init/version-timestamp.o and .vmlinux.export.o, both of which contain
  _sub_I_00099_0 functions.  As a result, the returns in these functions
  are not annotated, and the panic occurs when we call one of them in
  do_ctors and it uses the default return thunk.

  This difference can be seen by counting the number of these functions in the object files:
  $ objdump -d vmlinux.o|grep -c "<_sub_I_00099_0>:"
  2601
  $ objdump -d vmlinux|grep -c "<_sub_I_00099_0>:"
  2603

  If these functions are only run during kernel boot, there is no
  speculation concern."

Fix it by disabling KCSAN on version-timestamp.o and .vmlinux.export.o
so the extra functions don't get generated.  KASAN and GCOV are already
disabled for those files.

  [ bp: Massage commit message. ]

Closes: https://lore.kernel.org/lkml/20231016214810.GA3942238@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20231017165946.v4i2d4exyqwqq3bx@treble
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Makefile            | 1 +
 scripts/Makefile.vmlinux | 1 +
 2 files changed, 2 insertions(+)

diff --git a/init/Makefile b/init/Makefile
index ec557ada3c12e..cbac576c57d63 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -60,4 +60,5 @@ include/generated/utsversion.h: FORCE
 $(obj)/version-timestamp.o: include/generated/utsversion.h
 CFLAGS_version-timestamp.o := -include include/generated/utsversion.h
 KASAN_SANITIZE_version-timestamp.o := n
+KCSAN_SANITIZE_version-timestamp.o := n
 GCOV_PROFILE_version-timestamp.o := n
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 3cd6ca15f390d..c9f3e03124d7f 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -19,6 +19,7 @@ quiet_cmd_cc_o_c = CC      $@
 
 ifdef CONFIG_MODULES
 KASAN_SANITIZE_.vmlinux.export.o := n
+KCSAN_SANITIZE_.vmlinux.export.o := n
 GCOV_PROFILE_.vmlinux.export.o := n
 targets += .vmlinux.export.o
 vmlinux: .vmlinux.export.o
-- 
2.42.0



