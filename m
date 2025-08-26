Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CDB3568FB;
	Tue, 26 Aug 2025 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217658; cv=none; b=UzQGfZiTBmvEr9SU7Ao1pMjKLKtQyFEXFp1h9igRk6VmpSQRO9Rm4NhNWUu+bO6saxInkeh9dY0/PHfN6+MSahRDDrzO6r0o/CqOxT59V8n79s5etvRR+KzjYL6i/KWRG74u51xaTEf1vRhEFxeA0m0doRtQG2PUtOFDUHmQmx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217658; c=relaxed/simple;
	bh=O1gZ+fzGBuAZOB+xDW7cHcDN0tmZ4hsjVZEyBhVM1OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuXfVECRmIfx9lutRpvp1+h4UblS0IUCimujQTRVqrgPcsvtahBCsnNrMzrLuByBH7Ch7SftbmLKjGLXdCHAMf5LWhzVvtfjcOutADBLwSRZrJuIlyof2y1lWd1b2D+D0IdBaENNe6q4pen6H08hCVLlmqTHYTIQjk3ySm13N0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvnzIRWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvnzIRWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4EAC113CF;
	Tue, 26 Aug 2025 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217658;
	bh=O1gZ+fzGBuAZOB+xDW7cHcDN0tmZ4hsjVZEyBhVM1OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvnzIRWgl0lNdfdq5t2CBeayJ/vs2h2k3MaZhEOgfGnAooVDfWau+3JBBca9RBUAB
	 hFAzhV7pdHAiZE/TTkSzkowEdmFk2msVrh87/iBZo1+VwUkwT+TK1J0TYQqUuy+hx1
	 LE3UnCxcVOGQWGV/rlUOAn9K5dVRi1/sycPJPyEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Chen <shawn2000100@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/523] usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command
Date: Tue, 26 Aug 2025 13:07:16 +0200
Message-ID: <20250826110930.034753264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Chen <shawn2000100@gmail.com>

[ Upstream commit f72b9aa821a2bfe4b6dfec4be19f264d0673b008 ]

There is a subtle contradiction between sections of the xHCI 1.2 spec
regarding the initialization of Input Endpoint Context fields. Section
4.8.2 ("Endpoint Context Initialization") states that all fields should
be initialized to 0. However, Section 6.2.3 ("Endpoint Context", p.453)
specifies that the Average TRB Length (avg_trb_len) field shall be
greater than 0, and explicitly notes (p.454): "Software shall set
Average TRB Length to '8' for control endpoints."

Strictly setting all fields to 0 during initialization conflicts with
the specific recommendation for control endpoints. In practice, setting
avg_trb_len = 0 is not meaningful for the hardware/firmware, as the
value is used for bandwidth calculation.

Motivation: Our company is developing a custom Virtual xHC hardware
platform that strictly follows the xHCI spec and its recommendations.
During validation, we observed that enumeration fails and a parameter
error (TRB Completion Code = 5) is reported if avg_trb_len for EP0 is
not set to 8 as recommended by Section 6.2.3. This demonstrates the
importance of assigning a meaningful, non-zero value to avg_trb_len,
even in virtualized or emulated environments.

This patch explicitly sets avg_trb_len to 8 for EP0 in
xhci_setup_addressable_virt_dev(), as recommended in Section 6.2.3, to
prevent potential issues with xHCI host controllers that enforce the
spec strictly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220033
Signed-off-by: Jay Chen <shawn2000100@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5b0e00978322..1874a81d9766 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1227,6 +1227,8 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 	ep0_ctx->deq = cpu_to_le64(dev->eps[0].ring->first_seg->dma |
 				   dev->eps[0].ring->cycle_state);
 
+	ep0_ctx->tx_info = cpu_to_le32(EP_AVG_TRB_LENGTH(8));
+
 	trace_xhci_setup_addressable_virt_device(dev);
 
 	/* Steps 7 and 8 were done in xhci_alloc_virt_device() */
-- 
2.39.5



