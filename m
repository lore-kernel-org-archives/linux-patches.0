Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E4360EF0;
	Tue, 13 Oct 2026 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895322; cv=none; b=BUGQ0rbWcgbB9H2fNKkilK2J7dfpHcajCDgv+RcG9xgwv38zED/AsoN67yoE2SXexfTNuiiQrd/iTv3EK1XouJSMsT5Blslpnv+XTb+SDmIfXteCYPWQXmUfF/9H1uIVge4XD/HhJTYmingnIByptitTAs6jwHX+l+mMiZ9MZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895322; c=relaxed/simple;
	bh=L4OkZb75JX+LV09SyJvSDJBn7kNzzCL/0+I4YBhVQjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol/wvTzqM/xxWqt9K7zVF138mj+ZtJfttGpQg1hgECa+eySVz1xC2MaNQXNZhNcFPU2DHgc7jJlFjNkTCFnRblncqdru32873PLg9MpG295MI8n7U2AGrsn8eI7ephJJLY1NYV+XrXesAh/1K9P+Uwma63IARgeP18eNZzghG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2+jwwKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2+jwwKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957CD1F000FF;
	Tue, 13 Oct 2026 12:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895321;
	bh=dpwSJpVreAkSdoSOYkWxy+PNlzIofsZ0Meh7nbBvANs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2+jwwKeoedlVcG5Z6ZR0Dp887CDcZuPx93NaK/kCnJTt/BOSMhDHC+yyhwyMNDNE
	 /Ty2+2UHKfGUukLRue7KeX9moDTumkXC1YuvWcTLv2HOr7wST/95zGnRIQbtnfso5T
	 uDtY7OlB4XNFiBsQ7AIMq+acMkj0KZhHFjkSMFw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 236/497] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Tue, 13 Oct 2026 13:36:43 +0200
Message-ID: <20261013112913.498123607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 8b958dd214ad0c003f56549e9e039cb8067dc1a2 upstream.

Neither the error path in sun4i_gpadc_probe() nor sun4i_gpadc_remove()
ever holds a runtime PM usage count. So the pm_runtime_put() in both
places always triggers the "Runtime PM usage count underflow!" warning
on every failed probe and every unbind.

Drop both calls.

Fixes: d1caa9905538 ("iio: adc: add support for Allwinner SoCs ADC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -663,7 +663,6 @@ err_map:
 	if (!info->no_irq && IS_ENABLED(CONFIG_THERMAL_OF))
 		iio_map_array_unregister(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return ret;
@@ -674,7 +673,6 @@ static void sun4i_gpadc_remove(struct pl
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct sun4i_gpadc_iio *info = iio_priv(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ENABLED(CONFIG_THERMAL_OF))


