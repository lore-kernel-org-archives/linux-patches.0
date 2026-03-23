Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B028D38B7C4;
	Mon, 23 Mar 2026 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282969; cv=none; b=JypoD7p6RQJRAA9u/YW6xKW5xBkW14UlVqVPeSh6plc4MgyEXM/ds0vORkvuYL2JOTxZXJzdsKKsXl2oLPYD0Ewlp6dOMEmj0HYSbEsSZ1Z+RhjF2ShkKUyOi7hU/Yec55gI3uhdAdhlFw5CkiDhVOyD5DIyJyKqtrd3cN7I0Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282969; c=relaxed/simple;
	bh=Axh1fa6YYkn+vloxTwthY7OBr4ouC6a7xr220QHJoE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bK3UMf5BSrYyr7w9BOr10bf0eU1vn2eGzTF9/x9ULviiDx9uSVmrRrFkzXqTacP0dMiAquLeR8yORcNFc5CgpRH38wAJawl/LbI3mqyiyiReC82BkXBlxSbzMoJx+rlTcpva1p4Ybftdo31ZYwHG8wDBNFkk1DT/QmpeTEOavWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZV9C7DS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZV9C7DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4128EC4CEF7;
	Mon, 23 Mar 2026 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282969;
	bh=Axh1fa6YYkn+vloxTwthY7OBr4ouC6a7xr220QHJoE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZV9C7DSbKuZcktGB82qHd2uoV8takjFmB1W/6jUeqRkU5RQiEu3YPqOokro22eDk
	 aE0yXT0jcMUcS+mNtV0zeApa8gPEM1TgticpgiBTP38Zuirm7Q4twlpYHkBWWRb7h+
	 wzRgZ5Rt4uyBWkiSa9IFz+W6o4bgGMSrYh12hndI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/481] iio: buffer: Fix wait_queue not being removed
Date: Mon, 23 Mar 2026 14:45:35 +0100
Message-ID: <20260323134533.712304537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 064234044056c93a3719d6893e6e5a26a94a61b6 ]

In the edge case where the IIO device is unregistered while we're
buffering, we were directly returning an error without removing the wait
queue. Instead, set 'ret' and break out of the loop.

Fixes: 9eeee3b0bf19 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -194,8 +194,10 @@ static ssize_t iio_buffer_write(struct f
 	written = 0;
 	add_wait_queue(&rb->pollq, &wait);
 	do {
-		if (!indio_dev->info)
-			return -ENODEV;
+		if (!indio_dev->info) {
+			ret = -ENODEV;
+			break;
+		}
 
 		if (!iio_buffer_space_available(rb)) {
 			if (signal_pending(current)) {


