Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE61DF981;
	Tue,  3 Dec 2024 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240835; cv=none; b=j3jOa6eOTIoSVVqc5q2CiGu1EGjObnRCPJMnvhjLnjBl0RwmpVZPF7NSHFRqCPsbj+bArp9OX6yGWVuzOVCOlJ71MPftMv4aEs+QwKLHNzrGR7GiJ4+7QyMhcZfQJ/QAhymMoeY2CRAiE2ig1+dpFHj2TbbJzNgdRLoUQe9q2lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240835; c=relaxed/simple;
	bh=xdS4AW+Dbbj1U28uldceDwlRBe4LaQ0+XUoQAXertn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhBpsBNYTFUEZg7BZateKs/nSCtdM/E3Mv8KoEvNZx9k4pEksrceTLDU2zFHtkaoB+iYJ97S15HQBs1JVDT2jZhnFpDzajABBTCQXlZKvN8EwmFC5PJ7E+ejNUUZ4bkQopPb8pcgag6mJl3lXuLrhBsQv58j28aFPwmRLF0TZAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1Ez7iwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1Ez7iwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEDDC4CECF;
	Tue,  3 Dec 2024 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240834;
	bh=xdS4AW+Dbbj1U28uldceDwlRBe4LaQ0+XUoQAXertn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1Ez7iwD6mZFWbFeCjP3Bf6BogZECBsMihk7c4aP44Dy2LvV9Cs2sk/HSRLUwiOMP
	 JpWigxiU1RE/l7enDt3DZovAgQPXa7be7at6ff/Cm3Sb27196BO+Q4vrHNct/c4cZ+
	 n7y3D2W5Gh1zYn3nUtD3XIZCSoYphxGntCs2Vswo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/826] selftests/bpf: Fix msg_verify_data in test_sockmap
Date: Tue,  3 Dec 2024 15:39:36 +0100
Message-ID: <20241203144753.479915136@linuxfoundation.org>
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

[ Upstream commit ee9b352ce4650ffc0d8ca0ac373d7c009c7e561e ]

Function msg_verify_data should have context of bytes_cnt and k instead of
assuming they are zero. Otherwise, test_sockmap with data integrity test
will report some errors. I also fix the logic related to size and index j

1/ 6  sockmap::txmsg test passthrough:FAIL
2/ 6  sockmap::txmsg test redirect:FAIL
7/12  sockmap::txmsg test apply:FAIL
10/11  sockmap::txmsg test push_data:FAIL
11/17  sockmap::txmsg test pull-data:FAIL
12/ 9  sockmap::txmsg test pop-data:FAIL
13/ 1  sockmap::txmsg test push/pop data:FAIL
...
Pass: 24 Fail: 52

After applying this patch, some of the errors are solved, but for push,
pull and pop, we may need more fixes to msg_verify_data, added a TODO

10/11  sockmap::txmsg test push_data:FAIL
11/17  sockmap::txmsg test pull-data:FAIL
12/ 9  sockmap::txmsg test pop-data:FAIL
...
Pass: 37 Fail: 15

Besides, added a custom errno EDATAINTEGRITY for msg_verify_data, we
shall not ignore the error in txmsg_cork case.

Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Fixes: 16edddfe3c5d ("selftests/bpf: test_sockmap, check test failure")
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Link: https://lore.kernel.org/r/20241012203731.1248619-2-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 30 ++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 3e02d7267de8b..8249f3c1fbd65 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -56,6 +56,8 @@ static void running_handler(int a);
 #define BPF_SOCKHASH_FILENAME "test_sockhash_kern.bpf.o"
 #define CG_PATH "/sockmap"
 
+#define EDATAINTEGRITY 2001
+
 /* global sockets */
 int s1, s2, c1, c2, p1, p2;
 int test_cnt;
@@ -510,23 +512,25 @@ static int msg_alloc_iov(struct msghdr *msg,
 	return -ENOMEM;
 }
 
-static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
+/* TODO: Add verification logic for push, pull and pop data */
+static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz,
+				 unsigned char *k_p, int *bytes_cnt_p)
 {
-	int i, j = 0, bytes_cnt = 0;
-	unsigned char k = 0;
+	int i, j, bytes_cnt = *bytes_cnt_p;
+	unsigned char k = *k_p;
 
-	for (i = 0; i < msg->msg_iovlen; i++) {
+	for (i = 0, j = 0; i < msg->msg_iovlen && size; i++, j = 0) {
 		unsigned char *d = msg->msg_iov[i].iov_base;
 
 		/* Special case test for skb ingress + ktls */
 		if (i == 0 && txmsg_ktls_skb) {
 			if (msg->msg_iov[i].iov_len < 4)
-				return -EIO;
+				return -EDATAINTEGRITY;
 			if (memcmp(d, "PASS", 4) != 0) {
 				fprintf(stderr,
 					"detected skb data error with skb ingress update @iov[%i]:%i \"%02x %02x %02x %02x\" != \"PASS\"\n",
 					i, 0, d[0], d[1], d[2], d[3]);
-				return -EIO;
+				return -EDATAINTEGRITY;
 			}
 			j = 4; /* advance index past PASS header */
 		}
@@ -536,7 +540,7 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 				fprintf(stderr,
 					"detected data corruption @iov[%i]:%i %02x != %02x, %02x ?= %02x\n",
 					i, j, d[j], k - 1, d[j+1], k);
-				return -EIO;
+				return -EDATAINTEGRITY;
 			}
 			bytes_cnt++;
 			if (bytes_cnt == chunk_sz) {
@@ -546,6 +550,8 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 			size--;
 		}
 	}
+	*k_p = k;
+	*bytes_cnt_p = bytes_cnt;
 	return 0;
 }
 
@@ -602,6 +608,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		float total_bytes, txmsg_pop_total;
 		int fd_flags = O_NONBLOCK;
 		struct timeval timeout;
+		unsigned char k = 0;
+		int bytes_cnt = 0;
 		fd_set w;
 
 		fcntl(fd, fd_flags);
@@ -696,7 +704,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 						iov_length * cnt :
 						iov_length * iov_count;
 
-				errno = msg_verify_data(&msg, recv, chunk_sz);
+				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt);
 				if (errno) {
 					perror("data verify msg failed");
 					goto out_errno;
@@ -704,7 +712,9 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 				if (recvp) {
 					errno = msg_verify_data(&msg_peek,
 								recvp,
-								chunk_sz);
+								chunk_sz,
+								&k,
+								&bytes_cnt);
 					if (errno) {
 						perror("data verify msg_peek failed");
 						goto out_errno;
@@ -812,7 +822,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 				s.bytes_sent, sent_Bps, sent_Bps/giga,
 				s.bytes_recvd, recvd_Bps, recvd_Bps/giga,
 				peek_flag ? "(peek_msg)" : "");
-		if (err && txmsg_cork)
+		if (err && err != -EDATAINTEGRITY && txmsg_cork)
 			err = 0;
 		exit(err ? 1 : 0);
 	} else if (rxpid == -1) {
-- 
2.43.0



