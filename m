Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B53C0633;
	Tue, 16 Jun 2026 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626378; cv=none; b=ML/j+Miv+zESbXNkjfRICpv3M0JoWNz4ii/G+c1b5X/eLRyWUQwdO7qSDa3d172l46WR9GgUcIxC6L1GfM/Wwj1xJ15i4DpQMlGjCpTBB0+ZsZ+nF2pAJGog3PwP8Ij3gmYSIaQC5bLbvCZo4lqcqs7AmeKVvNjiOkBeFb+ZgKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626378; c=relaxed/simple;
	bh=nFf4GoCt34M2eLNaZu3FVoXBLeMsrmhKEpNDH/sQ78E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LffoJ1CY/iy3hAtN1GviAZiTbZOdpKlrMI6DwYQvehsrRZnHJneYHZd/yhXDfk822khrnMnzNP6wjhT6dVUXSiMiiW5GxrU9CMOWRgoQAXoF33GIeKBGhLA1osTcrmtpYA1HdKUWf7rSux4m6PGPJzn3AswRIuiEI22ICz8cK8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEHUCddg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEHUCddg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F051F000E9;
	Tue, 16 Jun 2026 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626377;
	bh=EdT1197uMeX8jX9YYOte/S/ebvPVMFTD8MuMNTTi/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEHUCddgd0jf7tmZkXOwMflTaZoCrwR5tEryRwg5VmB+7wTjJ7oPMX2mHn6iAp404
	 yOpqRmT2BIYjOejmwzasNfjUqnZi6hyZveZeCXpl8sZVcYx9tY+RKVBSOqgB8B3knJ
	 E/H6PcVMAHOx/TMoledBnJreTLSOFrHBQ5x0Zh/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/325] RDMA/umem: Add ib_umem_dmabuf_get_pinned_and_lock helper
Date: Tue, 16 Jun 2026 20:31:45 +0530
Message-ID: <20260616145114.416197784@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 553dfa8cbd0c6d36adae042d9738ddf8f8765ac7 ]

Move the inner logic of ib_umem_dmabuf_get_pinned_with_dma_device()
to a new static function that returns with the lock held upon success.

The intent is to allow reuse for the future get_pinned_revocable_and_lock
function.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260305170826.3803155-2-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: badad6fad60d ("RDMA: During rereg_mr ensure that REREG_ACCESS is compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/umem_dmabuf.c |   35 +++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -198,18 +198,19 @@ static struct dma_buf_attach_ops ib_umem
 	.move_notify = ib_umem_dmabuf_unsupported_move_notify,
 };
 
-struct ib_umem_dmabuf *
-ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
-					  struct device *dma_device,
-					  unsigned long offset, size_t size,
-					  int fd, int access)
+static struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_and_lock(struct ib_device *device,
+				   struct device *dma_device,
+				   unsigned long offset,
+				   size_t size, int fd, int access,
+				   const struct dma_buf_attach_ops *ops)
 {
 	struct ib_umem_dmabuf *umem_dmabuf;
 	int err;
 
-	umem_dmabuf = ib_umem_dmabuf_get_with_dma_device(device, dma_device, offset,
-							 size, fd, access,
-							 &ib_umem_dmabuf_attach_pinned_ops);
+	umem_dmabuf =
+		ib_umem_dmabuf_get_with_dma_device(device, dma_device, offset,
+						   size, fd, access, ops);
 	if (IS_ERR(umem_dmabuf))
 		return umem_dmabuf;
 
@@ -222,7 +223,6 @@ ib_umem_dmabuf_get_pinned_with_dma_devic
 	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
 	if (err)
 		goto err_release;
-	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 
 	return umem_dmabuf;
 
@@ -231,6 +231,23 @@ err_release:
 	ib_umem_release(&umem_dmabuf->umem);
 	return ERR_PTR(err);
 }
+
+struct ib_umem_dmabuf *
+ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
+					  struct device *dma_device,
+					  unsigned long offset, size_t size,
+					  int fd, int access)
+{
+	struct ib_umem_dmabuf *umem_dmabuf =
+		ib_umem_dmabuf_get_pinned_and_lock(device, dma_device, offset,
+						   size, fd, access,
+						   &ib_umem_dmabuf_attach_pinned_ops);
+	if (IS_ERR(umem_dmabuf))
+		return umem_dmabuf;
+
+	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
+	return umem_dmabuf;
+}
 EXPORT_SYMBOL(ib_umem_dmabuf_get_pinned_with_dma_device);
 
 struct ib_umem_dmabuf *ib_umem_dmabuf_get_pinned(struct ib_device *device,


