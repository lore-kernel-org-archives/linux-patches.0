Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318A4477FD;
	Mon, 17 Aug 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980404; cv=none; b=MlMEQcJ+SL2rePtiCebRl74a6w2xRZsXlwlGhXY4yJ2Obdn8Z0zXMeA6qrQa9njxJoCmpdQyE+mPDygmND9mTH66zefyyUSce1sWoccVBGiqh1c/YyJwoBJDGg7rikdngPN9hHMipEj0qf6IGOrTLDOvL9CgS2953UXQfFELi1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980404; c=relaxed/simple;
	bh=BS/tRmsBF5h8z2KRsJm3aZjOOZroiZ0xlzLGXMW63zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHKWjGxBpjBCQbZ+9mDuf/WCvLhE7Idq54pEiMLRJmj1FsOQs0gbu94fVpjaZOaba60JA8BxqIfPzB4VmOILzWNigVxyIRoL/t/9DLL0ih5D8enxitpmieMptmEj3xHe+AoeL+Jlc1sfMQAdwiLyWNY4EXurl/nH+zCc1MOqoq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfbHRSym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfbHRSym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6399F1F000E9;
	Mon, 17 Aug 2026 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980402;
	bh=zc6bINWz23IbLFz0Qhytt7JUrSLt2B36+Le9f+uuzdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfbHRSymUlLn4PSmfLuw9WHkB7/0MoIEuqiUDzWbHTQRnZh3w8PrGWQ2CTu3CQqiV
	 EwxZE+hRMcwGbLOvZqbwayER6gpq104Be3hDk0qbJBcOOSAvIDcb2qsyCT2POd7d0X
	 fmr6yw1F7O4zZ0hbQ9sMMKaNzlTCmfimgivbTOmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 560/609] fortify: refactor test_fortify Makefile to fix some build problems
Date: Mon, 17 Aug 2026 15:34:16 +0200
Message-ID: <20260817132602.469453799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 4e9903b0861c9df3464b82db4a7025863bac1897 upstream.

There are some issues in the test_fortify Makefile code.

Problem 1: cc-disable-warning invokes compiler dozens of times

To see how many times the cc-disable-warning is evaluated, change
this code:

  $(call cc-disable-warning,fortify-source)

to:

  $(call cc-disable-warning,$(shell touch /tmp/fortify-$$$$)fortify-source)

Then, build the kernel with CONFIG_FORTIFY_SOURCE=y. You will see a
large number of '/tmp/fortify-<PID>' files created:

  $ ls -1 /tmp/fortify-* | wc
       80      80    1600

This means the compiler was invoked 80 times just for checking the
-Wno-fortify-source flag support.

$(call cc-disable-warning,fortify-source) should be added to a simple
variable instead of a recursive variable.

Problem 2: do not recompile string.o when the test code is updated

The test cases are independent of the kernel. However, when the test
code is updated, $(obj)/string.o is rebuilt and vmlinux is relinked
due to this dependency:

  $(obj)/string.o: $(obj)/$(TEST_FORTIFY_LOG)

always-y is suitable for building the log files.

Problem 3: redundant code

  clean-files += $(addsuffix .o, $(TEST_FORTIFY_LOGS))

... is unneeded because the top Makefile globally cleans *.o files.

