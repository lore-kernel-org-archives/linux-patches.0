Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AB65FF17;
	Tue, 13 Feb 2024 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845921; cv=none; b=cPKMTdq+z0Dwz41hMcLRjehSXJ3hfp4v91WWmC1EcXC0660vnfKR4wZdHx+1qqL48l/943Qa+JNhJ4uMqKI2k7Ua5KhnmqpIvfo/S3l6GNC9b/vvhcDTxSOtDu7Nx41lDujC9VQnyl6XrHnEs1X1GVdXp9ySN2ZTmBFWj7rkI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845921; c=relaxed/simple;
	bh=Lh5LXjp9ZtuKgVFdKFwmnZIzyY8nVQwsvRHy5SsW+dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfYeJqmpjbjH/S18/kNzJcQ+FWbO6T5/M/kMfXgxavPrOPwIqgd+de/BZQKCwfn9GMT6SJDY5PygX1N/2PPtpYLwNk7wePCNa79kbfJrNcq7njebiPnrTvmynB2fy3V+3+qnHmugiuVcIYqr7PBgnDbn2xXzHusHd6eJbx9Awso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+vkLXyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+vkLXyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AACDC433C7;
	Tue, 13 Feb 2024 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845921;
	bh=Lh5LXjp9ZtuKgVFdKFwmnZIzyY8nVQwsvRHy5SsW+dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+vkLXyTCq5PkDad85JLhyH8T01ZNCK2FDXIQXr1/xem2OeEQjUrqNkcyyHpbK6X5
	 DzEgLaqPmGteIn+5maFEDr5VpsOMiH2z8AD0GA9fxa6W/SEGGgdgcoBg3xh1vPlecx
	 MnyWJI0ppNmg67fnkXDU6DcotgDhxNfE3Bm9CwJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.7 097/124] usb: host: xhci-plat: Add support for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date: Tue, 13 Feb 2024 18:21:59 +0100
Message-ID: <20240213171856.563949676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


