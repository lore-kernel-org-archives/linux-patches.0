Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5153B38B8;
	Thu, 30 Jul 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427108; cv=none; b=V+8QrnpQkw7uKRc4d2hUa1LLhGPNFrv6muvlVr7jsEmTKTYJy7MdhPVofIfDD9krFh3gnEtp+5FdrROCvfmQLcqEVNKqkOi2uRSng9trpQwpB3OcrtoNkJhLWcTwUu5WRqNvsSMFJeBbzETSpDQp9YOM2nFrheVjo7OLQuBD3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427108; c=relaxed/simple;
	bh=e1G2bM5JEQjRfRw3fzBe7WtBhvCzhjYdS7W0KPZhIM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNvwXfuld5zYz/FL/mx/g6EsBisZUcgB/4zCL9HUBJhLDTvgE/dAbgn39fZhwv3IjRWiorx4S1iIUlqQWl1YjETkPGGK/8E8DVkpb9vFJPhFLsHRXbAKozKse2A0bKRXhxXkUz1PmGNJT7LkFxGgsf6ty7KvR3HNeMDwoMpz110=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddgx5DG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddgx5DG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9842C1F000E9;
	Thu, 30 Jul 2026 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427107;
	bh=acX2VM7UUJ9R/LrlLtK0Mssq1sjDPYKp2ahqaPMlcK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddgx5DG5mPEwij+cRdFSmk508tNeA+FV6j/4U37Bqg8Z7BpLkGLr3NdH9Nk+P/Slz
	 lqqwRq/tdtRRRNj7RebHmFpsX66QkiTbemOd1AGrmuYfvN2cJsXFWTVloOnon8QxnE
	 j2m9oZGBlNlddmV9qAa9zGMwcCJY7Vm9qoFMXX/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/484] RDMA/umem: Add support for creating pinned DMABUF umem with a given dma device
Date: Thu, 30 Jul 2026 16:08:54 +0200
Message-ID: <20260730141424.229634933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 682358fd35dece838e6ae2d9d6a69fc0b9a9d411 ]

Add support for creating pinned DMABUF umem with a specified DMA device
instead of the DMA device of the given IB device.

This API will be utilized in the upcoming patches of the series when
multiple path DMAs are implemented.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/038aad36a43797e5591b20ba81051fc5758124f9.1722512548.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a846aecb931b ("RDMA/irdma: Prevent rereg_mr for non-mem regions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 45 ++++++++++++++++++++-------
 include/rdma/ib_umem.h                | 15 +++++++++
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 66f5760197479d..674a4b45e7bfe7 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -110,10 +110,12 @@ void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf)
 }
 EXPORT_SYMBOL(ib_umem_dmabuf_unmap_pages);
 
-struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
-					  unsigned long offset, size_t size,
-					  int fd, int access,
-					  const struct dma_buf_attach_ops *ops)
+static struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
+				   struct device *dma_device,
+				   unsigned long offset, size_t size,
+				   int fd, int access,
+				   const struct dma_buf_attach_ops *ops)
 {
 	struct dma_buf *dmabuf;
 	struct ib_umem_dmabuf *umem_dmabuf;
@@ -152,7 +154,7 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
 
 	umem_dmabuf->attach = dma_buf_dynamic_attach(
 					dmabuf,
-					device->dma_device,
+					dma_device,
 					ops,
 					umem_dmabuf);
 	if (IS_ERR(umem_dmabuf->attach)) {
@@ -168,6 +170,15 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
 	dma_buf_put(dmabuf);
 	return ret;
 }
+
+struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
+					  unsigned long offset, size_t size,
+					  int fd, int access,
+					  const struct dma_buf_attach_ops *ops)
+{
+	return ib_umem_dmabuf_get_with_dma_device(device, device->dma_device,
+						  offset, size, fd, access, ops);
+}
 EXPORT_SYMBOL(ib_umem_dmabuf_get);
 
 static void
@@ -184,16 +195,18 @@ static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_ops = {
 	.move_notify = ib_umem_dmabuf_unsupported_move_notify,
 };
 
-struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
-						 unsigned long offset,
-						 size_t size, int fd,
-						 int access)
+struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
+					  struct device *dma_device,
+					  unsigned long offset, size_t size,
+					  int fd, int access)
 {
 	struct ib_umem_dmabuf *umem_dmabuf;
 	int err;
 
-	umem_dmabuf = ib_umem_dmabuf_get(device, offset, size, fd, access,
-					 &ib_umem_dmabuf_attach_pinned_ops);
+	umem_dmabuf = ib_umem_dmabuf_get_with_dma_device(device, dma_device, offset,
+							 size, fd, access,
+							 &ib_umem_dmabuf_attach_pinned_ops);
 	if (IS_ERR(umem_dmabuf))
 		return umem_dmabuf;
 
@@ -215,6 +228,16 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 	ib_umem_release(&umem_dmabuf->umem);
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned_with_dma_device);
+
+struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
+						 unsigned long offset,
+						 size_t size, int fd,
+						 int access)
+{
+	return ib_umem_dmabuf_get_pinned_with_dma_device(device, device->dma_device,
+							 offset, size, fd, access);
+}
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned);
 
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf)
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index eac3c05278c153..3441ba9f2a0daf 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -122,6 +122,11 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,
 						 unsigned long offset,
 						 size_t size, int fd,
 						 int access);
+struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
+					  struct device *dma_device,
+					  unsigned long offset, size_t size,
+					  int fd, int access);
 int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf);
 void ib_umem_dmabuf_release(struct ib_umem_dmabuf *umem_dmabuf);
@@ -170,6 +175,16 @@ ib_umem_dmabuf_get_pinned(struct ib_device *device, unsigned long offset,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+
+static inline struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
+					  struct device *dma_device,
+					  unsigned long offset, size_t size,
+					  int fd, int access)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 {
 	return -EOPNOTSUPP;
-- 
2.53.0



