Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374FE29CE7;
	Wed,  2 Oct 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876095; cv=none; b=PeaMkmBq6ryCnYN1wY3ZkddvDHO2W9HGY12Pcmw6WZIhBjXoL8uNr55yXMxk3tUzj9M4hUgDv4fhfJK+/yX6LQIGNosE5bgpTc1LKxCcrXN688pKYZQcwhXVdbcQKdSTplCxQ2GYKGnaBOOcAHXS1BgOlwfm5M9+ZfIA8zzPd1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876095; c=relaxed/simple;
	bh=SBpBNAL6Y3mJFnwjytMJdu9DF8ccXsingF32jl7n1vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVXPOls0as2PZsgcjqHHC0KTLEkhnIESGaOepq6JyElH7gjbjOpiaXfSUrfrXlgzKFmwxiaIuyDdxV70mSVOdbpAd4g2UuhvZ/aZr+ZaxQ+RW1Ca5iJ1S9dsG6Z0/zPX22xIlYqfTzvNiI8xybPFqfYTDVxwXC/IrMsdqQd66/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfE1VcoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfE1VcoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA2C4CEC5;
	Wed,  2 Oct 2024 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876095;
	bh=SBpBNAL6Y3mJFnwjytMJdu9DF8ccXsingF32jl7n1vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfE1VcoXvhqD7MSm+BXoq42GsKBQr+OlayqIZRe1WJPROWYm/wWqlQilLzLxdXjTt
	 MWitDynILafPw2C4lfuoiWPfJ1zB3HOlK5Yy1sGM3XTzPbL4PksyqSkMyUFVfjqGYb
	 2vxHhp4HGjNM77YrvRQVvK4uH16CeFIiM3VkXi20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 296/695] selftests/bpf: fix to avoid __msg tag de-duplication by clang
Date: Wed,  2 Oct 2024 14:54:54 +0200
Message-ID: <20241002125834.255651308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit f00bb757ed630affc951691ddaff206039cbb7ee ]

__msg, __regex and __xlated tags are based on
__attribute__((btf_decl_tag("..."))) annotations.

Clang de-duplicates such annotations, e.g. the following
two sequences of tags are identical in final BTF:

    /* seq A */            /* seq B */
    __tag("foo")           __tag("foo")
    __tag("bar")           __tag("bar")
    __tag("foo")

Fix this by adding a unique suffix for each tag using __COUNTER__
pre-processor macro. E.g. here is a new definition for __msg:

    #define __msg(msg) \
      __attribute__((btf_decl_tag("comment:test_expect_msg=" XSTR(__COUNTER__) "=" msg)))

Using this definition the "seq A" from example above is translated to
BTF as follows:

    [..] DECL_TAG 'comment:test_expect_msg=0=foo' type_id=X component_idx=-1
    [..] DECL_TAG 'comment:test_expect_msg=1=bar' type_id=X component_idx=-1
    [..] DECL_TAG 'comment:test_expect_msg=2=foo' type_id=X component_idx=-1

Surprisingly, this bug affects a single existing test:
verifier_spill_fill/old_stack_misc_vs_cur_ctx_ptr,
where sequence of identical messages was expected in the log.

Fixes: 537c3f66eac1 ("selftests/bpf: add generic BPF program tester-loader")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240820102357.3372779-4-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h  | 15 +++---
 .../selftests/bpf/progs/verifier_spill_fill.c |  8 ++--
 tools/testing/selftests/bpf/test_loader.c     | 47 ++++++++++++++-----
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index a225cd87897c4..4f10297437341 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -2,6 +2,9 @@
 #ifndef __BPF_MISC_H__
 #define __BPF_MISC_H__
 
+#define XSTR(s) STR(s)
+#define STR(s) #s
+
 /* This set of attributes controls behavior of the
  * test_loader.c:test_loader__run_subtests().
  *
@@ -68,15 +71,15 @@
  *                   Several __arch_* annotations could be specified at once.
  *                   When test case is not run on current arch it is marked as skipped.
  */
-#define __msg(msg)		__attribute__((btf_decl_tag("comment:test_expect_msg=" msg)))
-#define __regex(regex)		__attribute__((btf_decl_tag("comment:test_expect_regex=" regex)))
-#define __xlated(msg)		__attribute__((btf_decl_tag("comment:test_expect_xlated=" msg)))
+#define __msg(msg)		__attribute__((btf_decl_tag("comment:test_expect_msg=" XSTR(__COUNTER__) "=" msg)))
+#define __regex(regex)		__attribute__((btf_decl_tag("comment:test_expect_regex=" XSTR(__COUNTER__) "=" regex)))
+#define __xlated(msg)		__attribute__((btf_decl_tag("comment:test_expect_xlated=" XSTR(__COUNTER__) "=" msg)))
 #define __failure		__attribute__((btf_decl_tag("comment:test_expect_failure")))
 #define __success		__attribute__((btf_decl_tag("comment:test_expect_success")))
 #define __description(desc)	__attribute__((btf_decl_tag("comment:test_description=" desc)))
