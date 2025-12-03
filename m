Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD6B32C924;
	Wed,  3 Dec 2025 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777009; cv=none; b=qnYuL6mgAn95qw2ZUdYAE9kTIcdKYcAcagql46mIlMUDpK1ZGGlUvdLat7LzwBCH6bkfNNgJGpcIhpjE0cjLzI4Gaa6J5W8M8yGKi4Pn9TajeadMPOCbSevs/k+iT/AzC4SbSAILO8l0kcRTgYjx99MnoHe6byDddHOgkR91CVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777009; c=relaxed/simple;
	bh=4Od+VMgAUtwTm+owrRDf/Tq+oAsbjZk9bcQM6aIyPQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUuH37oFIhFiz/2PZn9OfW7yC3HGf5c2jr/rK6EqHeZvathjumRv8eD/bHGmedEyKYP7QXKtLUXXIyT1Q1CgkSYxEd6RMWI95qiLe85cIwvhvSP6HZ+PZP1d4/jF6NT6nPmE8yK34b4JPr+NrbX7b0wjah+ufqvDFlVOKf1o4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCOwSPrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCOwSPrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60575C116C6;
	Wed,  3 Dec 2025 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777008;
	bh=4Od+VMgAUtwTm+owrRDf/Tq+oAsbjZk9bcQM6aIyPQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCOwSPrAAqVI/XAoLpYNWmSSdxrKzhmrz9Mswkusd2n4rOoGjVZowHHaZIKxKuzFu
	 w4qpS+fq01q1+tF4yYKtS17JIbE01roATSLrVg13XdRE7aYst1ya2XMGTSEB5SLUFr
	 /8A6qZ4uc5Te5Df8Ggl2UknXrRGIFiCiJ21/YpUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 054/146] iio: buffer-dma: support getting the DMA channel
Date: Wed,  3 Dec 2025 16:27:12 +0100
Message-ID: <20251203152348.449391598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit f9c198c3ccaf90a1a265fb2ffa8d4b093c3b0784 upstream.

Implement the .get_dma_dev() callback for DMA buffers by returning the
device that owns the DMA channel. This allows the core DMABUF
infrastructure to properly map DMA buffers using the correct device,
avoiding the need for bounce buffers on systems where memory is mapped
above the 32-bit range.

The function returns the DMA queue's device, which is the actual device
responsible for DMA operations in buffer-dma implementations.

Cc: stable@vger.kernel.org
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-buffer-dma.c |    6 ++++++
 include/linux/iio/buffer-dma.h               |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/iio/buffer/industrialio-buffer-dma.c
+++ b/drivers/iio/buffer/industrialio-buffer-dma.c
@@ -786,6 +786,12 @@ out_end_signalling:
 }
 EXPORT_SYMBOL_NS_GPL(iio_dma_buffer_enqueue_dmabuf, "IIO_DMA_BUFFER");
 
+struct device *iio_dma_buffer_get_dma_dev(struct iio_buffer *buffer)
+{
+	return iio_buffer_to_queue(buffer)->dev;
+}
+EXPORT_SYMBOL_NS_GPL(iio_dma_buffer_get_dma_dev, "IIO_DMA_BUFFER");
+
 void iio_dma_buffer_lock_queue(struct iio_buffer *buffer)
 {
 	struct iio_dma_buffer_queue *queue = iio_buffer_to_queue(buffer);
--- a/include/linux/iio/buffer-dma.h
+++ b/include/linux/iio/buffer-dma.h
@@ -174,5 +174,6 @@ int iio_dma_buffer_enqueue_dmabuf(struct
 				  size_t size, bool cyclic);
 void iio_dma_buffer_lock_queue(struct iio_buffer *buffer);
 void iio_dma_buffer_unlock_queue(struct iio_buffer *buffer);
+struct device *iio_dma_buffer_get_dma_dev(struct iio_buffer *buffer);
 
 #endif


