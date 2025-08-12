Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6B2FA0DB;
	Tue, 12 Aug 2025 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021436; cv=none; b=q82fj1BHUmxxFxkTsOvjPOMnOemOspxSnRfnCB0Skeal+CaPsrmboOD4Yho+qAgYXxwTEivgj3MBbT1Db+jllMLjfICGjxiFT0QPr8g8BOFA10HxViD3IJr9fLQg4fzXqfcdwFOmFRfOgKuZmfyeztIcZQjsEqq2RgbknMrCPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021436; c=relaxed/simple;
	bh=4Tw1MK3EOVxFZhPhNX4VyVpcSZ5ApcJNjB9RL2UQUQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkHns1MQB5wc5FDDb5TygYhIa6Wnpm942IE0DRB0u8QYS0on8Ev8KQDlhSCZA6/fnq8wDMdiJUIYC4p3HFJSYQAlEkDNjEvgg8o9mNse3STcyOckyl198ey9minQmEwyF7iteXK4N5LVAF4v1tsW46eJV2kbzzx/Ql4Tt/oN4WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+8t7X1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+8t7X1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D133C4CEF0;
	Tue, 12 Aug 2025 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021436;
	bh=4Tw1MK3EOVxFZhPhNX4VyVpcSZ5ApcJNjB9RL2UQUQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+8t7X1VHEpV+fn68vlaAa47gshL14j8Ugg55p3EJUUzZCkZUgblGqdf6QFS/CvJ3
	 8wDu/U+KwsUiRTsd1siVKCjGmoJXN6oI+iPgiQabQPhXca6KzHh75d9Sn8OiuFJ1q0
	 rEnul+07Kaakrv3PqKnB5XQPXkes/+rPqr0SMFdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/262] Bluetooth: hci_event: Mask data status from LE ext adv reports
Date: Tue, 12 Aug 2025 19:28:00 +0200
Message-ID: <20250812172956.984467094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Chris Down <chris@chrisdown.name>

[ Upstream commit 0cadf8534f2a727bc3a01e8c583b085d25963ee0 ]

The Event_Type field in an LE Extended Advertising Report uses bits 5
and 6 for data status (e.g. truncation or fragmentation), not the PDU
type itself.

The ext_evt_type_to_legacy() function fails to mask these status bits
before evaluation. This causes valid advertisements with status bits set
(e.g. a truncated non-connectable advertisement, which ends up showing
as PDU type 0x40) to be misclassified as unknown and subsequently
dropped. This is okay for most checks which use bitwise AND on the
relevant event type bits, but it doesn't work for non-connectable types,
which are checked with '== LE_EXT_ADV_NON_CONN_IND' (that is, zero).

In terms of behaviour, first the device sends a truncated report:

> HCI Event: LE Meta Event (0x3e) plen 26
      LE Extended Advertising Report (0x0d)
        Entry 0
          Event type: 0x0040
            Data status: Incomplete, data truncated, no more to come
          Address type: Random (0x01)
          Address: 1D:12:46:FA:F8:6E (Non-Resolvable)
          SID: 0x03
          RSSI: -98 dBm (0x9e)
          Data length: 0x00

Then, a few seconds later, it sends the subsequent complete report:

> HCI Event: LE Meta Event (0x3e) plen 122
      LE Extended Advertising Report (0x0d)
        Entry 0
          Event type: 0x0000
            Data status: Complete
          Address type: Random (0x01)
          Address: 1D:12:46:FA:F8:6E (Non-Resolvable)
          SID: 0x03
          RSSI: -97 dBm (0x9f)
          Data length: 0x60
          Service Data: Google (0xfef3)
            Data[92]: ...

These devices often send multiple truncated reports per second.

This patch introduces a PDU type mask to ensure only the relevant bits
are evaluated, allowing for the correct translation of all valid
extended advertising packets.

Fixes: b2cc9761f144 ("Bluetooth: Handle extended ADV PDU types")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_event.c   | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index e4a97b2d0998..4c084a03d6bb 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2577,6 +2577,7 @@ struct hci_ev_le_conn_complete {
 #define LE_EXT_ADV_DIRECT_IND		0x0004
 #define LE_EXT_ADV_SCAN_RSP		0x0008
 #define LE_EXT_ADV_LEGACY_PDU		0x0010
+#define LE_EXT_ADV_DATA_STATUS_MASK	0x0060
 #define LE_EXT_ADV_EVT_TYPE_MASK	0x007f
 
 #define ADDR_LE_DEV_PUBLIC		0x00
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8516ba62c545..3b22ce3aa95b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6216,6 +6216,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 
 static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 {
+	u16 pdu_type = evt_type & ~LE_EXT_ADV_DATA_STATUS_MASK;
+
+	if (!pdu_type)
+		return LE_ADV_NONCONN_IND;
+
 	if (evt_type & LE_EXT_ADV_LEGACY_PDU) {
 		switch (evt_type) {
 		case LE_LEGACY_ADV_IND:
@@ -6247,8 +6252,7 @@ static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 	if (evt_type & LE_EXT_ADV_SCAN_IND)
 		return LE_ADV_SCAN_IND;
 
-	if (evt_type == LE_EXT_ADV_NON_CONN_IND ||
-	    evt_type & LE_EXT_ADV_DIRECT_IND)
+	if (evt_type & LE_EXT_ADV_DIRECT_IND)
 		return LE_ADV_NONCONN_IND;
 
 invalid:
-- 
2.39.5



