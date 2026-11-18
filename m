Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022059;
	b=AivF9HynBrec9GSfcLZmo6XkGdbbmwZw/NHbORfH7A09A2dxwKrHS8+YA5FfTbUjy6RC
	 Vf/40rnqb9f3vQw1G2WIPj4N8P3P0d6s2sCgCwcISkyBWrGiS4oG1k8WCAYk/7iRpwWPL
	 19nOVqsYhemw9FsshElMlU+3q/zNT8fOzvpfSEL9qmb7PQRHAxUuz+Fonb7IANEpVogON
	 04BiZQehfcY7Fxcnt0po0N1pCD6hYM5QkbnPSuSKTnQ/+Itm6B3r6EFNB6HsZQ2Bq+mc9
	 9eKDoTt6pSxqSEfmH1qOUbmT4BjlL/D8A135If9r4XIrJWINLPyw4OBVwkK2jwwUyTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J63VJ7fKqmdAedR2DovnSZ0g7SdSK1kl02KMKGCdWzs=;
	b=lm+8D1FFEFOJrboARMomTOuM5pL67LYDtK4Qis4LZ5g3UienxGnK2vUC5WFf5Lh94Uz1
	 bqHEEBfnsS+0bnVu56uX3yqcgAyRKilUX2TgqmBZd4hbnWtUrsygOdAbZHPbcCHK24o64
	 RCw1Uu/KUM1hGvJKC+nbZOgW3iFgyp9ZWHQS30P44jCM8K1eca00hCHza35LabWAMphB8
	 i47OoHqQuEHTOu21jZvfvQzlhYJgs7zJ+sJUf8TA9dbeMDKhSe0zZrKQUGGavlJwEDvOf
	 /2o8XIXk/79prF++kIYllURezWphB1O9gHEYCEzOAB0HFoq4CldgwSDYDUXNNyVFEEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jx57hQj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B91606A32A;
	Wed, 18 Nov 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jx57hQj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC901F000C4;
	Wed, 18 Nov 2026 17:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022058;
	bh=J63VJ7fKqmdAedR2DovnSZ0g7SdSK1kl02KMKGCdWzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jx57hQj04Y2pHVWug65ZRcHyNTRZaYqKnbT45kPBKqFJUqGcaGRQZPwYQD1qGQHcu
	 fj/H7nw8kEyVJ7wZ37IdgRwxLBicBV5QyCDBTfp0tnaovqQZxZ/dCbml4/JQlU/qeW
	 txX1ftIHoX+FVldgarwnm+H2TkAOnT6qKnaT+2Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2526/2651] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150415.587724875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1ece32e702f3d..8f791d5651bd3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1362,7 +1362,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



