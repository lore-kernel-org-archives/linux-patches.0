Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8487139A27A;
	Wed,  3 Dec 2025 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780836; cv=none; b=O5rvE2Za5tTTYOX7S4csuTOjpG0Slgv7K4cQl6w1roum3Fu+K6QNqphCMJE466XYrfb1RJ72ZZF+t/f3KaLszddYKQU97BXAZdn3tQ2Zd/WPWPT87aaYB6tMI0kh/reW5SWdLCig1HcmhtsGJS2DXoT5EyADUZViSCg0ZLg8ZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780836; c=relaxed/simple;
	bh=4FlbixaNZ8VT1NLsQ87YjTAGRMvrd595FP/k8Z2P25k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+3L+JESavLpRPD3zO4VOAb3WAoKq3wmhEdiAq1gUDGew9zng+l5Z+GegCcx5QcQfJlUNjdyIWDQTeXwnd6C1xirVNZn70RcvkEHbTmmBwoL2V7BfgHVV5TMlYVF+AVirjuiDBscGIb0DfTi31ZcOPFxo9AkVGDVMvuyGn/HFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlT5ilsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlT5ilsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79A7C4CEF5;
	Wed,  3 Dec 2025 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780836;
	bh=4FlbixaNZ8VT1NLsQ87YjTAGRMvrd595FP/k8Z2P25k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlT5ilshin/nOxmIDM5wxyPHrc+8ZSJyziV6qntoQ7cYjbaMVkvU1ZDUVzchtKFoO
	 9xdBUKYJ+6897Q5nodMNH4t5YE7nZvpPPUoc1ueCYyoZIaXb0a0HXy2Z7VQaaMCajY
	 xjyDIhWyfw5+HJXEbGsN7nxk0FIx6oTnmeGG6usA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	IncogCyberpunk <incogcyberpunk@proton.me>,
	Douglas Anderson <dianders@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 071/132] Bluetooth: btusb: mediatek: Avoid btusb_mtk_claim_iso_intf() NULL deref
Date: Wed,  3 Dec 2025 16:29:10 +0100
Message-ID: <20251203152345.925501626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit c884a0b27b4586e607431d86a1aa0bb4fb39169c upstream.

In btusb_mtk_setup(), we set `btmtk_data->isopkt_intf` to:
  usb_ifnum_to_if(data->udev, MTK_ISO_IFNUM)

That function can return NULL in some cases. Even when it returns
NULL, though, we still go on to call btusb_mtk_claim_iso_intf().

As of commit e9087e828827 ("Bluetooth: btusb: mediatek: Add locks for
usb_driver_claim_interface()"), calling btusb_mtk_claim_iso_intf()
when `btmtk_data->isopkt_intf` is NULL will cause a crash because
we'll end up passing a bad pointer to device_lock(). Prior to that
commit we'd pass the NULL pointer directly to
usb_driver_claim_interface() which would detect it and return an
error, which was handled.

Resolve the crash in btusb_mtk_claim_iso_intf() by adding a NULL check
at the start of the function. This makes the code handle a NULL
`btmtk_data->isopkt_intf` the same way it did before the problematic
commit (just with a slight change to the error message printed).

Reported-by: IncogCyberpunk <incogcyberpunk@proton.me>
Closes: http://lore.kernel.org/r/a380d061-479e-4713-bddd-1d6571ca7e86@leemhuis.info
Fixes: e9087e828827 ("Bluetooth: btusb: mediatek: Add locks for usb_driver_claim_interface()")
Cc: stable@vger.kernel.org
Tested-by: IncogCyberpunk <incogcyberpunk@proton.me>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2714,6 +2714,11 @@ static void btusb_mtk_claim_iso_intf(str
 	if (!btmtk_data)
 		return;
 
+	if (!btmtk_data->isopkt_intf) {
+		bt_dev_err(data->hdev, "Can't claim NULL iso interface");
+		return;
+	}
+
 	/*
 	 * The function usb_driver_claim_interface() is documented to need
 	 * locks held if it's not called from a probe routine. The code here


