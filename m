Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15A72F5E;
	Tue, 12 Aug 2025 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022363; cv=none; b=SmxnIW91rVnNo6B8euIaYNw5/JXwloMNVJxAoo8PgxB5eiY94R2MCsZivI3mJiJl0ZbXBGNcDKwyppHH5JJTfQ/kF61u9Wv+R3U0QKRlOsXLDiZOeNzi5y0iBUuY4AqcxPOUujrE2aA4+RAa+oZJMPMQpoMfLrLVxt5KZUud9u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022363; c=relaxed/simple;
	bh=ZBvLmtWmDWg958fwtBQeFWEuWt+ZHCd4eXA46Ax1Mz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLmjf9MT8EmVSuzXnU0j5vZzaxIJuWfFcfcR1r9Ve4hp1Nr6gGkMSzGusELQvYjgtYdgo+dzU6cmZYjovE77SSg+hWNxV/K0CoToU9DI45TbouLzQnca78T+Hz4KcNuJAVJc59FjHUJiq+zWQAmmhNS785iNhRoD1WqLzXng718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCmlnYGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCmlnYGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2ECC4CEF0;
	Tue, 12 Aug 2025 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022363;
	bh=ZBvLmtWmDWg958fwtBQeFWEuWt+ZHCd4eXA46Ax1Mz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCmlnYGhFO9/OVXXG3g1NGGcaWNzMdY5B2QpbUhrethfwa8rrussQpdXHzjEu8+H6
	 1uzq+OqiZUskqTjtVnt2+VDdOM/R+ZW+izJK/3vkZJqwV/JDagfjU4nPtuci3S30Wy
	 Zpk8mfWd/OxFKlrg6wSLJKo6KtJOSobmB4Oop96Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/369] Bluetooth: hci_event: Mask data status from LE ext adv reports
Date: Tue, 12 Aug 2025 19:27:09 +0200
Message-ID: <20250812173019.736730809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 40fce4193cc1..4b3200542fe6 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2612,6 +2612,7 @@ struct hci_ev_le_conn_complete {
 #define LE_EXT_ADV_DIRECT_IND		0x0004
 #define LE_EXT_ADV_SCAN_RSP		0x0008
 #define LE_EXT_ADV_LEGACY_PDU		0x0010
+#define LE_EXT_ADV_DATA_STATUS_MASK	0x0060
 #define LE_EXT_ADV_EVT_TYPE_MASK	0x007f
 
 #define ADDR_LE_DEV_PUBLIC		0x00
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b7dcebc70189..38643ffa65a9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6221,6 +6221,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 
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
@@ -6252,8 +6257,7 @@ static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 	if (evt_type & LE_EXT_ADV_SCAN_IND)
 		return LE_ADV_SCAN_IND;
 
-	if (evt_type == LE_EXT_ADV_NON_CONN_IND ||
-	    evt_type & LE_EXT_ADV_DIRECT_IND)
+	if (evt_type & LE_EXT_ADV_DIRECT_IND)
 		return LE_ADV_NONCONN_IND;
 
 invalid:
-- 
2.39.5



