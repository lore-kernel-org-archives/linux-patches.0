Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCF26AD6;
	Sat, 30 Dec 2023 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKvq3xDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9582C433C8;
	Sat, 30 Dec 2023 12:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937870;
	bh=hWs6gQ8FaiI7yCEu21b1u5xCEmbZwxKknMzSS7DZN7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKvq3xDOSPXYg7mWf4tmE/oY9aHny6QqE8JdFUAOiavoa7OlBAkKgvg/Gb6OkGt9J
	 zGW9PNceU+1VWIecNtiE3flAdzJ30XuzkxmQEA13/CjkobGidSNNn3wnfg5EKFai1v
	 hxBumg4IcLyQ/hfzSTXUDKv2X3T1iQTs9qsCNAL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 095/156] iio: triggered-buffer: prevent possible freeing of wrong buffer
Date: Sat, 30 Dec 2023 11:59:09 +0000
Message-ID: <20231230115815.462289333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit bce61476dc82f114e24e9c2e11fb064781ec563c upstream.

Commit ee708e6baacd ("iio: buffer: introduce support for attaching more
IIO buffers") introduced support for multiple buffers per indio_dev but
left indio_dev->buffer for a few legacy use cases.

In the case of the triggered buffer, iio_triggered_buffer_cleanup()
still assumes that indio_dev->buffer points to the buffer allocated by
iio_triggered_buffer_setup_ext(). However, since
iio_triggered_buffer_setup_ext() now calls iio_device_attach_buffer()
to attach the buffer, indio_dev->buffer will only point to the buffer
allocated by iio_device_attach_buffer() if it the first buffer attached.

This adds a check to make sure that no other buffer has been attached
yet to ensure that indio_dev->buffer will be assigned when
iio_device_attach_buffer() is called.

As per discussion in the review thread, we may want to deal with multiple
triggers per device, but this is a fix for the issue in the meantime and
any such support would be unlikely to be suitable for a backport.

Fixes: ee708e6baacd ("iio: buffer: introduce support for attaching more IIO buffers")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Acked-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231031210521.1661552-1-dlechner@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-triggered-buffer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/iio/buffer/industrialio-triggered-buffer.c
+++ b/drivers/iio/buffer/industrialio-triggered-buffer.c
@@ -46,6 +46,16 @@ int iio_triggered_buffer_setup_ext(struc
 	struct iio_buffer *buffer;
 	int ret;
 
+	/*
+	 * iio_triggered_buffer_cleanup() assumes that the buffer allocated here
+	 * is assigned to indio_dev->buffer but this is only the case if this
+	 * function is the first caller to iio_device_attach_buffer(). If
+	 * indio_dev->buffer is already set then we can't proceed otherwise the
+	 * cleanup function will try to free a buffer that was not allocated here.
+	 */
+	if (indio_dev->buffer)
+		return -EADDRINUSE;
+
 	buffer = iio_kfifo_allocate();
 	if (!buffer) {
 		ret = -ENOMEM;


