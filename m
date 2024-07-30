Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524181A617E;
	Tue, 30 Jul 2024 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356388; cv=none; b=b3z9E15wOeAOX2k68G2XakDn57idQ+7rNsivAn0A8hsvdl8upouENg9xbtjgpgwci1Fc2D+1D+fKDKKbKpUYkEbZGHkkjDdHfD6ihkqqirP6RGjWx1wJaF0w2eACW6MUxEDXL5+zzWV8LSsMrRQAOt8dYsScIz12NUa6c4FY4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356388; c=relaxed/simple;
	bh=nKGAiP1IZz2PePzXw4vhF9xsVzKjVx8hF6dCOtzPOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo6vRA4N3H7en15O/4pH7nTTdiUYZ7e0sp17NmUwtAZAeCi7FMx9QZ9e25uxy4Hh0DWsdBtHpWJJi0TzMZ4r2ZsqET66xmLAc6Y165fBwbqF31jl0VCITZERtzLBlYHsCi144SgMO+aNidXcmP8SEcC86fZJflDVjMoFv5pEyG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNF2eVsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNF2eVsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECE6C32782;
	Tue, 30 Jul 2024 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356388;
	bh=nKGAiP1IZz2PePzXw4vhF9xsVzKjVx8hF6dCOtzPOo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNF2eVsFj8V+u1zSKrrpIU9dmLCKkXxi2BAKPhoGjXmAvv1tVBptJn9zInTq+VCy6
	 DeO9MuJj3ySXfOeFnzLbRmQOgKsRR3i3K6DebPFbKJuQX4q/zE0VG723pU6Su8eYKI
	 MY/N9x/l7YUDBU+pndbNR8bNarPcdTVIbHvR3sHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/440] RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE
Date: Tue, 30 Jul 2024 17:47:00 +0200
Message-ID: <20240730151623.178373488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d94e6834e01b..0ef347e91ffeb 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -109,6 +109,19 @@ unsigned long __mlx5_umem_find_best_quantized_pgoff(
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
index bc97958818bb5..af73c5ebe6ac5 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -706,10 +706,8 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
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



