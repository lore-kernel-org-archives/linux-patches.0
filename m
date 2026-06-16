Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E5A3CC324;
	Tue, 16 Jun 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633434; cv=none; b=hxo9d55dVbcu7poR3sUpOmTRBzWUt95ZFK+L0mfwoftn8w32tHAYCHB1y3y3nWzLR6Z62jYupmS3XLY1Rjy8hJEGUuI/zfWSHuZBDIRQn/XsH8EQAzPvUvhxZvV+MYC740w0tzodVFcMeXlg6b73Ec9hccWKs81ZoOI0FmGpvvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633434; c=relaxed/simple;
	bh=BOstoCXPutIcpFs391ysMK/VULgzFp836Tl0D2/Esgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsVxmg5NQT9AlNKKNefJ/sEhNmWRjM8HYx9tqszY1MoZG2lnYA4QGxJbz/k/1RQlKaKQwldwe4XtwunEd4ZRWZImPPzfWZ9VUHKBZ8T8zkkSneYZm7mxW/DidZ+yAHiKFFyxAZJ+62s5E4kbfIo7Kraqk1eZ2r7gMGqO+abuph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkEOtOin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkEOtOin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D41F000E9;
	Tue, 16 Jun 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633433;
	bh=UrHoa9BV8/D/k54hmN2WMBPaXGpJQx56qLK20ddI0gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkEOtOinNtnTyWEiG2BVvZomSbK9EYcgLcD0cYPR8Fvq26UIrX08HzNHfKMIvgimR
	 w3tkZHcGpGRK7ouLbEU9lrmCeniplIJKACk3/5tJUT0Hee9yKGaC980rqOMrxn31lS
	 WgngkA2BHUH+mJ8ExlMesq5jhEVi6b0/Hh/wv75Q=
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
Subject: [PATCH 5.15 078/411] iio: buffer: hw-consumer: fix use-after-free in error path
Date: Tue, 16 Jun 2026 20:25:16 +0530
Message-ID: <20260616145104.419620567@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


