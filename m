Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20D51D0954;
	Wed,  2 Oct 2024 13:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877479; cv=none; b=US0qp9/W8JQz4MKGv/RcrO15tQcnnUa6OKf4TMWst9G/n5gsrBAHG49h7sWgoDdo2Z30uETVNh+y1EfIzoIR4spuw/OfMgdh6Je4b/MbOEGYUjrDD12XcfztV+Bu9wptMbwsocqLodDldyTrXAGkjOrZPIl2NOu22m9HIEaEUYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877479; c=relaxed/simple;
	bh=zyGGevShtUrF6s+tnF29MPGnM6LTtStaSEmuhl1a1eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmQhq3z3TJtXBukrJofIqM40m2yZflRGa4wJZESpbfHwMJaMOJHnwqaIUyqTdvsPPn0S4+IO2QDVSqENQWA9OTfMtoaL0arwTu50So385YSS5wIZ7v+MZLt9VT+nvSjx/3aE07d/HkCKpKU2vbaWsWcflKI1EFb5LE8JeLaj82k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbMwl1W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbMwl1W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBC0C4AF55;
	Wed,  2 Oct 2024 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877479;
	bh=zyGGevShtUrF6s+tnF29MPGnM6LTtStaSEmuhl1a1eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbMwl1W+PXY/SNDIgOwDmd2wNnlCrnS3xGR3eZ4ilESINQDssjtOb/yPr32///N3e
	 P3qP1D8qj1hNuzXqZJ8JwGoyPBJpoIPX4WcW5uPlKyJAi8P6VIirNsSDTJ7P1tR92g
	 DW2jVMPtnbp2NJqZ5Xu0hFsRVgFrEEmASz6sdw68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/634] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Wed,  2 Oct 2024 14:53:12 +0200
Message-ID: <20241002125814.741771967@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7b05933340f4490ef5b09e84d644d12484b05fdf ]

Requesting transfers of the exact same size of wMaxPacketSize may result
in ZPL/short-transfer since the USB stack cannot handle it as we are
limiting the buffer size to be the same as wMaxPacketSize.

Also, in terms of throughput this change has the same effect to
interrupt endpoint as 290ba200815f "Bluetooth: Improve USB driver throughput
by increasing the frame size" had for the bulk endpoint, so users of the
advertisement bearer (e.g. BT Mesh) may benefit from this change.

Fixes: 5e23b923da03 ("[Bluetooth] Add generic driver for Bluetooth USB devices")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0927f51867c26..c41b86608ba86 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1393,7 +1393,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
 	if (!urb)
 		return -ENOMEM;
 
-	size = le16_to_cpu(data->intr_ep->wMaxPacketSize);
+	/* Use maximum HCI Event size so the USB stack handles
+	 * ZPL/short-transfer automatically.
+	 */
+	size = HCI_MAX_EVENT_SIZE;
 
 	buf = kmalloc(size, mem_flags);
 	if (!buf) {
-- 
2.43.0



