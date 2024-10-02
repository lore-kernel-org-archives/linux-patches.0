Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C931D0953;
	Wed,  2 Oct 2024 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879623; cv=none; b=gLU7Ol7q7GDv8TqFQNkpGQI/7lLjgSp8mHH/G05eliLv4HEPjfy9yDYcupqxHofTr0AUCahULTiYkrzuuX8fADLxWzGw9qnge1y8CTnLZlMvxM9PfTp8XNnqxTU9/SwM5iGstw0ZgYECYm2ZuowobDSB86u+aDeUiNTiIVLTY6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879623; c=relaxed/simple;
	bh=VK8pPoKCMgzastEweajGOfjFiBcyCGhoAu6HkvhPdI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hx871jQLMBRazMcmjzt5TulOfytrvlch5s0xwfbP9Rzzt9oKq/oAgvbwUjphnmyhcEHDGz1+HNTTrM60K1YgQ63MTnQtrmR7gHh18EZCKIrWU+afi/s5G5+Iup3RCFHkm0c1D4ZfKwLDsKT+gZz+teUqDvrYujfQ/metxxs+U30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yslMT1yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yslMT1yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9A3C4CECD;
	Wed,  2 Oct 2024 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879622;
	bh=VK8pPoKCMgzastEweajGOfjFiBcyCGhoAu6HkvhPdI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yslMT1yudFWzXGlqdyf4S+rHL0DE5eqqHeFF3v0nBNzJDLmAwau3pz+5pAVsTAZ1e
	 G/fm/Tahoza62IYSYOcB2oOJ5BgDHBzH111QKYG0UQB48xrcN1pJyTkmjDl0rxEGaB
	 3WYHq3WYnVrEu1O+A6TTwe4UvaII4mcYsH0QWmeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/538] bpf: Use -Wno-error in certain tests when building with GCC
Date: Wed,  2 Oct 2024 14:57:01 +0200
Message-ID: <20241002125759.440864925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose E. Marchesi <jose.marchesi@oracle.com>

[ Upstream commit 646751d523587cfd7ebcf1733298ecd470879eda ]

Certain BPF selftests contain code that, albeit being legal C, trigger
warnings in GCC that cannot be disabled.  This is the case for example
for the tests

  progs/btf_dump_test_case_bitfields.c
  progs/btf_dump_test_case_namespacing.c
  progs/btf_dump_test_case_packing.c
  progs/btf_dump_test_case_padding.c
  progs/btf_dump_test_case_syntax.c

which contain struct type declarations inside function parameter
lists.  This is problematic, because:

- The BPF selftests are built with -Werror.

- The Clang and GCC compilers sometimes differ when it comes to handle
  warnings.  in the handling of warnings.  One compiler may emit
  warnings for code that the other compiles compiles silently, and one
  compiler may offer the possibility to disable certain warnings, while
  the other doesn't.

In order to overcome this problem, this patch modifies the
tools/testing/selftests/bpf/Makefile in order to:

1. Enable the possibility of specifing per-source-file extra CFLAGS.
   This is done by defining a make variable like:

   <source-filename>-CFLAGS := <whateverflags>

   And then modifying the proper Make rule in order to use these flags
   when compiling <source-filename>.

2. Use the mechanism above to add -Wno-error to CFLAGS for the
   following selftests:

   progs/btf_dump_test_case_bitfields.c
   progs/btf_dump_test_case_namespacing.c
   progs/btf_dump_test_case_packing.c
   progs/btf_dump_test_case_padding.c
   progs/btf_dump_test_case_syntax.c

   Note the corresponding -CFLAGS variables for these files are
   defined only if the selftests are being built with GCC.

Note that, while compiler pragmas can generally be used to disable
particular warnings per file, this 1) is only possible for warning
that actually can be disabled in the command line, i.e. that have
-Wno-FOO options, and 2) doesn't apply to -Wno-error.

Tested in bpf-next master branch.
No regressions.

Signed-off-by: Jose E. Marchesi <jose.marchesi@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240127100702.21549-1-jose.marchesi@oracle.com
Stable-dep-of: 3ece93a4087b ("selftests/bpf: Fix wrong binary in Makefile log output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 598cd118dfd65..397306f5cf911 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -56,6 +56,15 @@ TEST_INST_SUBDIRS := no_alu32
 ifneq ($(BPF_GCC),)
 TEST_GEN_PROGS += test_progs-bpf_gcc
 TEST_INST_SUBDIRS += bpf_gcc
+
+# The following tests contain C code that, although technically legal,
+# triggers GCC warnings that cannot be disabled: declaration of
+# anonymous struct types in function parameter lists.
+progs/btf_dump_test_case_bitfields.c-CFLAGS := -Wno-error
+progs/btf_dump_test_case_namespacing.c-CFLAGS := -Wno-error
+progs/btf_dump_test_case_packing.c-CFLAGS := -Wno-error
+progs/btf_dump_test_case_padding.c-CFLAGS := -Wno-error
+progs/btf_dump_test_case_syntax.c-CFLAGS := -Wno-error
 endif
 
 ifneq ($(CLANG_CPUV4),)
@@ -492,7 +501,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.bpf.o:				\
 		     $(wildcard $(BPFDIR)/*.bpf.h)			\
 		     | $(TRUNNER_OUTPUT) $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
-					  $(TRUNNER_BPF_CFLAGS))
+					  $(TRUNNER_BPF_CFLAGS)         \
+					  $$($$<-CFLAGS))
 
 $(TRUNNER_BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-- 
2.43.0



