Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D16B1F09A2;
	Wed, 19 Mar 2025 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395166; cv=none; b=B4Etl/f7l1J5VaTHETC7ZR8p6GNLskyklPGujGp6zAMqwpaGPlGJPsT3M3D+Fm72q52phPEJmzFt6XqFT195wb6LrAnJzMUj4U8nqGUXmovcUNED1iNFm0qcjTiAwBrItctq/kg7je+ttVEbH0ZIlrP3WxeArSMIF0A+PoQKHOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395166; c=relaxed/simple;
	bh=zngIUVi0A1eXVt0mCLZncDIOEBPR1IC0aysjgmfGHE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG6ve7DvTE3oxl9Qlz2rco6Wk4NxcWC1sPX8GNzJNlscTZR+7xVX7BWBKiEAirNOkc2CV+8qPTWBAnZFvhHz2+kKMtDjfB8GdY6j9DCyjWXIwzA8KoCj4feovYCXE1ff9hpPxWRQLUipHv2FlVmZFjY6Jsy85R5xx5NObW/bAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IInqopI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IInqopI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C743C4CEE4;
	Wed, 19 Mar 2025 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395166;
	bh=zngIUVi0A1eXVt0mCLZncDIOEBPR1IC0aysjgmfGHE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IInqopIW836WPjarlMcAQrglUekYrj9HeHHScxmQedDPsxcHZxDjb/6q43CHZTOI
	 LhRe9LTUcPDxVB2q68ImPz47eGQcBQbrPW67Ouwrn53q9pdAtmDzoO5t1d0C5jXqpi
	 GbDq9i7fTB4NfHvzebfr9H1ceDzLooQS9ZE8eSbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/166] Bluetooth: hci_event: Fix enabling passive scanning
Date: Wed, 19 Mar 2025 07:29:46 -0700
Message-ID: <20250319143020.395875497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0bdd88971519cfa8a76d1a4dde182e74cfbd5d5c ]

Passive scanning shall only be enabled when disconnecting LE links,
otherwise it may start result in triggering scanning when e.g. an ISO
link disconnects:

> HCI Event: LE Meta Event (0x3e) plen 29
      LE Connected Isochronous Stream Established (0x19)
        Status: Success (0x00)
        Connection Handle: 257
        CIG Synchronization Delay: 0 us (0x000000)
        CIS Synchronization Delay: 0 us (0x000000)
        Central to Peripheral Latency: 10000 us (0x002710)
        Peripheral to Central Latency: 10000 us (0x002710)
        Central to Peripheral PHY: LE 2M (0x02)
        Peripheral to Central PHY: LE 2M (0x02)
        Number of Subevents: 1
        Central to Peripheral Burst Number: 1
        Peripheral to Central Burst Number: 1
        Central to Peripheral Flush Timeout: 2
        Peripheral to Central Flush Timeout: 2
        Central to Peripheral MTU: 320
        Peripheral to Central MTU: 160
        ISO Interval: 10.00 msec (0x0008)
...
> HCI Event: Disconnect Complete (0x05) plen 4
        Status: Success (0x00)
        Handle: 257
        Reason: Remote User Terminated Connection (0x13)
< HCI Command: LE Set Extended Scan Enable (0x08|0x0042) plen 6
        Extended scan: Enabled (0x01)
        Filter duplicates: Enabled (0x01)
        Duration: 0 msec (0x0000)
        Period: 0.00 sec (0x0000)

Fixes: 9fcb18ef3acb ("Bluetooth: Introduce LE auto connect options")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 01e51e1dc9b33..1e689d8c00a50 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3394,23 +3394,30 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
 		hci_update_scan(hdev);
 	}
 
-	params = hci_conn_params_lookup(hdev, &conn->dst, conn->dst_type);
-	if (params) {
-		switch (params->auto_connect) {
-		case HCI_AUTO_CONN_LINK_LOSS:
-			if (ev->reason != HCI_ERROR_CONNECTION_TIMEOUT)
+	/* Re-enable passive scanning if disconnected device is marked
+	 * as auto-connectable.
+	 */
+	if (conn->type == LE_LINK) {
+		params = hci_conn_params_lookup(hdev, &conn->dst,
+						conn->dst_type);
+		if (params) {
+			switch (params->auto_connect) {
+			case HCI_AUTO_CONN_LINK_LOSS:
+				if (ev->reason != HCI_ERROR_CONNECTION_TIMEOUT)
+					break;
+				fallthrough;
+
+			case HCI_AUTO_CONN_DIRECT:
+			case HCI_AUTO_CONN_ALWAYS:
+				hci_pend_le_list_del_init(params);
+				hci_pend_le_list_add(params,
+						     &hdev->pend_le_conns);
+				hci_update_passive_scan(hdev);
 				break;
-			fallthrough;
 
-		case HCI_AUTO_CONN_DIRECT:
-		case HCI_AUTO_CONN_ALWAYS:
-			hci_pend_le_list_del_init(params);
-			hci_pend_le_list_add(params, &hdev->pend_le_conns);
-			hci_update_passive_scan(hdev);
-			break;
-
-		default:
-			break;
+			default:
+				break;
+			}
 		}
 	}
 
-- 
2.39.5



