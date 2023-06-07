Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB5F34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BA7C433D2;
	Wed,  7 Jun 2023 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171665;
	bh=zwCMlFHOQOHByVgksGmv+EBPDQ2hCSz80fcxQXkKVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3qnvRBplGh5Lsl+EqKlUVN9/ZAkXTtKCZQHWHTLdtxTLB/upWEFFX0/tr0cOUVno
	 rKDY/fL01Cy8b3Pg/lY86cir1s48LJyl+AQEBQQclWhJFW21AJBcxGjEz5fgjapMEs
	 SULI8Dz6HM9WgSvDZjdYWCpMQ8wXnUHkz8JDkiFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Honda <honda@mechatrax.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 104/159] iio: adc: ad_sigma_delta: Fix IRQ issue by setting IRQ_DISABLE_UNLAZY flag
Date: Wed,  7 Jun 2023 22:16:47 +0200
Message-ID: <20230607200907.085279673@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Honda <honda@mechatrax.com>

commit 626d312028bec44209d0ecd5beaa9b1aa8945f7d upstream.

The Sigma-Delta ADCs supported by this driver can use SDO as an interrupt
line to indicate the completion of a conversion. However, some devices
cannot properly detect the completion of a conversion by an interrupt.
This is for the reason mentioned in the following commit.

commit e9849777d0e2 ("genirq: Add flag to force mask in
                      disable_irq[_nosync]()")

A read operation is performed by an extra interrupt before the completion
of a conversion. At this time, the value read from the ADC data register
is the same as the previous conversion result. This patch fixes the issue
by setting IRQ_DISABLE_UNLAZY flag.

Fixes: 0c6ef985a1fd ("iio: adc: ad7791: fix IRQ flags")
Fixes: 1a913270e57a ("iio: adc: ad7793: Fix IRQ flag")
Fixes: e081102f3077 ("iio: adc: ad7780: Fix IRQ flag")
Fixes: 89a86da5cb8e ("iio: adc: ad7192: Add IRQ flag")
Fixes: 79ef91493f54 ("iio: adc: ad7124: Set IRQ type to falling")
Signed-off-by: Masahiro Honda <honda@mechatrax.com>
Link: https://lore.kernel.org/r/20230518110816.248-1-honda@mechatrax.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -490,6 +490,10 @@ static int devm_ad_sd_probe_trigger(stru
 	init_completion(&sigma_delta->completion);
 
 	sigma_delta->irq_dis = true;
+
+	/* the IRQ core clears IRQ_DISABLE_UNLAZY flag when freeing an IRQ */
+	irq_set_status_flags(sigma_delta->spi->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = devm_request_irq(dev, sigma_delta->spi->irq,
 			       ad_sd_data_rdy_trig_poll,
 			       sigma_delta->info->irq_flags | IRQF_NO_AUTOEN,


