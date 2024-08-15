Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DB31A00D2;
	Thu, 15 Aug 2024 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729526; cv=none; b=DEXxky9sQCv5ltVb07rOCMnqhDERoGDTqwF1qOKEw75aQiIBmfwZkfbSTfDmxpSHXbHN685kar0F/CIqtiHAJw7XIke/gjskjVDXZpPRX+naOEgPVCCRYqQYJoa/xkLvmGONXmLvruAc1Do0Fqjv1/kdEu+rUOTJws05Wr5IdI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729526; c=relaxed/simple;
	bh=iIRd+uNiOFLxnuHrrYfeeG3YB4B62uNF8rzsqrR+mbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3bJrbu8bT3JnBhV7XHVkOrKRj3rG/WauON26kyM1yU0VpDYBliQfO82xDo3/ddlB1UpwKSyrzpCPxRvfuQeqV+cRC1JjZ6yWoXgAjw1wb3JDkbIOrDau69792W4WtKP9CCvpAV2iE0+fjo0ytMkjWSXnjAZ+Zz4PDCbgmaqWOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNDRsgiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNDRsgiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B08C32786;
	Thu, 15 Aug 2024 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729526;
	bh=iIRd+uNiOFLxnuHrrYfeeG3YB4B62uNF8rzsqrR+mbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNDRsgiJQyAav8lgm9YMtfiiroO8WG/6Ko8VwqYxii+x4dj9rozC8L6CXJ0D+5hSD
	 +gCcrV3NcO5EZAjI8KJsZYtVVLQ2WthLBllW/HOOFBya1yvkpKHWOPJmZi7RK7937X
	 t8AzAUUn9fLL9hQNWx13M9wiqB8dN2+a1377Pj+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/484] RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE
Date: Thu, 15 Aug 2024 15:19:42 +0200
Message-ID: <20240815131946.084351074@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bf20a388eabe1..08c59c5a1e108 100644
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
index fcf6447b4a4e0..66e53e895d341 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -704,10 +704,8 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
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



