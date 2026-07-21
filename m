Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65633B95E0;
	Tue, 21 Jul 2026 21:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668238; cv=none; b=ZMegM68S7kIhQhIqfwevXLbpz+5oZg88lM9aeqrTYuC0ror6+QskaggbhDEfHGU1MjkapDKb0h0/hukbU2NuQS/hHZ8cceS/kuY0HOG16fU7Rf98zYSIr7rvG5n+C+bsHMJvsaw5fX/czDVswNhGuf++k/1jX9OkPXZYewxY/Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668238; c=relaxed/simple;
	bh=Ufn+MlVKF5ICI++3a4mxCBrdTtA4xlaYJUmIPsJM8i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cewp21WYJV8Tb4wJC5Qxb8IaFifAImzVUxFIRPc4I+VzTXu5PWZhlcqfWk1GrFP5USouuDqy5ejqGJMIXR/oWD9RQYpmu4SlcER1j9wW1XWy3VyDPxK72ZbW8iYq5+oUDy81zL3ni0ipRTV+8sqLSsRL2jymTK71lR/bouwJOr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcfL+ReY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcfL+ReY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E92B1F000E9;
	Tue, 21 Jul 2026 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668237;
	bh=iAiKLwY2Cfx4JUd+B6z628seSBXbIIf2Xz4yUyiEEIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcfL+ReYuy7pOQ7AlErbc3Pm9jO6U4XT00xOVdEqp8ejmkBnyJfGlniwv1iL8FaZ2
	 e1volOg3Se9X6ZQp/tThl1kSOIfskuDe+3NKxVMCnbVOTDBERrlbGKTiXKVFCNWFga
	 j+NI1zdiDHYfQIz2uLdRyYH0roqI9tNI8dbOOWnc=
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
Subject: [PATCH 6.1 0056/1067] iio: adc: lpc32xx: Initialize completion before requesting IRQ
Date: Tue, 21 Jul 2026 17:10:57 +0200
Message-ID: <20260721152425.820228865@linuxfoundation.org>
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

commit e561b35633f450ee607e87a6401d97f156a0cd54 upstream.

In the report from Jaeyoung Chung:

"lpc32xx_adc_probe() in drivers/iio/adc/lpc32xx_adc.c registers its
interrupt handler with devm_request_irq() before it initializes
st->completion with init_completion(). If an interrupt arrives after
devm_request_irq() and before init_completion(), the handler calls
complete() on an uninitialized completion, causing a kernel panic.

The probe path, in lpc32xx_adc_probe():

    iodev = devm_iio_device_alloc(&pdev->dev, sizeof(*st)); /* st kzalloc-zeroed */
    ...
    retval = devm_request_irq(&pdev->dev, irq, lpc32xx_adc_isr, 0,
                              LPC32XXAD_NAME, st);           /* register handler */
    ...
    init_completion(&st->completion);                       /* initialize completion */

lpc32xx_adc_isr() calls complete():

    complete(&st->completion);

If the device raises an interrupt before init_completion() runs,
complete() acquires the uninitialized wait.lock and walks the zeroed
task_list in swake_up_locked(). The zeroed task_list makes list_empty()
return false, so swake_up_locked() dereferences a NULL list entry,
triggering a KASAN wild-memory-access."

Fix the chance of a spurious IRQ causing an uninitialized pointer
dereference by moving init_completion() above devm_request_irq().

Fixes: 7901b2a1453e ("staging:iio:adc:lpc32xx rename local state structure to _state")
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
 drivers/iio/adc/lpc32xx_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/lpc32xx_adc.c
+++ b/drivers/iio/adc/lpc32xx_adc.c
@@ -176,6 +176,8 @@ static int lpc32xx_adc_probe(struct plat
 	if (irq < 0)
 		return irq;
 
+	init_completion(&st->completion);
+
 	retval = devm_request_irq(&pdev->dev, irq, lpc32xx_adc_isr, 0,
 				  LPC32XXAD_NAME, st);
 	if (retval < 0) {
@@ -194,8 +196,6 @@ static int lpc32xx_adc_probe(struct plat
 
 	platform_set_drvdata(pdev, iodev);
 
-	init_completion(&st->completion);
-
 	iodev->name = LPC32XXAD_NAME;
 	iodev->info = &lpc32xx_adc_iio_info;
 	iodev->modes = INDIO_DIRECT_MODE;


