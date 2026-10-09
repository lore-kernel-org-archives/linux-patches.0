Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2383367B8F;
	Fri,  9 Oct 2026 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557579; cv=none; b=aTtgzG//qzl+7NXNAH1bxnftqZVN84VN6Emy0iU+cUuCk/9mlbEDKyDUq3Gy8aZfBv0Dmu47ToRiwpxk8JIfjPreGkKd0xVYRx9JkE8YAg8gvGpp/wtGW2kkqrLd/oWL3JnVJFGroQJGcklRyI5hIG5u4DL4g2DozxY4Ic5fEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557579; c=relaxed/simple;
	bh=dhDJ4dRyp/QGUPw+DkNI5s/3Dfg6yBVZi7fTsL/AGvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp72C2x5s+Ol12VwLezHJcXM1tKFcIBBmkLsdZXHxFEB00jsbyb4KPRpGw4oul+VTFbVBOwFi3tahH6q5ofA++or/hVdtyF4S8mwcfPyWilQyI3sRZ9ZmC7QN3Lcb91sTmJSEdNdDZDbo5wnEVLb0jFIgbkIgHE6PMk6xNzhS7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1K4Ek/nU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1K4Ek/nU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEAF1F000FF;
	Fri,  9 Oct 2026 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557578;
	bh=jyxYicUaOCF6HHgxdTvWLITDjxzSNpA3WxdJHpjEJe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1K4Ek/nUeW4HI5ZHDzOD6fgVDjLZE/ptW7olExJK4NMkxXDjjgNg7rrssKRp2Ykwf
	 DIRIc5yhHDdUhyoW/VnPXNR/RxnWqZitdyLHCa5ckgxCQ6JBz7DKf4HEMr4Ncao18M
	 TuP4OqNF0MhatOt0q7t1oERkr5qAuKGhQNrWvPUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 392/428] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Fri,  9 Oct 2026 16:12:09 +0200
Message-ID: <20261009140954.816121494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -657,7 +657,6 @@ err_map:
 	if (!info->no_irq && IS_ENABLED(CONFIG_THERMAL_OF))
 		iio_map_array_unregister(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return ret;
@@ -668,7 +667,6 @@ static void sun4i_gpadc_remove(struct pl
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct sun4i_gpadc_iio *info = iio_priv(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ENABLED(CONFIG_THERMAL_OF))


