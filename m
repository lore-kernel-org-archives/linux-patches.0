Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C969C223302;
	Thu, 12 Dec 2024 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019328; cv=none; b=cpaaRhcS/QpyMMq4jHQrW37ugjx/r0M1oIgV2ZbRA0GECzxcKh3RwIKA0GsTX+u2JGcDhM9ecxXF/Z5jC8ufV6rA9kqTqRduYh2U4YdytZOhU/SY/Myr6EAGHEKy/2mb6UoUOp3v6PbuNy205RuLwyYN5UFA+mKFoFz1ZghqH5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019328; c=relaxed/simple;
	bh=0Jw2QFYHVlghpQaLwIjsn+2L1PzRois590FnRQJx26A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXq1669sCdMlVpE/3ciNFreFJumZGrNqbTtEjHchCY6rEkXPurGCRQvr0QpHsQyRqkNUk+dWHsimFD8U2AV259JkaB0EKaooRX5Mw4ZqQgnw9I6zPV/+lWyNAlYv+VvRFYOL+SV7n20BMBnKQy1YtgjBVGUMaSTlYkx38E6OXGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCJrwa1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCJrwa1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B813C4CED0;
	Thu, 12 Dec 2024 16:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019328;
	bh=0Jw2QFYHVlghpQaLwIjsn+2L1PzRois590FnRQJx26A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCJrwa1aqVx2eIPCGWtbdfZ+v1Y3kOzksuMlWyIKMc5SMIVNl1pl6PrWtOVc9wqkc
	 a9fe4B++fJ/h7VVn3iAoTFs6A8vSDJDCXjr8QTb091QsUIfxZDg3L30Dx0d471yhe/
	 PJw41T7fju5FY63uUr6/lJCbDPLw6xNMMmRQ8sIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/772] selftests/bpf: Add txmsg_pass to pull/push/pop in test_sockmap
Date: Thu, 12 Dec 2024 15:52:03 +0100
Message-ID: <20241212144357.300142163@linuxfoundation.org>
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
index 1954c2aeb7a9c..102a9bafbe6bc 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1599,11 +1599,13 @@ static void test_txmsg_cork_hangs(int cgrp, struct sockmap_options *opt)
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
@@ -1632,11 +1634,13 @@ static void test_txmsg_pull(int cgrp, struct sockmap_options *opt)
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
@@ -1665,11 +1669,13 @@ static void test_txmsg_pop(int cgrp, struct sockmap_options *opt)
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
@@ -1690,6 +1696,7 @@ static void test_txmsg_push(int cgrp, struct sockmap_options *opt)
 
 static void test_txmsg_push_pop(int cgrp, struct sockmap_options *opt)
 {
+	txmsg_pass = 1;
 	txmsg_start_push = 1;
 	txmsg_end_push = 10;
 	txmsg_start_pop = 5;
-- 
2.43.0



