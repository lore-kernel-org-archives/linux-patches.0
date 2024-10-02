Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CCD1D0DDF;
	Wed,  2 Oct 2024 14:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877995; cv=none; b=BgrM+JMRGFZdMTfsqwA+x3+txXwUy+ZDNF7qbCNtCA8VrqV75k4ZXXLbCIKKCLV1xmz6C88uNA5AxNbENmL0GkBQmt5SbkKrfDeyzcJAw2vG3BKr6IhrvFzotgqpcMFFjGPuuVRUslaoSTPOVVFJQD9O8tkItfbKAOq7RTu2p60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877995; c=relaxed/simple;
	bh=16UwKXULpMM1EhcreN68ZB1xLEImxqNXx6XiYym7pCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcPW1rJsImjqpjycP0hjckxGDwN0rGilyhvTsBfCjowhzojmVs67znFyA4Y9ioKDsH1PXWJNfgNmM30QQQxUvRqTD51Mkb6JufEa0e8R168jxR2J7dh3mpv5nLFm/EXiFEXbJ3nmuA5mwsRIPshlUkh9wV5ggP1ifGuVHc2A7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un3CLcNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un3CLcNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849DAC4CEC5;
	Wed,  2 Oct 2024 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877994;
	bh=16UwKXULpMM1EhcreN68ZB1xLEImxqNXx6XiYym7pCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un3CLcNpQpDUwArNlQzBHg54e6S/ee3dIhFaCuBVxocbBe7E9GjI9SpY4MEkjrMfW
	 z6DRS4eMI0L8UEphQJlwnuoKTY68I0EE37nkzMnxyQeqXzJVycgp2quEDi6v5ON4O9
	 hZikT246eiJOPiHBEFBvRm2Tlk981p6gRDibBlks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 264/634] selftests/bpf: extract test_loader->expect_msgs as a data structure
Date: Wed,  2 Oct 2024 14:56:04 +0200
Message-ID: <20241002125821.521541910@linuxfoundation.org>
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

[ Upstream commit 64f01e935ddb26f48baec71883c27878ac4231dc ]

Non-functional change: use a separate data structure to represented
expected messages in test_loader.
This would allow to use the same functionality for expected set of
disassembled instructions in the follow-up commit.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240722233844.1406874-8-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: f00bb757ed63 ("selftests/bpf: fix to avoid __msg tag de-duplication by clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_loader.c | 81 ++++++++++++-----------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 47508cf66e896..3f84903558dd8 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -55,11 +55,15 @@ struct expect_msg {
 	regex_t regex;
 };
 
+struct expected_msgs {
+	struct expect_msg *patterns;
+	size_t cnt;
+};
+
 struct test_subspec {
 	char *name;
 	bool expect_failure;
-	struct expect_msg *expect_msgs;
-	size_t expect_msg_cnt;
+	struct expected_msgs expect_msgs;
 	int retval;
 	bool execute;
 };
@@ -96,44 +100,45 @@ void test_loader_fini(struct test_loader *tester)
 	free(tester->log_buf);
 }
 
-static void free_test_spec(struct test_spec *spec)
+static void free_msgs(struct expected_msgs *msgs)
 {
 	int i;
 
+	for (i = 0; i < msgs->cnt; i++)
+		if (msgs->patterns[i].regex_str)
+			regfree(&msgs->patterns[i].regex);
+	free(msgs->patterns);
+	msgs->patterns = NULL;
+	msgs->cnt = 0;
+}
+
+static void free_test_spec(struct test_spec *spec)
+{
 	/* Deallocate expect_msgs arrays. */
-	for (i = 0; i < spec->priv.expect_msg_cnt; i++)
-		if (spec->priv.expect_msgs[i].regex_str)
-			regfree(&spec->priv.expect_msgs[i].regex);
-	for (i = 0; i < spec->unpriv.expect_msg_cnt; i++)
-		if (spec->unpriv.expect_msgs[i].regex_str)
-			regfree(&spec->unpriv.expect_msgs[i].regex);
+	free_msgs(&spec->priv.expect_msgs);
+	free_msgs(&spec->unpriv.expect_msgs);
 
 	free(spec->priv.name);
 	free(spec->unpriv.name);
-	free(spec->priv.expect_msgs);
-	free(spec->unpriv.expect_msgs);
-
 	spec->priv.name = NULL;
 	spec->unpriv.name = NULL;
-	spec->priv.expect_msgs = NULL;
-	spec->unpriv.expect_msgs = NULL;
 }
 
-static int push_msg(const char *substr, const char *regex_str, struct test_subspec *subspec)
+static int push_msg(const char *substr, const char *regex_str, struct expected_msgs *msgs)
 {
 	void *tmp;
 	int regcomp_res;
 	char error_msg[100];
 	struct expect_msg *msg;
 
-	tmp = realloc(subspec->expect_msgs,
-		      (1 + subspec->expect_msg_cnt) * sizeof(struct expect_msg));
+	tmp = realloc(msgs->patterns,
+		      (1 + msgs->cnt) * sizeof(struct expect_msg));
 	if (!tmp) {
 		ASSERT_FAIL("failed to realloc memory for messages\n");
 		return -ENOMEM;
 	}
-	subspec->expect_msgs = tmp;
-	msg = &subspec->expect_msgs[subspec->expect_msg_cnt];
+	msgs->patterns = tmp;
+	msg = &msgs->patterns[msgs->cnt];
 
 	if (substr) {
 		msg->substr = substr;
@@ -150,7 +155,7 @@ static int push_msg(const char *substr, const char *regex_str, struct test_subsp
 		}
 	}
 
-	subspec->expect_msg_cnt += 1;
+	msgs->cnt += 1;
 	return 0;
 }
 
