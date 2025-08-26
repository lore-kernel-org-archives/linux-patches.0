Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77659340D95;
	Tue, 26 Aug 2025 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218938; cv=none; b=S2BUJaQRMbQK6EUgyOnAG77212wu3EuHa8wYLyYFi8v23CnZIOKSKPMMoW80a6RwEUaoT+VxpyJcQ4uR6TlfjX5h165qupO88WGNTCHZmx+G35J3/CsOQtHnBnHWKim6IDj/Tv2pdFMO5fYAyj08gaI7zVIsYyaNDiYWPpMee9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218938; c=relaxed/simple;
	bh=+9S+PWmrsNh7sKkaXRNFxJ0Om2TJowp0URN5nLcYc3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNr9UXASRJRBpNZr++Osr2NtdzWRQ10bI4KLOOUkmpD0OB9ssEKVsOX+NwnCr2DgKpul1+tk5dJ9hVphIQ5FcBXFyS+73/MC27Q8ZQvFEhDa8gMvejrNiM8sWqvxQjHRzc9WJHVM27WQ2bS9td46bwXR/ET3U3+jG0rJMokrHlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOD3J5cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOD3J5cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9077CC4CEF1;
	Tue, 26 Aug 2025 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218935;
	bh=+9S+PWmrsNh7sKkaXRNFxJ0Om2TJowp0URN5nLcYc3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOD3J5cMjS7IbFCICqyVsUjl9k2b7JiNXWKL3O2/LzXGjsA+OFRTRPzUQR32iGFml
	 EifT/ViPd/fSkRHxMwqWsPJ6eDolneKYUZx6dD2xQtFyW1oPlJE7dmKsXKYdmbUPu4
	 1hVUyPcNur8nEzfpR0U8xTMY0AOFHqmBjhx3aF+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/403] usb: xhci: Avoid showing warnings for dying controller
Date: Tue, 26 Aug 2025 13:08:29 +0200
Message-ID: <20250826110911.937836635@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 65fc0fc137b5da3ee1f4ca4f61050fcb203d7582 ]

When a USB4 dock is unplugged from a system it won't respond to ring
events. The PCI core handles the surprise removal event and notifies
all PCI drivers. The XHCI PCI driver sets a flag that the device is
being removed, and when the device stops responding a flag is also
added to indicate it's dying.

When that flag is set don't bother to show warnings about a missing
controller.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3383d7f0c88f..dcda4d7c2b75 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -118,7 +118,8 @@ int xhci_halt(struct xhci_hcd *xhci)
 	ret = xhci_handshake(&xhci->op_regs->status,
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
 	if (ret) {
-		xhci_warn(xhci, "Host halt failed, %d\n", ret);
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host halt failed, %d\n", ret);
 		return ret;
 	}
 	xhci->xhc_state |= XHCI_STATE_HALTED;
@@ -175,7 +176,8 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 	state = readl(&xhci->op_regs->status);
 
 	if (state == ~(u32)0) {
-		xhci_warn(xhci, "Host not accessible, reset failed.\n");
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host not accessible, reset failed.\n");
 		return -ENODEV;
 	}
 
-- 
2.39.5



