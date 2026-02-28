Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85543D4F4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301152; cv=none; b=byDIvZn9tWvE+jMgvI0cnEiS09xsCWw6o4AVA6rTuU996MJhZk9fF+jwG3w0V4HAC7/f2zseB8PFa71AjEtC88tir37aXgqwZP++a3rDSr6dHEug4A5WnfKGRa5fTvAThoLN99NRIhonZdDfhI0udRJDUuRa1Ck8I8peaFl6jgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301152; c=relaxed/simple;
	bh=zpKMOc6QSDnE53TTgWQmCKCyJ5lSbLE5bZC0VB8gSP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG9FXgxyunvcQkcBNCx7mAxF/dbD/2GPoot9uIHhn0j6Y9s0WVPMqX6CsKwPuej44RnrwpcNvHH3F9XDp18JDAUJa6QZ6Edxn5QCTWaQ8pW5LeDP3tzvQOZO3PCxdRqU13D9WLu0SU/5xYYfhkeafb3k2yXMGyX13z1jWe5JqaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+P8hz14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+P8hz14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91E1C116D0;
	Sat, 28 Feb 2026 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301152;
	bh=zpKMOc6QSDnE53TTgWQmCKCyJ5lSbLE5bZC0VB8gSP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+P8hz14BmISCSvv+hecIyG8TuVrnJoBwcnDMhPpPC3N0r7KZL+AQMMUM9NGEN14R
	 hvm7FLBVQlp9DyXuSRq8Hu2xiwlOjz/dgiMy/dBVVqT0XbokxGPCnbI/nuqUbi1c8f
	 UiVtQGB75IGcx6pZXOzA6pV3bit/JOxgc31PUrvzHQMOjS1i8WpLUl4dQeIqc4sIok
	 AmcRHmFK/hJqlzC5GNfh2LzhzHitN6pFVz0TKFid5HH4yvGJWK97L/hiJD6ZVWhKDc
	 x+BYKmR+UzPfBOiGC/PFjCdo3KfFJUNmwsdvspczGonLhM864SpiglWXeYNA26z/cD
	 mZOerm5MNaUCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 315/752] remoteproc: mediatek: Break lock dependency to `prepare_lock`
Date: Sat, 28 Feb 2026 12:40:26 -0500
Message-ID: <20260228174750.1542406-315-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit d935187cfb27fc4168f78f3959aef4eafaae76bb ]

A potential circular locking dependency (ABBA deadlock) exists between
`ec_dev->lock` and the clock framework's `prepare_lock`.

The first order (A -> B) occurs when scp_ipi_send() is called while
`ec_dev->lock` is held (e.g., within cros_ec_cmd_xfer()):
1. cros_ec_cmd_xfer() acquires `ec_dev->lock` and calls scp_ipi_send().
2. scp_ipi_send() calls clk_prepare_enable(), which acquires
   `prepare_lock`.
See #0 in the following example calling trace.
(Lock Order: `ec_dev->lock` -> `prepare_lock`)

The reverse order (B -> A) is more complex and has been observed
(learned) by lockdep.  It involves the clock prepare operation
triggering power domain changes, which then propagates through sysfs
and power supply uevents, eventually calling back into the ChromeOS EC
driver and attempting to acquire `ec_dev->lock`:
1. Something calls clk_prepare(), which acquires `prepare_lock`.  It
   then triggers genpd operations like genpd_runtime_resume(), which
   takes `&genpd->mlock`.
2. Power domain changes can trigger regulator changes; regulator
   changes can then trigger device link changes; device link changes
   can then trigger sysfs changes.  Eventually, power_supply_uevent()
   is called.
3. This leads to calls like cros_usbpd_charger_get_prop(), which calls
   cros_ec_cmd_xfer_status(), which then attempts to acquire
   `ec_dev->lock`.
See #1 ~ #6 in the following example calling trace.
(Lock Order: `prepare_lock` -> `&genpd->mlock` -> ... -> `&ec_dev->lock`)

Move the clk_prepare()/clk_unprepare() operations for `scp->clk` to the
remoteproc prepare()/unprepare() callbacks.  This ensures `prepare_lock`
is only acquired in prepare()/unprepare() callbacks.  Since
`ec_dev->lock` is not involved in the callbacks, the dependency loop is
broken.

This means the clock is always "prepared" when the SCP is running.  The
prolonged "prepared time" for the clock should be acceptable as SCP is
designed to be a very power efficient processor.  The power consumption
impact can be negligible.

