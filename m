Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF1C4E50CC;
	Fri,  9 Oct 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556940; cv=none; b=bk41R3U/FeXOEL64Nc0V9j3BApyzX6tomG2jhRsmmUCQY8+EXpdk6A+GfdylY1KVge5nItzzF8aUYHBB9CyjfNPqDEVWA3HYzC9cadpvUOgTNm5C9je1kTsSv+GgodNxUDXkTYWMy+YjjybRbxUr5a2PyaMsUd1ebQ81pTeqErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556940; c=relaxed/simple;
	bh=U9f9rDxy/ck5hia1XDVT8jdG0PHI9lLCgNi9Ej6ecMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIqnCCifd2GCgoRY7LeWoic00ipTyquuOKOK4jNyZnY/QXdZViXNdigx2tqGUgHafOjCpAI7KRIQbriUTcjkxJcGyA9LzpPH4BLpjrFgleMVUzzWE5R8oFmuiBa/hlN5Uver7NL0yLNlJ+lxfWYKyHR1DcEHatvSCpI8MniMvSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XCrYOFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XCrYOFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D7F1F000FF;
	Fri,  9 Oct 2026 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556939;
	bh=37QXG6l0xgIGk6UNTuAgwsN5yfaMhvuCvSOXGjlCBuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XCrYOFo/RtQmnJ7MWN4zFdEIN/bsGsmpmWZj01BT/UNK0bKuQWX9hlOteTmK2WJ1
	 q+7XuI6b2Ciins7F51Jpo8hjkkCGLO1w7A+9YnKaB8oYw20pdvdse5XnXwAkpAJfAj
	 IEvcVr0FyzkHnyyPF5hERaau089iKkA50o9Mvb6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 317/403] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Fri,  9 Oct 2026 16:11:18 +0200
Message-ID: <20261009140959.638129267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


