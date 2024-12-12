Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87F20967D;
	Thu, 12 Dec 2024 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022190; cv=none; b=EP2YhOSM7WDGkwvB2bPOvmMz7tNyVmMGVM3qxZZ78/nOH6azYduThSt52Ffy3yry5saqUsMooRrMiynLZ7d7QNNaq0AbFwOqyM6ckc3P1zVyPmanGNcbVLt+iKI/Yhwg86H0GT0dfvFy/OBDBqk9QuyGt6gUgTOE4jQR3LFD+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022190; c=relaxed/simple;
	bh=39YDM7htdoFmQtE8f8USdEAn0A5D108Ql4WzdKAc018=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4LFNDQte/eQolydsY+YyzoGOZGSjqHsq194SwPksAhjatilvl4RkSYzfo40Nf9nNjFnMM931Wb2xy4RboYuyTMzBtXJ4GUVtaeiIplxziVoaHKcHgGlPE4P5lsbUaWem3D3ylHZYvxiApo819HRu0LXfSYR9/a3RGpW6UlZges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De1Xs8zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De1Xs8zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA065C4CECE;
	Thu, 12 Dec 2024 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022190;
	bh=39YDM7htdoFmQtE8f8USdEAn0A5D108Ql4WzdKAc018=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De1Xs8zCL957bVEZ4G0ILJrbQ0gyqqk7Gj3c1RmUk/MoQfYsZwxTbJSTtbk8+4Ep+
	 EePHp6wQaXqqDtHZcWZsHmHYpwt59tMOqr2XBHaD6kHqf2C20q1M/peNrK3zC9rvdI
	 odBs8GO2MyXubKpwQfWU1UvqSgFOiaDCD3V9/ONY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/565] selftests/bpf: Fix msg_verify_data in test_sockmap
Date: Thu, 12 Dec 2024 15:56:07 +0100
Message-ID: <20241212144318.273995552@linuxfoundation.org>
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
index 230ca335a9919..8404f09cb1e35 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -58,6 +58,8 @@ static void running_handler(int a);
 #define BPF_SOCKHASH_FILENAME "test_sockhash_kern.o"
 #define CG_PATH "/sockmap"
 
+#define EDATAINTEGRITY 2001
+
 /* global sockets */
 int s1, s2, c1, c2, p1, p2;
 int test_cnt;
@@ -509,23 +511,25 @@ static int msg_alloc_iov(struct msghdr *msg,
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
@@ -535,7 +539,7 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 				fprintf(stderr,
 					"detected data corruption @iov[%i]:%i %02x != %02x, %02x ?= %02x\n",
 					i, j, d[j], k - 1, d[j+1], k);
-				return -EIO;
+				return -EDATAINTEGRITY;
 			}
 			bytes_cnt++;
 			if (bytes_cnt == chunk_sz) {
@@ -545,6 +549,8 @@ static int msg_verify_data(struct msghdr *msg, int size, int chunk_sz)
 			size--;
 		}
 	}
+	*k_p = k;
+	*bytes_cnt_p = bytes_cnt;
 	return 0;
 }
 
@@ -593,6 +599,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		float total_bytes, txmsg_pop_total;
 		int fd_flags = O_NONBLOCK;
 		struct timeval timeout;
+		unsigned char k = 0;
+		int bytes_cnt = 0;
 		fd_set w;
 
 		fcntl(fd, fd_flags);
@@ -671,7 +679,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 						iov_length * cnt :
 						iov_length * iov_count;
 
-				errno = msg_verify_data(&msg, recv, chunk_sz);
+				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt);
 				if (errno) {
 					perror("data verify msg failed");
 					goto out_errno;
@@ -679,7 +687,9 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
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
@@ -770,7 +780,7 @@ static int sendmsg_test(struct sockmap_options *opt)
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



