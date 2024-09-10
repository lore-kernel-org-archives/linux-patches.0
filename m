Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B6318C90B;
	Tue, 10 Sep 2024 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962705; cv=none; b=oq3ZUzatPov4wJ1hTQtBYJ4H60KpzLJ/S51cpCMKxVz2zTJ+UaURD5YJtWzFexDG+e7VsyrFcyNmv5FSu7xuOhfH5M/KBlUEPqmkPtU/i2yfhvwHaKUVUT+UnjEBTQjUrstETS5blnTLGneDRM1P28mRfgBBGZ25swmCFFuWR/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962705; c=relaxed/simple;
	bh=bAO0gWH5+eYDyw3lZWLiUX9lqju5hOv7WOw9XBvzG/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMfCpBoGVrq8IC3k8TRBwHKvie3T0QQPx1EOKkQZO0m9oRVS8kQL0ZBnUpbNagc5MFXMI+E6C8FifDobTl0HAFzEIt19le8FFEuxmskRCOjAb7WXbj7oDhYohjN+KF6U7aiArn4acNcW0nL1Q58eLbkKPrAzdin+gpoB968RRBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EF8wDLGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EF8wDLGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A7CC4CEC3;
	Tue, 10 Sep 2024 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962704;
	bh=bAO0gWH5+eYDyw3lZWLiUX9lqju5hOv7WOw9XBvzG/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EF8wDLGuZ4bVsF3d7aNGQkFpoNj8Yv1VeCG8LqznHXSqrlb2/n4wycz+Mg+I7Un9s
	 ahXRAzTNsmzNum1u8jeZw8IFEaJ2eG84ugNMLVjLYmXKQESK+8xYcaWrwLSyh+2S66
	 8JLBZyElq6FqzgXWZJFB2NkVQVV1frdrAaddRock=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 096/121] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:32:51 +0200
Message-ID: <20240910092550.394641057@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 84c65d8008764a8fb4e627ff02de01ec4245f2c4 upstream.

If dma_get_slave_caps() fails, we need to release the dma channel before
returning an error to avoid leaking the channel.

Fixes: 2d6ca60f3284 ("iio: Add a DMAengine framework based buffer")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20240723-iio-fix-dmaengine-free-on-error-v1-1-2c7cbc9b92ff@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -158,7 +158,7 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	ret = dma_get_slave_caps(chan, &caps);
 	if (ret < 0)
-		goto err_free;
+		goto err_release;
 
 	/* Needs to be aligned to the maximum of the minimums */
 	if (caps.src_addr_widths)
@@ -183,6 +183,8 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


