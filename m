Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4209E2DBF75;
	Sat, 12 Sep 2026 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213601; cv=none; b=WFHeFdTFqqPJMJDegy9OGoUNGF+YchAIkYgsftTW4gI+hulVh4VKe4BihSyxRZJbpSVIJ+qMq9+DljpV34x3Ik97JBKDPbgo51piCWZ8xJ0aKPrk9+bWtbi0097RPERaBH5kKTRMw2cxbJk31tjL2AbfdKN+2vDX4n6eviTRC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213601; c=relaxed/simple;
	bh=k+XuBD7L6zftWSmpiP6DLQ91ef87HFCwSUn/kBxCxSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mls9+kpzM/tN7fJPke+wLcuAOJAc6lbDc0bUYfReuVnuO5xY131EPLqdm2P6YVj6oTscpSnYsGEp1eqIsl/KgbKYL8miCMPSMrwq/0YaXVoj37a3QEnDKNHZdpzzu4Vr75f+cba3LqoXwnJ9SJDauzVqwj+AW9ngYk1XKJ1Fhwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqBPMatT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqBPMatT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1628D1F000FF;
	Sat, 12 Sep 2026 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213600;
	bh=G41wrPXmZ05qCYGFwXR9ct6x+ZjgLKCRjBmoPrNvKrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqBPMatTWtMmRslHiFoVhX7/hPk3aqbwMgN429LoX6Tmk8WqBP09b72Z6IWzucARM
	 cH1f5RC1JzrCfKP8NkmC1GoYF6EaAAjDHF+YWEkfUiMWjDPGszy7ljhVL2q9V0b7zz
	 bo79B5XcVKTp06caUIHm/Z2yvXn+fSsMF2PX7HaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0138/1376] iio: buffer: Tie IIO dma fence lock lifetime to the fence
Date: Sat, 12 Sep 2026 08:42:44 +0200
Message-ID: <20260912065610.630300822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