@@ -272,25 +277,25 @@ static int parse_test_spec(struct test_loader *tester,
 			spec->mode_mask |= UNPRIV;
 		} else if (str_has_pfx(s, TEST_TAG_EXPECT_MSG_PFX)) {
 			msg = s + sizeof(TEST_TAG_EXPECT_MSG_PFX) - 1;
-			err = push_msg(msg, NULL, &spec->priv);
+			err = push_msg(msg, NULL, &spec->priv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= PRIV;
 		} else if (str_has_pfx(s, TEST_TAG_EXPECT_MSG_PFX_UNPRIV)) {
 			msg = s + sizeof(TEST_TAG_EXPECT_MSG_PFX_UNPRIV) - 1;
-			err = push_msg(msg, NULL, &spec->unpriv);
+			err = push_msg(msg, NULL, &spec->unpriv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= UNPRIV;
 		} else if (str_has_pfx(s, TEST_TAG_EXPECT_REGEX_PFX)) {
 			msg = s + sizeof(TEST_TAG_EXPECT_REGEX_PFX) - 1;
-			err = push_msg(NULL, msg, &spec->priv);
+			err = push_msg(NULL, msg, &spec->priv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= PRIV;
 		} else if (str_has_pfx(s, TEST_TAG_EXPECT_REGEX_PFX_UNPRIV)) {
 			msg = s + sizeof(TEST_TAG_EXPECT_REGEX_PFX_UNPRIV) - 1;
-			err = push_msg(NULL, msg, &spec->unpriv);
+			err = push_msg(NULL, msg, &spec->unpriv.expect_msgs);
 			if (err)
 				goto cleanup;
 			spec->mode_mask |= UNPRIV;
@@ -387,11 +392,12 @@ static int parse_test_spec(struct test_loader *tester,
 			spec->unpriv.execute = spec->priv.execute;
 		}
 
-		if (!spec->unpriv.expect_msgs) {
-			for (i = 0; i < spec->priv.expect_msg_cnt; i++) {
-				struct expect_msg *msg = &spec->priv.expect_msgs[i];
+		if (spec->unpriv.expect_msgs.cnt == 0) {
+			for (i = 0; i < spec->priv.expect_msgs.cnt; i++) {
+				struct expect_msg *msg = &spec->priv.expect_msgs.patterns[i];
 
-				err = push_msg(msg->substr, msg->regex_str, &spec->unpriv);
+				err = push_msg(msg->substr, msg->regex_str,
+					       &spec->unpriv.expect_msgs);
 				if (err)
 					goto cleanup;
 			}
@@ -443,18 +449,14 @@ static void emit_verifier_log(const char *log_buf, bool force)
 	fprintf(stdout, "VERIFIER LOG:\n=============\n%s=============\n", log_buf);
 }
 
-static void validate_case(struct test_loader *tester,
-			  struct test_subspec *subspec,
-			  struct bpf_object *obj,
-			  struct bpf_program *prog,
-			  int load_err)
+static void validate_msgs(char *log_buf, struct expected_msgs *msgs)
 {
 	regmatch_t reg_match[1];
-	const char *log = tester->log_buf;
+	const char *log = log_buf;
 	int i, j, err;
 
-	for (i = 0; i < subspec->expect_msg_cnt; i++) {
-		struct expect_msg *msg = &subspec->expect_msgs[i];
+	for (i = 0; i < msgs->cnt; i++) {
+		struct expect_msg *msg = &msgs->patterns[i];
 		const char *match = NULL;
 
 		if (msg->substr) {
@@ -471,9 +473,9 @@ static void validate_case(struct test_loader *tester,
 
 		if (!ASSERT_OK_PTR(match, "expect_msg")) {
 			if (env.verbosity == VERBOSE_NONE)
-				emit_verifier_log(tester->log_buf, true /*force*/);
+				emit_verifier_log(log_buf, true /*force*/);
 			for (j = 0; j <= i; j++) {
-				msg = &subspec->expect_msgs[j];
+				msg = &msgs->patterns[j];
 				fprintf(stderr, "%s %s: '%s'\n",
 					j < i ? "MATCHED " : "EXPECTED",
 					msg->substr ? "SUBSTR" : " REGEX",
@@ -692,9 +694,8 @@ void run_subtest(struct test_loader *tester,
 			goto tobj_cleanup;
 		}
 	}
-
 	emit_verifier_log(tester->log_buf, false /*force*/);
-	validate_case(tester, subspec, tobj, tprog, err);
+	validate_msgs(tester->log_buf, &subspec->expect_msgs);
 
 	if (should_do_test_run(spec, subspec)) {
 		/* For some reason test_verifier executes programs
-- 
2.43.0



