Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097F3D994;
	Wed,  4 Feb 2026 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217947; cv=none; b=Fl939NrEjS6XH0EMmWvSYjzh9MFoYT/E5Mgoy6IpLEr7uARNx+WU4w7X80jmy/kUtN5FVqjkYSx/Wh8OzScNPC3keSxI2df8qpWzgu8CZhw3PVrXwZ9Ag9ZPnJQj0IWw5o4QZRQHirAm8+K0ylMAzfL1C9H2nNbeVZHBhoVJQfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217947; c=relaxed/simple;
	bh=VM/PGWc5YWp4gBk74mvtisL4O073AzevcqLzJN83Z9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGkNi9SnMI2zhMQwRsSzpljAREkRVDEOkwkvwvjW4imxyXGbezAXsTzqZ855twyyrcX1YJFJn38RLgfzxmXvcDbliHXUbZzgwBSuPRhmjXA7KFOKUgQU+UYxZE7VvBl2GWPILozzOaqweHgKpu9w2PAMBFa0/1Z4BqtBAXy6lwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0pyonQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0pyonQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769FFC4CEF7;
	Wed,  4 Feb 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217946;
	bh=VM/PGWc5YWp4gBk74mvtisL4O073AzevcqLzJN83Z9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0pyonQo/H/ozTFGjglLDE3NHqBCBAII2QfbM+j2xZMGIsr+KQQ4iTa5guMeJTmZQ
	 PeLUxOPzXvppWcoB5T/hdhFGfciwhRWiuicaYykkposp+nnAZMX9gwNdjcYkdICiFJ
	 b3pEMBFJmvnX4fcjXS1U7QHuKQZREVn59/Sa34Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 159/280] iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver
Date: Wed,  4 Feb 2026 15:38:53 +0100
Message-ID: <20260204143915.345966075@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Pei Xiao <xiaopei01@kylinos.cn>

commit dbdb442218cd9d613adeab31a88ac973f22c4873 upstream.

at91_adc_interrupt can call at91_adc_touch_data_handler function
to start the work by schedule_work(&st->touch_st.workq).

If we remove the module which will call at91_adc_remove to
make cleanup, it will free indio_dev through iio_device_unregister but
quite a bit later. While the work mentioned above will be used. The
sequence of operations that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | at91_adc_workq_handler
at91_adc_remove                      |
iio_device_unregister(indio_dev)     |
//free indio_dev a bit later         |
                                     | iio_push_to_buffers(indio_dev)
                                     | //use indio_dev

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in at91_adc_remove.

Fixes: 23ec2774f1cc ("iio: adc: at91-sama5d2_adc: add support for position and pressure channels")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -2521,6 +2521,7 @@ static int at91_adc_remove(struct platfo
 	struct at91_adc_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
+	cancel_work_sync(&st->touch_st.workq);
 
 	at91_adc_dma_disable(st);
 


