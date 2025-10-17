Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB69336ECE;
	Fri, 17 Oct 2025 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715470; cv=none; b=KaWPqKF4yHzGnim+iHgMSMx39LxSe7fn/swv49ViFZHR37t+1kojirgQBQCd9iO/XcA+rpz856DtGWTRd8cgYLCix2cse/w+luvKtV/ijczRAMJfGpkO/ogU7tpawIGkOdTgwNCrQXKUMGBADJUgjUquk+Q8tlpTn+LkzEptVjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715470; c=relaxed/simple;
	bh=GWPVB25TSSu6OYOkxr8F3/sitRvoz1sv+mq7/I5ejlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzWjlqzkHmMw307BdZyNAawQQcw8DNdfltTFPUXXdSblHMnn/4iAzOC3Lfwx94qgH+PwEVlheSchF9md44Z+jmGQcAGYPUdOybrRxVcDnw5aIADrjbDCjUauXioCb0PT5hO3QGL0gTUG4yoSnTl9vM+St2k9bJNEuHfxBY5c1VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OcrUECr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OcrUECr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B836AC116B1;
	Fri, 17 Oct 2025 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715470;
	bh=GWPVB25TSSu6OYOkxr8F3/sitRvoz1sv+mq7/I5ejlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OcrUECrjdFko1OaA8Q3mT9vVsvOibxnKp0EjvTG12DwUfKuA6krnkMQfiIw1Hkqn
	 jRc5umr9soVdKIMbJg49J5V3kXD0k+BsTfY4nMNxvorpWhE4OUcSm/GN5f3G1FT3Dx
	 CFr4e2C4Cy4mmsyxM1JKtT1PgnK2PWx4DInBcxXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 226/371] iio: imu: inv_icm42600: Simplify pm_runtime setup
Date: Fri, 17 Oct 2025 16:53:21 +0200
Message-ID: <20251017145210.262652976@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 0792c1984a45ccd7a296d6b8cb78088bc99a212e upstream.

Rework the power management in inv_icm42600_core_probe() to use
devm_pm_runtime_set_active_enabled(), which simplifies the runtime PM
setup by handling activation and enabling in one step.
Remove the separate inv_icm42600_disable_pm callback, as it's no longer
needed with the devm-managed approach.
Using devm_pm_runtime_enable() also fixes the missing disable of
autosuspend.
Update inv_icm42600_disable_vddio_reg() to only disable the regulator if
the device is not suspended i.e. powered-down, preventing unbalanced
disables.
Also remove redundant error msg on regulator_disable(), the regulator
framework already emits an error message when regulator_disable() fails.

This simplifies the PM setup and avoids manipulating the usage counter
unnecessarily.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250901-icm42pmreg-v3-1-ef1336246960@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   24 ++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -711,20 +711,12 @@ static void inv_icm42600_disable_vdd_reg
 static void inv_icm42600_disable_vddio_reg(void *_data)
 {
 	struct inv_icm42600_state *st = _data;
-	const struct device *dev = regmap_get_device(st->map);
-	int ret;
-
-	ret = regulator_disable(st->vddio_supply);
-	if (ret)
-		dev_err(dev, "failed to disable vddio error %d\n", ret);
-}
+	struct device *dev = regmap_get_device(st->map);
 
-static void inv_icm42600_disable_pm(void *_data)
-{
-	struct device *dev = _data;
+	if (pm_runtime_status_suspended(dev))
+		return;
 
-	pm_runtime_put_sync(dev);
-	pm_runtime_disable(dev);
+	regulator_disable(st->vddio_supply);
 }
 
 int inv_icm42600_core_probe(struct regmap *regmap, int chip,
@@ -824,16 +816,14 @@ int inv_icm42600_core_probe(struct regma
 		return ret;
 
 	/* setup runtime power management */
-	ret = pm_runtime_set_active(dev);
+	ret = devm_pm_runtime_set_active_enabled(dev);
 	if (ret)
 		return ret;
-	pm_runtime_get_noresume(dev);
-	pm_runtime_enable(dev);
+
 	pm_runtime_set_autosuspend_delay(dev, INV_ICM42600_SUSPEND_DELAY_MS);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_put(dev);
 
-	return devm_add_action_or_reset(dev, inv_icm42600_disable_pm, dev);
+	return ret;
 }
 EXPORT_SYMBOL_NS_GPL(inv_icm42600_core_probe, "IIO_ICM42600");
 


