Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A2618C91B;
	Tue, 10 Sep 2024 10:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964529; cv=none; b=hRB/AonAbBuESDzO7JTJ4efL1FESJow/rgoII+23UhzmPjlEbF36AmJZAP+k1TeUYeiwLh67t4j5LSEpoErlMiZ6ELBb2Oh/Sn4H8y+mdgL7JxQAkzkO4NiS5QwFgOhdyS5RsRbBM9dUJ8jP/P2Pu8SnV5wCz05EtE6DpCL/aUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964529; c=relaxed/simple;
	bh=desCQJwzoRvMUqAfdjGBIuH9xqy46Eyx2cg6SuW+2AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb9x7L2R3wx0ZVRhIyszp8/0RNQ8/MxpZ6JPdJzOAMxJLWZzSyTCeTeMv5pG50qtcPaUOxS+H15VCErQDN1GYox588dDqBoNDzdkVXgFW6OT2kqkXBCmRHIDRzIxtwm3rtUNDNmLnV9xRIsv0rdz4FdUV7kVzjFg8MBvMyHX7pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVlhw2Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVlhw2Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AE3C4CECD;
	Tue, 10 Sep 2024 10:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964528;
	bh=desCQJwzoRvMUqAfdjGBIuH9xqy46Eyx2cg6SuW+2AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVlhw2TuAbZIGCn8xI2f8duHmHA/i4WeGya1E0X4ukoJsZv5WICNUfR3S1gAoM+3D
	 pCZKDzghtbqaXkUbizcfBj/zgw+IuowsPnN2tHm4SvTEe4KtkjgORLysr5vrXFigox
	 DgIaJxDGXyFyIfNjdRTSBpwO9CYDFDScBDlBGVIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 206/269] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:33:13 +0200
Message-ID: <20240910092615.400273524@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
@@ -180,7 +180,7 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	ret = dma_get_slave_caps(chan, &caps);
 	if (ret < 0)
-		goto err_free;
+		goto err_release;
 
 	/* Needs to be aligned to the maximum of the minimums */
 	if (caps.src_addr_widths)
@@ -206,6 +206,8 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


