Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7913A1CE8;
	Wed,  3 Dec 2025 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781106; cv=none; b=tOau1LVPujta/uuw8WEEW8T6HqXGGQE4NPMy+EovvoH6UEwMAO3MUfJuGFGm5NmrlloeDK1bvbFM/1bAfMrCeFlyc6+HXBUam1FiygI4weHH1Nvg93zpsC4MTOAKLp8MXQ1SgE3o3gfTsG7yYhulCbGNTgdjKg7eT2kNjELnGJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781106; c=relaxed/simple;
	bh=yAZJdcT6ccIIto8/d8SW+cR0l6C1KO6RKwgk1NdL2z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/UjFH4oo+sFlcPW/WmBy2SoMDQtnfLA7yzXX81e/7BUPp3FbG17mD5yjw2OHS7fgxGnMM2Ya6AOCKjgno/0fBg9C0t6hfpk/ZtHcSSN4d7qjP88/M6Z51W6l///i30s3C+gMTMYGsPbpJqzMMvhl/QbBiOJ/p8yRi6u5Gz8ziM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xoq1ByLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xoq1ByLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C265C4CEF5;
	Wed,  3 Dec 2025 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781105;
	bh=yAZJdcT6ccIIto8/d8SW+cR0l6C1KO6RKwgk1NdL2z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xoq1ByLzhBs5YdkusLtbbH60zDq0oPli3Y4u6kZDUDnJYmK1vj5e86t33r21RZFjj
	 TGfzmwhkEjwvl5fLih8eWLUqAQJa15Au0Yn0w0imhPQyKb6z0ODnCuZyBsJ8OCfmlz
	 W7qGJXfxou5ZsTypH9o1v9+2CGJ8mOUC+hEvBeNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 49/93] drivers/usb/dwc3: fix PCI parent check
Date: Wed,  3 Dec 2025 16:29:42 +0100
Message-ID: <20251203152338.334332584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
@@ -1990,7 +1991,7 @@ static int dwc3_probe(struct platform_de
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
-	if (!dwc->sysdev_is_parent &&
+	if (!dev_is_pci(dwc->sysdev) &&
 	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
 		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
 		if (ret)


