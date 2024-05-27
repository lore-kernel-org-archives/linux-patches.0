Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B3B17727;
	Mon, 27 May 2024 19:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838450; cv=none; b=qtrt2ZwvGNrvutiogoos8ef1sn5IV9+yJnuv6wOn9aek9NrS0of2Rqk6v+PkI75xQ01x40j33mPO9m97KgWKrgNHJ4nHK9qT+172uFoHnbMmjsSNyxkvT2SYtvbh+uS35tkx/lhTF2fn2J39QPoR65iF+U9c3jxAvZqUGRD+p94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838450; c=relaxed/simple;
	bh=0mSniK1cFbSDgxLbXJ5YNg//wctExtpiNrTRvR4/rmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6IQtP/jjVr1m326zM3GzItzD/tBG5kMmKWVJLG2j2nSPLZQUQ1/OFQtA+yNPCM6BYDwctJ6Ryh9QbR+UYeNo34T62Z6pF5OO1SVMDmlFUUuvpCatzZJZpWLmifAxBlIKph1II3LQPdDbobXvl8oUGtDJzkQUMhkFiSgKmVf+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjKRXdD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjKRXdD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F4C2BBFC;
	Mon, 27 May 2024 19:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838450;
	bh=0mSniK1cFbSDgxLbXJ5YNg//wctExtpiNrTRvR4/rmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjKRXdD9Pim+wMpaUHJtOLs9yd0pa4l2WAT+34DZRKuwKBbvfephO1jWkgvz7LflY
	 kxwsSdRP4ckqLtKTKLbJ85gPyCn4D9/2eT9X9vhHUiTjiqFpaGIGh74S+rYas0T1xD
	 comzKvaU5JpnTC34J5kz87a5cPA6FhvbHsvwrNDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Eizan Miyamoto <eizan@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 358/493] drm/dp: Dont attempt AUX transfers when eDP panels are not powered
Date: Mon, 27 May 2024 20:56:00 +0200
Message-ID: <20240527185641.996850503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 8df1ddb5bf11ab820ad991e164dab82c0960add9 ]

If an eDP panel is not powered on then any attempts to talk to it over
the DP AUX channel will timeout. Unfortunately these attempts may be
quite slow. Userspace can initiate these attempts either via a
/dev/drm_dp_auxN device or via the created i2c device.

Making the DP AUX drivers timeout faster is a difficult proposition.
In theory we could just poll the panel's HPD line in the AUX transfer
function and immediately return an error there. However, this is
easier said than done. For one thing, there's no hard requirement to
hook the HPD line up for eDP panels and it's OK to just delay a fixed
amount. For another thing, the HPD line may not be fast to probe. On
parade-ps8640 we need to wait for the bridge chip's firmware to boot
before we can get the HPD line and this is a slow process.

The fact that the transfers are taking so long to timeout is causing
real problems. The open source fwupd daemon sometimes scans DP busses
looking for devices whose firmware need updating. If it happens to
scan while a panel is turned off this scan can take a long time. The
fwupd daemon could try to be smarter and only scan when eDP panels are
turned on, but we can also improve the behavior in the kernel.

