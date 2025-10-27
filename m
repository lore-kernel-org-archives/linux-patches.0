Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326032D0EE;
	Mon, 27 Oct 2025 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592096; cv=none; b=GCbzCEniPx2rOnvnWNRArfMo3CpU7XXi8VFWXdmHO0cTS6gyuCUr65+236XtfmMPa2sQ+KZ/XN+dZMzEEyvTFh3RwbVrzhyK7pEgnlevHbPJQMTJIMYNs59IiD5J17bSXWwzsUVsovjf+U2CO66GrJaQILhLtDB9z9ilOuNINq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592096; c=relaxed/simple;
	bh=BDYiAGd5I0KshkacKnVSQZzxNhFPDXacYJfotNGkbgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5L0yqpn4xLH8pLDi3IhV8R4Kga/NoFVjz3CUk3c0C5+FeDxTgJ7mjapl2cFM3+vCVZU3+QzSyGthlQwwx1pEBhaqgT0nFhg/9pLHHuItbU7PLNXYp3lWU1dTS7Gacx22ueJ80oJ43JhjOXikSQ89Urvxx6bWY2V8Bgo3hx6MA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt4fwCr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt4fwCr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407AEC4CEF1;
	Mon, 27 Oct 2025 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592095;
	bh=BDYiAGd5I0KshkacKnVSQZzxNhFPDXacYJfotNGkbgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt4fwCr8qLKB5D84vLaisuJQI0fL3VYs3wp/Z3+DrhIxB3gpEjMKcYQBcE9oxEsCB
	 p7dtwCQcpHcxLbMt9Ub4TJhQdxKGBLp80yiY+X+4mM/Pa0ZSFNKXfMzT3MjTcNcjTZ
	 coX96Iqs9GgO5Tdb9CO+KQiG9vdGrqUTdOLqwAX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/123] iio: imu: inv_icm42600: Simplify pm_runtime setup
Date: Mon, 27 Oct 2025 19:36:18 +0100
Message-ID: <20251027183449.013457336@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 0792c1984a45ccd7a296d6b8cb78088bc99a212e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   24 ++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -550,20 +550,12 @@ static void inv_icm42600_disable_vdd_reg
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
 
 int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
@@ -660,16 +652,14 @@ int inv_icm42600_core_probe(struct regma
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
 EXPORT_SYMBOL_GPL(inv_icm42600_core_probe);
 


