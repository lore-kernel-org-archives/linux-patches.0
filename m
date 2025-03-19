Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8A374EA;
	Wed, 19 Mar 2025 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394838; cv=none; b=BudH9Gx+5fDW+VKSVOWHnFRxlsmdqCi0AA8mIydgKUmn1UiNFhXo5WIzas6X3aGrmVhJP0lHSzAl6YQzru6poRRDOfF7tCRbpA1tmZo/hPuNEj/KHmFEqx1IiDbJwZJiZm6lfxZxW/XrxDgApbty9BBuYH2kd5fuyVDSgvDM704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394838; c=relaxed/simple;
	bh=GaasaHH7+0z1WbqETHsJL0VW0up+M6YZjflacFAGi0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuCkKgxQX7xWXZ3MqY/9uKovgAD/tas0kRHDYDd6myQ69k7sPI6KLMkrPB4GfwxTZZNhFtRM3YXWoYDSTPVaJ5bI92eviqvtGmUnBjU3MK5XE4e/DyUlDF0cb9khzI9BMgXfxdNd15rtxeweHRI3Bgc+CLJeHMRTBTQnOEV6m6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvEzKDPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvEzKDPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D283DC4CEE4;
	Wed, 19 Mar 2025 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394837;
	bh=GaasaHH7+0z1WbqETHsJL0VW0up+M6YZjflacFAGi0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvEzKDPMaxPwZPGDVY3a3ZKbaHyMQjoSfrGagmvnlysDM84GdL4BoXR8C9KGlGuSr
	 Kn3yKzkaRMkxgKXo2fpdhbR+eBHnK1l71GBWRxBOVrtlqckGEQ7I3Lya0QafHlvLGJ
	 EAOHdPtwbP2yXR5boAII7A/V248fmTv/iVj4NftU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 019/241] Bluetooth: hci_event: Fix enabling passive scanning
Date: Wed, 19 Mar 2025 07:28:09 -0700
Message-ID: <20250319143028.184156053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2cc7a93063501..903b0b52692aa 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3391,23 +3391,30 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
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



