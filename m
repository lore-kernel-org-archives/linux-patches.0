Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A28214227;
	Thu, 12 Dec 2024 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022367; cv=none; b=irFDo5vsW4I+7VRYlcOGxPsAoyGDqK81BZFBW8rQ686J2UXbjRX4Uz71sq05nqUTPf/slWIj0TzYQ6PIe0/PqUCuyd+KsUj/oskXTUOQJiKxpJbgmbH6mZX0PmfQ7pXW8x7Ory8ATAW+4X2HJnZK3XtwIPpNgcfSuVawwJ6rhmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022367; c=relaxed/simple;
	bh=qrZpFUdBJNMBK5dnkV33RyjwOgnyYzCapOEIbvpLN78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYuIuXVpPSPWkklfeTUnFvTl4zkQ0+N9ACmTzFdU8YFA5TAf4h63R1455GcR4XkyEe5c3eHA+VzUG5PDXw1CdwL5gCS5mHHxGb09SZwCbMJqbC2khrIPceFfBjkrdFufKC1q2BrxHsqimShEsE7qNFOwVV0huXLH2fdbmR80I4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxbxlmiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxbxlmiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89317C4CECE;
	Thu, 12 Dec 2024 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022367;
	bh=qrZpFUdBJNMBK5dnkV33RyjwOgnyYzCapOEIbvpLN78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxbxlmiOZpoU9DzKqVGzRwtKFUrW7l+GpsM5k5sfwe7YQo27FvGHkQfW5AfNjLx9w
	 7C02Y2OI0Z+158U0DAnm8DAum9f2gv5a8ZE6UjC2bCCJ2ri1PFw4MsmEGZn9imEriN
	 +msY/V/E/Dwi1vsDVi8Y2D6BK+TE5zd24EpQQPtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/565] selftests, bpf: Add one test for sockmap with strparser
Date: Thu, 12 Dec 2024 15:56:26 +0100
Message-ID: <20241212144319.031020559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit d69672147faa2a7671c0779fa5b9ad99e4fca4e3 ]

Add the test to check sockmap with strparser is working well.

Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211029141216.211899-3-liujian56@huawei.com
Stable-dep-of: 523dffccbade ("selftests/bpf: Fix total_bytes in msg_loop_rx in test_sockmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 33 ++++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 83a7366c54b51..74cfab7d5eff4 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -141,6 +141,7 @@ struct sockmap_options {
 	bool sendpage;
 	bool data_test;
 	bool drop_expected;
+	bool check_recved_len;
 	int iov_count;
 	int iov_length;
 	int rate;
@@ -564,8 +565,12 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 	int err, i, flags = MSG_NOSIGNAL;
 	bool drop = opt->drop_expected;
 	bool data = opt->data_test;
+	int iov_alloc_length = iov_length;
 
-	err = msg_alloc_iov(&msg, iov_count, iov_length, data, tx);
+	if (!tx && opt->check_recved_len)
+		iov_alloc_length *= 2;
+
+	err = msg_alloc_iov(&msg, iov_count, iov_alloc_length, data, tx);
 	if (err)
 		goto out_errno;
 	if (peek_flag) {
@@ -678,6 +683,13 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 			if (recv > 0)
 				s->bytes_recvd += recv;
 
+			if (opt->check_recved_len && s->bytes_recvd > total_bytes) {
+				errno = EMSGSIZE;
+				fprintf(stderr, "recv failed(), bytes_recvd:%zd, total_bytes:%f\n",
+						s->bytes_recvd, total_bytes);
+				goto out_errno;
+			}
+
 			if (data) {
 				int chunk_sz = opt->sendpage ?
 						iov_length :
@@ -759,7 +771,8 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	rxpid = fork();
 	if (rxpid == 0) {
-		iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
+		if (txmsg_pop || txmsg_start_pop)
+			iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
 		if (opt->drop_expected || txmsg_ktls_skb_drop)
 			_exit(0);
 
@@ -1708,6 +1721,19 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
 	test_exec(cgrp, opt);
 }
 
+static void test_txmsg_ingress_parser2(int cgrp, struct sockmap_options *opt)
+{
+	if (ktls == 1)
+		return;
+	skb_use_parser = 10;
+	opt->iov_length = 20;
+	opt->iov_count = 1;
+	opt->rate = 1;
+	opt->check_recved_len = true;
+	test_exec(cgrp, opt);
+	opt->check_recved_len = false;
+}
+
 char *map_names[] = {
 	"sock_map",
 	"sock_map_txmsg",
@@ -1802,7 +1828,8 @@ struct _test test[] = {
 	{"txmsg test pull-data", test_txmsg_pull},
 	{"txmsg test pop-data", test_txmsg_pop},
 	{"txmsg test push/pop data", test_txmsg_push_pop},
-	{"txmsg text ingress parser", test_txmsg_ingress_parser},
+	{"txmsg test ingress parser", test_txmsg_ingress_parser},
+	{"txmsg test ingress parser2", test_txmsg_ingress_parser2},
 };
 
 static int check_whitelist(struct _test *t, struct sockmap_options *opt)
-- 
2.43.0



