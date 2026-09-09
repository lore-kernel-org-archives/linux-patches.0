Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6167A566C53;
	Wed,  9 Sep 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963818; cv=none; b=GC1M6YUAA9Jk39yZY7HhNdaMElZZrmDL0OAahS7PzA+FkvZGVw4R592DEMNtlJz6SftCXHbEraVYwMPIykbvdC/VDt57s5hObutVEWwy1mC0yJSfzz0VPjfZAMGew83awIJ4anOUDhvOaqQt3YF4QOPlWj4EvMLAaxse43YLJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963818; c=relaxed/simple;
	bh=GUeMED7/h1+/srnvyM2wshX2PiYWuKN8Ku4yfK95dgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/cFeZq3yxX+0LbXtWyfpSBBfdhCJDaM26weIH8uAtF0VnuIy16QbIJuwuepTFTnRpNcUXjvnttzxOLr8M8IWJj0yVQgVMNn7Lq4eVjEI6jp8Ukp5xDW+DYmfqm6vEsbBwrHgV9QFiNb7I6/ehwrYhpIZWMB6dxFcqV7x95cgjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaGRts0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaGRts0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2541F00A3A;
	Wed,  9 Sep 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963817;
	bh=+CIFSkV8rUk1CZuIdKBnqaniwBJ71xbQbtGsbgMSt1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaGRts0lSqDBctZQHDU5DLoccKdTn5JEutfunW4Wd0B0XunoDU2Yj9gKbuS8Nh9R+
	 MtIwaZ2CO1cOB3Hs1nAH2McbBE45L06iVeqpgvyymiJHN3XvMtBNh4zzNa8NfSYBB3
	 d6T8Bx7kSvUG4jg2MwaPpTiOSQA7DQBA61yaDvsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 208/583] iio: buffer: Tie IIO dma fence lock lifetime to the fence
Date: Wed,  9 Sep 2026 15:38:13 +0200
Message-ID: <20260909134245.349296553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1690,7 +1688,6 @@ static int iio_buffer_attach_dmabuf(stru
 	if (!priv)
 		return -ENOMEM;
 
-	spin_lock_init(&priv->lock);
 	priv->context = dma_fence_context_alloc(1);
 
 	dmabuf = dma_buf_get(fd);
@@ -1871,6 +1868,8 @@ static int iio_buffer_enqueue_dmabuf(str
 		goto err_attachment_put;
 	}
 
+	spin_lock_init(&fence->lock);
+
 	fence->priv = priv;
 
 	seqno = atomic_add_return(1, &priv->seqno);
@@ -1881,7 +1880,7 @@ static int iio_buffer_enqueue_dmabuf(str
 	 * the dma_fence.
 	 */
 	dma_fence_init(&fence->base, &iio_buffer_dma_fence_ops,
-		       &priv->lock, priv->context, seqno);
+		       &fence->lock, priv->context, seqno);
 
 	ret = iio_dma_resv_lock(dmabuf, nonblock);
 	if (ret)


