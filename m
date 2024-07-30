Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B882A1A6169;
	Tue, 30 Jul 2024 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357492; cv=none; b=o17p+D4zEqKCu7+JVM3bCKSEOJ+TTGkSA+2REh9Fz/qmPEF9b58+1phoWLn2qeaPf8UZFjgA/Na4FlVLGKLKnBL7hDTuDilh7JexzggzQ4c9mYF3dwCTFP9+3VP7vVS1BNZw1KIOH/9oNPY7kF/yOdBEqD1WnivUzI/wcplP0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357492; c=relaxed/simple;
	bh=U++3a3RZ2N/f1tcplWDG/jNgUDca11VPWBXw9p5RSFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAcMqdD7HsHlopbHGag/qEgKkTAbaveKhQ9gtWaduHvw4GJ3AGwYooE1ejPKcOWluDj/hNfn6y7SKsSRv8r7lZc1Li2NXEFRxH+v7qW6XTYrRLwoGpFYqC892m91joyfr7M+lD9PPu8Qo1+9avCErq+AF58d8wX0oJlaXCkm/Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwCZRDGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwCZRDGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26E1C32782;
	Tue, 30 Jul 2024 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357492;
	bh=U++3a3RZ2N/f1tcplWDG/jNgUDca11VPWBXw9p5RSFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwCZRDGjoBu/9d0/Kf3HZs9YnJcvJiLCe6TXuB599covYzfyH1hnCTbaCJtiTczjI
	 7qVGOcmN5N/XU9gQRN/ymoUeXfXq1De++AHG3TkuS3m54V74JSC6lNNhK/ltvzlV/v
	 clpAz4l7xz7AU3AIzplxZL85SxVT722sJnWaw/C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/568] RDMA/mlx5: Set mkeys for dmabuf at PAGE_SIZE
Date: Tue, 30 Jul 2024 17:46:07 +0200
Message-ID: <20240730151650.039669073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6a57af8fa231b..43a963e205eb4 100644
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



