Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD538226861;
	Tue, 26 Aug 2025 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216268; cv=none; b=FSvnQv+Vl2GrePihl1UVYkMaEo1boVTNNjMTV16Yt2sLWkiksgFji5WyXCNJUTsGWIaJpGR5IRKp84CHJRExcqikmHfc58soRTOlJjFbPG3NFd+R+6VPK7yEJLBg1Tbuo1zqVz8lBSlqa65w5qRapVIiB87GzLFrd4e6iFHnU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216268; c=relaxed/simple;
	bh=k3ayMHXioL7ByMl/KSUr6PPIctDMzuLilqWKGMBqIeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF1IhMAddeJRKfK7gONANrxbyXqjTOX5uZ+KWGGb8mN7n7GgwQC2BSZW0H0GKxQvi6huuDIWtU7p4YD+twT5o+dk7j0VMtU5Rtv+EUw5JEsecDNfiU6es+ayuCZuQlWe26efHJP+uczknfI84HUfvANPnGWxFK92olcznwROUU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymJ15KGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymJ15KGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B788C4CEF1;
	Tue, 26 Aug 2025 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216268;
	bh=k3ayMHXioL7ByMl/KSUr6PPIctDMzuLilqWKGMBqIeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymJ15KGIV9VWmGhMBIrOEFoiLSDSsu55qyYcGZKiXpJ6WY7/CHflFlSQ4HB1BqtAU
	 9vDWg4CC5nfOmVcZn6rQPE1MrDZqneAoP0Z7+2lSq3KBoYuVCdCv47IYb0MQgtjeoU
	 iBZJ0PP07jH4jpBt0GR4DqZcPhA6Js+r/1wni8FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/644] usb: xhci: Avoid showing errors during surprise removal
Date: Tue, 26 Aug 2025 13:06:32 +0200
Message-ID: <20250826110953.844450590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4b9c60e440525b729ac5f071e00bcee12e0a7e84 ]

When a USB4 dock is unplugged from a system it won't respond to ring
events. The PCI core handles the surprise removal event and notifies
all PCI drivers. The XHCI PCI driver sets a flag that the device is
being removed as well.

When that flag is set don't show messages in the cleanup path for
marking the controller dead.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 626f02605192..d56740af8160 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1297,12 +1297,15 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
  */
 void xhci_hc_died(struct xhci_hcd *xhci)
 {
+	bool notify;
 	int i, j;
 
 	if (xhci->xhc_state & XHCI_STATE_DYING)
 		return;
 
-	xhci_err(xhci, "xHCI host controller not responding, assume dead\n");
+	notify = !(xhci->xhc_state & XHCI_STATE_REMOVING);
+	if (notify)
+		xhci_err(xhci, "xHCI host controller not responding, assume dead\n");
 	xhci->xhc_state |= XHCI_STATE_DYING;
 
 	xhci_cleanup_command_queue(xhci);
@@ -1316,7 +1319,7 @@ void xhci_hc_died(struct xhci_hcd *xhci)
 	}
 
 	/* inform usb core hc died if PCI remove isn't already handling it */
-	if (!(xhci->xhc_state & XHCI_STATE_REMOVING))
+	if (notify)
 		usb_hc_died(xhci_to_hcd(xhci));
 }
 
-- 
2.39.5



