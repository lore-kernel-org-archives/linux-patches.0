Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D13332604;
	Thu, 16 Jul 2026 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211707; cv=none; b=QBuECMb/7mRkzl1V7e1SBUJZZ4AoplVTHVbOKCR03h6dJGDvlC3R9TJ+Eo47o5zbVcohq9j7u2AZkD+efbxXAkHeeajHGwGZ6VQmifTZlgYp+ZerKjbQbtOpo+ICa+1Jt2Tn6rrPlPEwgXzLkWXujHWWd6z2ePIGqRzppVkiUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211707; c=relaxed/simple;
	bh=LgTSv+Or169A/WYEEfhcDuKZL9Amqd6o+Ycx70a/zPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfQ+bm6nNspI3bm5efFIRAITV7YLmi6BbpW68Us5wrgeoKNOdUQiQRT3ePrid4RxRQb/kMTVn1ixA3gxgfLDu/KYe19LuhgQwWpi9tlV7lGwHa8y4yaEbAG8S5Hrcw0y0/1/eAr+ZqnV8VLZRQCUiOGZVTIZy7gonvkY+cEHQpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRn+Cw49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRn+Cw49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E171F000E9;
	Thu, 16 Jul 2026 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211705;
	bh=oPu0jE5DlZEbIUcD2r+iTNtppnYyOlKUsVQPwCSYlyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRn+Cw49cnNjTZF2wiCrnvdmgrCA0gQ9VKveP6X3wWSdpObpdlx9/F/TSnIrkuIc6
	 eevJGGMaG/ASaOVC+Gv57cx3ZXJWODHbg1vAUi3z/cIrDN0wyXB44tyCPWjrYGKAw2
	 sOq3pttHUAHSN6xC80ozhvh3XKhWJzHE5k0CwIdQ=
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
Subject: [PATCH 6.12 047/349] iio: adc: spear: Initialize completion before requesting IRQ
Date: Thu, 16 Jul 2026 15:29:41 +0200
Message-ID: <20260716133034.376047190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -281,6 +281,7 @@ static int spear_adc_probe(struct platfo
 	st = iio_priv(indio_dev);
 	st->dev = dev;
 
+	init_completion(&st->completion);
 	mutex_init(&st->lock);
 
 	/*
@@ -327,8 +328,6 @@ static int spear_adc_probe(struct platfo
 
 	spear_adc_configure(st);
 
-	init_completion(&st->completion);
-
 	indio_dev->name = SPEAR_ADC_MOD_NAME;
 	indio_dev->info = &spear_adc_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;


