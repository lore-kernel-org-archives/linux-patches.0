Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6CA257855;
	Sun,  7 Jun 2026 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828883; cv=none; b=L1Hs2yMoRLwHBz2E/5CvmWfmy7XMVIUJOrlIevW6KGcySfoE1cj0a7+RX92pEVwmcC2nCU6O1zO/dZkp8B1IGsUHFKJ6ZnWHNT71z/uSUDRXr9yKwqAMojzG7RXMdsNt7VwrRslMxR3V0WCzXotwmviI6DEnqRgQ0HJJzatYxro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828883; c=relaxed/simple;
	bh=TcKwQJkkbj8demCcqupgg1vMjphJLZEheJg1zdfbltI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pf8htESTajnJWz30YyXwzgWw5Lp3efoHUJGF7Jy7YvTDpt3269wVd7kxzyAAEWZ5A6PE2wgGG9i4HEuEog9vv50+YXvGZdcRuLAQCtKo2CevlUiySqhEDOXpkeWP/bXiLCMmoFEVXdMGvEgofwawOJgYeEFzEdIr21t36nQWSyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oomw3dkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oomw3dkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A44C1F00893;
	Sun,  7 Jun 2026 10:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828882;
	bh=kBebDAnQOhp2TMonCtjm/5H8u7KvCArz/u2qHFCoh/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oomw3dkzkg8PW0aczsyiQik42QicpuASOQ1NWnon/MiRpEPydsDwAkCc9IcuvnAUg
	 nTEWg+acdtSFmcqFBpimDdHqgeF+Rd83+0OEiqwfVZjuyXOG5eHL3+4exJN6cTdPg+
	 g4d/4MUy64anwcydqus1GUSLZQIS3FUaI1aSvwXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	James Nuss <jamesnuss@nanometrics.ca>
Subject: [PATCH 6.12 176/307] iio: buffer: Fix DMA fence leak in iio_buffer_enqueue_dmabuf()
Date: Sun,  7 Jun 2026 11:59:33 +0200
Message-ID: <20260607095734.180033883@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1911,6 +1911,7 @@ static int iio_buffer_enqueue_dmabuf(str
 
 	dma_resv_add_fence(dmabuf->resv, &fence->base,
 			   dma_to_ram ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_READ);
+	dma_fence_put(&fence->base);
 	dma_resv_unlock(dmabuf->resv);
 
 	cookie = dma_fence_begin_signalling();


