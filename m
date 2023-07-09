Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378AB522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE67EC433C7;
	Sun,  9 Jul 2023 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901712;
	bh=Jh9G4tnr8lC9eIVSE/pb0hegprMYA7UGTQi+ApdC0uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaltHLnykLVk5mngkHJcKvUHqbsjinRWdWo7VE+NQ8paGMFh+nagQsU+UyxvZdYuU
	 utNty7OnRP5XnWZ1UWEb2N5ZjWZrUomt1aQBos3rkMXbjzU2P+BNbE9Y4fbA0ZY6yF
	 kPg+29/KboXlABEZCxACLkGeLK+2Y9arcPXeXHS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 117/431] selftests/bpf: Fix invalid pointer check in get_xlated_program()
Date: Sun,  9 Jul 2023 13:11:05 +0200
Message-ID: <20230709111453.896633434@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit b23ed4d74c4d583b5f621ee4c776699442833554 ]

Dan Carpenter reported invalid check for calloc() result in
test_verifier.c:get_xlated_program():

  ./tools/testing/selftests/bpf/test_verifier.c:1365 get_xlated_program()
  warn: variable dereferenced before check 'buf' (see line 1364)

  ./tools/testing/selftests/bpf/test_verifier.c
    1363		*cnt = xlated_prog_len / buf_element_size;
    1364		*buf = calloc(*cnt, buf_element_size);
    1365		if (!buf) {

  This should be if (!*buf) {

    1366			perror("can't allocate xlated program buffer");
    1367			return -ENOMEM;

This commit refactors the get_xlated_program() to avoid using double
pointer type.

Fixes: 933ff53191eb ("selftests/bpf: specify expected instructions in test_verifier tests")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://lore.kernel.org/bpf/ZH7u0hEGVB4MjGZq@moroto/
Link: https://lore.kernel.org/bpf/20230609221637.2631800-1-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 24 +++++++++++----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 8b9949bb833d7..2e9bdf2e91351 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1232,45 +1232,46 @@ static bool cmp_str_seq(const char *log, const char *exp)
 	return true;
 }
 
-static int get_xlated_program(int fd_prog, struct bpf_insn **buf, int *cnt)
+static struct bpf_insn *get_xlated_program(int fd_prog, int *cnt)
 {
+	__u32 buf_element_size = sizeof(struct bpf_insn);
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	__u32 xlated_prog_len;
-	__u32 buf_element_size = sizeof(struct bpf_insn);
+	struct bpf_insn *buf;
 
 	if (bpf_prog_get_info_by_fd(fd_prog, &info, &info_len)) {
 		perror("bpf_prog_get_info_by_fd failed");
-		return -1;
+		return NULL;
 	}
 
 	xlated_prog_len = info.xlated_prog_len;
 	if (xlated_prog_len % buf_element_size) {
 		printf("Program length %d is not multiple of %d\n",
 		       xlated_prog_len, buf_element_size);
-		return -1;
+		return NULL;
 	}
 
 	*cnt = xlated_prog_len / buf_element_size;
-	*buf = calloc(*cnt, buf_element_size);
+	buf = calloc(*cnt, buf_element_size);
 	if (!buf) {
 		perror("can't allocate xlated program buffer");
-		return -ENOMEM;
+		return NULL;
 	}
 
 	bzero(&info, sizeof(info));
 	info.xlated_prog_len = xlated_prog_len;
-	info.xlated_prog_insns = (__u64)(unsigned long)*buf;
+	info.xlated_prog_insns = (__u64)(unsigned long)buf;
 	if (bpf_prog_get_info_by_fd(fd_prog, &info, &info_len)) {
 		perror("second bpf_prog_get_info_by_fd failed");
 		goto out_free_buf;
 	}
 
-	return 0;
+	return buf;
 
 out_free_buf:
-	free(*buf);
-	return -1;
+	free(buf);
+	return NULL;
 }
 
 static bool is_null_insn(struct bpf_insn *insn)
@@ -1403,7 +1404,8 @@ static bool check_xlated_program(struct bpf_test *test, int fd_prog)
 	if (!check_expected && !check_unexpected)
 		goto out;
 
-	if (get_xlated_program(fd_prog, &buf, &cnt)) {
+	buf = get_xlated_program(fd_prog, &cnt);
+	if (!buf) {
 		printf("FAIL: can't get xlated program\n");
 		result = false;
 		goto out;
-- 
2.39.2



