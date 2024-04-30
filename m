Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845E12B176;
	Tue, 30 Apr 2024 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474193; cv=none; b=hx/lMnKAiC/cEhjwnQ7pH291d16IlcNm0/9rJCIzpkXyBwEmMkkHXxm8jHaAcvq38GJkJ+dYyStOmj0gllMjh+7IXBzB+nmGlwsMFKuxTV6W2N5WTF4JhnPIBDR4ZfT5gxBp6/AfDqyEJzklckhDsGxKMSlPArqIIhUwkZjfOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474193; c=relaxed/simple;
	bh=0sN67SVKhwEfJk6kmHcJ/mwBmZRk2cMAfnrCbldHgLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kak8banUQpj58gQINs8+KZzUJ1CgCnPNlPBMBSFq+t0ape+w+KYlCRO3y0nC8LMBGsSGXNge++RK8ccOcbB1SyLRVZhr1DSMTPWsA6x8OJ6M5pM/4geseTIMsLIMV+GfaraJtfEmJ+Ua9wMNWoPRRNaQuza2zpnZLZTzFuI9sAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMTLvs0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMTLvs0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847C4C2BBFC;
	Tue, 30 Apr 2024 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474192;
	bh=0sN67SVKhwEfJk6kmHcJ/mwBmZRk2cMAfnrCbldHgLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMTLvs0KJq4Fp05wUqFrQBTjYzOLEUhEczcB0u8/jW6Hanp/WZuoJiYPuplEw92fK
	 MuGl7/RFVaZy3SQBBqD3TPPN8xZ69Rx8BQYjNhGv5IehJ5E++BFpKV2OlSqTyhsVpY
	 I6Q8P1Rwll7lYDwkwEafeAdAmkQVM6fUgE/ZSv8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 084/228] Bluetooth: ISO: Reassemble PA data for bcast sink
Date: Tue, 30 Apr 2024 12:37:42 +0200
Message-ID: <20240430103106.227114867@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 168d9bf9c7f01df71e6404cfff66d9c2a8e968fb ]

This adds support to reassemble PA data for a Broadcast Sink
listening socket. This is needed in case the BASE is received
fragmented in multiple PA reports.

PA data is first reassembled inside the hcon, before the BASE
is extracted and stored inside the socket. The length of the
le_per_adv_data hcon array has been raised to 1650, to accommodate
the maximum PA data length that can come fragmented, according to
spec.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      |  5 ++++
 include/net/bluetooth/hci_core.h |  5 ++--
 net/bluetooth/iso.c              | 50 +++++++++++++++++++++++++++++---
 3 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index bfddb648fcc3e..2cfd8d862639f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2053,6 +2053,7 @@ struct hci_cp_le_set_per_adv_params {
 } __packed;
 
 #define HCI_MAX_PER_AD_LENGTH	252
+#define HCI_MAX_PER_AD_TOT_LEN	1650
 
 #define HCI_OP_LE_SET_PER_ADV_DATA		0x203f
 struct hci_cp_le_set_per_adv_data {
@@ -2813,6 +2814,10 @@ struct hci_ev_le_per_adv_report {
 	__u8     data[];
 } __packed;
 
+#define LE_PA_DATA_COMPLETE	0x00
+#define LE_PA_DATA_MORE_TO_COME	0x01
+#define LE_PA_DATA_TRUNCATED	0x02
+
 #define HCI_EV_LE_EXT_ADV_SET_TERM	0x12
 struct hci_evt_le_ext_adv_set_term {
 	__u8	status;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 93e2b17b11267..1da71254caf61 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -735,8 +735,9 @@ struct hci_conn {
 	__u16		le_supv_timeout;
 	__u8		le_adv_data[HCI_MAX_EXT_AD_LENGTH];
 	__u8		le_adv_data_len;
-	__u8		le_per_adv_data[HCI_MAX_PER_AD_LENGTH];
-	__u8		le_per_adv_data_len;
+	__u8		le_per_adv_data[HCI_MAX_PER_AD_TOT_LEN];
+	__u16		le_per_adv_data_len;
+	__u16		le_per_adv_data_offset;
 	__u8		le_tx_phy;
 	__u8		le_rx_phy;
 	__s8		rssi;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index a8b05baa8e5a9..fa6c2e95d5542 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1955,16 +1955,58 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 	ev3 = hci_recv_event_data(hdev, HCI_EV_LE_PER_ADV_REPORT);
 	if (ev3) {
-		size_t base_len = ev3->length;
+		size_t base_len = 0;
 		u8 *base;
+		struct hci_conn *hcon;
 
 		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
 					 iso_match_sync_handle_pa_report, ev3);
-		base = eir_get_service_data(ev3->data, ev3->length,
-					    EIR_BAA_SERVICE_UUID, &base_len);
-		if (base && sk && base_len <= sizeof(iso_pi(sk)->base)) {
+		if (!sk)
+			goto done;
+
+		hcon = iso_pi(sk)->conn->hcon;
+		if (!hcon)
+			goto done;
+
+		if (ev3->data_status == LE_PA_DATA_TRUNCATED) {
+			/* The controller was unable to retrieve PA data. */
+			memset(hcon->le_per_adv_data, 0,
+			       HCI_MAX_PER_AD_TOT_LEN);
+			hcon->le_per_adv_data_len = 0;
+			hcon->le_per_adv_data_offset = 0;
+			goto done;
+		}
+
+		if (hcon->le_per_adv_data_offset + ev3->length >
+		    HCI_MAX_PER_AD_TOT_LEN)
+			goto done;
+
+		memcpy(hcon->le_per_adv_data + hcon->le_per_adv_data_offset,
+		       ev3->data, ev3->length);
+		hcon->le_per_adv_data_offset += ev3->length;
+
+		if (ev3->data_status == LE_PA_DATA_COMPLETE) {
+			/* All PA data has been received. */
+			hcon->le_per_adv_data_len =
+				hcon->le_per_adv_data_offset;
+			hcon->le_per_adv_data_offset = 0;
+
+			/* Extract BASE */
+			base = eir_get_service_data(hcon->le_per_adv_data,
+						    hcon->le_per_adv_data_len,
+						    EIR_BAA_SERVICE_UUID,
+						    &base_len);
+
+			if (!base || base_len > BASE_MAX_LENGTH)
+				goto done;
+
 			memcpy(iso_pi(sk)->base, base, base_len);
 			iso_pi(sk)->base_len = base_len;
+		} else {
+			/* This is a PA data fragment. Keep pa_data_len set to 0
+			 * until all data has been reassembled.
+			 */
+			hcon->le_per_adv_data_len = 0;
 		}
 	} else {
 		sk = iso_get_sock_listen(&hdev->bdaddr, BDADDR_ANY, NULL, NULL);
-- 
2.43.0



