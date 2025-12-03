Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3ED32C92E;
	Wed,  3 Dec 2025 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777012; cv=none; b=pCW48PkKiorylxe8iNZr1hQW1EpkD4mXHT1tQMqhFa6uCPZ3HKokuF32UQ19czbs8vt1Hdyp/UfuV45AdTqYevJY9ijAUNbLq7bFEV03zd0CoDMstdgmbNY6EUX1Yldy05maubSi+M2gjLObUxvXgp7sJKlQzBu5+HyxZ+C6JvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777012; c=relaxed/simple;
	bh=FA4Sg9ELA1A2W+2UhtsKQQOZaDE5TZ4QmnnKmvY/+CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoW6kifPOBv6Vq0WHmZHMnLcaZY++Rw2A8IDQ6PHnAEmPWrJfZZH3zxXYXWur4x6mQ7EaLUMXmVtMsvT4SsOAzUFKfU8Bia2w/B4lm6NTYaYE5E601WJvi7yLMmVJAJVXm6/qG9tRd02kpFUCoDX+fp36JsAd5tpKjtoOKFxE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDsfWavm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDsfWavm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FD3C116B1;
	Wed,  3 Dec 2025 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777012;
	bh=FA4Sg9ELA1A2W+2UhtsKQQOZaDE5TZ4QmnnKmvY/+CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDsfWavmRiVLffr41EHS+6rsWikzA8i80Aeo3yCIKWpCLG03xU6+hYOF/4EVNBnxG
	 bI2g6sec2tJLbu7+iMXDeeYC72uLqU+Dp0hdqML0zwNewAXkXUs8RSFSp9TUiX6VV3
	 +XO4v4++SdDulyRhI1etOiqHSgz2SgqG41/QGiqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 055/146] iio: buffer-dmaengine: enable .get_dma_dev()
Date: Wed,  3 Dec 2025 16:27:13 +0100
Message-ID: <20251203152348.485467317@linuxfoundation.org>
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

commit 3db847df994d475db7812dde90376f2848bcd30a upstream.

Wire up the .get_dma_dev() callback to use the DMA buffer infrastructure's
implementation. This ensures that DMABUF operations use the correct DMA
device for mapping, which is essential for proper operation on systems
where memory is mapped above the 32-bit range.

Without this callback, the core would fall back to using the IIO device's
parent, which may not have the appropriate DMA mask configuration for
high memory access.

Fixes: 7a86d469983a ("iio: buffer-dmaengine: Support new DMABUF based userspace API")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -177,6 +177,8 @@ static const struct iio_buffer_access_fu
 	.lock_queue = iio_dma_buffer_lock_queue,
 	.unlock_queue = iio_dma_buffer_unlock_queue,
 
+	.get_dma_dev = iio_dma_buffer_get_dma_dev,
+
 	.modes = INDIO_BUFFER_HARDWARE,
 	.flags = INDIO_BUFFER_FLAG_FIXED_WATERMARK,
 };


