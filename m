Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8B273D9F;
	Tue, 21 Oct 2025 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076537; cv=none; b=MBJsxVNe/7tMeKTxd+g6kiJtxx+LRY+531hiNun1fuOsjJILT86ZtIwzFr/5+IlUZbj5afrvitv8p/pqrOXDZbdUDNcP87LB6sOkpc1iUV2eo7qlE1XP153VEv1WPOfe6pTBJrD5Wvoj9sZhkcBAMYZx3VV1UtDM3wRaGGQIKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076537; c=relaxed/simple;
	bh=KH/b+t0RiincyEZbFQcod0wnLNuJSKT5BdbkeM9cOGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2Nwk4IqQGpv20aLUEt+k1kf7hQV5OxC6HJZHrVvfvcHPOt01vM3UEaoZSrfIqSgEIvobtgwjZfTdA5ct4p27NQqHciwe9Rq6qj9v2plttu6uD/n1IrX6wm+jOG9M7fu3/hPH2gsg+GmArDTJ09PaFrgAZ+lzRn+86EEcIS/+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9z9mo88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9z9mo88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA5EC4CEF1;
	Tue, 21 Oct 2025 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076537;
	bh=KH/b+t0RiincyEZbFQcod0wnLNuJSKT5BdbkeM9cOGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9z9mo88TSh24uxOCQ9esKj7314eWsz/NkEBlSiQ/xo1pcy7VQ1ouoMnq/v+lKCkp
	 djBCktRw4SEEfHQ6VCPrczaopkDCvxXcceT+d58p5ZcnngW97XMZ0SZyuneHyYE2ME
	 hSNQ6+eETCHomHCxHpJ7HkR3q9t0FuqkoEW+YCbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/105] selftests/bpf: make arg_parsing.c more robust to crashes
Date: Tue, 21 Oct 2025 21:51:15 +0200
Message-ID: <20251021195023.234802896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit e603a342cf7ecd64ef8f36207dfe1caacb9e2583 ]

We started getting a crash in BPF CI, which seems to originate from
test_parse_test_list_file() test and is happening at this line:

  ASSERT_OK(strcmp("test_with_spaces", set.tests[0].name), "test 0 name");

One way we can crash there is if set.cnt zero, which is checked for with
ASSERT_EQ() above, but we proceed after this regardless of the outcome.
Instead of crashing, we should bail out with test failure early.

Similarly, if parse_test_list_file() fails, we shouldn't be even looking
at set, so bail even earlier if ASSERT_OK() fails.

Fixes: 64276f01dce8 ("selftests/bpf: Test_progs can read test lists from file")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20251014202037.72922-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/arg_parsing.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/arg_parsing.c b/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
index bb143de68875c..fbf0d9c2f58b3 100644
--- a/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
+++ b/tools/testing/selftests/bpf/prog_tests/arg_parsing.c
@@ -146,9 +146,12 @@ static void test_parse_test_list_file(void)
 
 	init_test_filter_set(&set);
 
-	ASSERT_OK(parse_test_list_file(tmpfile, &set, true), "parse file");
+	if (!ASSERT_OK(parse_test_list_file(tmpfile, &set, true), "parse file"))
+		goto out_fclose;
+
+	if (!ASSERT_EQ(set.cnt, 4, "test  count"))
+		goto out_free_set;
 
-	ASSERT_EQ(set.cnt, 4, "test  count");
 	ASSERT_OK(strcmp("test_with_spaces", set.tests[0].name), "test 0 name");
 	ASSERT_EQ(set.tests[0].subtest_cnt, 0, "test 0 subtest count");
 	ASSERT_OK(strcmp("testA", set.tests[1].name), "test 1 name");
@@ -158,8 +161,8 @@ static void test_parse_test_list_file(void)
 	ASSERT_OK(strcmp("testB", set.tests[2].name), "test 2 name");
 	ASSERT_OK(strcmp("testC_no_eof_newline", set.tests[3].name), "test 3 name");
 
+out_free_set:
 	free_test_filter_set(&set);
-
 out_fclose:
 	fclose(fp);
 out_remove:
-- 
2.51.0



