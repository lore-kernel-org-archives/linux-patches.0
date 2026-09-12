Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740978C9C;
	Sat, 12 Sep 2026 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223855; cv=none; b=lYS0lM9vHIEK05nKcok8PCZbup5eSZaD1Vs63qjGj1qXVQns4zQORmlY74Y7Bx/zbE+x/vMmVQtp6jTWmKTPDBZxaOApyQIW5oNwNwmtQSo6GcZ3sFRBQamvanS7b0xm0P66XRs16RMfIt280mNfrx204wRv+ZuctZ/frihPLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223855; c=relaxed/simple;
	bh=0BV3R0VV/ueHarecB5pyOpSOyz+paSMxaXPLHtxS5sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMYwVx6e5Otc7VpigsbbW2n4u9tZT+03ColR76HqFrJ1MDhZlFnLJrajFgrjZaGsd+YiLHR5zyomqeXWBlcYIC/iLnrc2JJNcJUrLC6JU8QxZMF3aS+UfOjhhV3yI/AgEPbhW02lUKwzQZrZkfn/dxbvXFDciDzDdYJl/NkYNl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDaMf467; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDaMf467"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774451F000FF;
	Sat, 12 Sep 2026 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223854;
	bh=JrtlYOe8r/4wU3GHLl3g0+9jSTqJDCifNbTz+OHJTSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDaMf467O/QTfXhMBd1VDcONGnlwl7mD7OiRkDcgpoPgxPXWimlmbfxrkwA354MTU
	 WsbvzIscYozPx6OEP5uvK9/T08QXpZ/Lu6xUAw7Tc54jrjXCHaxdZPUfBvrAcaBVLq
	 enySqcx9PVbP26t9Lr1S3WOG3Q+B+ffveKGqGpBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0875/1424] selftests/bpf: Fix incorrect error checking for pthread_create
Date: Sat, 12 Sep 2026 08:55:07 +0200
Message-ID: <20260912065626.917328049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 74620ed3a166e..29a005cad80f7 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1391,7 +1391,7 @@ static void server_main(void)
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



