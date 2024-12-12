Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCE223302;
	Thu, 12 Dec 2024 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019333; cv=none; b=twqmpeMYyNt6zFeZ3fDiT8arc5XhuR4aT0jxUdlPCtbKuk7qLXn+tYCtL6NwX+Lk8F+OMF0Xzc7dd7W+cH4TmAq8Kvf+YwrXhmnw9brqtdwQg+10xlXnwW69uHxPaYw0iwdjcvN38zWRIm+JcVEeup8JhL3PZ6+TpxCQDSQEpDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019333; c=relaxed/simple;
	bh=I80I5+EEDjx+/mpuOxRbmzXrwTncZhLohgZfFO3wFlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnEg8AhzbxiuAL9N9FSJF1/YJPXuJ1duvVpV3yjVRpZCki18Id+k+uEernf2g3OELXLdcDUmmVEfS8G5ARPPyMgiAZL5RAqxlDLqBO/L9hxxKW84eynUBdcWXZULWHTiiCvrMes6rXStS4pcSsp+0W1ZNPS7wJq/0dm/w70xgig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJUdrsqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJUdrsqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AFEC4CECE;
	Thu, 12 Dec 2024 16:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019333;
	bh=I80I5+EEDjx+/mpuOxRbmzXrwTncZhLohgZfFO3wFlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJUdrsqankW/xfsSCqS9JLy49CkM9/n7QrOg3g1Jlbo3wdTq0Wk+3dZQXmINaxvNm
	 IvW9XilEl31WcFrT8q1BdvA1RskVp03BYLAHBH67Gy2zIjq9KLExj0jQLm2eHWlrEa
	 jbfu+E70D0gRt4gNJBzcgkjJ/1OLLlbkM56AZSqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/772] selftests/bpf: Fix SENDPAGE data logic in test_sockmap
Date: Thu, 12 Dec 2024 15:52:04 +0100
Message-ID: <20241212144357.341079774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 4095031463d4e99b534d2cd82035a417295764ae ]

In the SENDPAGE test, "opt->iov_length * cnt" size of data will be sent
cnt times by sendfile.
1. In push/pop tests, they will be invoked cnt times, for the simplicity of
msg_verify_data, change chunk_sz to iov_length
2. Change iov_length in test_send_large from 1024 to 8192. We have pop test
where txmsg_start_pop is 4096. 4096 > 1024, an error will be returned.

Fixes: 328aa08a081b ("bpf: Selftests, break down test_sockmap into subtests")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241106222520.527076-3-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 102a9bafbe6bc..07edc88fa9cba 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -419,16 +419,18 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 {
 	bool drop = opt->drop_expected;
 	unsigned char k = 0;
+	int i, j, fp;
 	FILE *file;
-	int i, fp;
 
 	file = tmpfile();
 	if (!file) {
 		perror("create file for sendpage");
 		return 1;
 	}
-	for (i = 0; i < iov_length * cnt; i++, k++)
-		fwrite(&k, sizeof(char), 1, file);
+	for (i = 0; i < cnt; i++, k = 0) {
+		for (j = 0; j < iov_length; j++, k++)
+			fwrite(&k, sizeof(char), 1, file);
+	}
 	fflush(file);
 	fseek(file, 0, SEEK_SET);
 
@@ -622,7 +624,9 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		 * This is really only useful for testing edge cases in code
 		 * paths.
 		 */
-		total_bytes = (float)iov_count * (float)iov_length * (float)cnt;
+		total_bytes = (float)iov_length * (float)cnt;
+		if (!opt->sendpage)
+			total_bytes *= (float)iov_count;
 		if (txmsg_apply)
 			txmsg_pop_total = txmsg_pop * (total_bytes / txmsg_apply);
 		else
@@ -700,7 +704,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 
 			if (data) {
 				int chunk_sz = opt->sendpage ?
-						iov_length * cnt :
+						iov_length :
 						iov_length * iov_count;
 
 				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt);
@@ -1469,8 +1473,8 @@ static void test_send_many(struct sockmap_options *opt, int cgrp)
 
 static void test_send_large(struct sockmap_options *opt, int cgrp)
 {
-	opt->iov_length = 256;
-	opt->iov_count = 1024;
+	opt->iov_length = 8192;
+	opt->iov_count = 32;
 	opt->rate = 2;
 	test_exec(cgrp, opt);
 }
-- 
2.43.0



