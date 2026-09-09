Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E3854B1C6;
	Wed,  9 Sep 2026 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962365; cv=none; b=MgTicVNdQhYBe4/krWILTUg8wJFbyI4si6FeNd99C746y/C0YdDiCYM/ifXuhokjRkHDlatAmZsARbCf+1oZkJqQ3CspARf7nhuAiX7sXEFZw0I5sfjI6He9avT9CzI8lvcaH4GghxcbV8Ugekt8v6IKP8Lw+Alw7ED0L7sYzto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962365; c=relaxed/simple;
	bh=20veaewtVKL+OnuMmtDHbN+A7KEEgYHAxXW1yfAd76E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxfufDKbzET7xltCEvNPhdMZQKxE52v/Gsp0RqEyLZ+GYsNH4InlB3C2cn6j2wNhp+6PQIptSyT5pQb07t/PEunUEV2ZW/ytYj93QJegJfwluMraCDEAN+/O69RBk8+x5uvUBsjGdW97kph3L+0hl7pBhmSry7xht0R/HLthxcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOpwxaos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOpwxaos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E751F00A3A;
	Wed,  9 Sep 2026 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962363;
	bh=jLaXr38MrMAyUV0+S/nei9G/IW1uQs+bJMKgLPyDR0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOpwxaosPyswzUz4i1FJsOsVt+xuMvE5HMmAicrAFq6gm6YtB0qx4zu/qlQHg5r+D
	 EITFOQOO1Tal62eQ8+ZoGQ0l0Q5xHQLbpJFjPEOGbTJ9r5yvH4rejixVkRQBm9Z8VW
	 VXhvdI9ZB7BlRazBruGnWZLqzyyOmTY/nmr92M+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 266/556] iio: buffer: Tie IIO dma fence lock lifetime to the fence
Date: Wed,  9 Sep 2026 15:39:06 +0200
Message-ID: <20260909134239.918910305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit f25ec4627d935dedfb5fe83bd2c2678cdcc19611 upstream.

The `iio_dma_fence` implementation currently uses a lock embedded in the
`iio_dmabuf_priv`. But the `iio_dma_fence` can outlive the
`iio_dmabuf_priv`, which can cause a use-after-free.

Tie the lifetime of the lock to the lifetime of the fence by embedding them
in the same struct.

We can't just hold a reference to the `iio_dmabuf_priv` from the
`iio_dma_fence` since `iio_buffer_dmabuf_release()` might sleep and the
fence release callback is not allowed to sleep.

Note that the `dma_fence` framework now has an internal lock that gets used
when the passing `NULL` for `lock` in `dma_fence_init()`, but in order to
allow this patch to be backportable use an external lock.

Reported-by: codex:gpt-5.6
Fixes: 3e26d9f08fbe ("iio: core: Add new DMABUF interface infrastructure")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -47,9 +47,6 @@ struct iio_dmabuf_priv {
 
 	u64 context;
 
-	/* Spinlock used for locking the dma_fence */
-	spinlock_t lock;
-
 	struct dma_buf_attachment *attach;
 	struct sg_table *sgt;
 	enum dma_data_direction dir;
@@ -62,6 +59,7 @@ struct iio_dma_fence {
 	 * the fence directly to dma_fence_free().
 	 */
 	struct dma_fence base;
+	spinlock_t lock; /* protects base */
 	struct iio_dmabuf_priv *priv;
 	struct work_struct work;
 };
@@ -1710,7 +1708,6 @@ static int iio_buffer_attach_dmabuf(stru
 	if (!priv)
 		return -ENOMEM;
 
-	spin_lock_init(&priv->lock);
 	priv->context = dma_fence_context_alloc(1);
 
 	dmabuf = dma_buf_get(fd);
@@ -1891,6 +1888,8 @@ static int iio_buffer_enqueue_dmabuf(str
 		goto err_attachment_put;
 	}
 
+	spin_lock_init(&fence->lock);
+
 	fence->priv = priv;
 
 	seqno = atomic_add_return(1, &priv->seqno);
@@ -1901,7 +1900,7 @@ static int iio_buffer_enqueue_dmabuf(str
 	 * the dma_fence.
 	 */
 	dma_fence_init(&fence->base, &iio_buffer_dma_fence_ops,
-		       &priv->lock, priv->context, seqno);
+		       &fence->lock, priv->context, seqno);
 
 	ret = iio_dma_resv_lock(dmabuf, nonblock);
 	if (ret)


