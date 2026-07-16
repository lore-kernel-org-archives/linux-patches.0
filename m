Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A3636A35E;
	Thu, 16 Jul 2026 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209062; cv=none; b=Y7ED/aupOnd7tuMZd/13gUAbV2ciWgOfZhG23OQ8yEqhw/DCizAi6/zrE7Ub/DkmJVCdEk+Z8GpxkMcILa3hNhF1sb0RcP7PFyWUYSkD8492G+B0d957oHxdmkWk54JVxwtoa+/3/5gYKInz37nk8iEF2G+t202y0XBy07dqh10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209062; c=relaxed/simple;
	bh=bGsmqWlsUgBg8mGlM92fyv3iifME5vpjnEPJ9uJYHS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glHYHoCofljyNyjeuoKL6QxjbB8LjRH4otf1PO/hcogyOBUSVtoJLesvbvfHISvIKY4g+TQb3t4di4iAAQW3Rwi2QkbBFRXYvplnNAvmcn4+1G0bDC/paixQXmoRgoIxVAQmW+eIoyBY/5oJbjz5YahjIZyn1WbWJTQ2TPdqspU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AS9dEdBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AS9dEdBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B6A1F000E9;
	Thu, 16 Jul 2026 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209060;
	bh=MmRWDCYAKPwhnRSXM+Pd3b/xfOzVlVLkgBjt0hpZPDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS9dEdBavtukjeNFFT8l6ggwm9J+QeL/uYfx8QBEPV5l528skkQY689iwv4RRJ3a/
	 ysQwn3ehoZg8RUkfAwQPF867/ybeiFVhuxQbU6AXxIq1BrhRdNO0v8KIZT2D4gRYw/
	 i72krXirdmvut+H6LGenjG3ga9W6fGfX4Tu1oGoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Maxwell Doose <m32285159@gmail.com>,
	Vladimir Zapolskiy <vz@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 043/518] iio: adc: spear: Initialize completion before requesting IRQ
Date: Thu, 16 Jul 2026 15:25:11 +0200
Message-ID: <20260716133048.724197970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxwell Doose <m32285159@gmail.com>

commit 3ee2128b6f0eb0be7b6cb8f6e0f1f113a65201a0 upstream.

In the report from Jaeyoung Chung:

"spear_adc_probe() in drivers/iio/adc/spear_adc.c registers its
interrupt handler with devm_request_irq() before it initializes
st->completion with init_completion(). If an interrupt arrives after
devm_request_irq() and before init_completion(), the handler calls
complete() on an uninitialized completion, causing a kernel panic.

The probe path, in spear_adc_probe():

    iodev = devm_iio_device_alloc(&pdev->dev, sizeof(*st)); /* st kzalloc-zeroed */
    ...
    retval = devm_request_irq(&pdev->dev, irq, spear_adc_isr, 0,
                              LPC32XXAD_NAME, st);           /* register handler */
    ...
    init_completion(&st->completion);                       /* initialize completion */

spear_adc_isr() calls complete():

    complete(&st->completion);

If the device raises an interrupt before init_completion() runs,
complete() acquires the uninitialized wait.lock and walks the zeroed
task_list in swake_up_locked(). The zeroed task_list makes list_empty()
return false, so swake_up_locked() dereferences a NULL list entry,
triggering a KASAN wild-memory-access."

Fix the chance of a spurious IRQ causing an uninitialized pointer
dereference by moving init_completion() above devm_request_irq().

Fixes: b586e5d9eee0 ("staging:iio:adc:spear rename device specific state structure to _state")
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Closes: https://lore.kernel.org/linux-iio/20260610115700.774689-1-jjy600901@snu.ac.kr/
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Reviewed-by: Vladimir Zapolskiy <vz@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/spear_adc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -280,6 +280,7 @@ static int spear_adc_probe(struct platfo
 	st = iio_priv(indio_dev);
 	st->dev = dev;
 
+	init_completion(&st->completion);
 	mutex_init(&st->lock);
 
 	/*
@@ -326,8 +327,6 @@ static int spear_adc_probe(struct platfo
 
 	spear_adc_configure(st);
 
-	init_completion(&st->completion);
-
 	indio_dev->name = SPEAR_ADC_MOD_NAME;
 	indio_dev->info = &spear_adc_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;


