Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF133BBA0B;
	Sat, 17 Oct 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257252; cv=none; b=bwV8BDOa4gXTJs9Mef3WBgiONc+1lOyA3J3JEB2CQIOKWffAMd4Ie1sVpeEPDO/mucU0GN9RPaJz+Gn0Djoo+nm/0bLwkqltowKmO0k/eNgVnfpo7vZsQd//QWfxb96ClMu+FxSKPHiQuqSs+RQ82I6OG3up4pv7B/tb7mlCuUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257252; c=relaxed/simple;
	bh=LSstxXYfEFvkplx/DLWRj+acl55OEw+92hteRqBPca4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8FaLKTZUbmRNQlOImuOP6E2f9Kq9lvE4wvuy3odNgw2p93CSZqJwYIF1i1O3WCyMh8OE/W3NEGvJC3lw36iRP9jwl10pzXyZmSAqLLeOOp3cL76WUp2kjdGkoZZLN4GP8Zl/r7Lajml3bbT8haHZn6wZCHKnGiOxUP2uT1fu6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvv2KSVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvv2KSVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A9F1F000C5;
	Sat, 17 Oct 2026 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257251;
	bh=wyo4rtiVxELUapuboExMpWVFhubmyHa+m9RZAm/GKvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvv2KSVlJpn4UcNShWc6SzVAwAVksQ2xSIk6AP5pI8rkDcn9w8/kcGNgpHtmg7O5g
	 Onqq1+TviInRnWMGAmtF0dxjsUCxYYLWm3d0fQSVa+calIqoQ95YM7p9pX1yeCfrW1
	 zYaZlwXG5ejrPAKvs9OxU593aKjNMxoVV5HPsBYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0500/1674] mmc: sdhci-sprd: disable runtime PM on remove
Date: Sat, 17 Oct 2026 17:46:12 +0200
Message-ID: <20261017160443.947379106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -903,6 +903,10 @@ static void sdhci_sprd_remove(struct pla
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
 
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(sprd_host->clk_sdio);


