Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D1F189BB0;
	Tue, 26 Aug 2025 12:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212798; cv=none; b=R8vb4IHT18YDwyVbVnBygfkZR2U5pJ2O2yn3X3YcDaMywtnIWbEaenNMpoB4Qw7/X3YdlKI7LTXPmooZITU/orztdBQtY2tCX0O2vgsPySASBBPdTMSUwrD1dpiNunPfGcV1Qe0AXBb85ENX8LV5vomAiBf88Rwf0TqFgY+7GjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212798; c=relaxed/simple;
	bh=kDG/sa+DE7tO8eIa/zrzCzzJlAcHu8knYt9U+rV462A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxBCLorOIibQ0D2PIRbRwl48RbGIG4KNvSjDx0X26jVYMDkFtbAGJ2AJQkwwOgcbwyBtGnH3bbmtHloyz5ByY7sKlsnhmlHcB6fOLTTUF+lhurLQpF0W/DvgNN9vG7BMeYeg03N6Dbd/bHOA3DeikZ4TTZjruzLDvxDq2mDyYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiFw/un/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiFw/un/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2A3C4CEF1;
	Tue, 26 Aug 2025 12:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212798;
	bh=kDG/sa+DE7tO8eIa/zrzCzzJlAcHu8knYt9U+rV462A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiFw/un/Z/rzluaoGlcCxYqt3g2h94POAAEhns9mkyu6f3uB1s4MG2SRi2dhdXu2n
	 QoXHPkAAbeldtRZ5HNtZD9DYT/8vVa3KRI3kARGTbrxUyYym0w5gZKU1WKmSWY6iqE
	 YqG3SKdQrJxvrJdoIm9vdDAeaBHGH0VX887SS5wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Chen <shawn2000100@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/587] usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command
Date: Tue, 26 Aug 2025 13:03:58 +0200
Message-ID: <20250826110955.197618926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cceb69d4f61e..b51464eeac46 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1182,6 +1182,8 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 	ep0_ctx->deq = cpu_to_le64(dev->eps[0].ring->first_seg->dma |
 				   dev->eps[0].ring->cycle_state);
 
+	ep0_ctx->tx_info = cpu_to_le32(EP_AVG_TRB_LENGTH(8));
+
 	trace_xhci_setup_addressable_virt_device(dev);
 
 	/* Steps 7 and 8 were done in xhci_alloc_virt_device() */
-- 
2.39.5



