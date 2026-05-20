Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D8833B969;
	Wed, 20 May 2026 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296169; cv=none; b=M2SDjOHXQYc8fDICBFjcO+P0g0ZP2snTxndovIS8PIdBGas57CZHu0Log2m5KY4Qi/RzFUH47sTmboY2anK6bPAvqg2kd9ect3a3wO4D1L9yKFBtDW/nYsKnuLg23PtIF6l/SttQ9vqVGvSzIj1+pPUN5RgGB/kAR/i0xC37bpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296169; c=relaxed/simple;
	bh=5CZxis/n+MuCB4SRHMr/Ndqz7ziaC5DdzMCBjZOHKZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7rY4yHAVjnWNrp+72+sSWjI3T9OUAbepoz5fOwUconUyhKsR6DyQ09ZCuk6QTKwEgsdsOYfFmsFU2hWEA5dzuxpy8pdKPJQTdOtAtBTl5TRbe2G1YQshuSRkhe7bBfYmRk2tt/mgnpbj9vHoUEVshOpuL0x7dlI+Yi6VMg4yaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0xZrhAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0xZrhAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4441F000E9;
	Wed, 20 May 2026 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296168;
	bh=TnBkEGfF2NfizyettGVNKjNGhqNEpsYitKk3ZbH0te4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0xZrhACH7zlVp6LrcowiyeYUoP+IU8inr4bs5hyeJXuxM732Gn5BG06kVpS4sLw7
	 GzI95pOeqnaZWUHFGHnKkg29jGYsRQJioMHGTcZH0WrI4abPLfmSpeLaIMQdtQSNzR
	 o3sRUFSsIRrmFRVU3pJ009o6JeK530WGdShORbjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Emre Cecanpunar <emreleno@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0690/1146] platform/x86: hp-wmi: add locking for concurrent hwmon access
Date: Wed, 20 May 2026 18:15:40 +0200
Message-ID: <20260520162203.804450666@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emre Cecanpunar <emreleno@gmail.com>

[ Upstream commit 5969c55e2145368254194edbe0e64880314be69f ]

hp_wmi_hwmon_priv.mode and .pwm are written by hp_wmi_hwmon_write() in
sysfs context and read by hp_wmi_hwmon_keep_alive_handler() in a
workqueue. A concurrent write and keep-alive expiry can observe an
inconsistent mode/pwm pair (e.g. mode=MANUAL with a stale pwm).

Add a mutex to hp_wmi_hwmon_priv protecting mode and pwm. Hold it in
hp_wmi_hwmon_write() across the field update and apply call, and in
hp_wmi_hwmon_keep_alive_handler() before calling apply.

In hp_wmi_hwmon_read(), only the pwm_enable path reads priv->mode; use
scoped_guard() there to avoid holding the lock across unrelated WMI
calls.

Fixes: c203c59fb5de ("platform/x86: hp-wmi: implement fan keep-alive")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Link: https://patch.msgid.link/20260407142515.20683-6-emreleno@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index dd0f86b8807fa..851056bee6146 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -458,6 +458,7 @@ enum pwm_modes {
 };
 
 struct hp_wmi_hwmon_priv {
+	struct mutex lock;	/* protects mode, pwm */
 	u8 min_rpm;
 	u8 max_rpm;
 	int gpu_delta;
@@ -2427,6 +2428,7 @@ static int hp_wmi_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 {
 	struct hp_wmi_hwmon_priv *priv;
 	int rpm, ret;
+	u8 mode;
 
 	priv = dev_get_drvdata(dev);
 	switch (type) {
@@ -2450,11 +2452,13 @@ static int hp_wmi_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			*val = rpm_to_pwm(rpm / 100, priv);
 			return 0;
 		}
-		switch (priv->mode) {
+		scoped_guard(mutex, &priv->lock)
+			mode = priv->mode;
+		switch (mode) {
 		case PWM_MODE_MAX:
 		case PWM_MODE_MANUAL:
 		case PWM_MODE_AUTO:
-			*val = priv->mode;
+			*val = mode;
 			return 0;
 		default:
 			/* shouldn't happen */
@@ -2472,6 +2476,7 @@ static int hp_wmi_hwmon_write(struct device *dev, enum hwmon_sensor_types type,
 	int rpm;
 
 	priv = dev_get_drvdata(dev);
+	guard(mutex)(&priv->lock);
 	switch (type) {
 	case hwmon_pwm:
 		if (attr == hwmon_pwm_input) {
@@ -2540,6 +2545,8 @@ static void hp_wmi_hwmon_keep_alive_handler(struct work_struct *work)
 
 	dwork = to_delayed_work(work);
 	priv = container_of(dwork, struct hp_wmi_hwmon_priv, keep_alive_dwork);
+
+	guard(mutex)(&priv->lock);
 	/*
 	 * Re-apply the current hwmon context settings.
 	 * NOTE: hp_wmi_apply_fan_settings will handle the re-scheduling.
@@ -2596,6 +2603,10 @@ static int hp_wmi_hwmon_init(void)
 	if (!priv)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(dev, &priv->lock);
+	if (ret)
+		return ret;
+
 	ret = hp_wmi_setup_fan_settings(priv);
 	if (ret)
 		return ret;
-- 
2.53.0



