Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A812940B;
	Mon, 23 Jun 2025 22:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716649; cv=none; b=l09x/VvlRdHjeD4rj3hRzVyntMWSTmYAjIt/zVeqI9m6IrB8D/JOzSa6brnNVqS8pQYznwdLdc+jmtCpUPl11hJndaVwhAz4nFRwgIbGWbyj+lCb7aD/Fza27M45yrXai4QpYZf4ndSvc6/t2F7EsOZ0WJ+KwpZPCPGv3rmecqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716649; c=relaxed/simple;
	bh=EW/FBwCOEMU2FBMQJTnKu4h5mH/InO9GLfzPS4ZH6/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oC/j4PHXlbqVlh6SYSIYRESiprEhfIeD5ghuaoHBTa0E9lpeIM0wJwxeG0FaKEplKMhgbHCOWNjb8VUY/GsKX+juO1PS/bNI55HfNdiWJKVr+WMZyh66pXjGUjz+Xo4oe5fL9JPv7iMf06kjMvYOnBY+X+F8DXTlUHMUoPs7AtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ltDXq+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ltDXq+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B58CC4CEEA;
	Mon, 23 Jun 2025 22:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716649;
	bh=EW/FBwCOEMU2FBMQJTnKu4h5mH/InO9GLfzPS4ZH6/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ltDXq+3iarUwfy5uMmJoyjnaZ76WdDhZfMRDZyVW1mdwm0GHvQRGADXmQlllrLCl
	 f6WfxONuZTZ5RxCm9fRxx7RzdwDwJyl273NXkKLsDmahl+9pEKlSCe93Ft2oQ6+ATn
	 Qj90+bWncsMqoJenTmclvbh2Y01KAr82/vqeDB6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 318/508] media: videobuf2: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:06:03 +0200
Message-ID: <20250623130653.150651285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -476,7 +476,7 @@ vb2_dma_sg_dmabuf_ops_begin_cpu_access(s
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_cpu(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 
@@ -487,7 +487,7 @@ vb2_dma_sg_dmabuf_ops_end_cpu_access(str
 	struct vb2_dma_sg_buf *buf = dbuf->priv;
 	struct sg_table *sgt = buf->dma_sgt;
 
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+	dma_sync_sgtable_for_device(buf->dev, sgt, buf->dma_dir);
 	return 0;
 }
 


