Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C24E200112;
	Tue, 26 Aug 2025 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208960; cv=none; b=I+sIUnWfUN33ju6QvZqcYDwKlF0bqvcgIHL1a93Ryd3to648+Puo4qqeRvyLXRwVgTJmlv6Vny6GKxP8UZ8OKm1vjlRmUx+X17dXkcEkgO6DPSyuQ2XRDyBP3+YCdCun5tU7SIh235scYAhNXLFIQ9yhEHvUx5ctvMxkY+tXMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208960; c=relaxed/simple;
	bh=rIttr2jSlxhc896CXQczCR6aIquQGQg47MxbMnUQHbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlhWnfrimIh8rvGxT+Nu8EDS2cHV+u4XWtjKpB6SK3yyC1Cis5BjkhTzCgM8v7ItdsKPBkZEYxh8tvxTZcLfxycca6wH2hV93b7U7RfkcIwBsvalG3YTLOlhKJGs09Sy94n4ueqmWZmcpvF6yRYiseMpOaPqMNzSzNgKDTM5O8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2TBy5HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2TBy5HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5FC4CEF1;
	Tue, 26 Aug 2025 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208958;
	bh=rIttr2jSlxhc896CXQczCR6aIquQGQg47MxbMnUQHbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2TBy5HWNU126C9jrTzZSKikdJyVmOYmNZ68BcUq2BfPXYiZOR3YYpJT1xoGTfBW7
	 CApyuFNl8gxcEubo/qqLgre2joT8PEv+KqITuObwSrUSP+XwJ7pY947qpsi7onm6eY
	 OKe0JuBvYMja2VEd8D4YqpBj5RvQk/GYhhBBU59g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/322] Bluetooth: hci_sync: Prevent unintended PA sync when SID is 0xFF
Date: Tue, 26 Aug 2025 13:11:34 +0200
Message-ID: <20250826110922.813329637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c7fd657c86ff..af86df9de941 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7020,10 +7020,13 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
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
@@ -7053,6 +7056,7 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 		__hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC_CANCEL,
 				      0, NULL, HCI_CMD_TIMEOUT);
 
+done:
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
 	/* Update passive scan since HCI_PA_SYNC flag has been cleared */
-- 
2.50.1



