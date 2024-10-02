Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89F31D042F;
	Wed,  2 Oct 2024 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878000; cv=none; b=M0VQDSxOn6BIPyebJuGdOxjTOfQ5/jXmVraqg0MHbUQ/Jk9a/pu3240GwnYU1qop16BxqrYN2YmZcK2gUVkXjcCZSCxmHdfl/mW1v8ZFxQvsm9RdsH4L4f+0IQslePKCf3ysofRtAYSSZCfNSgrABffQRnJVGAk3IsXTzCZl7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878000; c=relaxed/simple;
	bh=q8gABAyunHWRhw9dDQv32YUMTqcVIrPgXcFYvuSuN9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYcUGpAoI6pIP726kyYn9A2iuNkwPCBp8sl0G2qCIE/HLkDg8FbZUlPQ3wol3mx/cV7hVig/h/TTrbvqEZJVK0xYtT4ZLDBvNZDtf0odCueViXGauvXRxL/c1oNRy+GRy/Z2ZnIPodjoj9qqAnD55B+Z9sVLVnQWX9AvNdViGKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU0L9QZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU0L9QZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AEAC4CEC2;
	Wed,  2 Oct 2024 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878000;
	bh=q8gABAyunHWRhw9dDQv32YUMTqcVIrPgXcFYvuSuN9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SU0L9QZhvIC4LJ2FNpRNIq2wnjCgiOe3PT9yDxHuZ2rdViYWXCDzHNZekd3jw4qNk
	 sJLqziTxyVzREDIxN8o+Uc6ZgmWufWCBxGv7NEW5jURN8VasWO4BfxkOMV6dNRO5Ay
	 wNlKt5mwy/CFCgEQLpLhv75qHvaKhHi1zYIvIUjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 266/634] selftests/bpf: __arch_* macro to limit test cases to specific archs
Date: Wed,  2 Oct 2024 14:56:06 +0200
Message-ID: <20241002125821.600277906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit ee7fe84468b1732fe65c5af3836437d54ac4c419 ]

Add annotations __arch_x86_64, __arch_arm64, __arch_riscv64
to specify on which architecture the test case should be tested.
Several __arch_* annotations could be specified at once.
When test case is not run on current arch it is marked as skipped.

For example, the following would be tested only on arm64 and riscv64:

  SEC("raw_tp")
  __arch_arm64
  __arch_riscv64
  __xlated("1: *(u64 *)(r10 - 16) = r1")
  __xlated("2: call")
  __xlated("3: r1 = *(u64 *)(r10 - 16);")
  __success
  __naked void canary_arm64_riscv64(void)
  {
  	asm volatile (
  	"r1 = 1;"
  	"*(u64 *)(r10 - 16) = r1;"
  	"call %[bpf_get_smp_processor_id];"
  	"r1 = *(u64 *)(r10 - 16);"
  	"exit;"
  	:
  	: __imm(bpf_get_smp_processor_id)
  	: __clobber_all);
  }

