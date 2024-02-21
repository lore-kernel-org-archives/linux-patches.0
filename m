Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71EE78B73;
	Wed, 21 Feb 2024 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523185; cv=none; b=d4pCzJ+5h0fiuaOIhZraInyMLYX9LloyxXUkggoqE+lj+NRzW447X1wd415Hmszcbt/zONWjQimhUAOaDE5Id1m+YjdLeiyVbg6r9DFxwNVSNwm403Z5OclXArj4DeguRraiCzj6iKWFiQj3/BysiWEeTAl5naAS6R0apt1sQiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523185; c=relaxed/simple;
	bh=YSwQOEQuvKjH7s+WkqZvv2rSEmar/QdjY1sw/FLyDDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPWRcP1RimG0x34Dke3bAOJ+5XP8XWTywbRgXtmloKaKbYpCXNYS2Vrp1VYdpwX5R8S3afcdfhf6L5AmVJ1OsBjHDiu9Z4CQ1aytcwKBnpJIIXyUuXoYpF4hwFmXFqPm9vkojGZs8ATacnnqf0ODroJG1x/LOMqoJzwzlPKSSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5avRxNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5avRxNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFBBC433C7;
	Wed, 21 Feb 2024 13:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523184;
	bh=YSwQOEQuvKjH7s+WkqZvv2rSEmar/QdjY1sw/FLyDDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5avRxNRNOOLmnDjr+zme8mnx2GY/SyQHUN1ZNBoCoPnw9d42pX2tODAJRPQ+KYWr
	 BjEW/OPkV/h0yHTbmPmftWH6HgxPEcQExglwBa/iqojAhv5GNp6uUTnl+1CrWVNkfq
	 RYuqgu0dz11p2IzZPztpJ/L+p9oEr0EJmJQJpybs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 334/476] usb: dwc3: host: Set XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Wed, 21 Feb 2024 14:06:25 +0100
Message-ID: <20240221130020.356018322@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 817349b6d26aadd8b38283a05ce0bab106b4c765 upstream.

Upstream commit bac1ec551434 ("usb: xhci: Set quirk for
XHCI_SG_TRB_CACHE_SIZE_QUIRK") introduced a new quirk in XHCI
which fixes XHC timeout, which was seen on synopsys XHCs while
using SG buffers. But the support for this quirk isn't present
in the DWC3 layer.

We will encounter this XHCI timeout/hung issue if we run iperf
loopback tests using RTL8156 ethernet adaptor on DWC3 targets
with scatter-gather enabled. This gets resolved after enabling
the XHCI_SG_TRB_CACHE_SIZE_QUIRK. This patch enables it using
the xhci device property since its needed for DWC3 controller.

In Synopsys DWC3 databook,
Table 9-3: xHCI Debug Capability Limitations
Chained TRBs greater than TRB cache size: The debug capability
driver must not create a multi-TRB TD that describes smaller
than a 1K packet that spreads across 8 or more TRBs on either
the IN TR or the OUT TR.

Cc: stable@vger.kernel.org #5.11
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240116055816.1169821-2-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/host.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -44,7 +44,7 @@ out:
 
 int dwc3_host_init(struct dwc3 *dwc)
 {
-	struct property_entry	props[4];
+	struct property_entry	props[5];
 	struct platform_device	*xhci;
 	int			ret, irq;
 	struct resource		*res;
@@ -89,6 +89,8 @@ int dwc3_host_init(struct dwc3 *dwc)
 
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
+	props[prop_idx++] = PROPERTY_ENTRY_BOOL("xhci-sg-trb-cache-size-quirk");
+
 	if (dwc->usb3_lpm_capable)
 		props[prop_idx++] = PROPERTY_ENTRY_BOOL("usb3-lpm-capable");
 


