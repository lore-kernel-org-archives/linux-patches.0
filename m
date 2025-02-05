Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251F418A6A8;
	Wed,  5 Feb 2025 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768484; cv=none; b=TEgehqf4j16lbpF6sQTCQ9lxFOe8ljAgQb7Trw4M53dVZHosZ9etyGWsBmlwJO+Wl4EARqnIeF7iQ3pK8ePWeSkcUtLIHuByIVJp+ofd8V4+Qsc1iDSpP//rOvdGXlnf8TjzqhfP8/yo/2N3VyEJw4gXfv4VkpXe6jgxiQA2e9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768484; c=relaxed/simple;
	bh=tTvZ8NI0TeX+kGs+gogtP9E+v2YPnzZjvxqzTZ7eMRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4P1LpSjZinBbXx9bbA8GkoqvLjjWdZOJ7GQ5w0/DUjflsspVJ/+s+1uewS4Pz9oB5Ajdu8Rrcd4tF8u5Bgeg+0J/UzbLl4QdHxEbtYwetoRdh0iYOL9ZnbGc+8AMVPmQ00RuYaHTUsSOdf1x++vhheNdhPmzHIMaa+W+GAl1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVVF0VLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVVF0VLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A19C4CED1;
	Wed,  5 Feb 2025 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768483;
	bh=tTvZ8NI0TeX+kGs+gogtP9E+v2YPnzZjvxqzTZ7eMRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVVF0VLFcZ5fIHU3CZW8eFiMiMDHWS5NaIE1HV5ggPpwUYuJJgsNl8jYOZ0w065uM
	 0bFYRrc1d2D/o5FoT3vH708fDv+ufm+pYwQAKBL7rZge/DoO7wuF9q2iwKI1rtnqQq
	 FGzc6QdroWDiW0vtifc3dqIXPTaIn5tIEhRELw3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 570/623] kbuild: fix Clang LTO with CONFIG_OBJTOOL=n
Date: Wed,  5 Feb 2025 14:45:12 +0100
Message-ID: <20250205134518.023967439@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 695ed93bb30e03e9f826ee70abdd83f970741a37 ]

Since commit bede169618c6 ("kbuild: enable objtool for *.mod.o and
additional kernel objects"), Clang LTO builds do not perform any
optimizations when CONFIG_OBJTOOL is disabled (e.g., for ARCH=arm64).
This is because every LLVM bitcode file is immediately converted to
ELF format before the object files are linked together.

This commit fixes the breakage.

Fixes: bede169618c6 ("kbuild: enable objtool for *.mod.o and additional kernel objects")
Reported-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build |  2 ++
 scripts/Makefile.lib   | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index c16e4cf54d770..0b85bf27598a8 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -183,7 +183,9 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 
 is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
 
+ifdef CONFIG_OBJTOOL
 $(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
+endif
 
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 cmd_warn_shared_object = $(if $(word 2, $(modname-multi)),$(warning $(kbuild-file): $*.o is added to multiple modules: $(modname-multi)))
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7395200538da8..2e280a02e9e65 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -287,6 +287,8 @@ delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT))
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
 
+objtool-enabled := y
+
 endif # CONFIG_OBJTOOL
 
 # Useful for describing the dependency of composite objects
@@ -302,11 +304,11 @@ endef
 # ===========================================================================
 # These are shared by some Makefile.* files.
 
-objtool-enabled := y
-
 ifdef CONFIG_LTO_CLANG
-# objtool cannot process LLVM IR. Make $(LD) covert LLVM IR to ELF here.
-cmd_ld_single = $(if $(objtool-enabled), ; $(LD) $(ld_flags) -r -o $(tmp-target) $@; mv $(tmp-target) $@)
+# Run $(LD) here to covert LLVM IR to ELF in the following cases:
+#  - when this object needs objtool processing, as objtool cannot process LLVM IR
+#  - when this is a single-object module, as modpost cannot process LLVM IR
+cmd_ld_single = $(if $(objtool-enabled)$(is-single-obj-m), ; $(LD) $(ld_flags) -r -o $(tmp-target) $@; mv $(tmp-target) $@)
 endif
 
 quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@
-- 
2.39.5



