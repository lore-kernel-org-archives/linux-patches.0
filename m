Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FCF1BFDFC;
	Mon, 14 Oct 2024 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917575; cv=none; b=Z4emutIu4YLGWY5qWIfyCEPmYotSiwPx+VXsp0nHrGxQIbLvX47HPNDpWI2SSF4TQ6eQRRWNKpLvOAtrGnkBjEEH4nSZKBmZw9yb6+sJprPuPWd4/AmGq5sYHNkX2u7F+6earBqbWHU6iuk++G/Oxe3mOynbuu2V2JzSLN1Za7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917575; c=relaxed/simple;
	bh=CJeO1Cyw8ows7Ev+75A5wJxC3FVsKRR7WBHbrdYqWDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjhOPLngfYJoqyDR/9Bdom4OJ0z5UBHkpJkoWY3+vyJe0BEOj2wtQfhr7IdGi1rSwF3uYfNT+tn3f25sKVIrPuUv1npLqwmPY+ZCHx0OF5VBim95YWFNLBIfpw9J1AZG3Hn1uLw6q28txGbhHooADbPMjDKFqHamGOkn0PCHUS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRP+r25B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRP+r25B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B73C4CED0;
	Mon, 14 Oct 2024 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917575;
	bh=CJeO1Cyw8ows7Ev+75A5wJxC3FVsKRR7WBHbrdYqWDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRP+r25BHkPUlTOtNGgE+7fLXGzLu86S8a5ObdcLNWilbJtWyYuWxtRarqo5Poy6I
	 OUcH4dSw9O7LLn5E6wY1mGyOI02d13cyV9UFMR/IwTAaLXkav0OiKrlMrYjHifd4BJ
	 RSs211TLESHJeT2LT+Cv0C4u535dLgR6JGB+r07k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/798] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Mon, 14 Oct 2024 16:10:08 +0200
Message-ID: <20241014141220.066746195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 2d8c405a27a6c..dc5150f677236 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1189,7 +1189,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



