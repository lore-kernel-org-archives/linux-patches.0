Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8D547AF6B;
	Tue, 16 Jun 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630872; cv=none; b=cKVWLmZXLBOqj7C714/s9wa05ykIisfCZ2z1VkMfPv+c+23yZE4EkGaO69HBShBfFMejFBJs1CseRgx3ZahaJn+VNqYcsPfNwlmTp1eLwAEq4IVy3OALvXpyL4JYjimUKivwetidAm0uXRBqF2cdbwJCZ3r1gu1NiqTT7HMo2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630872; c=relaxed/simple;
	bh=YmXj1l1m3/mleA6neVOo5yQm1IhTgnA1Li1r9FRBcEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZ+cIZZ0S/rVF2deYgHdii+GAAOwyyO3bN7nXreCSbSfXKFYDgVNA4Vn9G6A9pzTw4o66h3yLPxuhxEgCvbh9kyXEZE+OTS+D9f6vb5nMFWzw1+oq8DxJIiKp9iV3fuuN/V2JW9WidStNkOBfrQHu37RItufIncmW1Im9/12i4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEQlBk1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEQlBk1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DC91F000E9;
	Tue, 16 Jun 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630869;
	bh=uiuz9U2eEIij7HyORzyYL89X57Pad31Ho2Oe5//uVZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEQlBk1qVdkNJ7ncIGoApsaXlHU92FEqUryS024q/FYZn9yD87198qZkAY6561lBv
	 QVBYxP9dr+PRDJc8qSvUsFcqaXZOK6DSdVhRRHGirXD3RM12vF5OFxs5cH/mx+QpJm
	 lIYrOYTL2Jct6c6FKD9SZXT2HykXz8haozvfyNuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Maxwell Doose <m32285159@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 113/522] iio: buffer: hw-consumer: fix use-after-free in error path
Date: Tue, 16 Jun 2026 20:24:20 +0530
Message-ID: <20260616145131.240614852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 6f5ed4f2c7c83f33344e0ba179f72a12e5dad4a4 upstream.

In the err_put_buffers cleanup path of iio_hw_consumer_alloc(), the code
was using list_for_each_entry() to iterate through buffers while calling
iio_buffer_put() which can free the current buffer if refcount drops to 0.
The list_for_each_entry() loop macro then evaluates buf->head.next to
continue iteration, accessing the freed buffer.

Fix this by using list_for_each_entry_safe().

Fixes: 48b66f8f936f ("iio: Add hardware consumer buffer support")
Reported-by: sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260427-iio_buf-v1-1-2bbdac844647%40gmail.com
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-hw-consumer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/buffer/industrialio-hw-consumer.c
+++ b/drivers/iio/buffer/industrialio-hw-consumer.c
@@ -82,7 +82,7 @@ static struct hw_consumer_buffer *iio_hw
  */
 struct iio_hw_consumer *iio_hw_consumer_alloc(struct device *dev)
 {
-	struct hw_consumer_buffer *buf;
+	struct hw_consumer_buffer *buf, *tmp;
 	struct iio_hw_consumer *hwc;
 	struct iio_channel *chan;
 	int ret;
@@ -113,7 +113,7 @@ struct iio_hw_consumer *iio_hw_consumer_
 	return hwc;
 
 err_put_buffers:
-	list_for_each_entry(buf, &hwc->buffers, head)
+	list_for_each_entry_safe(buf, tmp, &hwc->buffers, head)
 		iio_buffer_put(&buf->buffer);
 	iio_channel_release_all(hwc->channels);
 err_free_hwc:


