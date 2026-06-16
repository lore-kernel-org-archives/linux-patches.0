Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D647D95B;
	Tue, 16 Jun 2026 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635517; cv=none; b=fsDa9m5tp2KMZSN9/rjBz9v4k1HxYoFtEv7SzDkLEpNfxvDWu66X5VPWbda851x28EwOlZXwsKFZGoLe34Wj1mSJdRJajHXXvLzW7PwCjFg20DJq2vI91RIX6JN2L/0ZyYvfiJnz3p5IgPx5tT19Xp0vfn02zEl0F/BdCdMJRu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635517; c=relaxed/simple;
	bh=UCZEgxHtbxuzMpyycgcFoK6gduP98AFzcmjkpjkZAYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFVBCblZiAbqKhNYxD7yPy1sExdCZcywDPr/Em/dge2VnPSVTp2Ike17n083m67uJDMa4X7FOxoaNpOtx3qQ7kBzC6cZSjtcQUIaAIx3ucWvt3HMRiT6u29WNBsEMMtFq9SSw1cXrKGBfRl2mc/0QXd92NyJbM93+6aRzRv+Mo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYhteKi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYhteKi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3C11F000E9;
	Tue, 16 Jun 2026 18:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635514;
	bh=gXKMs45v7vfftdK7M0HZXYZRT+l+nBJCs+VKRlygx3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYhteKi2hz1c1yRxzWjT+AOUneXMnTT4Z9iHj+G8shM+BBj/Lkmv34HLHHbfpoAyL
	 DjY1ik61B4K9UIYdm9RS0A1Xbli1J1BaxMDNtBqYaB8HugKiCUV4qbUlPZNwwV+cvB
	 1BXSUL6Tz7nRCb0lqpwBEU0xCvm6pPmZeqm6f2xM=
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
Subject: [PATCH 5.10 064/342] iio: buffer: hw-consumer: fix use-after-free in error path
Date: Tue, 16 Jun 2026 20:26:00 +0530
Message-ID: <20260616145051.236668615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


