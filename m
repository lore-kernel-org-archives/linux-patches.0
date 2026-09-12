Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3593C3FD96B;
	Sat, 12 Sep 2026 10:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208221; cv=none; b=UNmutLiqTNHwJkd/S4AdQzyaJb5Lg5okG8/pFXh0K1od6KFIVy8PQOMfQx1aTkNas9QOpMVncShBBGR6tVqxO54NlPAYKrae2LkF9jcGhUf95Z58A9K3ghc7n4en4aHVe4HXbO0Icf0xz8ZkGurAdlyIL0fKkc48MMeoAQXnm64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208221; c=relaxed/simple;
	bh=6MlkVJN0UwNkyRMrvF6nJYxziP78qEd60moCMLQeJ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLZ5/QAw+aiHEanG93KWaLLcYIEDfRiX1V4B2FCyjEGe9HmTtmciP76hbLWqrTU327nog/ldRmK0gF7W6L3tBMqPt5JdR297f4f7w33yBZmyogr0VLIR79o7xRQJ4eTW6GbLKN5+IGGET6k4hYNxqXjobdaiWGsJ3XAhQ1vngdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An4RVUVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An4RVUVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29901F00898;
	Sat, 12 Sep 2026 10:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208217;
	bh=uVlN5xb0UMq2tpGJZVKROTPCFFui7FC/psin+O3ey58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=An4RVUVzPbTVWwSh0zJHQCAicduiwS547zbICKcCq1tiHCp1VjFcGYte3qjIp49Lv
	 47oXUWsa5ZcVWQRJlCZ+sLIFVFNhGiW/V3rfNBnYXcMYGkbo4W/zI3pQGolmTlHqqS
	 fPAcZYjf42mSqUTnulAN3JcfkhmRGfGTH3e6EMfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0573/1518] selftests/bpf: Fix incorrect error checking for pthread_create
Date: Sat, 12 Sep 2026 08:45:42 +0200
Message-ID: <20260912065636.392806671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02a85dda30e64..082f05f341e58 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1690,7 +1690,7 @@ static void server_main(void)
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



