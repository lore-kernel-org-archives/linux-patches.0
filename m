Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9403536C0C1;
	Wed,  3 Dec 2025 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780370; cv=none; b=IXDYJv5DnZ+8ZCuk/maBcIicRWf39X3+lynu0XHyOgLnI306QB7A4aph8E0vTQ1q1iZ+q6ylT95I60FQhHSR6Bi927PxZLGndpbZMmZPtU0Brp8uR43p596krXTXGq2WFjU4GVY2rWNleQH3rtrHQAX2HNHhEJq9+tHTx3ACsvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780370; c=relaxed/simple;
	bh=RPSKY+KASsd2AWnGBQJkHr35dzLAs5thiHEeGd+p0Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3ojktPrGsdap6rtn4FeG1d37OhYh2+bl2vS/DjnJU2PKc2kpjQEluCEMcEKubCa7FBz+RLsQx/Lsy/VteFV5ix313evuqiQ5ZkXlGf5y6e3Hz9VdGx9DBetPg9emxGnpCrxdeIDOTC9FZSPoPESUZq2IkqwGbn6ccC5Ann/s34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV8148/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV8148/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8241C4CEF5;
	Wed,  3 Dec 2025 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780370;
	bh=RPSKY+KASsd2AWnGBQJkHr35dzLAs5thiHEeGd+p0Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV8148/71s5r6POtY7idC682dHref2LB6lP8Aw8KRxYkZBgbMGG8yp2cbtqkxYMmy
	 hxiesbevbTG/zB1sT0g8et6TPGE3osyP1uMZ/8FYHF73npGZ6LQNkAWOhqPn+hzNZf
	 3STG3xyh8xG0h9Cr+w2WFc34bP9fR+EZjCVqLS7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 529/568] drivers/usb/dwc3: fix PCI parent check
Date: Wed,  3 Dec 2025 16:28:51 +0100
Message-ID: <20251203152500.090201704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 #include <linux/reset.h>
 #include <linux/bitfield.h>
@@ -1996,7 +1997,7 @@ static int dwc3_probe(struct platform_de
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
-	if (!dwc->sysdev_is_parent &&
+	if (!dev_is_pci(dwc->sysdev) &&
 	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
 		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
 		if (ret)


