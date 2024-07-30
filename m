Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DBA83A17;
	Tue, 30 Jul 2024 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358860; cv=none; b=i5tFZ5kEk+utC7QWj50RT+vphcj3aBEKuxVPkmGLcprbyXWrUW+3Qjb5350WMPKOP4pXoRkENzeepUMuRaxQsmQCKxt2xNr1oK7KoOTsUnoCfDvaRRP+mOCdpsuN3DL/DF2NWT09VWB9ndMtjyohzybwvYTSR1TtBWmwyr/DDZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358860; c=relaxed/simple;
	bh=gMjOw+oJauiFPIAknMlwkASp0KAjmL2aw53lnA27XQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4rRM9K/tFlAnK9doenFububbjgnWE4S8gZNnmsuR3ybmsEgAHTWqAQQEhA59/wmH4IBBmtputnpTHtd8hQTikpUe2sTocXY+0dUgN8MVDBjUQuh5l+8swfYQ7meVT9KH93lamnIerFaDgeJj89HOLRVkK3FzcVmNyrf90L3530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phesKa2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phesKa2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6973C32782;
	Tue, 30 Jul 2024 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358860;
	bh=gMjOw+oJauiFPIAknMlwkASp0KAjmL2aw53lnA27XQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phesKa2tnqB6/OY0vWMStkZrfq+TU5/umbR+dyXT4OUVZmqJBQBl/9sVppUawe/h9
	 Wpt+Xp0tzK7DY08lagrwdz7WDFhwl2ZGtUxbBUJb4OLH398p5Vhqg27MZ15y36uVBR
	 ZYHtCAEqHLtNS+I48kPiiU/X83v7wa7KtskCtF6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 403/809] RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE
Date: Tue, 30 Jul 2024 17:44:39 +0200
Message-ID: <20240730151740.604748255@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit a4e540119be565f47c305f295ed43f8e0bc3f5c3 ]

Set the mkey for dmabuf at PAGE_SIZE to support any SGL
after a move operation.

ib_umem_find_best_pgsz returns 0 on error, so it is
incorrect to check the returned page_size against PAGE_SIZE

Fixes: 90da7dc8206a ("RDMA/mlx5: Support dma-buf based userspace memory region")
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/1e2289b9133e89f273a4e68d459057d032cbc2ce.1718301631.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 13 +++++++++++++
 drivers/infiniband/hw/mlx5/odp.c     |  6 ++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f255a12e26a02..f9abdca3493aa 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -115,6 +115,19 @@ unsigned long __mlx5_umem_find_best_quantized_pgoff(
 		__mlx5_bit_sz(typ, page_offset_fld), 0, scale,                 \
 		page_offset_quantized)
 
+static inline unsigned long
+mlx5_umem_dmabuf_find_best_pgsz(struct ib_umem_dmabuf *umem_dmabuf)
+{
+	/*
+	 * mkeys used for dmabuf are fixed at PAGE_SIZE because we must be able
+	 * to hold any sgl after a move operation. Ideally the mkc page size
+	 * could be changed at runtime to be optimal, but right now the driver
+	 * cannot do that.
+	 */
+	return ib_umem_find_best_pgsz(&umem_dmabuf->umem, PAGE_SIZE,
+				      umem_dmabuf->umem.iova);
+}
+
 enum {
 	MLX5_IB_MMAP_OFFSET_START = 9,
 	MLX5_IB_MMAP_OFFSET_END = 255,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 4a04cbc5b78a4..a524181f34df9 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -705,10 +705,8 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
 		return err;
 	}
 
-	page_size = mlx5_umem_find_best_pgsz(&umem_dmabuf->umem, mkc,
-					     log_page_size, 0,
-					     umem_dmabuf->umem.iova);
-	if (unlikely(page_size < PAGE_SIZE)) {
+	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf);
+	if (!page_size) {
 		ib_umem_dmabuf_unmap_pages(umem_dmabuf);
 		err = -EINVAL;
 	} else {
-- 
2.43.0



