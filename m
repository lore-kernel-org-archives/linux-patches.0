Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F161D0DDF;
	Wed,  2 Oct 2024 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877998; cv=none; b=YTIPCF1y3ix4RiPObQmYpEKn+b1eaJ6JKYSRpaa/NeJnm1wVfYtp7s69DtQ2X796INduQ38Tjo7PcOPOq8rQlhDyu4b8fcDT1dmt5xDFUSAwds+w6X/HjxY9VP/Nbu6+IhOwEUe0QmCTmvh4/OZF9/9L+Tz9cI6rIm5V5bQ6qv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877998; c=relaxed/simple;
	bh=qzT+Jz/9OBQ4wDh3eU42IIUt985LkCGlh7ugnrhXu9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPUV7MmBrfJWcK6zXRXQZcHJ0AyIaUp3W9x1G3zIS32GpVsGig1EqIMqfw5hb4zmgvtlW0v93P8493akv8OWOoEur4bhdjrsf/qBheKTNTriOcolXC7CN1urK4TsOxbUTEyGS+2kxgcrU4bIoybT4jOrdXrdNo8QJ93WRUfgstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywJWkbtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywJWkbtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D16C4CEC2;
	Wed,  2 Oct 2024 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877997;
	bh=qzT+Jz/9OBQ4wDh3eU42IIUt985LkCGlh7ugnrhXu9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywJWkbtNP0KGp63S74DCHLdi41EcjsZ7LwhUBG0wIYm+mAZ0MJYhWkREi20W6b0o5
	 rqR6QzEvgcVGcX2NJxGw0p1nm07tucoUZDKOXY+4YzbOCLxC8ecb2EXJRhcKCS8+fY
	 Pkf6HAsShiYrinnq7YhRDCiP1JeVgWCfCGSAY4KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 265/634] selftests/bpf: allow checking xlated programs in verifier_* tests
Date: Wed,  2 Oct 2024 14:56:05 +0200
Message-ID: <20241002125821.560313092@linuxfoundation.org>
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

[ Upstream commit 9c9f7339131030949a8ef111080427ff1a8085b5 ]

Add a macro __xlated("...") for use with test_loader tests.

When such annotations are present for the test case:
- bpf_prog_get_info_by_fd() is used to get BPF program after all
  rewrites are applied by verifier.
- the program is disassembled and patterns specified in __xlated are
  searched for in the disassembly text.

__xlated matching follows the same mechanics as __msg:
each subsequent pattern is matched from the point where
previous pattern ended.