This commit fixes these issues and makes the code readable.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240727150302.1823750-2-masahiroy@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
[nathan: Fixed conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/.gitignore              |  2 --
 lib/Makefile                | 34 +---------------------------------
 lib/test_fortify/.gitignore |  2 ++
 lib/test_fortify/Makefile   | 28 ++++++++++++++++++++++++++++
 scripts/remove-stale-files  |  2 ++
 5 files changed, 33 insertions(+), 35 deletions(-)
 create mode 100644 lib/test_fortify/.gitignore
 create mode 100644 lib/test_fortify/Makefile

diff --git a/lib/.gitignore b/lib/.gitignore
index 54596b634ecbf..101a4aa92fb53 100644
--- a/lib/.gitignore
+++ b/lib/.gitignore
@@ -5,5 +5,3 @@
 /gen_crc32table
 /gen_crc64table
 /oid_registry_data.c
-/test_fortify.log
-/test_fortify/*.log
diff --git a/lib/Makefile b/lib/Makefile
index 6ae66e13f3194..1081d0c161159 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -394,36 +394,4 @@ CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
-# FORTIFY_SOURCE compile-time behavior tests
-TEST_FORTIFY_SRCS = $(wildcard $(srctree)/$(src)/test_fortify/*-*.c)
-TEST_FORTIFY_LOGS = $(patsubst $(srctree)/$(src)/%.c, %.log, $(TEST_FORTIFY_SRCS))
-TEST_FORTIFY_LOG = test_fortify.log
-
-quiet_cmd_test_fortify = TEST    $@
-      cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
-			$< $@ "$(NM)" $(CC) $(c_flags) \
-			$(call cc-disable-warning,fortify-source) \
-			-DKBUILD_EXTRA_WARN1
-
-targets += $(TEST_FORTIFY_LOGS)
-clean-files += $(TEST_FORTIFY_LOGS)
-clean-files += $(addsuffix .o, $(TEST_FORTIFY_LOGS))
-$(obj)/test_fortify/%.log: $(src)/test_fortify/%.c \
-			   $(src)/test_fortify/test_fortify.h \
-			   $(srctree)/include/linux/fortify-string.h \
-			   $(srctree)/scripts/test_fortify.sh \
-			   FORCE
-	$(call if_changed,test_fortify)
-
-quiet_cmd_gen_fortify_log = GEN     $@
-      cmd_gen_fortify_log = cat </dev/null $(filter-out FORCE,$^) 2>/dev/null > $@ || true
-
-targets += $(TEST_FORTIFY_LOG)
-clean-files += $(TEST_FORTIFY_LOG)
-$(obj)/$(TEST_FORTIFY_LOG): $(addprefix $(obj)/, $(TEST_FORTIFY_LOGS)) FORCE
-	$(call if_changed,gen_fortify_log)
-
-# Fake dependency to trigger the fortify tests.
-ifeq ($(CONFIG_FORTIFY_SOURCE),y)
-$(obj)/string.o: $(obj)/$(TEST_FORTIFY_LOG)
-endif
+subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
diff --git a/lib/test_fortify/.gitignore b/lib/test_fortify/.gitignore
new file mode 100644
index 0000000000000..c1ba37d14b50e
--- /dev/null
+++ b/lib/test_fortify/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/*.log
diff --git a/lib/test_fortify/Makefile b/lib/test_fortify/Makefile
new file mode 100644
index 0000000000000..7887e6126e79c
--- /dev/null
+++ b/lib/test_fortify/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+
+ccflags-y := $(call cc-disable-warning,fortify-source)
+
+quiet_cmd_test_fortify = TEST    $@
+      cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
+			$< $@ "$(NM)" $(CC) $(c_flags) -DKBUILD_EXTRA_WARN1
+
+$(obj)/%.log: $(src)/%.c $(srctree)/scripts/test_fortify.sh \
+	      $(src)/test_fortify.h \
+	      $(srctree)/include/linux/fortify-string.h \
+	      FORCE
+	$(call if_changed,test_fortify)
+
+logs = $(patsubst $(srctree)/$(src)/%.c, %.log, $(wildcard $(srctree)/$(src)/*-*.c))
+targets += $(logs)
+
+quiet_cmd_gen_fortify_log = CAT     $@
+      cmd_gen_fortify_log = cat $(or $(real-prereqs),/dev/null) > $@
+
+$(obj)/test_fortify.log: $(addprefix $(obj)/, $(logs)) FORCE
+	$(call if_changed,gen_fortify_log)
+
+always-y += test_fortify.log
+
+# Some architectures define __NO_FORTIFY if __SANITIZE_ADDRESS__ is undefined.
+# Pass CFLAGS_KASAN to avoid warnings.
+KASAN_SANITIZE := y
diff --git a/scripts/remove-stale-files b/scripts/remove-stale-files
index ccadfa3afb2b8..c22fe4630bac0 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -47,3 +47,5 @@ rm -f arch/riscv/purgatory/kexec-purgatory.c
 rm -f scripts/extract-cert
 
 rm -f arch/x86/purgatory/kexec-purgatory.c
+
+rm -f lib/test_fortify.log
-- 
2.53.0



