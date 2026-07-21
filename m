Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D702DF3EA;
	Tue, 21 Jul 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659424; cv=none; b=MAwHyO1x4zqK9AroyDgZep91E3fdqDjL9IdfIE4XvngkjAPPIMv2M0U27KzxezJijJK0pL0ofqril8VbPJf3mU8hi+HGYnqeCinGh8XQqWjNGis7joNoc2ELzPlJcJ6cEfqFWAsZgE/+AlyMLyPyGAQR/hszqXf3G66c+3GkypM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659424; c=relaxed/simple;
	bh=icFDhjLDEdDAHR4TC/i3dGW3ol6m13DtU0PIj/KrxFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXA9r/6IReWIN1ZQZ2mu5+kVGGuXtRTn5MOvcLPKJuW+j2b/H/2fR0snrZs5UutnqMSYJbw4oqGdRJcfIgtfibpduHeXlezOdStQbKI8y56YyjzqF1yJ80IXSUWTZWSyPQK3RApQ9sL8/7R8SjbqnWyob+jxieJfyM+h34hycH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSwznOPS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSwznOPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABAB1F000E9;
	Tue, 21 Jul 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659422;
	bh=RKuDh+KERWjn6nyUDQDOJZnM3NiGkAcpQNIac4zws+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSwznOPS2UELkFX5pnar5jNV6v0CCRmOxg7UKaLD3agMYV1XVsZvpHFeenhWlUi+W
	 aWIhJ/TlwpGx9s+NqC1TcZGonenMGgK0vZno7z1VLBAPyNaBlCNH6zF+5PWlFHuIXy
	 k4npN40ds6NoycKPKALfgMvEvtXplU2CatP8ItuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1514/1611] mmc: sdhci-esdhc-imx: fix resume error handling
Date: Tue, 21 Jul 2026 17:27:10 +0200
Message-ID: <20260721152549.497661428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Luke Wang <ziniu.wang_1@nxp.com>

commit e27c946b589c53520409a0956b33d52ef7a0898f upstream.

Check pm_runtime_force_resume() return value in resume. If it fails
(clock enable failure), return immediately since accessing hardware
registers on an unclocked device would cause a kernel panic.

The early return intentionally skips enable_irq() and
sdhci_disable_irq_wakeups() because the IRQ handler reads
SDHCI_INT_STATUS, which would also fault without clocks. The PM runtime
usage counter leak only affects this already-broken device instance and
is an acceptable tradeoff to preserve system stability.

Remove the return value check for mmc_gpio_set_cd_wake(host->mmc, false)
since disable_irq_wake() called internally always returns 0.

Also return 0 explicitly on the success path instead of propagating
stale return values.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2100,12 +2100,12 @@ static int sdhci_esdhc_resume(struct dev
 			dev_warn(dev, "Failed to restore pinctrl state\n");
 	}
 
-	pm_runtime_force_resume(dev);
-
-	ret = mmc_gpio_set_cd_wake(host->mmc, false);
+	ret = pm_runtime_force_resume(dev);
 	if (ret)
 		return ret;
 
+	mmc_gpio_set_cd_wake(host->mmc, false);
+
 	/* re-initialize hw state in case it's lost in low power mode */
 	sdhci_esdhc_imx_hwinit(host);
 
@@ -2132,7 +2132,7 @@ static int sdhci_esdhc_resume(struct dev
 
 	pm_runtime_put_autosuspend(dev);
 
-	return ret;
+	return 0;
 }
 
 static int sdhci_esdhc_runtime_suspend(struct device *dev)


