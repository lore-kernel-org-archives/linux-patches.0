Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81C1DA4C;
	Tue, 10 Sep 2024 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965164; cv=none; b=IryTfB3f53q5Tt8BX/m4P+aShJO/tdVfrwHlKLHUMd7Nhhen4YgOgphXnC4X0XryGm+LaMusAjn3nbi5iJ1OanRTUb9tWs6/FLvb9sSuHM1otzEjGCe9TIQbD0rbV7/liENoq7OTV/iDJr1oRny9T3Hu2Ifkkabeu5Fhr1p971A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965164; c=relaxed/simple;
	bh=LkOYRH5x8fgreIPIEB01AgVfi5Oc/3+ZFCqIf3FTg3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TP9nBru7DId/AhOGozezBohsoRbbmLih6VzaijiZgs4tCEfSJ9m21yvQ7Urmks9mA+JcfftNh09ujBtj7blNVyvRZjmjOo9gb/fQQqd+EKxX7V2vNr0MesnYoud9AzaAVybOvjGmudBxbpVQZfEfbjk9K7s/+JSfCw7DaZrqUWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doSu482L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doSu482L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30033C4CEC3;
	Tue, 10 Sep 2024 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965163;
	bh=LkOYRH5x8fgreIPIEB01AgVfi5Oc/3+ZFCqIf3FTg3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doSu482LcK/DlvUA7d+u5AWL+L1GnOcPNlt5sd1Q+YAsxQd3DU9Ol+r2OA66b0nJp
	 9WdgPayDSD1znyoIG/ZqMHddPhi44IMsZvIwXs3ZdGuL2QUmsjC2b9yW97otpAOGJd
	 uFuOvILbChpfp6dYO7TLJrmnyf3AUybh5JLnVIFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 159/186] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:34:14 +0200
Message-ID: <20240910092601.166189826@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -207,6 +207,8 @@ static struct iio_buffer *iio_dmaengine_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


