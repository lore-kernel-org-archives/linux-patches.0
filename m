Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83D1DF249;
	Wed,  6 Nov 2024 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894897; cv=none; b=X/X5PizXF9iMdgnn/XRgySr/TIldnFwAH4ira7olcnLF+Vr3/TI+mZpnWD0RUNmPHP7hM8DcuO+8zZ7I66+o6EQt2LSWOwpuHojXdEUMEWfWtMFsiCKJNA2XQKkt3pwUW04udGMRVeq0XYVqEAUa2agrp/NdOYSqyfNnSm9DT18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894897; c=relaxed/simple;
	bh=BeJuYUUHZ00XZvNymKiq2lNlKl0NB5rQrWaPaohCHn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXAzMfUuxPVBI8OBoJNzua8ENJ1MypdbXIz3lh4zo85yPeahqATPrTCMRtrfF8Vt9Tq2nwlQPUX7p91JvmUS+v9TE33YR8z0JPcHrMhcRuGK5RKDoRDUaIYdZUfKrLz6blxa2EdeqF7c6Bv6u4KgG4mzarULk5YCWMJaEVfxrlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiboY9I9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiboY9I9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544A2C4CECD;
	Wed,  6 Nov 2024 12:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894897;
	bh=BeJuYUUHZ00XZvNymKiq2lNlKl0NB5rQrWaPaohCHn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiboY9I91Lbkf+idUdhrQrVcDFurNpWwjxBRUuID366wNEQFqTUJ1E5/HNEUcbVe3
	 KzZV6HH12FXc3bhNBdNB1wAL/z+S4I8AMCqo5Et+tXRxQ/oafXaVvNI3+mpKLMju/I
	 n/+xwiDOKk0COt2pLiSN1BjtgJshOW7Ibfi1CEEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/350] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Wed,  6 Nov 2024 12:59:24 +0100
Message-ID: <20241106120321.775610631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b6eb48e44e6b1..c7a1ec57256b4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -743,7 +743,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



