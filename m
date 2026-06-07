Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2294F2D3A69;
	Sun,  7 Jun 2026 10:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828636; cv=none; b=NR07yZUL5qrCItB9H2PaUxMOb0ORGYbL/6fPubbI3Mv9Scqgn6Ysm4WboPqkH0L+aiQn8sBvfgcFCtYlnARMFkiih/DIhOMph9kAq3pDXol+YfZKrQFlU1fljJDnfPRUkoddvL+euxvBPq88GJ4i6TywMl+tV9OCab/9sA8lO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828636; c=relaxed/simple;
	bh=JsvOcWUtBF8MHkseFQCnmKQ/pzDDv2qvELzIQVrBwYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B98JctygjPEExjkPYA47HIEehdWhL6qAJC+AsUE8QPh6jZ3cRYyDTMk27dx7n7z9NDvCjKm6nmHqCWJhNCOz4gab4rUzOigzF7bx65dHnitSVfnkkcsl4hwbXVZ7hsJt2Jau52Ok7+Z5M7G6nTkPqV4kqZ4CCMYO2TZBh5b7iis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/j/kwkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/j/kwkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFD81F00893;
	Sun,  7 Jun 2026 10:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828634;
	bh=qTNIXDG+g5TXhcwNzrJbQMb4axWskkt6PJ+JX00fH38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/j/kwkRT4XP2EGta6FERVNOFwIuT874MXey+A6P0l0k8ZdxmvsOk/+/hEbbICYCf
	 9Woaa+kqgVCgP3vxok3djGJEqoX5FD1EL/DxHtxGCm40j/SqGG1yqubJxecpd48Mpp
	 e01uv6xnC6RUyJo0o/YWZlEmJcdp14Y76pxStYRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	James Nuss <jamesnuss@nanometrics.ca>
Subject: [PATCH 7.0 199/332] iio: buffer: Fix DMA fence leak in iio_buffer_enqueue_dmabuf()
Date: Sun,  7 Jun 2026 11:59:28 +0200
Message-ID: <20260607095735.363715538@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

commit a093999355084bdbfe6e97f1dd232e58a1525f0b upstream.

iio_buffer_enqueue_dmabuf() allocates a struct iio_dma_fence (104 bytes,
kmalloc-128) via kmalloc_obj()+dma_fence_init(), which sets the initial
kref to 1.  It then calls dma_resv_add_fence() which takes a second
reference (kref=2), and stores a raw pointer in block->fence.

On the success path the function returns without calling dma_fence_put()
to release the initial reference, so every buffer enqueue permanently
leaks one kmalloc-128 allocation.

The iio_buffer_cleanup() work item only releases the temporary reference
taken during completion signalling by iio_buffer_signal_dmabuf_done();
the initial reference from dma_fence_init() is never released.

With four iio_rwdev instances at 240kHz and 512 samples per buffer,
this produces ~1875 kmalloc-128 allocations per second matching the
observed slab growth exactly. A test with ftrace confirmed that the
dma_fence_destroy event was never triggered.

Fix by calling dma_fence_put() after dma_resv_add_fence(), transferring
ownership of the fence to the DMA reservation object. The DMA fence then
gets properly discarded after being signalled.

Fixes: 3e26d9f08fbe0 ("iio: core: Add new DMABUF interface infrastructure")
Originally-by: James Nuss <jamesnuss@nanometrics.ca>
Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1909,6 +1909,7 @@ static int iio_buffer_enqueue_dmabuf(str
 
 	dma_resv_add_fence(dmabuf->resv, &fence->base,
 			   dma_to_ram ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_READ);
+	dma_fence_put(&fence->base);
 	dma_resv_unlock(dmabuf->resv);
 
 	cookie = dma_fence_begin_signalling();


