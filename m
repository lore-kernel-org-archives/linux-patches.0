Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D6142885F;
	Sat, 12 Sep 2026 16:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230045; cv=none; b=Op/n82xkp5/cl6/KrPhTO5DBPjFiz1V5JPLV7z5NNx4ZZzFAWmAr1V4GctFb5CDi8HgHz6gBQusy2f/T9La5sa0bNjNCDBzet1dCUGiVtSrID/R9qlX2La18VPshP/NpwpB5sZ98EShk8hKF5rpGdfbwhoH95tjcSfmHYKR4Jcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230045; c=relaxed/simple;
	bh=LAgsyw530DWoKksmcz/hJvtUOU5bm31RZIzSvk438N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/AiWD8TQ+yNawTquYgD4qHnVJDY7znzzsTq2Rq/wevBikiwLJoLcP+4xXXxPQiqrCnSFqotOaQs5nmvC4Uw/4WWI4AfXtE1ZjdB6ulm3PYitAyi2mrA+vKliXL0Dz4U0Ml/T3qUPvY469hA+FFjXvh8XZYy+sHRn4TFsuHCs24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipieGEqB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipieGEqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2881F000FF;
	Sat, 12 Sep 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230042;
	bh=8JJiTweqUFX1g/OzEEJWvguTGO4yLLiQUp41qVgumuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipieGEqB6cVZ3V/c6/+o4lkDStv+2sjCiRrzDrzlZLBAT3BThQq2+z5mkG6c662go
	 kw9pu0dnVa9P6QQKU5Ygugsg2qbH2VIbZ5/AP0C0zemFIBYS2F84jHhDLeKUuXA6S8
	 /A3LbGlugsRIK27EOse6rVc04x6tJQ7z9iVMxnfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0713/1191] selftests/bpf: Fix incorrect error checking for pthread_create
Date: Sat, 12 Sep 2026 08:57:21 +0200
Message-ID: <20260912065604.292959006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6068f5bde8fd5..9f827139655a6 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1260,7 +1260,7 @@ static void server_main(void)
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



