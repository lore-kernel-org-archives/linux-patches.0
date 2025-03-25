Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485B259CAE;
	Tue, 25 Mar 2025 12:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905563; cv=none; b=ufeQvGElGd3dmFqqPSy31rXTDI3Rk3o0sJtiWOj14kwmHbvsZbnolplQiReNh0gCp59MmpsclpFWYiKlLElLjt0LlCkZQzJ3Phuhy/sndbPnKAbkYjPwLVDEuyhw7CbnGS5pQBpVWgu0S9fvdshnNejqQ77ZElMp+RCBuO7z0i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905563; c=relaxed/simple;
	bh=6KIwzaPCZYZqvk8RlNAkgF4MJlreeoVRuvPDv9Viytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl4fEznUqn4P54D0Vp5jeJRKXTK4OsCCj0jznZv1HeY4z4t0M7U1iZQWDSBotu9X8/nb0dKQ8SD6wtv1uf/8Ay7xgzABEU7VGSMJ8SWUxAlHh2mSsWlj3VR4Lez2CTf3GpJUGJvypkBWXX2mxMOPMyPwdGOD/X9/skIbk1uurlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfIchO+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfIchO+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638DC4CEE4;
	Tue, 25 Mar 2025 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905563;
	bh=6KIwzaPCZYZqvk8RlNAkgF4MJlreeoVRuvPDv9Viytk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfIchO+XFjpaZUX0GHHBXZyUBGbluKT1Kto89MgZgJ7NNM8HdCkd5ObCDO6mUwBAx
	 oa8na1Y3fMh5PM3gW3bIJ+q2KyxVINpvarNOJftvkzPYCAOiUx5Le0weUgwr1MxaVd
	 56GoBC/4AT+fZwq86q0WYVP53DO4Y0ozUAtyJ0wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/198] Bluetooth: hci_event: Fix enabling passive scanning
Date: Tue, 25 Mar 2025 08:19:34 -0400
Message-ID: <20250325122156.961823472@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b6fe5e15981f8..6cfd61628cd78 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3477,23 +3477,30 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
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



