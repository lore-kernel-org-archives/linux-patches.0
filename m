Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AF72DA765;
	Wed, 28 Jan 2026 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614608; cv=none; b=liKiYYfOC1hv/iU76YwDk93QBk2OcEWmTDmOj1LybShG1XZ8V01CNksvMGMF0bdl1+LVK48hY8D4TDPxsqknKwg7m7anNfpT6h5t/K6A8jJHDxfKupJZf/gmVYDFsd5l9dR0J4Noc0ZmiNNJKGmlaDsayFKp287SlSxt4KLPBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614608; c=relaxed/simple;
	bh=WZF7otD+xN72WQs9ine46MrwsKr2dqKVIdTdCqOkuHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPGhtpfkO4O1Iz5twi7ShDW0SscvLF/JKeHW69BXUMnF6eep5iGN4fsigCMWRfESbO0NqD4UTc6KH9aK2LedKUilEeVdsT1AsPDJc2Fey9ELNeHvmz8ecyLLL4TDWPk+Ydidp/wnjU1EoRUKcjhinnC8Gh+em6zriAO1jheSflA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2J7eIPOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2J7eIPOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B8BC4CEF7;
	Wed, 28 Jan 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614608;
	bh=WZF7otD+xN72WQs9ine46MrwsKr2dqKVIdTdCqOkuHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2J7eIPOKB9R44T1hTFWN4IvsktWdzJ+L6mB9e1bxxlaVIFbxU395npGnME0xzcyPq
	 YnJUKojAFJJCn+YpArFLGMDCbeo41noPKsFMA7WIgwzLc0HwQzncM4x4NctZo+Lilb
	 WOjahdSiRitageZrO3B+b7OU7eiU0nWySHO9xDf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 189/254] iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver
Date: Wed, 28 Jan 2026 16:22:45 +0100
Message-ID: <20260128145351.601653151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2504,6 +2504,7 @@ static int at91_adc_remove(struct platfo
 	struct at91_adc_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
+	cancel_work_sync(&st->touch_st.workq);
 
 	at91_adc_dma_disable(st);
 


