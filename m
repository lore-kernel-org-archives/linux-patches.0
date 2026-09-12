Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AF63148DA;
	Sat, 12 Sep 2026 07:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199747; cv=none; b=WADDafBGZV5tqc+Yx4ym542JYP+/8QKN+A8udV+JF+9hNx0L1xOeq9GqUJ2gwqssyqd2EGGPAb1Q3OwtFoU6OdXnaiUTzjxO762br0I7+D/JCUy51b9ceq8ufHM8/di4N7BSVnjhn4/wXEQ1/YzmNrPwC5w4Rg4K/zY4iPNuBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199747; c=relaxed/simple;
	bh=4P9lj8XQz1UA+US6sNK4Q5X3WUfZtb8ks5+uSqEiwqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVeRMC6RtU3pHKArXvaggWyiinIK+eRObH9SAtbJp762Ul8kEifydD7O8e5LjMevqmtMnXy9unDjSXLKfBq+xADzMpBlAHMnJMvSm0Oy+ZQNXewi5/TFaCbeLIwv8av0l9+6KmfVVFU0TO1amgZEt3PDt0p1B3puP1IyU5m+Fts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REGd/JnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REGd/JnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52131F000FF;
	Sat, 12 Sep 2026 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199745;
	bh=2manMoq86SLUmmwGpBC/+2q2Q+uBxsgaoyf2f+E7RJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REGd/JnQ3R7sGo8n+2NMNu9cgyY/9q3HMjY0X11YVKxMnis9mAbIeIe9rvSmAQIDS
	 56g6rdVuk5D4wO1H6VYDl/hXnAtlJYvDPl4PA+Bsz02cc+NJabQtFnwpHLVYMeELP2
	 qp3Nc46VDY+XQLO0ANw+eAidT6jZ2A87c8kWrbVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0649/1815] selftests/bpf: Fix incorrect error checking for pthread_create
Date: Sat, 12 Sep 2026 08:39:59 +0200
Message-ID: <20260912065704.115781912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit b04b8d4e198aefc863e7b702ececb957845b0c25 ]

pthread_create returns 0 on success and a positive error code on failure;
it never returns a negative value. The current conditional branch can never be taken.
Failures during thread creation are silently ignored, which will lead to
invalid memory access when waiting on threads or dereferencing thread handles later.

Fixes: 91b2c0afd00c ("selftests/bpf: Add parallelism to test_progs")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Link: https://lore.kernel.org/bpf/20260723085100.482147-3-yangfeng59949@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 7ba82974ee784..643c199c3e0c1 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1741,7 +1741,7 @@ static void server_main(void)
 		data[i].worker_id = i;
 		data[i].sock_fd = env.worker_socks[i];
 		rc = pthread_create(&dispatcher_threads[i], NULL, dispatch_thread, &data[i]);
-		if (rc < 0) {
+		if (rc) {
 			perror("Failed to launch dispatcher thread");
 			exit(EXIT_ERR_SETUP_INFRA);
 		}
-- 
2.53.0



