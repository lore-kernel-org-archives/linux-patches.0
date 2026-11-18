Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042543;
	b=NyVNj7ThQqHZrjtTsoxEQACgBvMUoVungq9eglMVjlj7Zx6ivxyx9aKHI+8c/NnKgVdJ
	 LLrWJgbEgOOTRehg7SkItxYGZ6/fyx0pRUJ5eivMyQLFe8bEuGdCH1GG9dxUrgklLalsY
	 66+rGGAkiCT8Z49U0JFuTq9sdcPt0YSafxfWAL+gESPL5taSl1MF47DxQ8hWIFzYlAGUP
	 ecAbXPAAoWl2lZVYnLMEgUUUd2xlzA4eiugN055vNiaEsBiIqNdTbXAXf62qlv2+E7hPc
	 tn9iO5a+aGcaa+WQ+HMCpxAzB1IP+8IGyTiFKwj7kU9MZHDtqxHYrmfXVcC2f9wxARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQKRMYfOvASND3HGTr3QcivPqoEbzN64vnnNHszw0xA=;
	b=UOoLYHMfFXuyhFr4i9aV2Yy4/LtVsnFxLlI0nOdsvmZaLMdZRmGSt8t6EHAhlhKKrpFr
	 S6x8O+iKMI9NwNjhHe6OELdDhA8B1SrmUm5fAXTlb0xwnUGk5ICE6pou1R965LRiDn0aU
	 Knnb4eD01CcPiQwljixYzu2aSrUZTt0+4r5/sZv5uXyq/DABMhcCgZczsHfScJAcbMn+l
	 xAwb4nLsDL42gpJjmnB36tQaKfwGj7lyj34GO2663ymAOZWdEdrzwtpTjKFTkDcfwZo/S
	 dPEn0v5MhjC+s/K4opohZoOkgpYZZXdSfJszCBiISU1FRiFCBO6ZGsg6IGJ/YARzX/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssWzwFWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8690D606A31C;
	Wed, 18 Nov 2026 22:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssWzwFWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91AB1F000C4;
	Wed, 18 Nov 2026 22:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042543;
	bh=yQKRMYfOvASND3HGTr3QcivPqoEbzN64vnnNHszw0xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssWzwFWZ0nECXdNJouVVu0iepl/sQ6koMA8RBdW7oUdr9FBYntb55uD7N4Ocv/Zan
	 VlNb49UAlCuXZDXLa1Sx6U2eOuVBT0s/nmI54A6uDGgtB/lZA3jb1h18kqZnAjLjnI
	 IuXTF5+/2S0qr9b+ipuKZw6iW4Y4VzI2LgEDNmCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3209/3318] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:03:51 +0100
Message-ID: <20261118150456.015479074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7b24528174ca8..1373e96dac729 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1130,7 +1130,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