This allows to write tests like below, where the goal is to verify the
behavior of one of the of the transformations applied by verifier:

    SEC("raw_tp")
    __xlated("1: w0 = ")
    __xlated("2: r0 = &(void __percpu *)(r0)")
    __xlated("3: r0 = *(u32 *)(r0 +0)")
    __xlated("4: exit")
    __success __naked void simple(void)
    {
            asm volatile (
            "call %[bpf_get_smp_processor_id];"
            "exit;"
            :
            : __imm(bpf_get_smp_processor_id)
            : __clobber_all);
    }

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240722233844.1406874-9-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: f00bb757ed63 ("selftests/bpf: fix to avoid __msg tag de-duplication by clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h |  5 ++
 tools/testing/selftests/bpf/test_loader.c    | 82 +++++++++++++++++++-
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index c0280bd2f340d..6c24e09df7d2b 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -26,6 +26,9 @@
  *
  * __regex           Same as __msg, but using a regular expression.
  * __regex_unpriv    Same as __msg_unpriv but using a regular expression.
+ * __xlated          Expect a line in a disassembly log after verifier applies rewrites.
+ *                   Multiple __xlated attributes could be specified.
+ * __xlated_unpriv   Same as __xlated but for unprivileged mode.
  *
  * __success         Expect program load success in privileged mode.
  * __success_unpriv  Expect program load success in unprivileged mode.
@@ -63,11 +66,13 @@
  */
 #define __msg(msg)		__attribute__((btf_decl_tag("comment:test_expect_msg=" msg)))
 #define __regex(regex)		__attribute__((btf_decl_tag("comment:test_expect_regex=" regex)))
+#define __xlated(msg)		__attribute__((btf_decl_tag("comment:test_expect_xlated=" msg)))
 #define __failure		__attribute__((btf_decl_tag("comment:test_expect_failure")))
 #define __success		__attribute__((btf_decl_tag("comment:test_expect_success")))
 #define __description(desc)	__attribute__((btf_decl_tag("comment:test_description=" desc)))
 #define __msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_msg_unpriv=" msg)))
 #define __regex_unpriv(regex)	__attribute__((btf_decl_tag("comment:test_expect_regex_unpriv=" regex)))
+#define __xlated_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_xlated_unpriv=" msg)))
 #define __failure_unpriv	__attribute__((btf_decl_tag("comment:test_expect_failure_unpriv")))
 #define __success_unpriv	__attribute__((btf_decl_tag("comment:test_expect_success_unpriv")))
 #define __log_level(lvl)	__attribute__((btf_decl_tag("comment:test_log_level="#lvl)))
diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 3f84903558dd8..b44b6a2fc82ce 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -7,6 +7,7 @@
 #include <bpf/btf.h>
 
 #include "autoconf_helper.h"
+#include "disasm_helpers.h"
 #include "unpriv_helpers.h"
 #include "cap_helpers.h"
 
@@ -19,10 +20,12 @@
 #define TEST_TAG_EXPECT_SUCCESS "comment:test_expect_success"
 #define TEST_TAG_EXPECT_MSG_PFX "comment:test_expect_msg="
 #define TEST_TAG_EXPECT_REGEX_PFX "comment:test_expect_regex="
+#define TEST_TAG_EXPECT_XLATED_PFX "comment:test_expect_xlated="
 #define TEST_TAG_EXPECT_FAILURE_UNPRIV "comment:test_expect_failure_unpriv"
 #define TEST_TAG_EXPECT_SUCCESS_UNPRIV "comment:test_expect_success_unpriv"
 #define TEST_TAG_EXPECT_MSG_PFX_UNPRIV "comment:test_expect_msg_unpriv="
 #define TEST_TAG_EXPECT_REGEX_PFX_UNPRIV "comment:test_expect_regex_unpriv="
+#define TEST_TAG_EXPECT_XLATED_PFX_UNPRIV "comment:test_expect_xlated_unpriv="
 #define TEST_TAG_LOG_LEVEL_PFX "comment:test_log_level="
 #define TEST_TAG_PROG_FLAGS_PFX "comment:test_prog_flags="
 #define TEST_TAG_DESCRIPTION_PFX "comment:test_description="
@@ -64,6 +67,7 @@ struct test_subspec {
 	char *name;
 	bool expect_failure;
 	struct expected_msgs expect_msgs;
+	struct expected_msgs expect_xlated;
 	int retval;
 	bool execute;
 };
@@ -117,6 +121,8 @@ static void free_test_spec(struct test_spec *spec)
 	/* Deallocate expect_msgs arrays. */
 	free_msgs(&spec->priv.expect_msgs);
 	free_msgs(&spec->unpriv.expect_msgs);
+	free_msgs(&spec->priv.expect_xlated);
+	free_msgs(&spec->unpriv.expect_xlated);
 
 	free(spec->priv.name);
 	free(spec->unpriv.name);
@@ -299,6 +305,18 @@ static int parse_test_spec(struct test_loader *tester,
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= UNPRIV;
+		} else if (str_has_pfx(s, TEST_TAG_EXPECT_XLATED_PFX)) {
+			msg = s + sizeof(TEST_TAG_EXPECT_XLATED_PFX) - 1;
+			err = push_msg(msg, NULL, &spec->priv.expect_xlated);
+			if (err)
+				goto cleanup;
+			spec->mode_mask |= PRIV;
+		} else if (str_has_pfx(s, TEST_TAG_EXPECT_XLATED_PFX_UNPRIV)) {
+			msg = s + sizeof(TEST_TAG_EXPECT_XLATED_PFX_UNPRIV) - 1;
+			err = push_msg(msg, NULL, &spec->unpriv.expect_xlated);
+			if (err)
+				goto cleanup;
+			spec->mode_mask |= UNPRIV;
 		} else if (str_has_pfx(s, TEST_TAG_RETVAL_PFX)) {
 			val = s + sizeof(TEST_TAG_RETVAL_PFX) - 1;
 			err = parse_retval(val, &spec->priv.retval, "__retval");
@@ -402,6 +420,16 @@ static int parse_test_spec(struct test_loader *tester,
 					goto cleanup;
 			}
 		}
+		if (spec->unpriv.expect_xlated.cnt == 0) {
+			for (i = 0; i < spec->priv.expect_xlated.cnt; i++) {
+				struct expect_msg *msg = &spec->priv.expect_xlated.patterns[i];
+
+				err = push_msg(msg->substr, msg->regex_str,
+					       &spec->unpriv.expect_xlated);
+				if (err)
+					goto cleanup;
+			}
+		}
 	}
 
 	spec->valid = true;
