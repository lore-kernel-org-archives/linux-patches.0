Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B10157A48;
	Tue,  9 Jul 2024 11:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523658; cv=none; b=Usr1qggBcNs5s+hZm255IyiM4vIs24UKEyaceUeBzedP7829qkKnbiXQ1/XXaY7qqhcNbloHLb6H1u5NIeYbCUD4OWBl8qndMAGltwkCBqu1r+0iucyOuyxnRw1PMp124FAhIFZ0jMU8Xz+OqDy6hzBMJiie0+GBl+IEnd1Sh58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523658; c=relaxed/simple;
	bh=4VJhmpcFRIepwSRgJiLVsvh8GzSPYzzNkNMD9y16El8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NjLedUyOZfzd/P+f+PJb/xRnT1OTay/gkc5GIbwmy8g9HeC2FHMJ0sqOQ6XReoIY1myWxRpbfuNraBEzYh3CDdfjydICo9GNnej3yn4kvgWuKsHADhRbYQBT/tdKGHBEOvP04/tZS6Yum4mBmNFe0xtwIr9B/ZXOIA4Hd3oche8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSaImx16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSaImx16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E48CC3277B;
	Tue,  9 Jul 2024 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523658;
	bh=4VJhmpcFRIepwSRgJiLVsvh8GzSPYzzNkNMD9y16El8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSaImx16YpoWhOknXNdFsD7F6J130U9wlTx2dBpDVHA5Wcd9VoUTg1zLWrtgCg6A9
	 zu7OR+zMDBmuLzG5TBymkpsluxlYqhqnH24nM7bw+u1lFAsOw0zOs9vjxTs+qOcF0R
	 XzQAVo/3eyHem1o+kF1g2rImpv9wSbzPFYUVNn4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/139] Bluetooth: hci_event: Fix setting of unicast qos interval
Date: Tue,  9 Jul 2024 13:09:26 +0200
Message-ID: <20240709110700.728161902@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ac65ecccae802417ce42e857defacad60e4b8329 ]

qos->ucast interval reffers to the SDU interval, and should not
be set to the interval value reported by the LE CIS Established
event since the latter reffers to the ISO interval. These two
interval are not the same thing:

BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 6, Part G

Isochronous interval:
The time between two consecutive BIS or CIS events (designated
ISO_Interval in the Link Layer)

SDU interval:
The nominal time between two consecutive SDUs that are sent or
received by the upper layer.

So this instead uses the following formula from the spec to calculate
the resulting SDU interface:

BLUETOOTH CORE SPECIFICATION Version 5.4 | Vol 6, Part G
page 3075:

Transport_Latency_C_To_P = CIG_Sync_Delay + (FT_C_To_P) ×
ISO_Interval + SDU_Interval_C_To_P
Transport_Latency_P_To_C = CIG_Sync_Delay + (FT_P_To_C) ×
ISO_Interval + SDU_Interval_P_To_C

Link: https://github.com/bluez/bluez/issues/823
Fixes: 2be22f1941d5 ("Bluetooth: hci_event: Fix parsing of CIS Established Event")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6ce4f812503f4..ffb7d43597a2d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6646,6 +6646,7 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 	struct bt_iso_qos *qos;
 	bool pending = false;
 	u16 handle = __le16_to_cpu(ev->handle);
+	u32 c_sdu_interval, p_sdu_interval;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
@@ -6670,12 +6671,25 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 
 	pending = test_and_clear_bit(HCI_CONN_CREATE_CIS, &conn->flags);
 
-	/* Convert ISO Interval (1.25 ms slots) to SDU Interval (us) */
-	qos->ucast.in.interval = le16_to_cpu(ev->interval) * 1250;
-	qos->ucast.out.interval = qos->ucast.in.interval;
+	/* BLUETOOTH CORE SPECIFICATION Version 5.4 | Vol 6, Part G
+	 * page 3075:
+	 * Transport_Latency_C_To_P = CIG_Sync_Delay + (FT_C_To_P) ×
+	 * ISO_Interval + SDU_Interval_C_To_P
+	 * ...
+	 * SDU_Interval = (CIG_Sync_Delay + (FT) x ISO_Interval) -
+	 *					Transport_Latency
+	 */
+	c_sdu_interval = (get_unaligned_le24(ev->cig_sync_delay) +
+			 (ev->c_ft * le16_to_cpu(ev->interval) * 1250)) -
+			get_unaligned_le24(ev->c_latency);
+	p_sdu_interval = (get_unaligned_le24(ev->cig_sync_delay) +
+			 (ev->p_ft * le16_to_cpu(ev->interval) * 1250)) -
+			get_unaligned_le24(ev->p_latency);
 
 	switch (conn->role) {
 	case HCI_ROLE_SLAVE:
+		qos->ucast.in.interval = c_sdu_interval;
+		qos->ucast.out.interval = p_sdu_interval;
 		/* Convert Transport Latency (us) to Latency (msec) */
 		qos->ucast.in.latency =
 			DIV_ROUND_CLOSEST(get_unaligned_le24(ev->c_latency),
@@ -6689,6 +6703,8 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 		qos->ucast.out.phy = ev->p_phy;
 		break;
 	case HCI_ROLE_MASTER:
+		qos->ucast.in.interval = p_sdu_interval;
+		qos->ucast.out.interval = c_sdu_interval;
 		/* Convert Transport Latency (us) to Latency (msec) */
 		qos->ucast.out.latency =
 			DIV_ROUND_CLOSEST(get_unaligned_le24(ev->c_latency),
-- 
2.43.0



