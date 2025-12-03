Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B3632FA07;
	Wed,  3 Dec 2025 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777121; cv=none; b=dpfkhhOWFc0Dn85GNFOyf1ttD5Tmp5GhH81gHow6Z/ngFy4Ht782nsqljISXTCrs0DYi9RMk2uJvjOJVezJTl13cURMbfLWQIfAky2ILxKwBmzJx7qvJL0EDIsTDt/8FN3If6gl2WS9SUXuZPnppZePWhqUCkjhkRsni/Tfmc2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777121; c=relaxed/simple;
	bh=sewMsT8afD43yHMPyaC2SV2OYXP/YRTZtLdoCQcoWSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9DShdXVbRmDB1xgAzCLfSKYA3mFvSS22+7n5TQk6YxD4xNkaerpbm7QYZpj/Yu6UZ761xfUFqN5YwQZvZGraR2XLcbIFxitPxUi+Z9iU7tqrwKV3AkkZyod1/S3Bzk4r9q5xr+Uog6S+2Xyha8SpePv7fgO494qSDqhzQ0OOsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IECcEOua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IECcEOua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2129EC4CEF5;
	Wed,  3 Dec 2025 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777121;
	bh=sewMsT8afD43yHMPyaC2SV2OYXP/YRTZtLdoCQcoWSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IECcEOua/wYBXy9q9H7vUs0MylZqAmza65o1kjGp4le1iylr2Z8igJ5vJF9xr+fkI
	 Wxqc5JJlG9Etx9addTkgDibSzVZQULY9Jxue2KXGI49IsAJvX9Q2lOtb83rfJbaMtl
	 6ND41s8YqOe1A2FNp8n1mw+wyIQPzyO2u8v26E+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.17 089/146] drivers/usb/dwc3: fix PCI parent check
Date: Wed,  3 Dec 2025 16:27:47 +0100
Message-ID: <20251203152349.717779739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <jamie.iles@oss.qualcomm.com>

commit 40f8d17eed7533ed2bbb5e3cc680049b19411b2e upstream.

The sysdev_is_parent check was being used to infer PCI devices that have
the DMA mask set from the PCI capabilities, but sysdev_is_parent is also
used for non-PCI ACPI devices in which case the DMA mask would be the
bus default or as set by the _DMA method.

Without this fix the DMA mask would default to 32-bits and so allocation
would fail if there was no DRAM below 4GB.

Fixes: 47ce45906ca9 ("usb: dwc3: leave default DMA for PCI devices")
Cc: stable <stable@kernel.org>
Signed-off-by: Jamie Iles <jamie.iles@oss.qualcomm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251107104437.1602509-1-punit.agrawal@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -25,6 +25,7 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/acpi.h>
+#include <linux/pci.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/devinfo.h>
 #include <linux/reset.h>
@@ -2240,7 +2241,7 @@ int dwc3_core_probe(const struct dwc3_pr
 	dev_set_drvdata(dev, dwc);
 	dwc3_cache_hwparams(dwc);
 
-	if (!dwc->sysdev_is_parent &&
+	if (!dev_is_pci(dwc->sysdev) &&
 	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
 		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
 		if (ret)


