Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04939061C;
	Tue, 13 Oct 2026 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895807; cv=none; b=t3lIAurB7RdYT/ZdjBptlIk4WBURchV97326GPBPU5HBHxyATZoZ29mnB6TCdgBQ0AxE1aFZMjTWBba5uh0bH9WDfysUe1K2bF3eX+5vci55rNj3EouIHCJQJdmdKeQSntpCfgeNLS989P8MMNlatX1XU6tp2eZC011aVbBBRdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895807; c=relaxed/simple;
	bh=Z58djFKWXgijko+Qv0VWfWAMqsJy+ZcB1rB/5mSTEh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8ewA+9+wmjkDRlWaglBys3MVb6viCXSOlzDgdafKNGgDvAuUpculhgVHEb5GzyLMKS72aS70Johw8ZgL8nFhY811fbDIoZUHXQVyVXQd7gfdm8dV2N5JfGywSeStFdP/iQjNjJ4TzWhCsPKLOgGWZJaM/tun0YRFdq0x/BVgiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ht60TER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ht60TER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B253F1F0089A;
	Tue, 13 Oct 2026 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895806;
	bh=/gCGVNJ8aNMe0mIHZkUWgX3R7dsN+vSEcSXxstMjPCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ht60TER2XAk5zuTVFsfw/7WYSH7PJYqo5uXzU1IFTCD0FmG55Ap9w/Ypogi5aoah
	 FIQfcn/Fh14qqsitpkvmhA466E3Mb0SwEI4xIUngaPmHVuGBLox5kh4aC/o0+ZDHjH
	 MFjdJyghO7tMjLPuDI+w1XeKyL1emOPr9oFtxamk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 398/497] mmc: sdhci-sprd: disable runtime PM on remove
Date: Tue, 13 Oct 2026 13:39:25 +0200
Message-ID: <20261013112917.338003628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e1c6c10a6a70a69e29b04fcc1ebe4b9bcbc7a49a upstream.

sdhci_sprd_probe() enables runtime PM, while sdhci_sprd_remove() does
not perform the corresponding runtime PM cleanup.

The probe failure path disables runtime PM before disabling the clocks,
but the normal remove path directly disables clocks that are also
managed by the runtime PM callbacks. If the device is runtime
suspended, those clocks may already be disabled.

Resume the device before removal, disable runtime PM and drop the
temporary runtime PM reference before disabling the clocks.

This issue was found by manual code inspection.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -902,6 +902,10 @@ static void sdhci_sprd_remove(struct pla
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
 
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(sprd_host->clk_sdio);


