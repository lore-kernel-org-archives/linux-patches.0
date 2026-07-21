Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D83404BE9;
	Tue, 21 Jul 2026 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655321; cv=none; b=eTh0fDIp9vqvewu1SSL8AkwO6r8H7iKF2NCI4kD9SbW8uVbzrWoXXI7cHqLCttyAgdFKG2GWgsKDU9M9ZudUoCxaqrrNRnhD4rctY6f1tM0EoGgmf/BcNXHi9g4Ql7iGOhuasxBqT7fLWKBZFzicrzS553zcpBzUf+eVI0Eg2cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655321; c=relaxed/simple;
	bh=Jpfoh/hHzE96GdMPn7CVRU8SJDaQXabnWim1KBVoY6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiov69N5glMmtKWZO7SRcVDOHLkEhyT5u7MhuhqLWXB/T4T+v2mPwNdQJxDnKY7TaD7aAThC7RmenjCeufvAHrfbhw+ari4qI6slzriUNeUIRX5o/gnYjpY17L6Kr/zqE6RCamljunNmq0UyTB3y9osaq7demrdC3oIUC3VKBLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldv+yonq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldv+yonq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529DE1F000E9;
	Tue, 21 Jul 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655319;
	bh=RBCNQk6nQGwm/joXIn+H0NSHecFTZi2vELz9vz+Ktpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldv+yonqg3KLMR//wDW+Dr/25Np4zswJQEWqIN28juuvwAEYFx1jeNUn2TQ1qj16J
	 6+dFypOet6QON2IW+SYVMny5y3trJuQXEQVdjyUXKpVobtG+X4cxtRRE9rR/cPPXQl
	 exMmbJoljIkM+B3AKLEFgK7FI37/tpF/fFy9E0yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2040/2077] mmc: sdhci-esdhc-imx: disable irq during suspend to fix unhandled interrupt
Date: Tue, 21 Jul 2026 17:28:33 +0200
Message-ID: <20260721152640.814525114@linuxfoundation.org>
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

commit 9d87eaf985cef9581b6ed99b461b38e8cd666480 upstream.

When using WIFI out-of-band wakeup, an "irq xxx: nobody cared" warning
occurs. This happens because the usdhc interrupt is not disabled during
system suspend when device_may_wakeup() returns false.

The sequence of events leading to this issue:
1. System enters suspend without disabling usdhc interrupt
(because device_may_wakeup() returns false for usdhc device)
2. WIFI out-of-band wakeup triggers system resume via GPIO interrupt
3. WIFI sends a Card interrupt before usdhc has fully resumed
4. usdhc is still in runtime suspend state and cannot handle the
interrupt properly
5. The unhandled interrupt triggers "nobody cared" warning

Fix this by unconditionally disabling the usdhc interrupt during suspend
and re-enabling it during resume, regardless of the wakeup capability.
This ensures no interrupts are processed during the suspend/resume
transition.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2077,9 +2077,10 @@ static int sdhci_esdhc_suspend(struct de
 	if (mmc_card_keep_power(host->mmc) && esdhc_is_usdhc(imx_data))
 		sdhc_esdhc_tuning_save(host);
 
+	/* The irqs of imx are not shared. It is safe to disable */
+	disable_irq(host->irq);
+
 	if (device_may_wakeup(dev)) {
-		/* The irqs of imx are not shared. It is safe to disable */
-		disable_irq(host->irq);
 		ret = sdhci_enable_irq_wakeups(host);
 		if (!ret)
 			dev_warn(dev, "Failed to enable irq wakeup\n");
@@ -2130,10 +2131,10 @@ static int sdhci_esdhc_resume(struct dev
 	/* re-initialize hw state in case it's lost in low power mode */
 	sdhci_esdhc_imx_hwinit(host);
 
-	if (host->irq_wake_enabled) {
+	if (host->irq_wake_enabled)
 		sdhci_disable_irq_wakeups(host);
-		enable_irq(host->irq);
-	}
+
+	enable_irq(host->irq);
 
 	/*
 	 * restore the saved tuning delay value for the device which keep


