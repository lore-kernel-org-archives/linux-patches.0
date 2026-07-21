Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F23F12CE;
	Tue, 21 Jul 2026 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655323; cv=none; b=uZMvBYfl4ePvZ6LTVg78+KVe2UxY4nZe+XAKBQa0MIF3+7QjHFCAaOygbciDNv7+Q8LWUxoiJPC1V+jEi9Df25qNcuS8J532p2J1VKnwQxFGBWm6FUV9TanY4RTjEW2bciJaKvfubY0i3rxRc5H9rSS66PiJW148vmK9g3gj8eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655323; c=relaxed/simple;
	bh=LGg9vqs5RtO16llRwa02Cxm9kWD3GwIof8SBaUfHnnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaIRvcYKa4TJcMLY7x5/GuPhid3JP73++gxCNPa2Tqc4ndSW4tArt8BeVUD2BhdWDIg1LRPJFZmrN/gTjeAhyr4ecqBPA7+lOYEByq0Ntuas3hmeSwMpMEUPTTLrqbqX6szb6qquI/tXbpMr64Y08sUfmiOPhhQ7jrXscEEXq74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAeova58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAeova58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EFE1F000E9;
	Tue, 21 Jul 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655322;
	bh=+8zlnfzMNSfzCNrCgi4lczBj4Khgyw+xGn/L/jG/aOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dAeova58hFcNCNPoFIIuy14PSt+uoBQPMy+PwHxZfrdbGSb0WmeNSpb+xBWaRLqAX
	 3egiRIHWDS+JuetNKy5eRHJKP2zUxuwH7Oi1Uzv094mxFDRNiz/mreq2VSeEyhOmmC
	 Z43w6vJOIdFCrApVeFYMMMyakKrpB+kouMATfNkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2041/2077] mmc: sdhci-esdhc-imx: use pm_runtime_resume_and_get() in suspend
Date: Tue, 21 Jul 2026 17:28:34 +0200
Message-ID: <20260721152640.837886856@linuxfoundation.org>
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

commit 8da5930144712412d85e7f868693d96ec5c2018c upstream.

Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() to
simplify error handling. pm_runtime_resume_and_get() automatically
drops the usage counter on failure, avoiding the need for a separate
pm_runtime_put_noidle() call. If it fails, the device is unclocked and
accessing hardware registers would cause a kernel panic, so return the
error immediately.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2061,7 +2061,9 @@ static int sdhci_esdhc_suspend(struct de
 	 * 2, make sure the pm_runtime_force_resume() in sdhci_esdhc_resume() really
 	 *    invoke its ->runtime_resume callback (needs_force_resume = 1).
 	 */
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
 
 	if ((imx_data->socdata->flags & ESDHC_FLAG_STATE_LOST_IN_LPMODE) &&
 		(host->tuning_mode != SDHCI_TUNING_MODE_1)) {


