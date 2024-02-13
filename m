Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0B95FF04;
	Tue, 13 Feb 2024 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845591; cv=none; b=PQNwXBazF08GaLV89BfbAU6y1A8GK3XNCqmLVb2Asy9v5SOgWBnbtJ8/6VYIO4oUgy258xMrSBm9LFDj6Pdiuxx1lbFZlmm+k9q5/cmc9BFR8a9GQxpTf81iwgKHNpbPeW9isUSUmX9eZcxfMLQ/qmsUdbMP2tJxy7Z1jKuZBso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845591; c=relaxed/simple;
	bh=SX7GKlUDEDbyUUXVyjog9104dzpq4lAoVm3N5XYcI/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmLQ3dyXSlGVZgNp2dXc5sLLz6fY/kKdCRq0ZbFH+57zREjoLklZTuIZOp3SA4lC0rAX6WSE3Qo5xfjVIDVOvm2EUJfYVCUejP1zmRymTZECHV/P7WKXwx24Zz1mbGKmf+udiLVIPg4SgA2Q81eQ6nCs8MmkzY3HjtgNUrZcK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul/7n9Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul/7n9Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D44C433F1;
	Tue, 13 Feb 2024 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845590;
	bh=SX7GKlUDEDbyUUXVyjog9104dzpq4lAoVm3N5XYcI/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul/7n9LrxuAKbRXv1TGpeMbyNqDRaUw8hRAEp/T7xAjTDFZm84RdqF1t4VZyQJSNT
	 OT9hXq+OwMTc+D5PzxB1UN8/6y0ZoY6guwN2C1BODugNB4DPI8UCRwcaZvbKh5gwF5
	 y9PtOmNN4r/B+X1jF8kJuD5hgR0PmPNioy0CWG3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.6 108/121] usb: host: xhci-plat: Add support for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Tue, 13 Feb 2024 18:21:57 +0100
Message-ID: <20240213171856.145205652@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 520b391e3e813c1dd142d1eebb3ccfa6d08c3995 upstream.

Upstream commit bac1ec551434 ("usb: xhci: Set quirk for
XHCI_SG_TRB_CACHE_SIZE_QUIRK") introduced a new quirk in XHCI
which fixes XHC timeout, which was seen on synopsys XHCs while
using SG buffers. Currently this quirk can only be set using
xhci private data. But there are some drivers like dwc3/host.c
which adds adds quirks using software node for xhci device.
Hence set this xhci quirk by iterating over device properties.

Cc: stable@vger.kernel.org # 5.11
Fixes: bac1ec551434 ("usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20240116055816.1169821-3-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -250,6 +250,9 @@ int xhci_plat_probe(struct platform_devi
 		if (device_property_read_bool(tmpdev, "quirk-broken-port-ped"))
 			xhci->quirks |= XHCI_BROKEN_PORT_PED;
 
+		if (device_property_read_bool(tmpdev, "xhci-sg-trb-cache-size-quirk"))
+			xhci->quirks |= XHCI_SG_TRB_CACHE_SIZE_QUIRK;
+
 		device_property_read_u32(tmpdev, "imod-interval-ns",
 					 &xhci->imod_interval);
 	}


