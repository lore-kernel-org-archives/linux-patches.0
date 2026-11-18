Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028090;
	b=Tl1wfIod/wiIMTx4eqGfCJh0BjrrGxykpmw7q6qyAQX2sKjv/FVKyn91YgImNVGAScFQ
	 DsAOzVWsSvbh+01iEc+X1zd2vUGIdn3FpwGkoGoZzoNNpRje5ySZwuhOJEA4dwSP2f+GW
	 TUk3oICaX/qTvAArOEzO9j1vXBgogDGZnCo2MzJM/u6Aq9P1txrOsS2dgTuEz0HzDWtD4
	 l897xa+tnq6RhxqfjCvWyguzEa1Mdi5FEMXzzglvfYH6qWujDHir8XAyVkS8u/mCpXsl5
	 g+AQSE/eV/gJ6rFwRbX0klfjmawHgeDTi66rwCAlG5eYTpgM7npwraLzfZu1FybbZvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9o8pDVMJxR8HMIEkQYLAirJuvbu4rR7LBjiriERhmD4=;
	b=LFw7KPwRqJb4xhALg9oROvVuNPhADEQwCnHbn/AhsLaWPFzSZdDjv1uBEI+a1jGeyv0p
	 n6DHirYtk3CLP11bbdBoYaA0ZXSGXbmXu/1Do8NL71BFr61TOewLDmhWojY6cfYi+3Zs8
	 L05ozAdEdWicAwygRK+fbgls0PHzJFpTOcWLHU7yk2m4tFT60tLjBB2e1Slj/FKlx5zyR
	 IgPseayvj3OQdbJgJZhnWbSt2d7SdftFqakpllImEtbzrOW+wmDBXXeXafeD5a0EU2a/0
	 fQm8B3opCVU/Uh4d7arSa4cMxVmE3pWW/KZmqGHfo2a0j8RgSNUyGNI+XhVZNBqPV0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="suLxRc/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52415606A31C;
	Wed, 18 Nov 2026 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=suLxRc/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6577D1F000C4;
	Wed, 18 Nov 2026 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028089;
	bh=9o8pDVMJxR8HMIEkQYLAirJuvbu4rR7LBjiriERhmD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suLxRc/KvUGJn5/T48HyYK19oJDiEIGDIAvSojiihlzafffIjnSMY8x1o49fO/Cem
	 nROf9iPkpbzLXU68BcdKubWm+NSzn7Q0yGPdppUeGAghFrNJNGyGaEVIGfTnxeu7RL
	 wahmBFgNN9YXk/aSvfQVpWrBg3DEs+SuXbJlAExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2021/2151] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:02:36 +0100
Message-ID: <20261118150235.355687148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6e3ae9e54bcd..ca3444f2ffb70 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1338,7 +1338,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



