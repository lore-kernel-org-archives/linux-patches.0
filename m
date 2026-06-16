Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1563CEBBD;
	Tue, 16 Jun 2026 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636259; cv=none; b=Sn2PPu670XSoRyBaH+/YFGrBU2o26/a4f4xYo3hP/4H6BJeM5N4YpP4x92mmlj2RCy6onLpSDeK4ml8ivUh2KT3T8WeHLcaTA9hTIi/fRuzUay/MD5hhDrZcYIP0orddvP1i1z5l84BbSz0mvzIplYRRog8ErfEAlzIC6z+hGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636259; c=relaxed/simple;
	bh=oOzCkgKYgj6TCIScV5m+ej3kTFF5CcCLYxOJ/+4pq84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F68GMt1g9k0YXsbB7RCJOYPlXc+gsPJ06eL+psALAcvZ3iN4VrRBVZIWcaVd8DHB21Ek1IncN/EDz3InTLhq1yVA6Z+ysxnr2AfCn7nSOO3bjbg7+amojyLwH4iJ27s0PEk/F22v6yQbJynE2yXTqlXIbr9TZwkB0KEU8++oC9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoX5y2ke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoX5y2ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41031F000E9;
	Tue, 16 Jun 2026 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636257;
	bh=uEndllCSgNh8aeop4dXKhAonfkCUPHJbfEt7Gpq4gP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoX5y2keXVO3AKCY+AnaRYiGsTcY4KSwhAJEkjRdoOceZY4QGaA6vLCbiMWHk+Zvb
	 s0jJs+wMuPu3LDYoHoyuXEaDa1+AQoF3ymMblcO/Z5Nebl3Gk0CUekWhjwZmiih8Q3
	 A8nmLovSLeE3q9jAAZ0RuDRN/cb/FVoMQhGA28Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 204/342] mmc: sdhci: add signal voltage switch in sdhci_resume_host
Date: Tue, 16 Jun 2026 20:28:20 +0530
Message-ID: <20260616145057.681360258@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit f595e8e77a51eee35e331f69321766593a845ef2 upstream.

I met one suspend/resume issue with sdr104 capable sdio wifi card (with
"keep-power-in-suspend" set in DT property):
After resuming from suspend to ram, the sdio wifi card stops working.
Further debug shows that although ios shows the sdio card is at sdr104
mode, the voltage is still at 3V3. This is due to missing the calling
of ->start_signal_voltage_switch() in sdhci_resume_host().

Fix this issue by adding ->start_signal_voltage_switch() in
sdhci_resume_host(). This also matches what we do for
sdhci_runtime_resume_host().

Then the question is: why this issue hasn't reported and fixed for so
long time. IMHO, several reasons: Some host controllers just kick off
the runtime resume for system resume, so they benefit from the well
supported runtime pm code; Some platforms just use the old sdio wifi
card which doesn't need signal voltage switch at all, the default
voltage is 3v3 after resuming.

Fixes: 6308d2905bd3 ("mmc: sdhci: add quirk for keeping card power during suspend")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3756,6 +3756,7 @@ int sdhci_resume_host(struct sdhci_host
 		host->pwr = 0;
 		host->clock = 0;
 		host->reinit_uhs = true;
+		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));


