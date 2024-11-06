Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D19A1E104A;
	Wed,  6 Nov 2024 12:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897880; cv=none; b=DbalM1eWjkg7BOKxAogQjIuicA+pB6FV8f9A1JVgBcy2sJrRXqXMw1gk7aSqkOfTQvYcuU1VmsaAvjVwMA8rto/FQ1wsRmviJC/Fdmv6V2WsWu2esfeApD4ZxIOIkxON0NYF0UnMBcEROU8rzWUI35TFIpBWIoUq2oaZA1Q+6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897880; c=relaxed/simple;
	bh=R2i6p2XahVSlvrws8WOA2JpLDeoRSwYvQJpFczdwyr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYQCJBjeiOECroyNYDdnoC/RU/wqfNlaaWYEKeTVXD/TLEELD/x72uzDSJs3eo7tjP5tTETPUCjj0FSAqN7AHTTqUj9OmhMujafsxKS8unlNl+sxwQIhOJ1prWUBi3hHPJvinFN/2wYDCMhUO1NtHm7VPD+YuzcRpIfQNRrnpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NERIGj+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NERIGj+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74B9C4CECD;
	Wed,  6 Nov 2024 12:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897880;
	bh=R2i6p2XahVSlvrws8WOA2JpLDeoRSwYvQJpFczdwyr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NERIGj+JYsMpvNjE9Bmx+us4yBFQm9vUrvOJd81WqhW3A5bHRCEgwB3hzz7n3wNkg
	 PgaowhrXRuVe44jHZpfph5aYU9fr6dWYGHJoXQyXves0U2eZMqdLZ5WZ3wHhE4pkf7
	 YQbapgaaXHg+SUOuUIQ5wDJpWDr+E2Jm0OoXS0Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/462] Bluetooth: btusb: Fix not handling ZPL/short-transfer
Date: Wed,  6 Nov 2024 12:59:03 +0100
Message-ID: <20241106120332.754607522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b9752625c88b4..87392ceee3dba 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -834,7 +834,10 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
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



