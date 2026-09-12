Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469E247AF69;
	Sat, 12 Sep 2026 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216186; cv=none; b=eauXIRb1oj/WvO+lmffBJ6RyQqCyHuldfoNXFiZA/eoHAOJIyx+nAJpUFon1lw8Ia/gxJPJwaetQ8nsVok+anQZz8hhJuDDYd29Mw4ADBaD6A2BQ/JfxoUdiL0gN6WUFH4LSzukqF/iYClW1HDIBpV5DUv891TavAFf1YhvbUoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216186; c=relaxed/simple;
	bh=yHRx13oxynjn010d+f+K/iUaUHq0/Jz2oU6/uj7HbK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIyL4P9btnBAO3MIm0B5IY5rH1XugE2jnpAmLSy2/vr9/KYbCcJ3AVNYD5Zjfgd7sbuCaocxqF+CQ6k8IiPNTC+YWlL0xeGNSk0JWhcTJwtTJERfw7YOaR6ub/IVBbHL8/EJxBYdlX8SJw8V/wL3YBklIxLxIAY5BU5APqGbfyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIeqozAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIeqozAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4235C1F000FF;
	Sat, 12 Sep 2026 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216184;
	bh=EWfJzhCDRV2RAUAOOFAhAtaTlKIH1IWahdG1zRdX/YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIeqozALup77xCUmQFXfYB4LMpzmoUgswdm24kpphWbDKMZePmsatb3GTmsOgXeJv
	 SWsGJDNodbKqJaRFJizh+6FN0Ud5HWBU8BPPOlOCFX6QpkvP0Me6bzUggCc9UEFktt
	 1lSJsdHfQwsoP6yJMUv+bda9f9pIGE9FsNjNroxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0684/1376] selftests/bpf: Fix incorrect error checking for pthread_create
Date: Sat, 12 Sep 2026 08:51:50 +0200
Message-ID: <20260912065622.791672467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fa829a7854f24..a48a3b1f687e6 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1561,7 +1561,7 @@ static void server_main(void)
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



