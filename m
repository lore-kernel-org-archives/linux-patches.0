Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D982FFDC7;
	Tue, 12 Aug 2025 18:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024057; cv=none; b=mPV0/uGwOgOtiVduMHDNR6P+/Tk3NVAzVqxtI/HcY0h1gv5SVZxK2ofvgN4vKl0gIc/Bj6Ztp3OISo/blmTUaj5saRpjS2Vpp0lyoqdNXNPsQSteh2aDuQ1+kjC4mX8mFwHCRN6wg13USCCd0pCP6MMtPMv9r4BecJj7D3383nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024057; c=relaxed/simple;
	bh=tlC6WOttenCNbxWCZUsqJoA77i/6rpxL/VBPgaQ7634=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXdhknLYbZdKH/0XjooEt3UAwFjceuLjYVubXRYkLUXPW0VosK34ZgycwOqVdtAhsZAX2gP11hvm7+WuuLT+XlBJse7GESb/CpE68se5vJ5cbdKYqbhajFX5y+Zf4ID/1c66WSDV2zhkHFIPvLPeZjEJdHYgXrHECtaVra7SC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19rMKAFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19rMKAFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBF8C4CEF0;
	Tue, 12 Aug 2025 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024056;
	bh=tlC6WOttenCNbxWCZUsqJoA77i/6rpxL/VBPgaQ7634=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19rMKAFx4oJWkcXAyHN1xaU44Y3t1dhxJMTMBi656m9PxMcFp6HBrH5lIfC/RDbAB
	 pIUr0MLcrIOctRxc56zxFE0hjoDI8oZY57Rn5v+poWZgs8c5jKvv+LyNejf/Jfhw6z
	 g1o0yZEU6pP6MewWVgtK1diaHcIr8Isel5Lyqgpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 260/627] Bluetooth: hci_event: Mask data status from LE ext adv reports
Date: Tue, 12 Aug 2025 19:29:15 +0200
Message-ID: <20250812173429.205181330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index c79901f2dc2a..5796ca9fe5da 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2634,6 +2634,7 @@ struct hci_ev_le_conn_complete {
 #define LE_EXT_ADV_DIRECT_IND		0x0004
 #define LE_EXT_ADV_SCAN_RSP		0x0008
 #define LE_EXT_ADV_LEGACY_PDU		0x0010
+#define LE_EXT_ADV_DATA_STATUS_MASK	0x0060
 #define LE_EXT_ADV_EVT_TYPE_MASK	0x007f
 
 #define ADDR_LE_DEV_PUBLIC		0x00
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cf4b30ac9e0e..c1dd8d78701f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6239,6 +6239,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 
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
@@ -6270,8 +6275,7 @@ static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 	if (evt_type & LE_EXT_ADV_SCAN_IND)
 		return LE_ADV_SCAN_IND;
 
-	if (evt_type == LE_EXT_ADV_NON_CONN_IND ||
-	    evt_type & LE_EXT_ADV_DIRECT_IND)
+	if (evt_type & LE_EXT_ADV_DIRECT_IND)
 		return LE_ADV_NONCONN_IND;
 
 invalid:
-- 
2.39.5



