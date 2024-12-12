Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80C4F218;
	Thu, 12 Dec 2024 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023971; cv=none; b=PshmJj5ZrVKqXP2u7zagHva2grG8++1MFJ2IBuQ4xrj4j61DJDXYuK1py/EIJLgBiM6P6WmgkwFQvEImPamJRcSz87dnyG0+1f3CqTL/UezximM0meyVxfv/thVcBXwy9g2uA+gUy7HkkaS4FSd7EaW0PNoOboysl4b104Sz84A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023971; c=relaxed/simple;
	bh=4VkXY44zh8CDct22bVDkTqxdEN/bPZa3pYqCqxV0dqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDZ9S2YdVfucTqYRJhFDQhCy4A0crn5uwR8Me3yQMdRop51VsfKEOXMiTyUFuc6bZijkr3uHenFo7jZZUg++70QrCMZrfpXAKuHW7BU9RM2MqX0t8FzP0sgRd1wRbvZJsPpv+l2xkhJtOrJxEPLP6TBseU913Ts7qrivBxK9Zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJCVo35C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJCVo35C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A64C4CECE;
	Thu, 12 Dec 2024 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023971;
	bh=4VkXY44zh8CDct22bVDkTqxdEN/bPZa3pYqCqxV0dqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJCVo35C3crJC+6iVDFVRQ+Z6PY6Rg3GuEUz26Rx3jnGOrIKpinKBmgyoUanrAxPR
	 g0T5P37RXYe32h/YPRRCX8fX7FtXaQvA2CwRVHssb9IaG8gdyk8gs8OdMyT1XevGn3
	 Q/dIT2Ns0wO+B9lhmmcFhuJJyY9dg4q7mAOUF5Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/459] selftests, bpf: Add one test for sockmap with strparser
Date: Thu, 12 Dec 2024 15:58:01 +0100
Message-ID: <20241212144259.161144671@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 46a1ca4f699e2..89d215416a34e 100644
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