A simplified calling trace reported by lockdep:
> -> #6 (&ec_dev->lock)
>        cros_ec_cmd_xfer
>        cros_ec_cmd_xfer_status
>        cros_usbpd_charger_get_port_status
>        cros_usbpd_charger_get_prop
>        power_supply_get_property
>        power_supply_show_property
>        power_supply_uevent
>        dev_uevent
>        uevent_show
>        dev_attr_show
>        sysfs_kf_seq_show
>        kernfs_seq_show
> -> #5 (kn->active#2)
>        kernfs_drain
>        __kernfs_remove
>        kernfs_remove_by_name_ns
>        sysfs_remove_file_ns
>        device_del
>        __device_link_del
>        device_links_driver_bound
> -> #4 (device_links_lock)
>        device_link_remove
>        _regulator_put
>        regulator_put
> -> #3 (regulator_list_mutex)
>        regulator_lock_dependent
>        regulator_disable
>        scpsys_power_off
>        _genpd_power_off
>        genpd_power_off
> -> #2 (&genpd->mlock/1)
>        genpd_add_subdomain
>        pm_genpd_add_subdomain
>        scpsys_add_subdomain
>        scpsys_probe
> -> #1 (&genpd->mlock)
>        genpd_runtime_resume
>        __rpm_callback
>        rpm_callback
>        rpm_resume
>        __pm_runtime_resume
>        clk_core_prepare
>        clk_prepare
> -> #0 (prepare_lock)
>        clk_prepare
>        scp_ipi_send
>        scp_send_ipi
>        mtk_rpmsg_send
>        rpmsg_send
>        cros_ec_pkt_xfer_rpmsg

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20260112110755.2435899-1-tzungbi@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c     | 39 +++++++++++++++++++++++---------
 drivers/remoteproc/mtk_scp_ipi.c |  4 ++--
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index 8206a17664818..2aeb0ded165cf 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -282,7 +282,7 @@ static irqreturn_t scp_irq_handler(int irq, void *priv)
 	struct mtk_scp *scp = priv;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clocks\n");
 		return IRQ_NONE;
@@ -290,7 +290,7 @@ static irqreturn_t scp_irq_handler(int irq, void *priv)
 
 	scp->data->scp_irq_handler(scp);
 
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return IRQ_HANDLED;
 }
@@ -664,7 +664,7 @@ static int scp_load(struct rproc *rproc, const struct firmware *fw)
 	struct device *dev = scp->dev;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
@@ -679,7 +679,7 @@ static int scp_load(struct rproc *rproc, const struct firmware *fw)
 
 	ret = scp_elf_load_segments(rproc, fw);
 leave:
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return ret;
 }
@@ -690,14 +690,14 @@ static int scp_parse_fw(struct rproc *rproc, const struct firmware *fw)
 	struct device *dev = scp->dev;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
 	}
 
 	ret = scp_ipi_init(scp, fw);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	return ret;
 }
 
@@ -708,7 +708,7 @@ static int scp_start(struct rproc *rproc)
 	struct scp_run *run = &scp->run;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(dev, "failed to enable clocks\n");
 		return ret;
@@ -733,14 +733,14 @@ static int scp_start(struct rproc *rproc)
 		goto stop;
 	}
 
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	dev_info(dev, "SCP is ready. FW version %s\n", run->fw_ver);
 
 	return 0;
 
 stop:
 	scp->data->scp_reset_assert(scp);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 	return ret;
 }
 
@@ -908,7 +908,7 @@ static int scp_stop(struct rproc *rproc)
 	struct mtk_scp *scp = rproc->priv;
 	int ret;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clocks\n");
 		return ret;
@@ -916,12 +916,29 @@ static int scp_stop(struct rproc *rproc)
 
 	scp->data->scp_reset_assert(scp);
 	scp->data->scp_stop(scp);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return 0;
 }
 
+static int scp_prepare(struct rproc *rproc)
+{
+	struct mtk_scp *scp = rproc->priv;
+
+	return clk_prepare(scp->clk);
+}
+
+static int scp_unprepare(struct rproc *rproc)
+{
+	struct mtk_scp *scp = rproc->priv;
+
+	clk_unprepare(scp->clk);
+	return 0;
+}
+
 static const struct rproc_ops scp_ops = {
+	.prepare	= scp_prepare,
+	.unprepare	= scp_unprepare,
 	.start		= scp_start,
 	.stop		= scp_stop,
 	.load		= scp_load,
diff --git a/drivers/remoteproc/mtk_scp_ipi.c b/drivers/remoteproc/mtk_scp_ipi.c
index c068227e251e7..7a37e273b3af8 100644
--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -171,7 +171,7 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 	    WARN_ON(len > scp_sizes->ipi_share_buffer_size) || WARN_ON(!buf))
 		return -EINVAL;
 
-	ret = clk_prepare_enable(scp->clk);
+	ret = clk_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clock\n");
 		return ret;
@@ -211,7 +211,7 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 
 unlock_mutex:
 	mutex_unlock(&scp->send_lock);
-	clk_disable_unprepare(scp->clk);
+	clk_disable(scp->clk);
 
 	return ret;
 }
-- 
2.51.0

