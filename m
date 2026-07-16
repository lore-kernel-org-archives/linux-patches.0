Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4F02DF137;
	Thu, 16 Jul 2026 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209075; cv=none; b=QfCfdSgpGeKN7DLJAQGAsbmJMk9JLFq0hL2GXpGMhtkum97ZzwEkGiPoJRxKfGhoKGyMqbuzo9G9AcGy0yFdwVvEayqHKnMbTAzdhJnP1hII4hNE86fm66qNfqA7njFuGg353i6uu/2B935aDuCuv7+80jfXOyNIAfVfY0V/n8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209075; c=relaxed/simple;
	bh=q0gn6P9nM5EyKNBYZ30QGSXRSO24gXGWX8xkZJiSnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9IeI+oWPmnLmRLzNIZrhKV5CcDHksV3S5Z66nuNm8aBfOGt8kbseIgm423f7r6ix5N3HTmrJPzqXwxgjzXowGPBF4rpuGHocU7jFFddA7tzF3/eYUrAz4499Ga8aKaOVyQtI54icQfyxFi7IoBVWmbcq2UUFgx+uKHpFx/IKWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/dyU9hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/dyU9hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704251F000E9;
	Thu, 16 Jul 2026 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209073;
	bh=aaWu+i95gtwiJdVL3enB2+UZGp0u8LF3WJAyxmUZkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/dyU9hj+uBGJSNDo9zfgolMHtj2QHqNJHrZCK5hWg+ya0VGGsYVXvKhNHxprLz0G
	 tG5yvE4yV1AJLLXxplNZYmKGjrGamS1YxKpOfbYc+OjO61Z04cISKpUuzuRKBg4IEl
	 K5kOtsdcd5W9QTfbXHd4Q0DOochiFshUNMVF27X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 047/518] iio: buffer: hw-consumer: free scan_mask on buffer release
Date: Thu, 16 Jul 2026 15:25:15 +0200
Message-ID: <20260716133048.815319150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 6325d6e2204327965b849c0a16efb6ac9202e5a8 upstream.

The scan_mask lifetime changed in commit 9a2e1233d38c ("iio: buffer:
hw-consumer: remove redundant scan_mask flexible array").

Before that change, the scan mask storage was embedded in struct
hw_consumer_buffer, so iio_hw_buf_release() could free the whole
allocation with a single kfree(hw_buf).

That commit moved the scan mask to a separate bitmap_zalloc() allocation
stored in buffer.scan_mask, but left iio_hw_buf_release() unchanged.

Free the scan mask in iio_hw_buf_release() before freeing the buffer
wrapper.

Fixes: 9a2e1233d38c ("iio: buffer: hw-consumer: remove redundant scan_mask flexible array")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-hw-consumer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/buffer/industrialio-hw-consumer.c b/drivers/iio/buffer/industrialio-hw-consumer.c
index 700528c9a0a4..10e912bbf0c5 100644
--- a/drivers/iio/buffer/industrialio-hw-consumer.c
+++ b/drivers/iio/buffer/industrialio-hw-consumer.c
@@ -40,6 +40,8 @@ static void iio_hw_buf_release(struct iio_buffer *buffer)
 {
 	struct hw_consumer_buffer *hw_buf =
 		iio_buffer_to_hw_consumer_buffer(buffer);
+
+	bitmap_free(buffer->scan_mask);
 	kfree(hw_buf);
 }
 
-- 
2.55.0



