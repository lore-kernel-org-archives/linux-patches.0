Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E341F76D4;
	Tue,  3 Dec 2024 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241158; cv=none; b=ChUbN62egiFfMq/LdlKKZeYm1sAdGLoWeYzFa27d3Jcvs13yVubr9Pk5v5MmcuhjCmioEUF1oC4HVaUvB9hIshMJ5RhyED5qtSPicrYfz5CImK0BrBU2EUaudRY8yZwTLeYKkWX6wYSk+h+cvCabuwJjNoGYC0sD8lyivl/Y4g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241158; c=relaxed/simple;
	bh=BV7UKlFYQJGqdclhIyyFie1pFLZMU8DxXbN9lpnkpOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjzfDIG10E8Hwow3+o8hx7tt8/ZLB97AI4E42buV99Oe5oui+1r8PXBOa77pRT0XKbFC9vju2CMAMjpvVZnma08qCB3+IEvELGSIswpxqXTbXlt7W08pN8lmabKevyL6/EFG2/tgNQ13ouoI6iH3HB3xDMvVyNldlz7M3JxK6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmtj42+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmtj42+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767ABC4CECF;
	Tue,  3 Dec 2024 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241158;
	bh=BV7UKlFYQJGqdclhIyyFie1pFLZMU8DxXbN9lpnkpOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmtj42+9v7mqKTJWTXBbLeul5MQrBXJSpaLiAmzWruUCzw2aZeVeDKACO0vuHbHjX
	 uJQPbRB82MMUihyyIwqGlYq7ArxtRR3bLxotSig8bvMDBhqKmH5dx4F55v4xpf7/PD
	 LaIbwbRMWmyMH8+LdEeUCWPoWR8Nly4Yvf+OAgjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/826] selftests/bpf: Add push/pop checking for msg_verify_data in test_sockmap
Date: Tue,  3 Dec 2024 15:40:38 +0100
Message-ID: <20241203144755.895962748@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 862087c3d36219ed44569666eb263efc97f00c9a ]

Add push/pop checking for msg_verify_data in test_sockmap, except for
pop/push with cork tests, in these tests the logic will be different.
1. With corking, pop/push might not be invoked in each sendmsg, it makes
the layout of the received data difficult
2. It makes it hard to calculate the total_bytes in the recvmsg
Temporarily skip the data integrity test for these cases now, added a TODO

Fixes: ee9b352ce465 ("selftests/bpf: Fix msg_verify_data in test_sockmap")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241106222520.527076-5-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 106 ++++++++++++++++++++-
 1 file changed, 101 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 5f4558f1f0049..61a747afcd05f 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -88,6 +88,10 @@ int ktls;
 int peek_flag;
 int skb_use_parser;
 int txmsg_omit_skb_parser;
+int verify_push_start;
+int verify_push_len;
+int verify_pop_start;
+int verify_pop_len;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -514,12 +518,41 @@ static int msg_alloc_iov(struct msghdr *msg,
 	return -ENOMEM;
 }
 
-/* TODO: Add verification logic for push, pull and pop data */
+/* In push or pop test, we need to do some calculations for msg_verify_data */
+static void msg_verify_date_prep(void)
+{
+	int push_range_end = txmsg_start_push + txmsg_end_push - 1;
+	int pop_range_end = txmsg_start_pop + txmsg_pop - 1;
+
+	if (txmsg_end_push && txmsg_pop &&
+	    txmsg_start_push <= pop_range_end && txmsg_start_pop <= push_range_end) {
+		/* The push range and the pop range overlap */
+		int overlap_len;
+
+		verify_push_start = txmsg_start_push;
+		verify_pop_start = txmsg_start_pop;
+		if (txmsg_start_push < txmsg_start_pop)
+			overlap_len = min(push_range_end - txmsg_start_pop + 1, txmsg_pop);
+		else
+			overlap_len = min(pop_range_end - txmsg_start_push + 1, txmsg_end_push);
+		verify_push_len = max(txmsg_end_push - overlap_len, 0);
+		verify_pop_len = max(txmsg_pop - overlap_len, 0);
+	} else {
+		/* Otherwise */
+		verify_push_start = txmsg_start_push;
+		verify_pop_start = txmsg_start_pop;
+		verify_push_len = txmsg_end_push;
+		verify_pop_len = txmsg_pop;
+	}
+}
+
 static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz,
