Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0A6226D0F;
	Mon, 18 Aug 2025 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523379; cv=none; b=axGZIclYjdZaqECtiKeN99pUZ2EJDgCQ+ZiIK/SiojCMsqO2SGBQWVq30eCWeT4gQLhaBTxR1gOTIn8yntfUCEmI/A115ZDO0JvOFT2VcggNGvNgtlyS7P9x18onGGAg940eQRHKW3b4Z5R8oYHL7rC6GrWmgooJ4vhqdkVuV2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523379; c=relaxed/simple;
	bh=F/FLW75PcioWZYR9KLJnrE9qkssvrFvSV5pvtYW021I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phx62n4qfIYSgYjT5sEJ8oQ4GDBsctgQDsG1pJcn5d+s9n+VgWj/0QTDJqXi7DQtM262AEiEzVw3PQEMx7AVBrVgyuuSiyuITvAjL0K7z93vlGqR2uiQFgpsEaroAYj6ppEWXoBctS1vtyPE18TP6y4V1rniWEBQBMTZQ/BHk2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fddb7I1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fddb7I1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1435C4CEEB;
	Mon, 18 Aug 2025 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523379;
	bh=F/FLW75PcioWZYR9KLJnrE9qkssvrFvSV5pvtYW021I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fddb7I1KOBbVawA6J6maY6RzgBjsC/b7QGc4eLML5f4SOJiO43YycwWDwRPJhrO3l
	 CEgHcUcgvcjePaFdt+2V16ai47xmjDoQOGlSk0mYrxZh6ximq6DO35Ib0Zkv9E/P7J
	 rdaqI6gHetFojqEDG4k42FVNpHwKDo8N0GQw86rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 120/515] usb: xhci: Avoid showing warnings for dying controller
Date: Mon, 18 Aug 2025 14:41:46 +0200
Message-ID: <20250818124502.968825421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cb9f35acb1f9..cb29aa49ceba 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -120,7 +120,8 @@ int xhci_halt(struct xhci_hcd *xhci)
 	ret = xhci_handshake(&xhci->op_regs->status,
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
 	if (ret) {
-		xhci_warn(xhci, "Host halt failed, %d\n", ret);
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host halt failed, %d\n", ret);
 		return ret;
 	}
 
@@ -179,7 +180,8 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 	state = readl(&xhci->op_regs->status);
 
 	if (state == ~(u32)0) {
-		xhci_warn(xhci, "Host not accessible, reset failed.\n");
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host not accessible, reset failed.\n");
 		return -ENODEV;
 	}
 
-- 
2.39.5