On x86 it would be skipped:

  #467/2   verifier_nocsr/canary_arm64_riscv64:SKIP

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240722233844.1406874-10-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: f00bb757ed63 ("selftests/bpf: fix to avoid __msg tag de-duplication by clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h |  8 ++++
 tools/testing/selftests/bpf/test_loader.c    | 43 ++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index 6c24e09df7d2b..078268a19b773 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -63,6 +63,10 @@
  * __auxiliary         Annotated program is not a separate test, but used as auxiliary
  *                     for some other test cases and should always be loaded.
  * __auxiliary_unpriv  Same, but load program in unprivileged mode.
+ *
+ * __arch_*          Specify on which architecture the test case should be tested.
+ *                   Several __arch_* annotations could be specified at once.
+ *                   When test case is not run on current arch it is marked as skipped.
  */
 #define __msg(msg)		__attribute__((btf_decl_tag("comment:test_expect_msg=" msg)))
 #define __regex(regex)		__attribute__((btf_decl_tag("comment:test_expect_regex=" regex)))
@@ -82,6 +86,10 @@
 #define __auxiliary		__attribute__((btf_decl_tag("comment:test_auxiliary")))
 #define __auxiliary_unpriv	__attribute__((btf_decl_tag("comment:test_auxiliary_unpriv")))
 #define __btf_path(path)	__attribute__((btf_decl_tag("comment:test_btf_path=" path)))
+#define __arch(arch)		__attribute__((btf_decl_tag("comment:test_arch=" arch)))
+#define __arch_x86_64		__arch("X86_64")
+#define __arch_arm64		__arch("ARM64")
+#define __arch_riscv64		__arch("RISCV64")
 
 /* Convenience macro for use with 'asm volatile' blocks */
 #define __naked __attribute__((naked))
diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index b44b6a2fc82ce..12b0c41e8d64c 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -34,6 +34,7 @@
 #define TEST_TAG_AUXILIARY "comment:test_auxiliary"
 #define TEST_TAG_AUXILIARY_UNPRIV "comment:test_auxiliary_unpriv"
 #define TEST_BTF_PATH "comment:test_btf_path="
+#define TEST_TAG_ARCH "comment:test_arch="
 
 /* Warning: duplicated in bpf_misc.h */
 #define POINTER_VALUE	0xcafe4all
@@ -80,6 +81,7 @@ struct test_spec {
 	int log_level;
 	int prog_flags;
 	int mode_mask;
+	int arch_mask;
 	bool auxiliary;
 	bool valid;
 };
@@ -213,6 +215,12 @@ static void update_flags(int *flags, int flag, bool clear)
 		*flags |= flag;
 }
 
+enum arch {
+	ARCH_X86_64	= 0x1,
+	ARCH_ARM64	= 0x2,
+	ARCH_RISCV64	= 0x4,
+};
+
 /* Uses btf_decl_tag attributes to describe the expected test
  * behavior, see bpf_misc.h for detailed description of each attribute
  * and attribute combinations.
@@ -226,6 +234,7 @@ static int parse_test_spec(struct test_loader *tester,
 	bool has_unpriv_result = false;
 	bool has_unpriv_retval = false;
 	int func_id, i, err = 0;
+	u32 arch_mask = 0;
 	struct btf *btf;
 
 	memset(spec, 0, sizeof(*spec));
@@ -364,11 +373,26 @@ static int parse_test_spec(struct test_loader *tester,
 					goto cleanup;
 				update_flags(&spec->prog_flags, flags, clear);
 			}
+		} else if (str_has_pfx(s, TEST_TAG_ARCH)) {
+			val = s + sizeof(TEST_TAG_ARCH) - 1;
+			if (strcmp(val, "X86_64") == 0) {
+				arch_mask |= ARCH_X86_64;
+			} else if (strcmp(val, "ARM64") == 0) {
+				arch_mask |= ARCH_ARM64;
+			} else if (strcmp(val, "RISCV64") == 0) {
+				arch_mask |= ARCH_RISCV64;
+			} else {
+				PRINT_FAIL("bad arch spec: '%s'", val);
+				err = -EINVAL;
+				goto cleanup;
+			}
 		} else if (str_has_pfx(s, TEST_BTF_PATH)) {
 			spec->btf_custom_path = s + sizeof(TEST_BTF_PATH) - 1;
 		}
 	}
 
+	spec->arch_mask = arch_mask;
+
 	if (spec->mode_mask == 0)
 		spec->mode_mask = PRIV;
 
@@ -677,6 +701,20 @@ static int get_xlated_program_text(int prog_fd, char *text, size_t text_sz)
 	return err;
 }
 
+static bool run_on_current_arch(int arch_mask)
+{
+	if (arch_mask == 0)
+		return true;
+#if defined(__x86_64__)
+	return arch_mask & ARCH_X86_64;
+#elif defined(__aarch64__)
+	return arch_mask & ARCH_ARM64;
+#elif defined(__riscv) && __riscv_xlen == 64
+	return arch_mask & ARCH_RISCV64;
+#endif
+	return false;
+}
+
 /* this function is forced noinline and has short generic name to look better
  * in test_progs output (in case of a failure)
  */
@@ -701,6 +739,11 @@ void run_subtest(struct test_loader *tester,
 	if (!test__start_subtest(subspec->name))
 		return;
 
+	if (!run_on_current_arch(spec->arch_mask)) {
+		test__skip();
+		return;
+	}
+
 	if (unpriv) {
 		if (!can_execute_unpriv(tester, spec)) {
 			test__skip();
-- 
2.43.0