-#define __msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_msg_unpriv=" msg)))
-#define __regex_unpriv(regex)	__attribute__((btf_decl_tag("comment:test_expect_regex_unpriv=" regex)))
-#define __xlated_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_xlated_unpriv=" msg)))
+#define __msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_msg_unpriv=" XSTR(__COUNTER__) "=" msg)))
+#define __regex_unpriv(regex)	__attribute__((btf_decl_tag("comment:test_expect_regex_unpriv=" XSTR(__COUNTER__) "=" regex)))
+#define __xlated_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_xlated_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __failure_unpriv	__attribute__((btf_decl_tag("comment:test_expect_failure_unpriv")))
 #define __success_unpriv	__attribute__((btf_decl_tag("comment:test_expect_success_unpriv")))
 #define __log_level(lvl)	__attribute__((btf_decl_tag("comment:test_log_level="#lvl)))
diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 85e48069c9e61..d4b99c3b4719b 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -1213,10 +1213,10 @@ __success  __log_level(2)
  * - once for path entry - label 2;
  * - once for path entry - label 1 - label 2.
  */
-__msg("r1 = *(u64 *)(r10 -8)")
-__msg("exit")
-__msg("r1 = *(u64 *)(r10 -8)")
-__msg("exit")
+__msg("8: (79) r1 = *(u64 *)(r10 -8)")
+__msg("9: (95) exit")
+__msg("from 2 to 7")
+__msg("8: safe")
 __msg("processed 11 insns")
 __flag(BPF_F_TEST_STATE_FREQ)
 __naked void old_stack_misc_vs_cur_ctx_ptr(void)
diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 12b0c41e8d64c..0f59bc33a666c 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -215,6 +215,35 @@ static void update_flags(int *flags, int flag, bool clear)
 		*flags |= flag;
 }
 
+/* Matches a string of form '<pfx>[^=]=.*' and returns it's suffix.
+ * Used to parse btf_decl_tag values.
+ * Such values require unique prefix because compiler does not add
+ * same __attribute__((btf_decl_tag(...))) twice.
+ * Test suite uses two-component tags for such cases:
+ *
+ *   <pfx> __COUNTER__ '='
+ *
+ * For example, two consecutive __msg tags '__msg("foo") __msg("foo")'
+ * would be encoded as:
+ *
+ *   [18] DECL_TAG 'comment:test_expect_msg=0=foo' type_id=15 component_idx=-1
+ *   [19] DECL_TAG 'comment:test_expect_msg=1=foo' type_id=15 component_idx=-1
+ *
+ * And the purpose of this function is to extract 'foo' from the above.
+ */
+static const char *skip_dynamic_pfx(const char *s, const char *pfx)
+{
+	const char *msg;
+
+	if (strncmp(s, pfx, strlen(pfx)) != 0)
+		return NULL;
+	msg = s + strlen(pfx);
+	msg = strchr(msg, '=');
+	if (!msg)
+		return NULL;
+	return msg + 1;
+}
+
 enum arch {
 	ARCH_X86_64	= 0x1,
 	ARCH_ARM64	= 0x2,
@@ -290,38 +319,32 @@ static int parse_test_spec(struct test_loader *tester,
 		} else if (strcmp(s, TEST_TAG_AUXILIARY_UNPRIV) == 0) {
 			spec->auxiliary = true;
 			spec->mode_mask |= UNPRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_MSG_PFX)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_MSG_PFX) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_MSG_PFX))) {
 			err = push_msg(msg, NULL, &spec->priv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= PRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_MSG_PFX_UNPRIV)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_MSG_PFX_UNPRIV) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_MSG_PFX_UNPRIV))) {
 			err = push_msg(msg, NULL, &spec->unpriv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= UNPRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_REGEX_PFX)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_REGEX_PFX) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_REGEX_PFX))) {
 			err = push_msg(NULL, msg, &spec->priv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= PRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_REGEX_PFX_UNPRIV)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_REGEX_PFX_UNPRIV) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_REGEX_PFX_UNPRIV))) {
 			err = push_msg(NULL, msg, &spec->unpriv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= UNPRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_XLATED_PFX)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_XLATED_PFX) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_XLATED_PFX))) {
 			err = push_msg(msg, NULL, &spec->priv.expect_xlated);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= PRIV;
-		} else if (str_has_pfx(s, TEST_TAG_EXPECT_XLATED_PFX_UNPRIV)) {
-			msg = s + sizeof(TEST_TAG_EXPECT_XLATED_PFX_UNPRIV) - 1;
+		} else if ((msg = skip_dynamic_pfx(s, TEST_TAG_EXPECT_XLATED_PFX_UNPRIV))) {
 			err = push_msg(msg, NULL, &spec->unpriv.expect_xlated);
 			if (err)
 				goto cleanup;
-- 
2.43.0



