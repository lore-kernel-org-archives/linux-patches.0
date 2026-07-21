Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653193B9DAB;
	Tue, 21 Jul 2026 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668241; cv=none; b=shJRMrTDCvvEc3nngDOTVXerxVzVMgoS5CfDXkwTh87tmHZ6cGrMCYxef+nlT7yC0m1rO1oVHosA4iaKZVVYMieXOAWP45pxbZptU5Ff4k/VHSYWyIasXOEzJiKNXYjTjOLghWt0S4I+MOZZVn60h4+ucMVUu9Qa75vHACcSaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668241; c=relaxed/simple;
	bh=CSAPisEuhF2Edf4dVWJbqtHiKFUhStsupFOzq4oa+9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juYNnSGlAqfFpti9I6OPXbaaJP5bhCMBq/C+eEU324PlRZckGGtLKKjkoQKCMNbIwDE5GcsVQcD1mwzjMGbvLkzmV0NepQBroTKzKf5VUD5WLN0TTBBU3mi/wzwqlHcTOJFoU07qWbYg/0wgMpD+yDCacDmTvOMoK0awKSw8G6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coZP+SNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coZP+SNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15D51F000E9;
	Tue, 21 Jul 2026 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668240;
	bh=Z+kgaQVoQGjXt4iAlf8kvQlpPwiOuOs8hnweBGmW8zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coZP+SNqN6fiXe6aXiuD40EC/6JFPEWkB76EEVQrTE9OPPyJ/vMQujawS1z8HuFw4
	 AeZmBJrHAGGxMQYFhPsO8qLq9L3/SHvJSJDGKcdFb41dh4Pc6X22XalH3n6bi/BVXm
	 1NyM290JaQcj49YrwUYCP7u4029+ggYj5zN0jABs=
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
Subject: [PATCH 6.1 0057/1067] iio: adc: spear: Initialize completion before requesting IRQ
Date: Tue, 21 Jul 2026 17:10:58 +0200
Message-ID: <20260721152425.840794283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -282,6 +282,7 @@ static int spear_adc_probe(struct platfo
 
 	st = iio_priv(indio_dev);
 
+	init_completion(&st->completion);
 	mutex_init(&st->lock);
 
 	st->np = np;
@@ -346,8 +347,6 @@ static int spear_adc_probe(struct platfo
 
 	platform_set_drvdata(pdev, indio_dev);
 
-	init_completion(&st->completion);
-
 	indio_dev->name = SPEAR_ADC_MOD_NAME;
 	indio_dev->info = &spear_adc_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;


