Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F892FAC02;
	Tue, 26 Aug 2025 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207760; cv=none; b=NFrB9KiKIj6vF6vPNHlm1FP1jT7ddWJTqxCt01MQ74Zj0W+pTrRR7abv1dMmn2ZqsPZDddQIF+8Y+rQt/1gm1moqLS3GumnbL/JA++xDbB0ohoyRJoNpAjElQefTPmNziHU+ZbytglX+4wk2apjGsd/8ssGF6uBKgK+zTEZYpNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207760; c=relaxed/simple;
	bh=wCV0CEFrhxG4VNX+JMcQeTsvArnNnOK3uGHSX+TY/E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALYDSFQ/TKpIhWGT828QE+UtCYShWLqqaTKcghBJnqrQVPruwwdN9PnXVBuKyDqo67Wfl5A/hJ1+tA4VaOptYGo6+CeIu0sZRj4rTXymQ0U9Vy1UOaJ2JLyJ+O9gpLYtvlddkZ7pJQmBVobEhh1/nVOTL/dZGGJ83w9dCpHiV7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8iOUr0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8iOUr0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF452C4CEF1;
	Tue, 26 Aug 2025 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207760;
	bh=wCV0CEFrhxG4VNX+JMcQeTsvArnNnOK3uGHSX+TY/E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8iOUr0EEuen7EHxKFZ1dJF41K5RoWhnKqWPysIWgIYuStbTzf9VI3ZI8bGPoIWE2
	 y2PSVsx5EP+FlmHs/r/mEJ/WzL4icQPvFyR67vD2BVDud+D+xxH2ZzscqzzOSxysMs
	 N7Ia0kFv4IG8vlpeNsvfluClBmcov3NTN4Tfv9J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 306/457] iio: adc: rzg2l: Cleanup suspend/resume path
Date: Tue, 26 Aug 2025 13:09:50 +0200
Message-ID: <20250826110944.928379030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit a3c6eabe3bbd6b0e7124d68b2d3bc32fed17362e upstream.

There is no need to manually track the runtime PM status in the driver.
The pm_runtime_force_suspend() and pm_runtime_force_resume() functions
already call pm_runtime_status_suspended() to check the runtime PM state.

Additionally, avoid calling pm_runtime_put_autosuspend() during the
suspend/resume path, as this would decrease the usage counter of a
potential user that had the ADC open before the suspend/resume cycle.

Fixes: 563cf94f9329 ("iio: adc: rzg2l_adc: Add suspend/resume support")
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20250810123328.800104-2-claudiu.beznea.uj@bp.renesas.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rzg2l_adc.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/iio/adc/rzg2l_adc.c b/drivers/iio/adc/rzg2l_adc.c
index 9674d48074c9..0cb5a67fd497 100644
--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -89,7 +89,6 @@ struct rzg2l_adc {
 	struct completion completion;
 	struct mutex lock;
 	u16 last_val[RZG2L_ADC_MAX_CHANNELS];
-	bool was_rpm_active;
 };
 
 /**
@@ -541,14 +540,9 @@ static int rzg2l_adc_suspend(struct device *dev)
 	};
 	int ret;
 
-	if (pm_runtime_suspended(dev)) {
-		adc->was_rpm_active = false;
-	} else {
-		ret = pm_runtime_force_suspend(dev);
-		if (ret)
-			return ret;
-		adc->was_rpm_active = true;
-	}
+	ret = pm_runtime_force_suspend(dev);
+	if (ret)
+		return ret;
 
 	ret = reset_control_bulk_assert(ARRAY_SIZE(resets), resets);
 	if (ret)
@@ -557,9 +551,7 @@ static int rzg2l_adc_suspend(struct device *dev)
 	return 0;
 
 rpm_restore:
-	if (adc->was_rpm_active)
-		pm_runtime_force_resume(dev);
-
+	pm_runtime_force_resume(dev);
 	return ret;
 }
 
@@ -577,11 +569,9 @@ static int rzg2l_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (adc->was_rpm_active) {
-		ret = pm_runtime_force_resume(dev);
-		if (ret)
-			goto resets_restore;
-	}
+	ret = pm_runtime_force_resume(dev);
+	if (ret)
+		goto resets_restore;
 
 	ret = rzg2l_adc_hw_init(dev, adc);
 	if (ret)
@@ -590,10 +580,7 @@ static int rzg2l_adc_resume(struct device *dev)
 	return 0;
 
 rpm_restore:
-	if (adc->was_rpm_active) {
-		pm_runtime_mark_last_busy(dev);
-		pm_runtime_put_autosuspend(dev);
-	}
+	pm_runtime_force_suspend(dev);
 resets_restore:
 	reset_control_bulk_assert(ARRAY_SIZE(resets), resets);
 	return ret;
-- 
2.50.1



