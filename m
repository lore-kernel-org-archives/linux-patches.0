Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69466340DA7;
	Tue, 26 Aug 2025 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207075; cv=none; b=jgp4KTO2wCDzueHtEskIWFDvT/VonDHsl0NEGfGKyBoOUVsQhobYaC8ViDJIALanqPVUbhIfc+RI4ho1WJn8mKHM95Fz0KJV5gTtpRe3fO6hgk4YaZ6ES/BUj9gUXJkGGTol2nUNbZ3B9/LuNp9RsbfOwQJS2bh6GcMFNAyKkhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207075; c=relaxed/simple;
	bh=afrC9Wuga2JXZSBU1X3hvj5L5lZzXzRLuFxCPImkx+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg+C+pQoIMxsPE9cXCWlHy1VOSI6MgN0G5Wmkp0iXQjv0ZNGGMURq9TXWcMh44FQy+d2YTJz68Ugh1CuqW5rASw3k5z9V89Y6HVGSu9zPieR1PAe46vZfZPfJetv88Z1prh0RFKPd0j/+zyZOnEJsTQK6Zuchl/6ABziWzWtHMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwOQ+oNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwOQ+oNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1DCC116B1;
	Tue, 26 Aug 2025 11:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207075;
	bh=afrC9Wuga2JXZSBU1X3hvj5L5lZzXzRLuFxCPImkx+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwOQ+oNTxgWqi9dh+2vqb1pvi8yqy8eBcwROdPaM8vWH7ZpPvis6Ne1B9VTppGVn+
	 KCY5fOGFVbKwaAiHz6ZqMuzjE/7fkfU/aHZkGIKw1n8M2PmN6/xYftl8AftWK32qJl
	 xVzDj9u479hRagF59DwqqrunO5SLgnV3nkygTDTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.16 014/457] usb: dwc3: imx8mp: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:04:58 +0200
Message-ID: <20250826110937.674887010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 086a0e516f7b3844e6328a5c69e2708b66b0ce18 upstream.

Make sure to drop the reference to the dwc3 device taken by
of_find_device_by_node() on probe errors and on driver unbind.

Fixes: 6dd2565989b4 ("usb: dwc3: add imx8mp dwc3 glue layer driver")
Cc: stable@vger.kernel.org	# 5.12
Cc: Li Jun <jun.li@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -244,7 +244,7 @@ static int dwc3_imx8mp_probe(struct plat
 					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
 	if (err) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
-		goto depopulate;
+		goto put_dwc3;
 	}
 
 	device_set_wakeup_capable(dev, true);
@@ -252,6 +252,8 @@ static int dwc3_imx8mp_probe(struct plat
 
 	return 0;
 
+put_dwc3:
+	put_device(&dwc3_imx->dwc3->dev);
 depopulate:
 	of_platform_depopulate(dev);
 remove_swnode:
@@ -265,8 +267,11 @@ disable_rpm:
 
 static void dwc3_imx8mp_remove(struct platform_device *pdev)
 {
+	struct dwc3_imx8mp *dwc3_imx = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
 
+	put_device(&dwc3_imx->dwc3->dev);
+
 	pm_runtime_get_sync(dev);
 	of_platform_depopulate(dev);
 	device_remove_software_node(dev);


