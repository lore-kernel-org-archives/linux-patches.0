Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCD71891A5;
	Tue, 10 Sep 2024 09:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961157; cv=none; b=gtROy1UQS8IqxavZyDSIacVqztQBLwX4f+RaVn6wQKuXjnasYXc0odngV+JXAiQxjNvrxtGfEBtLBEyr5vZQ4qBBFB3Nm487w+kxBqLNg2JM2WWn7JiM0NOzayP4+nk1GrfbNecp/pNKGcKjCdsHQ0kwYRdNcIzaZI3+NUSQ5Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961157; c=relaxed/simple;
	bh=cnw1NvE75DN2vfC3XZ+uAb6A16PNEAK7m/px1fu3gdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn8VANdH/FzGSZE5Mv+3+wh492xQlq0R9zEqbNpMBf/c7+l1RVoPPnDbU/sIPM3hj/3fOydSSOANmZPp04i+n74uNHdC6dP5eOUXSh9USpC3mw+Nonw8gHVNYr95qiPLdH3b7PthyyddFlXxOZZcMy+f/VIf7aNlezp2qRqQkjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLu0o0Uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLu0o0Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13974C4CEC3;
	Tue, 10 Sep 2024 09:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961157;
	bh=cnw1NvE75DN2vfC3XZ+uAb6A16PNEAK7m/px1fu3gdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLu0o0UhcLzVrkF0aAYT8bQyQylXtGtXW0naS0PoxEw4tRQk0su5rd7OLlulWqIef
	 ohtyGewjpCF1tVR7QjPhgPUEAGr9uxrf/aRdTneKFgI5DCwEN7w2Cft9vcVdNs87Qs
	 UO4PxH2fjUb7UbIXJZq8mILQKVGjbN2bBUtz4Xxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 73/96] iio: buffer-dmaengine: fix releasing dma channel on error
Date: Tue, 10 Sep 2024 11:32:15 +0200
Message-ID: <20240910092544.765207189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,7 +159,7 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	ret = dma_get_slave_caps(chan, &caps);
 	if (ret < 0)
-		goto err_free;
+		goto err_release;
 
 	/* Needs to be aligned to the maximum of the minimums */
 	if (caps.src_addr_widths)
@@ -184,6 +184,8 @@ struct iio_buffer *iio_dmaengine_buffer_
 
 	return &dmaengine_buffer->queue.buffer;
 
+err_release:
+	dma_release_channel(chan);
 err_free:
 	kfree(dmaengine_buffer);
 	return ERR_PTR(ret);


