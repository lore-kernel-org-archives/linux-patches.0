Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493213C276E;
	Tue, 21 Jul 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655215; cv=none; b=KMD7IoK6c+WbhqXYeTkwubkvu6qZ9pzfocFWDuo0wNgCs+efhjD4bkurEG1/VzA3KdK970rhK2PIyB+TRPgBSdS2gx/kr4BmgnETd3EE7bsmg48YmTox154qrPdxb7siW7RGOGKknOnEb7+i53xmLvE+PkH/+yM3KH9tP7XNtA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655215; c=relaxed/simple;
	bh=TswKjMyV4E5w473Iu/F5xlqDc7T8MWVYvg07+qTIxbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOQZDdrtiLCzzymO1+1ztnFMCRizqGsWVWbtOQa/7NSWynYcAQ/pbm/MqZqE72UjjhbsxWsY3Q+5HVSGkn3k0LZCmVIawH77Hasg/Xw4eh5CPPtRNYkPZLKC7jnGCldkgcbvRz168wKcndsxZe11CPY0uMS0ZvnU+JhfdH+btwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g82u0U3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g82u0U3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B075E1F000E9;
	Tue, 21 Jul 2026 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655214;
	bh=+KZVIuYIQ4AmBms2t6Paj+6nmFEtvTVc+2Jaet0juYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g82u0U3ksLy5Kv7uOXJ/xSGyDbKqiLRIe/HJK12i2b3e99jq9enAlYgiMcFBR6RJg
	 ertU7LxUHpMl5puDXJFNwcwJ9YhDELUkQEW8rzggRN8DXmPmpIzq0f5wMOXycrKVcZ
	 yJ89VypaBwX3mWopi/2fU3pUXvjnn9xLHpiv58Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2000/2077] mmc: sdhci-esdhc-imx: restore pinctrl before restoring ios timing on resume
Date: Tue, 21 Jul 2026 17:27:53 +0200
Message-ID: <20260721152639.887598628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 1db87818bde3d2295613660879378b43a70d31f8 upstream.

SDIO devices such as WiFi may keep power during suspend, so the MMC
core skips full card re-initialization on resume and directly restores
the host controller's ios timing to match the card. For DDR mode,
pm_runtime_force_resume() sets DDR_EN before the pin configuration is
restored from sleep state.

This is related to the SoC IP integration: switching pinctrl setting
(changing alt from GPIO to USDHC) impacts the internal loopback path.
If pinctrl configures the pad to GPIO function, once DDR_EN is set, the
DLL delay will be fixed based on the GPIO function loopback path. When
the pinctrl is later changed to USDHC function, the internal loopback
path changes, making the original fixed sample point no longer suitable
for the current loopback path. This causes persistent read CRC errors on
subsequent data transfers.

SD/eMMC running in DDR mode are unaffected as they are fully
re-initialized from legacy timing after resume.

Fix this by restoring the pinctrl state based on current timing mode
using esdhc_change_pinstate() before pm_runtime_force_resume(). This
ensures the correct pin configuration (e.g., 100/200MHz for UHS modes)
is applied before DDR_EN is set. Only restore for non-wakeup devices
since wakeup devices kept their active pin state during suspend.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2106,6 +2106,12 @@ static int sdhci_esdhc_resume(struct dev
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
+	if (!device_may_wakeup(dev)) {
+		ret = esdhc_change_pinstate(host, host->timing);
+		if (ret)
+			dev_warn(dev, "Failed to restore pinctrl state\n");
+	}
+
 	pm_runtime_force_resume(dev);
 
 	ret = mmc_gpio_set_cd_wake(host->mmc, false);