@@ -449,7 +477,15 @@ static void emit_verifier_log(const char *log_buf, bool force)
 	fprintf(stdout, "VERIFIER LOG:\n=============\n%s=============\n", log_buf);
 }
 
-static void validate_msgs(char *log_buf, struct expected_msgs *msgs)
+static void emit_xlated(const char *xlated, bool force)
+{
+	if (!force && env.verbosity == VERBOSE_NONE)
+		return;
+	fprintf(stdout, "XLATED:\n=============\n%s=============\n", xlated);
+}
+
+static void validate_msgs(char *log_buf, struct expected_msgs *msgs,
+			  void (*emit_fn)(const char *buf, bool force))
 {
 	regmatch_t reg_match[1];
 	const char *log = log_buf;
@@ -473,7 +509,7 @@ static void validate_msgs(char *log_buf, struct expected_msgs *msgs)
 
 		if (!ASSERT_OK_PTR(match, "expect_msg")) {
 			if (env.verbosity == VERBOSE_NONE)
-				emit_verifier_log(log_buf, true /*force*/);
+				emit_fn(log_buf, true /*force*/);
 			for (j = 0; j <= i; j++) {
 				msg = &msgs->patterns[j];
 				fprintf(stderr, "%s %s: '%s'\n",
@@ -610,6 +646,37 @@ static bool should_do_test_run(struct test_spec *spec, struct test_subspec *subs
 	return true;
 }
 
+/* Get a disassembly of BPF program after verifier applies all rewrites */
+static int get_xlated_program_text(int prog_fd, char *text, size_t text_sz)
+{
+	struct bpf_insn *insn_start = NULL, *insn, *insn_end;
+	__u32 insns_cnt = 0, i;
+	char buf[64];
+	FILE *out = NULL;
+	int err;
+
+	err = get_xlated_program(prog_fd, &insn_start, &insns_cnt);
+	if (!ASSERT_OK(err, "get_xlated_program"))
+		goto out;
+	out = fmemopen(text, text_sz, "w");
+	if (!ASSERT_OK_PTR(out, "open_memstream"))
+		goto out;
+	insn_end = insn_start + insns_cnt;
+	insn = insn_start;
+	while (insn < insn_end) {
+		i = insn - insn_start;
+		insn = disasm_insn(insn, buf, sizeof(buf));
+		fprintf(out, "%d: %s\n", i, buf);
+	}
+	fflush(out);
+
+out:
+	free(insn_start);
+	if (out)
+		fclose(out);
+	return err;
+}
+
 /* this function is forced noinline and has short generic name to look better
  * in test_progs output (in case of a failure)
  */
@@ -695,7 +762,16 @@ void run_subtest(struct test_loader *tester,
 		}
 	}
 	emit_verifier_log(tester->log_buf, false /*force*/);
-	validate_msgs(tester->log_buf, &subspec->expect_msgs);
+	validate_msgs(tester->log_buf, &subspec->expect_msgs, emit_verifier_log);
+
+	if (subspec->expect_xlated.cnt) {
+		err = get_xlated_program_text(bpf_program__fd(tprog),
+					      tester->log_buf, tester->log_buf_sz);
+		if (err)
+			goto tobj_cleanup;
+		emit_xlated(tester->log_buf, false /*force*/);
+		validate_msgs(tester->log_buf, &subspec->expect_xlated, emit_xlated);
+	}
 
 	if (should_do_test_run(spec, subspec)) {
 		/* For some reason test_verifier executes programs
-- 
2.43.0



