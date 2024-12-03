Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491DB1F890F;
	Tue,  3 Dec 2024 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238583; cv=none; b=TuajNv1KTdohlD9GX6N9Yi4U/nLbAKT4SkiUnZB8EmrTCfxKDFOGKxGfCS/2f2pX2nTFN2kQ4OHbVskl3cc+J0Go/v8yBDnQjMXKk2TafeO0R5GNN3UeYH2iARNu2KzoR+25Q9oCH5dAOTaD6S1PnnVemuxH57pw1e4w7L4KygI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238583; c=relaxed/simple;
	bh=s48d1+IDHhU3bjKEu+JX6PMPpyXuHxGeU6LZmYc0RQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKslLX97OrTSv3CjGsgN8QYjx1p30NIM0PrpdWkdVAoHgw/0YPM2Bc2T7AqsjGYRBcatG3jVR235o+AGsv1Hoj2FbJ59gMj4CNQl8Ko62qf2K/w9Dt4WkMZPL1CZnDCI6ebXUZEnFDx9bO8FV2ZRtkbA8dtFpa8Uj0PXsbX5gCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eopvXJ5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eopvXJ5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4441C4CED6;
	Tue,  3 Dec 2024 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238583;
	bh=s48d1+IDHhU3bjKEu+JX6PMPpyXuHxGeU6LZmYc0RQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eopvXJ5sAscQgw+uoL9NBTjMbeaTY5bSCvzrPiZjEbRUQsSwJDjwGHnK8VqLldkLi
	 HMa0k8wfI0wI9lc5JDF+301GxXXuNYJ8f73jK+/VLTppGhkE7N8NEUjhABMkXDpyz+
	 l2bVvrLZ7vgKKEVFM2PBayFQQngcF8xs7l2jXEfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 327/817] selftests/bpf: Add txmsg_pass to pull/push/pop in test_sockmap
Date: Tue,  3 Dec 2024 15:38:19 +0100
Message-ID: <20241203144008.582204319@linuxfoundation.org>
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

[ Upstream commit 66c54c20408d994be34be2c070fba08472f69eee ]

Add txmsg_pass to test_txmsg_pull/push/pop. If txmsg_pass is missing,
tx_prog will be NULL, and no program will be attached to the sockmap.
As a result, pull/push/pop are never invoked.

Fixes: 328aa08a081b ("bpf: Selftests, break down test_sockmap into subtests")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241106222520.527076-2-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 075c93ed143e6..0f065273fde32 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1596,11 +1596,13 @@ static void test_txmsg_cork_hangs(int cgrp, struct sockmap_options *opt)
 static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 {
 	/* Test basic start/end */
+	txmsg_pass = 1;
 	txmsg_start = 1;
 	txmsg_end = 2;
 	test_send(opt, cgrp);
 
 	/* Test >4k pull */
+	txmsg_pass = 1;
 	txmsg_start = 4096;
 	txmsg_end = 9182;
 	test_send_large(opt, cgrp);
@@ -1629,11 +1631,13 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
 static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 {
 	/* Test basic pop */
+	txmsg_pass = 1;
 	txmsg_start_pop = 1;
 	txmsg_pop = 2;
 	test_send_many(opt, cgrp);
 
 	/* Test pop with >4k */
+	txmsg_pass = 1;
 	txmsg_start_pop = 4096;
 	txmsg_pop = 4096;
 	test_send_large(opt, cgrp);
@@ -1662,11 +1666,13 @@ static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
 static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 {
 	/* Test basic push */
+	txmsg_pass = 1;
 	txmsg_start_push = 1;
 	txmsg_end_push = 1;
 	test_send(opt, cgrp);
 
 	/* Test push 4kB >4k */
+	txmsg_pass = 1;
 	txmsg_start_push = 4096;
 	txmsg_end_push = 4096;
 	test_send_large(opt, cgrp);
@@ -1687,6 +1693,7 @@ static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 
 static void test_txmsg_push_pop(int cgrp, struct sockmap_options *opt)
 {
+	txmsg_pass = 1;
 	txmsg_start_push = 1;
 	txmsg_end_push = 10;
 	txmsg_start_pop = 5;
-- 
2.43.0



