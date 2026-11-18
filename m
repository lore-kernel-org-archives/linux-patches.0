Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062121;
	b=LWEmDZitoSCI39t3mkNDOefbc1wXJOpVByLZtW0N8GZ8juGLX1B2YgGE/FS/OsFhyu2j
	 AV79MTe0Fiyh5w4b5YntwLwJsPwG6rKjB73kQeLU5l73vXTY89ZcHOBP+RePrRN9tGYLO
	 XDoemwtZvbJtNW90R8vAjKc53d13KYav5A7eIIKlNke9TKj5+K0/I7rtpIq2l2I1sz74q
	 /uq5zueK+zOGDGWfXeKcek5m8dKe7oDiqoQw5yOoVwH38PxB8lO1w6HBsGCAE8lIwg9Hf
	 XCQEJ4ZxcmJzC2IWzxrxxY6zIa8mxSL8C0ZT9UAZwueEg32K/CYsyGyqtTepVKiijhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOtKQ5kQ8cwkDmB3vis30rFDJwZbxDySkV287kbicR0=;
	b=2foS/C+VRnh1wWjPE9AoUn5Caf3xV56n632rWcRzrZbPRaeqZ0dG//YZsCJL4GOChSZ1
	 orEl/zOPeo2E7INSxuCgjCuORA1e6X7rPjfttw+DUxCUIYcgLacZyiQuMa9oe3QZNYX8H
	 ZzoHdtfEacq1+MyHVDubn4QFr0yUpe6cRx7Somn8PKUaMvnY6aJS1oFMq21JRvUu3e5CI
	 T8Ttv/0KaD8/1mmiGEjevOKXv9qLMeBThC1ZS36nZ3NYNYk7Dp8UxDswZPI0R0+4mrxwN
	 GKVrpngJpVtV0ubVB/R7Y21bZXB8FtvpT5N4J6f1V6P78SpFNcihZf3VyoaIPj6Ibew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CriNJQJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CD606A326;
	Thu, 19 Nov 2026 04:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CriNJQJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1671F000C4;
	Thu, 19 Nov 2026 04:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062121;
	bh=UOtKQ5kQ8cwkDmB3vis30rFDJwZbxDySkV287kbicR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CriNJQJP1MnMlcysp5UbSIkQs9IHmYgnKrnoj4IBAxGxEzPpyccGtQ6aWGWQX9HuM
	 +8RTpZ7fzAS+rQcpXFA2ljCqkAdnhr4qXzohEhbT8cg72zS6T3nJG2wzhsPPzCsZEO
	 jGQWA4cr29d0+b4V7woUKLlHaDaE4pHRFCELA+GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1797/1848] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:03:55 +0100
Message-ID: <20261118150034.494336755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 068e490098aa9..f1a8918156ea7 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1061,7 +1061,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



