Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1541D12F0;
	Wed,  2 Oct 2024 14:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877992; cv=none; b=abk5OEsvWdebwm8RNR0GYXGB8hPuRaxD4qRMOZtui+jkz8gqeFNJwOfuvb3Diq5PQJQFHzIDq8o6MAehSmhkQ8LauxbIAqvBp55ERPxPApOG1OVytcYoMnXb49HruOaqcfn++mmQcX1IurAdrBWfnGox38m3cGrCKjrMhK6O3GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877992; c=relaxed/simple;
	bh=G9Lc6Cvh+auonFM5S9zRWsBSAS0S9TElQf/OYGziVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdpoWAfBF7HxYP3/A+8VNGxe0+OVdnsrM15CbK8SnoAi9AKdsJEV1BQVSSPanp1j37JSRTXZKdcA522pfG2c5a6fwQZix0rzE32scUa+uiWCDQtS3beL+KOvwIG3QeIkBqTkXuDDdmks6j49Um2oqOG7UBtl65B3CiANKp2pogo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYYuH9+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYYuH9+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C87C4CEC2;
	Wed,  2 Oct 2024 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877992;
	bh=G9Lc6Cvh+auonFM5S9zRWsBSAS0S9TElQf/OYGziVig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYYuH9+4wesXJkjK7rRRtmiJ9fGYcLLKne/q/PTCC9VR1mIBFZorvPcoThV2RP6Hw
	 KNGf5uXSgC0ITB/us/kdvu+27rR859rhC+g5c1mORRvYQgTVHwtDKfN3+k6q0DeYfV
	 QpyfZwbv0LYHCWmQ3gZtYZdJCTlnpIVDOqgyyNfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 263/634] selftests/bpf: no need to track next_match_pos in struct test_loader
Date: Wed,  2 Oct 2024 14:56:03 +0200
Message-ID: <20241002125821.482137433@linuxfoundation.org>
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

[ Upstream commit 4ef5d6af493558124b7a6c13cace58b938fe27d4 ]

The call stack for validate_case() function looks as follows:
- test_loader__run_subtests()
  - process_subtest()
    - run_subtest()
      - prepare_case(), which does 'tester->next_match_pos = 0';
      - validate_case(), which increments tester->next_match_pos.

Hence, each subtest is run with next_match_pos freshly set to zero.
Meaning that there is no need to persist this variable in the
struct test_loader, use local variable instead.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240722233844.1406874-7-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: f00bb757ed63 ("selftests/bpf: fix to avoid __msg tag de-duplication by clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_loader.c | 19 ++++++++-----------
 tools/testing/selftests/bpf/test_progs.h  |  1 -
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index f14e10b0de96e..47508cf66e896 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -434,7 +434,6 @@ static void prepare_case(struct test_loader *tester,
 	bpf_program__set_flags(prog, prog_flags | spec->prog_flags);
 
 	tester->log_buf[0] = '\0';
-	tester->next_match_pos = 0;
 }
 
 static void emit_verifier_log(const char *log_buf, bool force)
@@ -450,25 +449,23 @@ static void validate_case(struct test_loader *tester,
 			  struct bpf_program *prog,
 			  int load_err)
 {
-	int i, j, err;
-	char *match;
 	regmatch_t reg_match[1];
+	const char *log = tester->log_buf;
+	int i, j, err;
 
 	for (i = 0; i < subspec->expect_msg_cnt; i++) {
 		struct expect_msg *msg = &subspec->expect_msgs[i];
+		const char *match = NULL;
 
 		if (msg->substr) {
-			match = strstr(tester->log_buf + tester->next_match_pos, msg->substr);
+			match = strstr(log, msg->substr);
 			if (match)
-				tester->next_match_pos = match - tester->log_buf + strlen(msg->substr);
+				log += strlen(msg->substr);
 		} else {
-			err = regexec(&msg->regex,
-				      tester->log_buf + tester->next_match_pos, 1, reg_match, 0);
+			err = regexec(&msg->regex, log, 1, reg_match, 0);
 			if (err == 0) {
-				match = tester->log_buf + tester->next_match_pos + reg_match[0].rm_so;
-				tester->next_match_pos += reg_match[0].rm_eo;
-			} else {
-				match = NULL;
+				match = log + reg_match[0].rm_so;
+				log += reg_match[0].rm_eo;
 			}
 		}
 
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 0ba5a20b19ba8..8e997de596db0 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -438,7 +438,6 @@ typedef int (*pre_execution_cb)(struct bpf_object *obj);
 struct test_loader {
 	char *log_buf;
 	size_t log_buf_sz;
-	size_t next_match_pos;
 	pre_execution_cb pre_execution_cb;
 
 	struct bpf_object *obj;
-- 
2.43.0



