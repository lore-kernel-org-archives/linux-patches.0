Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E6634DCD6;
	Wed,  3 Dec 2025 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780659; cv=none; b=mm+7NSYoydZTCaMS52A6IZI4u4kOI1Hqkh0ZNYbwTEH9JA0AHgDnu93yDYyIgUEIzqd7r/tlLbx+qo+S9os5tudc+7vPV0Xo3ebS1miMAhf7omVKScXEqOfjfRXY0b2msA0aWz9WPQlfcOkuI2029/rim5czYS/srsuktaxi/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780659; c=relaxed/simple;
	bh=RuzhchP8PSMYK+O9FJAEL2jCM3KCV/I7i97oJfw+qcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8UK/yMX+ffVb7VLdes2+YONXDeTNKr+U72gZ7UJbN3Ifb87Ijjajg8lXK91HRjhDcx/xRMT8wybOE2JRf2GrZkThmF+Ji0v6ku8x+pku00p+H9feNPDaz1TqxtArpuUZM28E3krEiPpdC/R1yFQ0PFr9TRQFcKIBMM4PVF1JVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7XBbRpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7XBbRpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71686C116C6;
	Wed,  3 Dec 2025 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780658;
	bh=RuzhchP8PSMYK+O9FJAEL2jCM3KCV/I7i97oJfw+qcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7XBbRpXFwDbYvwCwLswBdYQK18JDpojhY6WyrwLYjFA3FQ09x6bePuRRzml61IQT
	 ysIofAzJo1bJkdn5qryqLp6exItCn1Kl5Vr3O5AazC3SrwJzQdQfIR3i1Q1q/jIsYm
	 9FcgAXh2wOj3m2agmb+6fYOv9oSu4Y3BDDmextC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 051/132] iio: buffer-dma: support getting the DMA channel
Date: Wed,  3 Dec 2025 16:28:50 +0100
Message-ID: <20251203152345.187147467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
 EXPORT_SYMBOL_NS_GPL(iio_dma_buffer_enqueue_dmabuf, IIO_DMA_BUFFER);
 
+struct device *iio_dma_buffer_get_dma_dev(struct iio_buffer *buffer)
+{
+	return iio_buffer_to_queue(buffer)->dev;
+}
+EXPORT_SYMBOL_NS_GPL(iio_dma_buffer_get_dma_dev, IIO_DMA_BUFFER);
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


