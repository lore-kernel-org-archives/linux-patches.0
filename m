Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4CC1F8914;
	Tue,  3 Dec 2024 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238586; cv=none; b=c5EPyu6ZYFmbOQzbXrNIjgDtxzT2uLC+eXqWXlQl4xora/2bjAX5KF2HnES3s6V4wmP6peL/yx0nPabXBkCt4DH+aZAgzuYsg4BLw8ABjE7k0OCGLRKoeNIBjbkeLMyQEBi6qDUo9EbpmkSmXgCwHM5zad0dIE85vMv9TQLGhTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238586; c=relaxed/simple;
	bh=vzks/Ii0p2Z7Cy9f9+QwVbE4iowGt/E+UBjHwS5RQ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RG3GPfqk2rrKBEGlNaSCIZ0yPt6uyu0C9jVHsT0upVrtGtnYuacjJHVzreuxgbxOo+GJYX+ryOcNEuPM6GQA2/GV2SQZh05yTR8wDqJu3kBZLowgXR3ncNCMY0ALVoPAbrHvOqQk7gJ6bC1rnJXPLRmm4l7elmRi6eYHr3GwDlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INGcj7G6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INGcj7G6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3DDC4CED6;
	Tue,  3 Dec 2024 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238586;
	bh=vzks/Ii0p2Z7Cy9f9+QwVbE4iowGt/E+UBjHwS5RQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INGcj7G6C+JJQWAoo3mNFPUMugOMIhXgMxB8ZCSS7+zvjxBh+wkfI8gPs5WqtfCzW
	 zRFcOzFhr2IB5mEtI1cxxVtc1kuHC5+JSdU5HVlYdmxM3G+bY28IXSpBjL7Plf1MvL
	 lXOwL9NpNE2hsmjxEhsqdBp+16cHUtjANwGR36Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 328/817] selftests/bpf: Fix SENDPAGE data logic in test_sockmap
Date: Tue,  3 Dec 2024 15:38:20 +0100
Message-ID: <20241203144008.622529349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0f065273fde32..1d59bed90d80b 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -420,16 +420,18 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
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
 
@@ -623,7 +625,9 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
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
@@ -701,7 +705,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 
 			if (data) {
 				int chunk_sz = opt->sendpage ?
-						iov_length * cnt :
+						iov_length :
 						iov_length * iov_count;
 
 				errno = msg_verify_data(&msg, recv, chunk_sz, &k, &bytes_cnt);
@@ -1466,8 +1470,8 @@ static void test_send_many(struct sockmap_options *opt, int cgrp)
 
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



