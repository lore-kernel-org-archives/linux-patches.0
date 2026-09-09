Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DCA56B85D;
	Wed,  9 Sep 2026 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962362; cv=none; b=lUgDNgDHgK4g9PyPxp83HyFMSumWwVnzBxQgk7ITB/Y/vAiBxculf2PsbXwZCX1OjVzzhiIWlld/jqtCy4jvmlKNV3UFpdg83PT82iZUL5gbcjMle7Avd68gWbWdtR/rl6revdg6fUbt0KPUPZXmjgmrpSY0ocNiUQC9B01fLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962362; c=relaxed/simple;
	bh=A0FNWo2eyYBwdQYbbUYCq2YZ3bq0Y9rUQEgA/9xAtQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lbe7AOn2GOB7l6kp8BpRwy4vRSZq9Cz09fP13yQ1Bqk0DxinMI+B9zuycaIhZ3NkU+p2a7JK/FB/RFJk6Dj/Lt6qP6NiinO5HJjkqoCV+taHO4L2VhwE6iDHrJK0YJf102wYMzIaRhKPJagzNsCYZOlI0vwIsNmjMocLaA847h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYwbFzYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYwbFzYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD451F00A3A;
	Wed,  9 Sep 2026 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962360;
	bh=wfIfF4gTEtrNdS3tAEkjFHgtFLfE6EO27QYwX9DpkiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYwbFzYMQ9MGChNgvoUP80C13dhfGJpxCkShSevuuHYg5Ln7tZhbkzt+szAlZsqYJ
	 hTbMjIi/jArxTtMHyDmRtGNxKqNB/9yNAoGucnBZSz6Y3LCuZHT9XTtOihurxMIp/t
	 CyanhEZqdxVrutmz9wdOmMuq6tAt5RIO2AEQQdps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 265/556] iio: buffer: Make IIO DMA fence release RCU-safe
Date: Wed,  9 Sep 2026 15:39:05 +0200
Message-ID: <20260909134239.867864636@linuxfoundation.org>
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

commit 8662e56c31cf23b61ca3d11b516efb94c35b8026 upstream.

The `dma_fence` documentation states that if a custom release
implementation is provided, the `dma_fence` object must be freed in an
RCU-safe way. The current `iio_dma_fence` implementation uses `kfree()`,
which might result in a use-after-free.

Remove the custom `release` implementation. This makes the DMA fence core
fall back to `dma_fence_free()`, which calls `kfree_rcu()` on the fence.
This requires that the fence be the first member of `struct iio_dma_fence`.

Using the default release method for extended DMA fence structures is a
common pattern.

Reported-by: codex:gpt-5.6
Fixes: 3e26d9f08fbe ("iio: core: Add new DMABUF interface infrastructure")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -57,6 +57,10 @@ struct iio_dmabuf_priv {
 };
 
 struct iio_dma_fence {
+	/*
+	 * Must remain the first member so the default release callback can pass
+	 * the fence directly to dma_fence_free().
+	 */
 	struct dma_fence base;
 	struct iio_dmabuf_priv *priv;
 	struct work_struct work;
@@ -1831,18 +1835,9 @@ iio_buffer_dma_fence_get_driver_name(str
 	return "iio";
 }
 
-static void iio_buffer_dma_fence_release(struct dma_fence *fence)
-{
-	struct iio_dma_fence *iio_fence =
-		container_of(fence, struct iio_dma_fence, base);
-
-	kfree(iio_fence);
-}
-
 static const struct dma_fence_ops iio_buffer_dma_fence_ops = {
 	.get_driver_name	= iio_buffer_dma_fence_get_driver_name,
 	.get_timeline_name	= iio_buffer_dma_fence_get_driver_name,
-	.release		= iio_buffer_dma_fence_release,
 };
 
 static int iio_buffer_enqueue_dmabuf(struct iio_dev_buffer_pair *ib,


