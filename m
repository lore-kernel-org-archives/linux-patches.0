Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46431E849;
	Sun,  7 Jun 2026 10:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828582; cv=none; b=tB+e+ulK/YYEq9qpJqhJ3pJf6vXe9iC7esUMbBLcqR0Y54Jzr9wBFiEQW+N8GBrY+4CEdxPVorTczzvyx6dXVrlIcWwFZqIt75mZnKuh5aXkg0yMp+igQpHpHS1em/gZ4w+CDehlPy1VTPJLUuNCW9OAeWAIxK4II/eYha7QOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828582; c=relaxed/simple;
	bh=E49HJwdpy8YLSvgFe90KvbZc8xOlpRx/NKCiFJLLXYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Waa6GGyhLRszTgtQJkmfnFq3UBKuR2af1mL3tbZ7230mmA9JD/EIvMj5lZ+1nfG2c6gHUcNOJcQiIuNYQ03yTpByTTKIPtXVH/G84QuGDkgWpFfVKu5YuA+vcWIQzRwzMNgcqTPN9Dhrrl0/s28B/Em9fX419N+aFRrBd5m2aCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PICcUcQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PICcUcQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1675F1F00893;
	Sun,  7 Jun 2026 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828581;
	bh=Du6xW42/HYJ/VrZGWE0R4a+25M9EcJeypF+Hn0Zlo/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PICcUcQHfZyJXbcXIUoG1Sk8ztPQF2AjGSz5PDMj7ERqH89JW2sxWoGxcGkKeJp/m
	 Ym/0qaJ0FDw70LKm0zX8pCTJhJ96l6DgcgzzzcRjEddkQsOyEeUbQzSg4vANiUEfdw
	 /AThony60JLKglqOD4vV3LP5hqBssOTU28wksYc8=
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
Subject: [PATCH 6.18 174/315] iio: buffer: hw-consumer: fix use-after-free in error path
Date: Sun,  7 Jun 2026 11:59:21 +0200
Message-ID: <20260607095733.977851832@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


