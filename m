Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B66529D26A;
	Tue, 26 Aug 2025 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207946; cv=none; b=UvVy/LvK8KIei2rmqmJVJ79jese+0ACChJeaAszsPvDIB8iUw8PRCiQwHIXeH15VVhRuE3JDJzHTkhAt+i/t69xp00CxHQ+Shv/LmqQo57wgypRN7jgHnKSK1dwd9b+ilNLq1mBWhmOUDB30Ql8Dq58C4x7AWWkJA480aawfd5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207946; c=relaxed/simple;
	bh=3BXOM1lvB0rKQyx9/iwnsqJfK5VaY8B6plEwtOLF6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGtP4aHico70oF7swqpvuh0+yV3cy60I99DRNa5XSap0gTGL2DqMdRFuGEuip3MoTyjbl+PQpFqVepS/2hka00X6B3GPEQj1MfumowX6wncD5G0yLdj12gpKiSW4fmmNJBpP86MWMJK23BqAg6P9huL3uJP525GyWZ2liP+97YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyiFOyw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyiFOyw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CC6C4CEF1;
	Tue, 26 Aug 2025 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207946;
	bh=3BXOM1lvB0rKQyx9/iwnsqJfK5VaY8B6plEwtOLF6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyiFOyw5a+iLqjAaK1VTfCjw3AXUj0lZf6qN8gRcOMdfgr50CZFlo5ZXdqv4jk31z
	 E40vXEwndA4azTul5x3lRta0/3L/603gMmjeS2O8V5oXmHyeci5k/pQ0wQ6EZR0h3O
	 sOg9IR0cR1RMIpeWoBoF290y4cfUjR1dDzUgWeAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 377/457] Bluetooth: hci_sync: Prevent unintended PA sync when SID is 0xFF
Date: Tue, 26 Aug 2025 13:11:01 +0200
Message-ID: <20250826110946.613392507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit 4d19cd228bbe8ff84a63fe7b11bc756b4b4370c7 ]

After LE Extended Scan times out, conn->sid remains 0xFF,
so the PA sync creation process should be aborted.

Btmon snippet from PA sync with SID=0xFF:

< HCI Command: LE Set Extended.. (0x08|0x0042) plen 6  #74726 [hci0] 863.107927
        Extended scan: Enabled (0x01)
        Filter duplicates: Enabled (0x01)
        Duration: 0 msec (0x0000)
        Period: 0.00 sec (0x0000)
> HCI Event: Command Complete (0x0e) plen 4            #74727 [hci0] 863.109389
      LE Set Extended Scan Enable (0x08|0x0042) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Periodic Ad.. (0x08|0x0044) plen 14  #74728 [hci0] 865.141168
        Options: 0x0000
        Use advertising SID, Advertiser Address Type and address
        Reporting initially enabled
        SID: 0xff
        Adv address type: Random (0x01)
        Adv address: 0D:D7:2C:E7:42:46 (Non-Resolvable)
        Skip: 0x0000
        Sync timeout: 20000 msec (0x07d0)
        Sync CTE type: 0x0000
> HCI Event: Command Status (0x0f) plen 4              #74729 [hci0] 865.143223
      LE Periodic Advertising Create Sync (0x08|0x0044) ncmd 1
        Status: Success (0x00)

Fixes: e2d471b7806b ("Bluetooth: ISO: Fix not using SID from adv report")
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 892eca21c6c4..a1b063fde286 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7045,10 +7045,13 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 	/* SID has not been set listen for HCI_EV_LE_EXT_ADV_REPORT to update
 	 * it.
 	 */
-	if (conn->sid == HCI_SID_INVALID)
-		__hci_cmd_sync_status_sk(hdev, HCI_OP_NOP, 0, NULL,
-					 HCI_EV_LE_EXT_ADV_REPORT,
-					 conn->conn_timeout, NULL);
+	if (conn->sid == HCI_SID_INVALID) {
+		err = __hci_cmd_sync_status_sk(hdev, HCI_OP_NOP, 0, NULL,
+					       HCI_EV_LE_EXT_ADV_REPORT,
+					       conn->conn_timeout, NULL);
+		if (err == -ETIMEDOUT)
+			goto done;
+	}
 
 	memset(&cp, 0, sizeof(cp));
 	cp.options = qos->bcast.options;
@@ -7078,6 +7081,7 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 		__hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC_CANCEL,
 				      0, NULL, HCI_CMD_TIMEOUT);
 
+done:
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
 	/* Update passive scan since HCI_PA_SYNC flag has been cleared */
-- 
2.50.1



