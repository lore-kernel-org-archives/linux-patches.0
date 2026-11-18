Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033034;
	b=qbAxQVYtZm8AlMD075N0nyaGiJCMBG8yy99xaEtKt0tcFiKiONS9tN7uS54n/C1g4Dxm
	 bHzhC41eVnVsN86cZ7qEnTdF5uNqzYzkCl90pXc1dfxbmuHBl7XaRq9y29OzWAFQWhoJt
	 Rn1uJdO6HfRnZ68RWlZTsVvulnV93WewE0M1iqH8sa4/zJSq7/L4w0Syb4rsKsskgSVqi
	 zqg6iA1qJXcWmAd1/bV1oByLwUCIiFhnhicoKUL3LoN3YwW3bVRrnt47eJDfzCNfCXRn5
	 Fy5YcWT/rN499qW8exkgQedAyBZGoSGx6EfVznc98kYlgxqwP5I/Tkw3FnquwlvlxTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WsPJpC0dc8DFKZrLKR3ioZ4E+Bd1XVQEcDxG9SKQD+E=;
	b=5QHQ0tu9UNuQ13LvM/2HxkOjEUyPJEgnQcsDGd9bu7SsgeZO3440B4pN34ciB+r0NFUQ
	 uPIuIOUpJPZp+q9Xrvz6QMDIfzm4NKSaF5uVkwAzuF1QhPsigB/HIz+dCDx0B2FFcYVIP
	 zhc+2l4PGiV4P8t7vExNt8nixr4R7JTMeF1FWt0EA7K7HmWodLEiy78afFq/zYOz7sq8a
	 +xMAqhk8Ukmh95WqnSOCs2tkYT1WWKnoshQ9PMrIYyoOmrqic+vzyNqMDO9oDb3vCUd1C
	 9UcQiKMVw0i+Hsy0ymTCXk8Mk9BnJwOe35AyYdOUia2uTtFck7esK6by01sJge8VXJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2NbCm31;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED080606A31C;
	Wed, 18 Nov 2026 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2NbCm31
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6E11F000C4;
	Wed, 18 Nov 2026 20:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033033;
	bh=WsPJpC0dc8DFKZrLKR3ioZ4E+Bd1XVQEcDxG9SKQD+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2NbCm31mlNqm79rHbJbdDbI9ReD6iPLP4+MERsKtCzZaxf1873Ar8F7k6dfYwTGb
	 JcZoUvPk1mkSKN9VFWk0k8dNLP9rh/5SHzfpV7EHvp51LueX12yw/kWLUlaWhDHrqg
	 AxKQkqj8GVqVMMA82A2dOksRtnv93Jdho635qdhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1624/1756] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150114.469747576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2f61b9d1d54edf75a352c43eebe3804144b5d44e ]

If metadata SGL allocation fails, nvmet_req_alloc_sgls() frees
req->sg without clearing it. The RDMA error completion path later
frees the same scatterlist again.

Use nvmet_req_free_sgls() instead so that the scatterlist pointers
and counts are cleared before response cleanup.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e2ebc699ae6c4..c4a4af8a0547c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1136,7 +1136,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