-				 unsigned char *k_p, int *bytes_cnt_p)
+			   unsigned char *k_p, int *bytes_cnt_p,
+			   int *check_cnt_p, int *push_p)
 {
-	int i, j, bytes_cnt = *bytes_cnt_p;
+	int bytes_cnt = *bytes_cnt_p, check_cnt = *check_cnt_p, push = *push_p;
 	unsigned char k = *k_p;
+	int i, j;
 
 	for (i = 0, j = 0; i < msg->msg_iovlen && size; i++, j = 0) {
 		unsigned char *d = msg->msg_iov[i].iov_base;
@@ -538,6 +571,37 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz,
 		}
 
 		for (; j < msg->msg_iov[i].iov_len && size; j++) {
+			if (push > 0 &&
+			    check_cnt == verify_push_start + verify_push_len - push) {
+				int skipped;
+revisit_push:
+				skipped = push;
+				if (j + push >= msg->msg_iov[i].iov_len)
+					skipped = msg->msg_iov[i].iov_len - j;
+				push -= skipped;
+				size -= skipped;
+				j += skipped - 1;
+				check_cnt += skipped;
+				continue;
+			}
+
+			if (verify_pop_len > 0 && check_cnt == verify_pop_start) {
+				bytes_cnt += verify_pop_len;
+				check_cnt += verify_pop_len;
+				k += verify_pop_len;
+
+				if (bytes_cnt == chunk_sz) {
+					k = 0;
+					bytes_cnt = 0;
+					check_cnt = 0;
+					push = verify_push_len;
+				}
+
+				if (push > 0 &&
+				    check_cnt == verify_push_start + verify_push_len - push)
+					goto revisit_push;
+			}
+
 			if (d[j] != k++) {
 				fprintf(stderr,
 					"detected data corruption @iov[%i]:%i %02x != %02x, %02x ?= %02x\n",
@@ -545,15 +609,20 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz,
 				return -EDATAINTEGRITY;
 			}
 			bytes_cnt++;
+			check_cnt++;
 			if (bytes_cnt == chunk_sz) {
 				k = 0;
 				bytes_cnt = 0;
+				check_cnt = 0;
+				push = verify_push_len;
 			}
 			size--;
 		}
 	}
 	*k_p = k;
 	*bytes_cnt_p = bytes_cnt;
+	*check_cnt_p = check_cnt;
+	*push_p = push;
 	return 0;
 }
 
@@ -612,6 +681,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		struct timeval timeout;
 		unsigned char k = 0;
 		int bytes_cnt = 0;
+		int check_cnt = 0;
+		int push = 0;
 		fd_set w;
 
 		fcntl(fd, fd_flags);
@@ -637,6 +708,10 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		}
 		total_bytes += txmsg_push_total;
 		total_bytes -= txmsg_pop_total;
+		if (data) {
+			msg_verify_date_prep();
+			push = verify_push_len;
+		}
 		err = clock_gettime(CLOCK_MONOTONIC, &s->start);
 		if (err < 0)
 			perror("recv start time");
@@ -712,7 +787,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 						iov_length :
 						iov_length * iov_count;
 
-				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt);
+				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt,
+							&check_cnt, &push);
 				if (errno) {
 					perror("data verify msg failed");
 					goto out_errno;
@@ -722,7 +798,9 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 								recvp,
 								chunk_sz,
 								&k,
-								&bytes_cnt);
+								&bytes_cnt,
+								&check_cnt,
+								&push);
 					if (errno) {
 						perror("data verify msg_peek failed");
 						goto out_errno;
@@ -1636,6 +1714,8 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 
 static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 {
+	bool data = opt->data_test;
+
 	/* Test basic pop */
 	txmsg_pass = 1;
 	txmsg_start_pop = 1;
@@ -1654,6 +1734,12 @@ static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 	txmsg_pop = 2;
 	test_send_many(opt, cgrp);
 
+	/* TODO: Test for pop + cork should be different,
+	 * - It makes the layout of the received data difficult
+	 * - It makes it hard to calculate the total_bytes in the recvmsg
+	 * Temporarily skip the data integrity test for this case now.
+	 */
+	opt->data_test = false;
 	/* Test pop + cork */
 	txmsg_redir = 0;
 	txmsg_cork = 512;
@@ -1667,10 +1753,13 @@ static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
 	test_send_many(opt, cgrp);
+	opt->data_test = data;
 }
 
 static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 {
+	bool data = opt->data_test;
+
 	/* Test basic push */
 	txmsg_pass = 1;
 	txmsg_start_push = 1;
@@ -1689,12 +1778,19 @@ static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 	txmsg_end_push = 2;
 	test_send_many(opt, cgrp);
 
+	/* TODO: Test for push + cork should be different,
+	 * - It makes the layout of the received data difficult
+	 * - It makes it hard to calculate the total_bytes in the recvmsg
+	 * Temporarily skip the data integrity test for this case now.
+	 */
+	opt->data_test = false;
 	/* Test push + cork */
 	txmsg_redir = 0;
 	txmsg_cork = 512;
 	txmsg_start_push = 1;
 	txmsg_end_push = 2;
 	test_send_many(opt, cgrp);
+	opt->data_test = data;
 }
 
 static void test_txmsg_push_pop(int cgrp, struct sockmap_options *opt)
-- 
2.43.0



