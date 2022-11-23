Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE17B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF8FC433D6;
	Wed, 23 Nov 2022 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193850;
	bh=qNa6ZgqqhbvXTp/YjOxgoK9GO2CkeK9YAx27ryM4fMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo5xxIp9gzODY9cbeogDNNBlh4DQLyLp6s7Q/ziHteh1U0QAQeR04ssilWQCGv7W4
	 PiFbHyA/VyzaQ7Omioh5eGA52bihiMau5DEc3EU1naSO/GOE95WIIN9kdZLYH+CVR1
	 YCi6kMnlhv1n4wkz98DIptgrX7hKozDo44fR4OAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 57/76] iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()
Date: Wed, 23 Nov 2022 09:50:56 +0100
Message-Id: <20221123084548.627779414@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit 65f20301607d07ee279b0804d11a05a62a6c1a1c upstream.

If iio_trigger_register() returns error, it should call iio_trigger_free()
to give up the reference that hold in iio_trigger_alloc(), so that it can
call iio_trig_release() to free memory when the refcount hit to 0.

Fixes: 0e589d5fb317 ("ARM: AT91: IIO: Add AT91 ADC driver.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221024084511.815096-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -617,8 +617,10 @@ static struct iio_trigger *at91_adc_allo
 	trig->ops = &at91_adc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret)
+	if (ret) {
+		iio_trigger_free(trig);
 		return NULL;
+	}
 
 	return trig;
 }


