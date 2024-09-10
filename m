Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25D9172BAE;
	Tue, 10 Sep 2024 09:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962151; cv=none; b=ckqQJvOBfs5VtrqBTx8LCq6oFguqt9Q0CVuMiyp9xg6O+M3fxvUW8LoNp8b1z2gmgUhavrkM2V27rpVa9VfiYdmVsez9LlZdAxb9A7J/yI6E9Rjkv3feWmvqou2CIuKscE5IMyJS6opHEgFmbxbgEFpy4EKj0O9rvWoVbYRQTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962151; c=relaxed/simple;
	bh=GVmueibNSKdZFHBRtI1SjHK1jAqEyfP5VW2JWpFqItg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip0AXmM6SoK6ikHpCZJQb+fQn7EoLofUNoyToIUqGmtJYDz/sAj46uCGP/q5A6aEbc3rQniBE/j631TRWTVjmQZ18TTApvP7eutTZH5S28Z6Xls5L0KnCWhCUNkN6NAmS/K8LYSxUhYaR0QX9YjcFzeyb0Jhbmk7/2goLRAH8Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4ovg0d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4ovg0d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE53C4CEC3;
	Tue, 10 Sep 2024 09:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962151;
	bh=GVmueibNSKdZFHBRtI1SjHK1jAqEyfP5VW2JWpFqItg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4ovg0d1erjFmffInmSi8+7ulBsB/9bzs6NFXEM0k6hNVgur/7ofpHYBya1GcznUD
	 4OfvN+nz4mSAkzA26ac36ILAznJKvqRvLgSaMqUZWF1NloZkOiYccKDgrFA8Yk8pFs
	 lp0xqQLIS70DcX2JPqpIapM689dUxpPILDLf+c8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.10 285/375] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:31:22 +0200
Message-ID: <20240910092632.141881654@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -193,7 +193,7 @@ static struct iio_buffer *iio_dmaengine_
 
 	ret = dma_get_slave_caps(chan, &caps);
 	if (ret < 0)
-		goto err_free;
+		goto err_release;
 
 	/* Needs to be aligned to the maximum of the minimums */
 	if (caps.src_addr_widths)
@@ -219,6 +219,8 @@ static struct iio_buffer *iio_dmaengine_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


