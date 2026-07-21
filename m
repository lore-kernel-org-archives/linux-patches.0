Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73318404BF6;
	Tue, 21 Jul 2026 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673326; cv=none; b=eykz3KrB9QF2VBvIPExFqMcYjn/AQb2YTt9ADnSWQA6kqsxzmVMq8qWg/tON4mciSoWwSpyroumxYTIutfGm8MjOSuu6Q0n1/AON0rDpgLSN1wXnjftt0qHVSItgJqygdnZDUK7F5iJxskXzrm11MD3LeM+VNxva/LaSSfiw/KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673326; c=relaxed/simple;
	bh=Lm6Qap8yHrfLXuMFeV9IzvSwYjsNM/7LqVqTQKPV9d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Asugmn6/znlFkCJ87GTzADFda3+WlU7quu9CagVmG87CYnOlvMCArD08AlVJbTUUoz8wDxa89IOAruyj7VxYk4Kxu+kpz3lpmzCbTtvEplHap0L2kC8lggdFMljT5Wuq3cbXSrRWcW5rAJGcPIoBc0XWhtBJ/7Yh1gM+CNS/TAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DllgggMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DllgggMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEEC1F000E9;
	Tue, 21 Jul 2026 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673325;
	bh=0AFyP8+URNZ5ImKSRJdWnh7STreBoh8uUPGZ8hbP6NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DllgggMBJM16bE48TuLCSsLF/AdOPg3MkA2XSQmQtXhaix3qdOMXf3xXsn3ZzxVLN
	 XnZs7e6zud3yH9gpvPfXwIiXJjdhr/isZPd71wOOuztiIUnCwPsFya0kndBXtM09dX
	 OwcH/5+NbDGjXAeV1gZQkIVAAXvEI+VtJs+wKntw=
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
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/699] iio: adc: spear: Initialize completion before requesting IRQ
Date: Tue, 21 Jul 2026 17:17:58 +0200
Message-ID: <20260721152358.389923177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxwell Doose <m32285159@gmail.com>

[ Upstream commit 3ee2128b6f0eb0be7b6cb8f6e0f1f113a65201a0 ]

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
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/spear_adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/spear_adc.c b/drivers/iio/adc/spear_adc.c
index 4d4aff88aa6ceb..12e0811a47b71a 100644
--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -274,6 +274,8 @@ static int spear_adc_probe(struct platform_device *pdev)
 	st = iio_priv(indio_dev);
 	st->np = np;
 
+	init_completion(&st->completion);
+
 	/*
 	 * SPEAr600 has a different register layout than other SPEAr SoC's
 	 * (e.g. SPEAr3xx). Let's provide two register base addresses
@@ -334,8 +336,6 @@ static int spear_adc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, indio_dev);
 
-	init_completion(&st->completion);
-
 	indio_dev->name = SPEAR_ADC_MOD_NAME;
 	indio_dev->info = &spear_adc_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.53.0



