Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306593B7772;
	Mon, 23 Mar 2026 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279218; cv=none; b=KkD4zswMyuzVYQJh4oEEMYO5GUs1MDTsTY64YCepW1R3UPWteaqeRRPCd1GY5B55CqZQ+pucMV6JbhINJ2dYUJU8jAjujBZJK4vCBxOtTICoFKIUPT29mZS5gDV5i/IoX4xUYjhpxMjo7zCrySHU02NBX9AZw9FUembfx44xZio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279218; c=relaxed/simple;
	bh=8ZxQAS0K9bg2dWRCT4bot1uowLBfXPaop5idZHHUb4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYGHnMwVsgBg7LBhQfYNNwcDv4GzxZFyClD43rW5HTy6YuCLLA5nghx0C3NR5M6Dbc3P00D2WKkkNAjHB6EMDOI7pLVS2iSXT7sCyUWSPOf0H7SMs4MGLtpRQ5P1c07g9tpTugY6weF1MxvGrpmQfdaVmz8GBT/Ju6mza/7cyrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjgHRCk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjgHRCk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D39C4CEF7;
	Mon, 23 Mar 2026 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279218;
	bh=8ZxQAS0K9bg2dWRCT4bot1uowLBfXPaop5idZHHUb4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjgHRCk3ivTYH0DoVX7pKZTwX3eNPTJ+f5YbGU06E0UTgiDo+aoHS1HVrAxYIXb5W
	 zrTqAe2Ltc09FsaJAAarNRF5yI+jBk5laLjVV+W9iJLlzGBKkrQt83uyYRx5chTXZB
	 2iOjr9kYovk/EXLy3eYsAlvpXM2eA267Jf+oeM54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/567] Bluetooth: hci_sync: Fix hci_le_create_conn_sync
Date: Mon, 23 Mar 2026 14:47:07 +0100
Message-ID: <20260323134546.562615008@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 2cabe7ff1001b7a197009cf50ba71701f9cbd354 ]

While introducing hci_le_create_conn_sync the functionality
of hci_connect_le was ported to hci_le_create_conn_sync including
the disable of the scan before starting the connection.

When this code was run non synchronously the immediate call that was
setting the flag HCI_LE_SCAN_INTERRUPTED had an impact. Since the
completion handler for the LE_SCAN_DISABLE was not immediately called.
In the completion handler of the LE_SCAN_DISABLE event, this flag is
checked to set the state of the hdev to DISCOVERY_STOPPED.

With the synchronised approach the later setting of the
HCI_LE_SCAN_INTERRUPTED flag has not the same effect. The completion
handler would immediately fire in the LE_SCAN_DISABLE call, check for
the flag, which is then not yet set and do nothing.

To fix this issue and make the function call work as before, we move the
setting of the flag HCI_LE_SCAN_INTERRUPTED before disabling the scan.

Fixes: 8e8b92ee60de ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6a14f76071077..6192f70e4d393 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6555,8 +6555,8 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 	 * state.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
-		hci_scan_disable_sync(hdev);
 		hci_dev_set_flag(hdev, HCI_LE_SCAN_INTERRUPTED);
+		hci_scan_disable_sync(hdev);
 	}
 
 	/* Update random address, but set require_privacy to false so
-- 
2.51.0



