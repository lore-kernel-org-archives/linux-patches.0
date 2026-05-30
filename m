Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33BF2D7D2E;
	Sat, 30 May 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164000; cv=none; b=FXL1k/G3BILY2UXsqRYWn4EOZKkNENc/RZ1mtbc1/LUD9RLO1cDo68u0zLHclpUHdvNrkj/++7IGa/awCKN/ActNnNtegel1xfSmE/iKBjzD1fWoG4zcbrhSwzTAJsV1Fia2cqMg3nGmFOYico81oBUCi3FW8GabT8r8BcB91RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164000; c=relaxed/simple;
	bh=OkdACNP7YgPfAt9TNYl//v4q0VBXoxjtNCrFifvAoVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNw9Olvm+TvvEpfWBYult6oA7IZ/FAcUF5TPhu3x2e62tBRgXcKFD/LqT5mEiLe2ooIYOe8fR9ZXZBYRrmgesa6X7dmUPfUlnE9Ymgk4I/WZMLQ9h19pD+qXCMrOzDDSQmKVL777A2S9kwuH8OiEJUge0IXPTpbNKgQQAeVOBqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6vnc30N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6vnc30N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3284C1F00893;
	Sat, 30 May 2026 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163999;
	bh=RAP80sQOmC1wPgMrHEJeQOTMaudiAN1tDC+AwpK6sLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6vnc30NKmCWpZ+M9a1vGmbpAMFzBcgJFZO1C/TbpNaTWUwkEWFQgZPZQqYE7gfw7
	 /R2PCVNCF2f5XCiT86XScu0AKtPDigk7Z85DJZcx+I5KrYaleFcKeATENBQArGubnX
	 uX+0i6PnqTX01W+CRkiTbc7qGlXBawGXt23IK5+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Rissanen <jonathan.rissanen@axis.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/776] Bluetooth: hci_ldisc: Clear HCI_UART_PROTO_INIT on error
Date: Sat, 30 May 2026 18:02:18 +0200
Message-ID: <20260530160251.416117314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Rissanen <jonathan.rissanen@axis.com>

[ Upstream commit 68d39ea5e0adc9ecaea1ce8abd842ec972eb8718 ]

When hci_register_dev() fails in hci_uart_register_dev()
HCI_UART_PROTO_INIT is not cleared before calling hu->proto->close(hu)
and setting hu->hdev to NULL. This means incoming UART data will reach
the protocol-specific recv handler in hci_uart_tty_receive() after
resources are freed.

Clear HCI_UART_PROTO_INIT with a write lock before calling
hu->proto->close() and setting hu->hdev to NULL. The write lock ensures
all active readers have completed and no new reader can enter the
protocol recv path before resources are freed.

This allows the protocol-specific recv functions to remove the
"HCI_UART_REGISTERED" guard without risking a null pointer dereference
if hci_register_dev() fails.

Fixes: 5df5dafc171b ("Bluetooth: hci_uart: Fix another race during initialization")
Signed-off-by: Jonathan Rissanen <jonathan.rissanen@axis.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 46b37d825d185..dfd1d4a4d9fc2 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -691,6 +691,9 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
+		percpu_down_write(&hu->proto_lock);
+		clear_bit(HCI_UART_PROTO_INIT, &hu->flags);
+		percpu_up_write(&hu->proto_lock);
 		hu->proto->close(hu);
 		hu->hdev = NULL;
 		hci_free_dev(hdev);
-- 
2.53.0



