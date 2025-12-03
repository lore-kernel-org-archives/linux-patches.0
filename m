Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7643AA184;
	Wed,  3 Dec 2025 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780740; cv=none; b=VuzuuqDWgdgze6g2niiJSrXlKXCNCO8wMaweIKYPvvwKKcQmZR+99W6fJ/5GVlPzXBs3eGH+GTu4QFtgCztrsSVYgUSDCEro8Nzf8LkYLvsfENOOGMjzTHHoiCUuQJuB6p35jd1KVP+hjZONMBBDBgjf9awgaPw8zDKJPjJ30fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780740; c=relaxed/simple;
	bh=zzkXWMWvOsYDw9EcxZ2Dci2xioM56x7RnlEe07pJp38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtodIbeukbbODDAJ1I7HnCPWOpRwtf3RtImUl7fGAJzSkodTIb8l7DVSeWhigNGNgkQAohxwj0fl0aLYbSlV7VA3h6oNLFK5spLqtKraTRXI1XIR1R2hQnq8faaEOgp7Ojym9ioVIwfLPNu4EuH2roTtjFa/JXMyJX3+TOUaZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thp02hqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thp02hqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C25C116C6;
	Wed,  3 Dec 2025 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780740;
	bh=zzkXWMWvOsYDw9EcxZ2Dci2xioM56x7RnlEe07pJp38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thp02hqhSd/4bJM9pvFyDdJeM64q3eigeoFecuViwgDHkNLu3A7HTavq8F/ZtEwMP
	 x5aRgnC1SN/pwz17UNQTFSXySW+QF5n+4FGkoci6RA6X7CFRnrvy28sXZ5bXC7ChVT
	 TP++oLi4AXtZC9PefPqe9Dka/FM6I0hSxMUkEfew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jamie Iles <jamie.iles@oss.qualcomm.com>,
	Punit Agrawal <punit.agrawal@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 076/132] drivers/usb/dwc3: fix PCI parent check
Date: Wed,  3 Dec 2025 16:29:15 +0100
Message-ID: <20251203152346.109172725@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
@@ -2211,7 +2212,7 @@ static int dwc3_probe(struct platform_de
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
-	if (!dwc->sysdev_is_parent &&
+	if (!dev_is_pci(dwc->sysdev) &&
 	    DWC3_GHWPARAMS0_AWIDTH(dwc->hwparams.hwparams0) == 64) {
 		ret = dma_set_mask_and_coherent(dwc->sysdev, DMA_BIT_MASK(64));
 		if (ret)


