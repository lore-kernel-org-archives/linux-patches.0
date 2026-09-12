Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB97B43BDDE;
	Sat, 12 Sep 2026 11:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213547; cv=none; b=dnThj3iia7mHn18Uq7kaq9u30CElyQ2mYL8fCzpSdV8YWulpjTw7Lzd92YjKGKFLhi/bcIx0eBKyzg40DTtr3eEdpXGjYvmDsZRWeLB62iCA0jc+gnJ0r57TZNQnMdw7tEy38WjeE1L1RFmINUbdV2RmUW3v0hbbfHgSfzAoSuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213547; c=relaxed/simple;
	bh=AJ51ecG0CFHxLH+yMKu8L5LQG88JQRYSsbfdS50jK80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ycn19W1FOzzK3Pbi/xM4uNIee/pj4EPEI0GovmfHR92aetV/jtn+zvYLLA7YWZKRzcLCBor3fHads62WajawaMJSZLkd/pKl0xlTetDMhmWzH/SmGDBBq2SJjYhLTKNfwFMYIqkQz6h6yBS2vgFKrwZNPzlIDwugQ2gfz1Nc2wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4ttuasJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4ttuasJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2481F000FF;
	Sat, 12 Sep 2026 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213545;
	bh=A0ulk+jfIVCFmU20WmOHZnjyDg9zUF4QXaL/PsH4uyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4ttuasJ6YUwKkx2g5PnhhfoVGVFJsjsbC5B0H7Dyjee99goT7v3uA4O5UioHxlsJ
	 8vob+FfcjLAab/ssbHY8cY/+KY9pSagPCcdReA7e4IEzZ3OU2xcf+FSWosCUup77Kx
	 JgAclApTjFknTqHWLARiEjF/Rcaj4qMsylV0kRIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0137/1376] iio: buffer: Make IIO DMA fence release RCU-safe
Date: Sat, 12 Sep 2026 08:42:43 +0200
Message-ID: <20260912065610.606746828@linuxfoundation.org>
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
@@ -1811,18 +1815,9 @@ iio_buffer_dma_fence_get_driver_name(str
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


