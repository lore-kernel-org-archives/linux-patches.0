Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2E3372EDE;
	Wed, 20 May 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296145; cv=none; b=cH3cldXTBjIs2zmUf8Dn77ZdwA1kvn1xoemarZeaDMJONnt8Cr9Qf4zvdRq4GRBv2aAj556rt2BEJXBm0fqL44c9k9wFGyzyYCOvFoLrX1GUh/qte3dK9hDfcRrC2qq0v7ma781xCu0VKZktcxTAdP1klRijZj3WkXnXCn9xvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296145; c=relaxed/simple;
	bh=CFwTchjEbKNlTYp9pWPCgu0c7xtHGATFuN0rl3wNIbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1sRXg6TQOP7B6Xpbf+CDupdEOVgIhrebZyLBpETTAUay4pawz6buqtmKHGFzkAe39sx01qJo323aRgLy/WajUZLGC2IPVVL8q3q3PrYPOdyR3t1yH2/8OZWe4BN6T/0yh6FoSc/lDsUR7oaJCaXtTDKZMjmR+WgzPesVOmlp0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh6uqtE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh6uqtE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDB71F000E9;
	Wed, 20 May 2026 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296144;
	bh=SXKi89bsWlJoaKnovl/EvKuNIYHi6mwMS9+Xaw5Tjys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh6uqtE7X+DCOEgpdjRMqoKvLQPpjNJ9f0rX+4YZTe9AHzl+ZKVayS+ANgVpqIEt5
	 K+M9sxVKqywvfHvpUjXtauGHKPqZaj6gfWyhgD9PHG6hGr8/Evts5hztRfo36pbUUO
	 3Z7O5aNSEi1EFD9/1mzdJ7Mklu4FuF+NZjQxNMWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0686/1146] platform/x86: hp-wmi: fix ignored return values in fan settings
Date: Wed, 20 May 2026 18:15:36 +0200
Message-ID: <20260520162203.715965123@linuxfoundation.org>
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

[ Upstream commit 7265b57fbc32782d02bdb8d865ba0d8efa209c8c ]

hp_wmi_get_fan_count_userdefine_trigger() can fail, but its return
value was silently ignored in hp_wmi_apply_fan_settings() for
PWM_MODE_MAX/AUTO. Propagate these errors consistently.

Additionally, handle the return value of hp_wmi_apply_fan_settings()
in its callers by adding appropriate warnings on failure, and remove an
unreachable "return 0" at the end of the function.

Fixes: 46be1453e6e6 ("platform/x86: hp-wmi: add manual fan control for Victus S models")
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Link: https://patch.msgid.link/20260407142515.20683-2-emreleno@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 62fd2fe0d8d0e..c9fe740d8933e 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -2358,8 +2358,11 @@ static int hp_wmi_apply_fan_settings(struct hp_wmi_hwmon_priv *priv)
 
 	switch (priv->mode) {
 	case PWM_MODE_MAX:
-		if (is_victus_s_thermal_profile())
-			hp_wmi_get_fan_count_userdefine_trigger();
+		if (is_victus_s_thermal_profile()) {
+			ret = hp_wmi_get_fan_count_userdefine_trigger();
+			if (ret < 0)
+				return ret;
+		}
 		ret = hp_wmi_fan_speed_max_set(1);
 		if (ret < 0)
 			return ret;
@@ -2377,7 +2380,9 @@ static int hp_wmi_apply_fan_settings(struct hp_wmi_hwmon_priv *priv)
 		return 0;
 	case PWM_MODE_AUTO:
 		if (is_victus_s_thermal_profile()) {
-			hp_wmi_get_fan_count_userdefine_trigger();
+			ret = hp_wmi_get_fan_count_userdefine_trigger();
+			if (ret < 0)
+				return ret;
 			ret = hp_wmi_fan_speed_max_reset(priv);
 		} else {
 			ret = hp_wmi_fan_speed_max_set(0);
@@ -2390,8 +2395,6 @@ static int hp_wmi_apply_fan_settings(struct hp_wmi_hwmon_priv *priv)
 		/* shouldn't happen */
 		return -EINVAL;
 	}
-
-	return 0;
 }
 
 static umode_t hp_wmi_hwmon_is_visible(const void *data,
@@ -2533,6 +2536,7 @@ static void hp_wmi_hwmon_keep_alive_handler(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct hp_wmi_hwmon_priv *priv;
+	int ret;
 
 	dwork = to_delayed_work(work);
 	priv = container_of(dwork, struct hp_wmi_hwmon_priv, keep_alive_dwork);
@@ -2540,7 +2544,10 @@ static void hp_wmi_hwmon_keep_alive_handler(struct work_struct *work)
 	 * Re-apply the current hwmon context settings.
 	 * NOTE: hp_wmi_apply_fan_settings will handle the re-scheduling.
 	 */
-	hp_wmi_apply_fan_settings(priv);
+	ret = hp_wmi_apply_fan_settings(priv);
+	if (ret)
+		pr_warn_ratelimited("keep-alive failed to refresh fan settings: %d\n",
+				    ret);
 }
 
 static int hp_wmi_setup_fan_settings(struct hp_wmi_hwmon_priv *priv)
@@ -2602,7 +2609,9 @@ static int hp_wmi_hwmon_init(void)
 
 	INIT_DELAYED_WORK(&priv->keep_alive_dwork, hp_wmi_hwmon_keep_alive_handler);
 	platform_set_drvdata(hp_wmi_platform_dev, priv);
-	hp_wmi_apply_fan_settings(priv);
+	ret = hp_wmi_apply_fan_settings(priv);
+	if (ret)
+		dev_warn(dev, "Failed to apply initial fan settings: %d\n", ret);
 
 	return 0;
 }
-- 
2.53.0



