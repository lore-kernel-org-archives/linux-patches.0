Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BC270838;
	Mon, 23 Jun 2025 21:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712943; cv=none; b=lR2IQBcCO91tluWjYvIfY0q/yNJgrQMBtnTV3VGtTwnoEfh5SjiEtZForn36tNeySw9uqd3acJWKVE23tKdwKBAnXFL4fr1AGE1YBgXaLsMjCTG7u96dqjt5ycmQPj+zo5SMGgbaDbMhPObEhfXcD62z7QNgKtOBl/VcMngh8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712943; c=relaxed/simple;
	bh=7nSMotcLz4l01q6ClHfHjRogpFUVmETrGcTKQFn6QUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaIdZrWL698xiQkxF8HZv1iaykJFMYtwg7Uc267FKu81aL3mm9aL4nPEbrz2dKd0MKLMC6LcAvMq5eflMKVBno54zOIbZbZYxk01lWPPaHeXABT6IvTlYarqw9UXft4sDucmvuserei8mA6c06fqvUndC6qnS+dE/3NKHBthA7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvnqvWpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvnqvWpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC54CC4CEEA;
	Mon, 23 Jun 2025 21:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712943;
	bh=7nSMotcLz4l01q6ClHfHjRogpFUVmETrGcTKQFn6QUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvnqvWpt+WN1jtJ6+IO0lMfsXcP1cyPgkw38nc9c5TyR9pggCemyq+YhzyBFl/gfa
	 JlkcJtvwHkj7xEtM9eI0KPUO6e+BB6C/iFagYOwjr1R+dsu7/w8Kz2EMQCHsa1CKTt
	 Js1ay7m5dzy3mO3PFvd3ufDwoX6b/D7fMUNHAh/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 039/290] media: videobuf2: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:05:00 +0200
Message-ID: <20250623130628.179639149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,7 +469,7 @@ vb2_dma_sg_dmabuf_ops_begin_cpu_access(s
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_cpu(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 
@@ -480,7 +480,7 @@ vb2_dma_sg_dmabuf_ops_end_cpu_access(str
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_device(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 


