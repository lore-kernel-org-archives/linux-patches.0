Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B2821CC5C;
	Mon, 17 Aug 2026 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978608; cv=none; b=GY1aPdkTgFBYMma5ONtZmTHbb4gi0xg/447kMnk39b4UHDzeVRPsB69ahtRSU/6DKy+0HZ/V0HlGg39WCV/vffLKik7LA1AN75dJz2UGOgiZXQrjNXRLYCz506jAeYucidi0hjII+JfE6JB9JYrMHgRuJ77TtQRRjLXrOdXusWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978608; c=relaxed/simple;
	bh=a5BeRxFhfhyNlDMLAmwl0EqWlTm0ycU8RezrHWtX8QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy1/O/0YYqX441GLjDHCDELz0fSCaFTTm/JUBM2St2JZEdWkscZ2ZFU96d6tDtBfkX3wE4foQ0JlBPoDJ1QFN+ZtVbOgH1x6ryGUvqql0V7TPMqQIBtHGzLa+LDORW3x2TchSdC+0HkwyjGITEzMnhmoMYpLlNgD8YNr00lblS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1Cy7ui2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1Cy7ui2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFFA1F00A3A;
	Mon, 17 Aug 2026 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978607;
	bh=qrex3BcQ2PoUoYp3kOU3GBA5imBKRyjhJA//5iReZgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1Cy7ui2dswSkynFs6uaaYq/zeAPBuvSesb0TcWf9TzEhJvRdUkMPdLlnis0GzAAN
	 pVf7mXvlKLE+SZ0A75IhWqXMz7ypQZV82CdnzqHHrBF2c9e9b6EQ/KCj7ktoSZTJN6
	 TRbVFINwHEcFnFtDCk6CbvjjZT13qKegdhz5Z+RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/156] fortify: refactor test_fortify Makefile to fix some build problems
Date: Mon, 17 Aug 2026 15:33:50 +0200
Message-ID: <20260817132538.374840037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b9d2577fbbe19..62737ad5aa74e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -407,36 +407,4 @@ CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 
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
index 8b1a636f85434..38eb84eb605b6 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -39,3 +39,5 @@ rm -rf include/ksym
 find . -name '*.usyms' | xargs rm -f
 
 rm -f binkernel.spec
+
+rm -f lib/test_fortify.log
-- 
2.53.0



