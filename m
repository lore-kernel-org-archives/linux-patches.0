Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A922F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3859C433D2;
	Wed, 12 Apr 2023 08:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289381;
	bh=lUYaeLjXfMA2sqDuy8wzZKzAMRg6AtMaH8ZBSHzwbq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7Xn9mpdj4IsCyvc+2Tysm3+IbG7G7/ws1MtYHBwxnETOv+ccemCikzmZAzFtmeYy
	 Be8BG9VUVjIw1JgzPkfZU7GoerOPLIq+ngMX2HXQkH/jKooMdSmm4Wf36QQD0QQyEE
	 suFp796J5LNKLIXbTG7HtW4LGKF0EcJ3VfYDs+Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait.k@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 077/173] iio: accel: kionix-kx022a: Get the timestamp from the drivers private data in the trigger_handler
Date: Wed, 12 Apr 2023 10:33:23 +0200
Message-Id: <20230412082841.165405969@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mehdi Djait <mehdi.djait.k@gmail.com>

commit 03fada47311a3e668f73efc9278c4a559e64ee85 upstream.

The trigger_handler gets called from the IRQ thread handler using
iio_trigger_poll_chained() which will only call the bottom half of the
pollfunc and therefore pf->timestamp will not get set.

Use instead the timestamp from the driver's private data which is always
set in the IRQ handler.

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Link: https://lore.kernel.org/linux-iio/Y+6QoBLh1k82cJVN@carbian/
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Mehdi Djait <mehdi.djait.k@gmail.com>
Link: https://lore.kernel.org/r/20230218135111.90061-1-mehdi.djait.k@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index f866859855cd..1c3a72380fb8 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -864,7 +864,7 @@ static irqreturn_t kx022a_trigger_handler(int irq, void *p)
 	if (ret < 0)
 		goto err_read;
 
-	iio_push_to_buffers_with_timestamp(idev, data->buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(idev, data->buffer, data->timestamp);
 err_read:
 	iio_trigger_notify_done(idev->trig);
 
-- 
2.40.0