Let's let eDP panels drivers specify that a panel is turned off and
then modify the common AUX transfer code not to attempt a transfer in
this case.

Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240202141109.1.I24277520ac754ea538c9b14578edc94e1df11b48@changeid
Stable-dep-of: 5e842d55bad7 ("drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesn't assert")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c       | 35 +++++++++++++++++++
 drivers/gpu/drm/panel/panel-edp.c             |  3 ++
 .../gpu/drm/panel/panel-samsung-atna33xc20.c  |  2 ++
 include/drm/display/drm_dp_helper.h           |  6 ++++
 4 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 26c188ce5f1c3..fb80843e7f2df 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -532,6 +532,15 @@ static int drm_dp_dpcd_access(struct drm_dp_aux *aux, u8 request,
 
 	mutex_lock(&aux->hw_mutex);
 
+	/*
+	 * If the device attached to the aux bus is powered down then there's
+	 * no reason to attempt a transfer. Error out immediately.
+	 */
+	if (aux->powered_down) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	/*
 	 * The specification doesn't give any recommendation on how often to
 	 * retry native transactions. We used to retry 7 times like for
@@ -599,6 +608,29 @@ int drm_dp_dpcd_probe(struct drm_dp_aux *aux, unsigned int offset)
 }
 EXPORT_SYMBOL(drm_dp_dpcd_probe);
 
+/**
+ * drm_dp_dpcd_set_powered() - Set whether the DP device is powered
+ * @aux: DisplayPort AUX channel; for convenience it's OK to pass NULL here
+ *       and the function will be a no-op.
+ * @powered: true if powered; false if not
+ *
+ * If the endpoint device on the DP AUX bus is known to be powered down
+ * then this function can be called to make future transfers fail immediately
+ * instead of needing to time out.
+ *
+ * If this function is never called then a device defaults to being powered.
+ */
+void drm_dp_dpcd_set_powered(struct drm_dp_aux *aux, bool powered)
+{
+	if (!aux)
+		return;
+
+	mutex_lock(&aux->hw_mutex);
+	aux->powered_down = !powered;
+	mutex_unlock(&aux->hw_mutex);
+}
+EXPORT_SYMBOL(drm_dp_dpcd_set_powered);
+
 /**
  * drm_dp_dpcd_read() - read a series of bytes from the DPCD
  * @aux: DisplayPort AUX channel (SST or MST)
@@ -1858,6 +1890,9 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 	struct drm_dp_aux_msg msg;
 	int err = 0;
 
+	if (aux->powered_down)
+		return -EBUSY;
+
 	dp_aux_i2c_transfer_size = clamp(dp_aux_i2c_transfer_size, 1, DP_AUX_MAX_PAYLOAD_BYTES);
 
 	memset(&msg, 0, sizeof(msg));
diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index e5e3f0b9ca61d..49b8a2484d92b 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -397,6 +397,7 @@ static int panel_edp_suspend(struct device *dev)
 {
 	struct panel_edp *p = dev_get_drvdata(dev);
 
+	drm_dp_dpcd_set_powered(p->aux, false);
 	gpiod_set_value_cansleep(p->enable_gpio, 0);
 	regulator_disable(p->supply);
 	p->unprepared_time = ktime_get_boottime();
@@ -453,6 +454,7 @@ static int panel_edp_prepare_once(struct panel_edp *p)
 	}
 
 	gpiod_set_value_cansleep(p->enable_gpio, 1);
+	drm_dp_dpcd_set_powered(p->aux, true);
 
 	delay = p->desc->delay.hpd_reliable;
 	if (p->no_hpd)
@@ -489,6 +491,7 @@ static int panel_edp_prepare_once(struct panel_edp *p)
 	return 0;
 
 error:
+	drm_dp_dpcd_set_powered(p->aux, false);
 	gpiod_set_value_cansleep(p->enable_gpio, 0);
 	regulator_disable(p->supply);
 	p->unprepared_time = ktime_get_boottime();
diff --git a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
index 5703f4712d96e..76c2a8f6718c8 100644
--- a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
+++ b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
@@ -72,6 +72,7 @@ static int atana33xc20_suspend(struct device *dev)
 	if (p->el3_was_on)
 		atana33xc20_wait(p->el_on3_off_time, 150);
 
+	drm_dp_dpcd_set_powered(p->aux, false);
 	ret = regulator_disable(p->supply);
 	if (ret)
 		return ret;
@@ -93,6 +94,7 @@ static int atana33xc20_resume(struct device *dev)
 	ret = regulator_enable(p->supply);
 	if (ret)
 		return ret;
+	drm_dp_dpcd_set_powered(p->aux, true);
 	p->powered_on_time = ktime_get_boottime();
 
 	if (p->no_hpd) {
diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
index 863b2e7add29e..472359a9d6756 100644
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -463,9 +463,15 @@ struct drm_dp_aux {
 	 * @is_remote: Is this AUX CH actually using sideband messaging.
 	 */
 	bool is_remote;
+
+	/**
+	 * @powered_down: If true then the remote endpoint is powered down.
+	 */
+	bool powered_down;
 };
 
 int drm_dp_dpcd_probe(struct drm_dp_aux *aux, unsigned int offset);
+void drm_dp_dpcd_set_powered(struct drm_dp_aux *aux, bool powered);
 ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
 			 void *buffer, size_t size);
 ssize_t drm_dp_dpcd_write(struct drm_dp_aux *aux, unsigned int offset,
-- 
2.43.0



