Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CE1F582A;
	Mon, 23 Jun 2025 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713962; cv=none; b=fgM9ELttfuHDy6oQ7XnD/glTgZxDv+M8gh7dxPVksEl6I1ioIopzOkB9w9bR5rHAVHgF6DRBzyj72f44kwV6XS3dS3w8xIhMH4WBd05aq5MEYr7G4VpYarF+UFhMAF4El/P40YIkWY7nMbricw0LnZWwnVPZiGq7yZDqwYg2idQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713962; c=relaxed/simple;
	bh=4GP/CU8u9ZbSqW90dYFMxdvFNAMKDIE+0V/oIhJOVpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwsE2cHjw4uGASq9ALFvBo8X4Ntfk46qglNdwEs0aXJqB7yObWI5CaqpgXYsL23LcAZ1CvyfNl3mazlUocHyJcHvjMA0wIDxYmQZTi++7Ds1LwQ7zjgxv5PU+4IEY3tu7d0/r8tsbeSgrRGSioGo7ch5UDoSfQmyWlgQbJUzLLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/gy9LVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/gy9LVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0925C4CEEA;
	Mon, 23 Jun 2025 21:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713962;
	bh=4GP/CU8u9ZbSqW90dYFMxdvFNAMKDIE+0V/oIhJOVpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/gy9LVOFZAnss8tgZMV4+5252SOwwl1pieG5VGVRRouDcAJn5FYMvmIkyQHbl4L1
	 69Y6lBQeu4PmV9yVzVNy+aiyaaa0cdLUOfpF5JkzU7fi6VatXOnzWXl4WH1qBDOvrZ
	 o1ZxdklHIsbwf2PWnu1u1LrzzYj/PWo+RNv7EKtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 176/355] media: videobuf2: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:06:17 +0200
Message-ID: <20250623130631.996728168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit a704a3c503ae1cfd9de8a2e2d16a0c9430e98162 upstream.

Use common wrappers operating directly on the struct sg_table objects to
fix incorrect use of scatterlists sync calls. dma_sync_sg_for_*()
functions have to be called with the number of elements originally passed
to dma_map_sg_*() function, not the one returned in sgt->nents.

Fixes: d4db5eb57cab ("media: videobuf2: add begin/end cpu_access callbacks to dma-sg")
CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -465,7 +465,7 @@ vb2_dma_sg_dmabuf_ops_begin_cpu_access(s
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_cpu(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 
@@ -476,7 +476,7 @@ vb2_dma_sg_dmabuf_ops_end_cpu_access(str
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_device(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 


