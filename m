Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3998F1C07C2;
	Tue, 15 Oct 2024 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997072; cv=none; b=QtdJhXEwwDvWMaEuqb7PjOgk5PSX8VucuG2Kv369qwaukAGVrNd1JfuZ25xsAsk/IQLjleHe4WErSKqUAE4aiXO6pHiyPFKEYQql7ML9YfwdHDQMdjW++rRVCkWyPlRaEzJHZ79N582cq39PBV/AL/zmlwNjdaQEjYfHI6JR4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997072; c=relaxed/simple;
	bh=n5maWz7JOuMRivxepd7xRinSJ4ilFbGGobClUjpblFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdotVDE/LrIn/+d4GazqB2fY0kH+6HTdcy4DM5tSXtqeigLt04Y5SzW9IqOHZAXntJaOKp45yv2RrOGv5HoiDkN24O7RgN44fFiYAYdUFIigNzW8U/LhDVnP7hz6Vr6SsVyQyk5iiwhcp38tNfNY1PPIAKr2r+h2BxSquiPZVKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7U4CB1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7U4CB1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41879C4CEC6;
	Tue, 15 Oct 2024 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997071;
	bh=n5maWz7JOuMRivxepd7xRinSJ4ilFbGGobClUjpblFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7U4CB1jL4oQfVMatfgPPG9DofUclK+DiAoYkEFHomPlT81x2y88JmXNfTOHWemeq
	 CqJwzlyiZTj6V7AGkSOYwa4A0NE3NNWfevLTVEOX8QlwRrvnFIUrpjni+V5t8PY1Ih
	 zyy660TYXOGmyiokGt3OJZJ3IHZqZNNs8/KzrRrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/518] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Tue, 15 Oct 2024 14:39:44 +0200
Message-ID: <20241015123920.088361830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b0d97c9ffd260..930dee28271e5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -928,7 +928,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



