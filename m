Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E40A47A5D;
	Mon,  1 Apr 2024 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990853; cv=none; b=Y439MRZx7/4k6sSVMfYQelrQyfqpxE3klDhIUg8lSSxvylaadI7Sfs9tl1nNGA4MbXOeyVMijBnbQ9kB5cHNg+F24xoczJeR3CGZ/NnXMZuffxBfPReserUsnQLbk5w0oNDVi3fLNpII84qSS0YOxMGFoRLhrsG79lUodq3lEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990853; c=relaxed/simple;
	bh=8PIhGgsN9LVTLYp5nSfpITLyUXgt0l9MItqtrJfygOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzPRW7eCm0ED78wqDE/a9Mwqqx0kRykXo5v3RwYhIDJGRl7bAXIRXsU40ZOD2m/OkJn4K3HYcb1xt2dcm4yK0Y6kK+sRZ5UsV0Zeq+2bE7okj/C6mDHW7ujmYZZG1EbcEuyNsf++1LfbRAINt83Q4kgDh7NWs5F3JtuXq1ZiSt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjWxiOOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjWxiOOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F995C433C7;
	Mon,  1 Apr 2024 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990853;
	bh=8PIhGgsN9LVTLYp5nSfpITLyUXgt0l9MItqtrJfygOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjWxiOOYq18oIhnhfGvTqSyRFqdzegP1lTvfZ+tyRvnVUKHGP4qc1dE92zbY2nGJ0
	 xp75Tm2pMP2QUgxYChTxRP/79ZbxeyqyoV3lKCiGIlbQu1lyHMget8BgIZ/idbMy3V
	 ZdSg8jcYGtG+bp+Nw0Ka3QAnaUQ5kVNC91G0RNcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/272] usb: xhci: Add error handling in xhci_map_urb_for_dma
Date: Mon,  1 Apr 2024 17:44:07 +0200
Message-ID: <20240401152532.329444736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit be95cc6d71dfd0cba66e3621c65413321b398052 ]

Currently xhci_map_urb_for_dma() creates a temporary buffer and copies
the SG list to the new linear buffer. But if the kzalloc_node() fails,
then the following sg_pcopy_to_buffer() can lead to crash since it
tries to memcpy to NULL pointer.

So return -ENOMEM if kzalloc returns null pointer.

Cc: stable@vger.kernel.org # 5.11
Fixes: 2017a1e58472 ("usb: xhci: Use temporary buffer to consolidate SG")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240229141438.619372-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c02ad4f76bb3c..565aba6b99860 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1334,6 +1334,8 @@ static int xhci_map_temp_buffer(struct usb_hcd *hcd, struct urb *urb)
 
 	temp = kzalloc_node(buf_len, GFP_ATOMIC,
 			    dev_to_node(hcd->self.sysdev));
+	if (!temp)
+		return -ENOMEM;
 
 	if (usb_urb_dir_out(urb))
 		sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-- 
2.43.0



