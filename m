Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD0183CB0;
	Tue, 10 Sep 2024 10:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963186; cv=none; b=CepwUsPe1EO+A2HyB20C+ozR55SJKtKS0yWnChu5lVYhKidKu5XAsPt6mrW6MVyy+nj2ELlJyzNpkQtniT+zCXocCFn0Nrrp6/dBqtsDqmvIfT6tMI2Uy180zPwZxTjSYzmnV2Us02lEnqvZgJN+H9OhmnuhMMzBi0jrtYwjiP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963186; c=relaxed/simple;
	bh=2397ziwlJclxlcXzbnhljsrzTmBUUYiOKLYA4dgeeOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/p+pCeYUxxZUISjLhdE4fJ714fT86EXKXMsx09PbZ88+xxZ+XzaemSdDvasow4ez92kS/0FqKazLsVBkxcHSeAcg+sGd705ZAKCqMHw9aWRUA49ZAFLBDX7JJFV4OtnmP9+sxyB7sQUkTP5JPXZck6OY7Ag6UkMbVtOafq9lOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tcu9yWTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tcu9yWTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2336C4CEC3;
	Tue, 10 Sep 2024 10:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963186;
	bh=2397ziwlJclxlcXzbnhljsrzTmBUUYiOKLYA4dgeeOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tcu9yWTYtS7tozKrPwIdOnP5LMGJUUqmT48KB60U60MdF/O3shW3YL3ZnesNNYGjR
	 EAggtpEj4iQJqeUenEsLV1qe0R6HMsZxGBZVQkVpqbC8qCHGUM01TAbOV8a2g7YVXI
	 l411ckJk8s+L0boY9scm4ZuD2taWOT9Ujo8Kg4JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 137/192] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:32:41 +0200
Message-ID: <20240910092603.639288121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -180,7 +180,7 @@ static struct iio_buffer *iio_dmaengine_
 
 	ret = dma_get_slave_caps(chan, &caps);
 	if (ret < 0)
-		goto err_free;
+		goto err_release;
 
 	/* Needs to be aligned to the maximum of the minimums */
 	if (caps.src_addr_widths)
@@ -206,6 +206,8 @@ static struct iio_buffer *iio_dmaengine_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


