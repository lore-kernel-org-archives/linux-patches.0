Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F36275861;
	Tue, 21 Oct 2025 20:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077511; cv=none; b=GM3CONmp80sV3wyiD9blyEZuM4zjELYwqgrZWV438nPZRpoeXzh6LDcQd7sFXo/jreiF2jA/vPqnKxEQ9V/SlmE/eaIUbHltxDM+476BVXl2fIisXN4iPMXFiHXmK9eebzCksr7GdbKKLySoQLqMxx+NxqkpfNwmtFOOPPGrvx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077511; c=relaxed/simple;
	bh=GlHz2JeD0d+ZF1Yfi2kVhDuNyZgwC6G3QkJMUSVi48k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKdqmoTNlFI9QurImxr9OqtpGAT6RaIPLEZRNqqSwitDKjCHzLt+lzPymoXhmkfs3XB250k3fr8GJ6EGTdtdIcQMAZjCSy0x/QFbq2M+pgGG+Bwa1KgfXT62rCZqI3RXHJqdWHrPEKzJs9sm0Nrfaaah3RKp6AKFvxodVgS0ip0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6BTZiLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6BTZiLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0217EC4CEF1;
	Tue, 21 Oct 2025 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077510;
	bh=GlHz2JeD0d+ZF1Yfi2kVhDuNyZgwC6G3QkJMUSVi48k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6BTZiLZ1RJrIT5PKF0mD42AcD8imZ65pM0kc9aeqF9sI7ITYTOSzIhWsc/YIV+mh
	 Yx9I/FkZx8o+HJ5IXLdnR0gas1Zw75FSZnS6izpVCXjqFY1wTJxkzDvYNeJXIlRNjq
	 alM/Xm57BpYkanS5qXD6K5ocmVUeseAt3IDCW1g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/159] selftests/bpf: make arg_parsing.c more robust to crashes
Date: Tue, 21 Oct 2025 21:51:43 +0200
Message-ID: <20251021195046.183391926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



