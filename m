Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D0224F6;
	Tue,  8 Apr 2025 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111055; cv=none; b=RHlS4fszNHihSLHpwIBQ9gonPq5A1RVADe6CBWu0rpLfb61s6GRFbsh/bQxSKXo3aC3HPizNnGZeHnUiDR8M6woVvLC8DmauB6JYPZgyuipiP/JOjXX6tBmb8RszWfUCnaU+YKNFUO9Pw7MuC0HA5+MRYhaaPVRF8pjAYV9vQ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111055; c=relaxed/simple;
	bh=RCLNQl9CUKfB/R2j6TQOV78azOtrlscMeWdnDQdYehE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4PjRbKqCcSgKNgp/62Sx6zppG1J/4vNBMPgDnfe2hjibJZaHYeq/CNUax1ycLaKnBTmUyPzXtSupdDJMbdKWF1s6LsGNaFF1jXPvwqJzmNPXu9O2BFXjaMxc5lmJNIj8JT2UTX9r6JvIBvMSrmED2av1q34otoi6nhq5UPg16U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPBvMc18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPBvMc18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F86C4CEE5;
	Tue,  8 Apr 2025 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111055;
	bh=RCLNQl9CUKfB/R2j6TQOV78azOtrlscMeWdnDQdYehE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPBvMc18ULizoMibed9jKtFe88hUQnpZOrJHMtVYTY19F9/JjGlgjRg7bSJNZOktD
	 S+d4wc95Almi3yA5H1AkKPsKyBEpZGkVLUlJPZ7o7cSCEOYN5lAr8q/YhkMFzY/FC0
	 Xyj8BRXjoq2cKJZLON2sHN+EZbkiJZNAn34tq0h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Pauli Virtanen <pav@iki.fi>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 256/731] Bluetooth: hci_core: Enable buffer flow control for SCO/eSCO
Date: Tue,  8 Apr 2025 12:42:33 +0200
Message-ID: <20250408104920.237623939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 13218453521d75916dfed55efb8e809bfc03cb4b ]

This enables buffer flow control for SCO/eSCO
(see: Bluetooth Core 6.0 spec: 6.22. Synchronous Flow Control Enable),
recently this has caused the following problem and is actually a nice
addition for the likes of Socket TX complete:

< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> HCI Event: Command Complete (0x0e) plen 11
      Read Buffer Size (0x04|0x0005) ncmd 1
        Status: Success (0x00)
        ACL MTU: 1021 ACL max packet: 5
        SCO MTU: 240  SCO max packet: 8
...
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
< SCO Data TX: Handle 257 flags 0x00 dlen 120
> HCI Event: Hardware Error (0x10) plen 1
        Code: 0x0a

To fix the code will now attempt to enable buffer flow control when
HCI_QUIRK_SYNC_FLOWCTL_SUPPORTED is set by the driver:

< HCI Command: Write Sync Fl.. (0x03|0x002f) plen 1
        Flow control: Enabled (0x01)
> HCI Event: Command Complete (0x0e) plen 4
      Write Sync Flow Control Enable (0x03|0x002f) ncmd 1
        Status: Success (0x00)

On success then HCI_SCO_FLOWCTL would be set which indicates sco_cnt
shall be used for flow contro.

Fixes: 7fedd3bb6b77 ("Bluetooth: Prioritize SCO traffic")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 13 +++++++
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 62 +++++++++++++++-----------------
 net/bluetooth/hci_event.c        |  2 ++
 net/bluetooth/hci_sync.c         | 24 +++++++++++++
 5 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index aa684d2b079fa..6da61c185c949 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -208,6 +208,13 @@ enum {
 	 */
 	HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 
+	/* When this quirk is set consider Sync Flow Control as supported by
+	 * the driver.
+	 *
+	 * This quirk must be set before hci_register_dev is called.
+	 */
+	HCI_QUIRK_SYNC_FLOWCTL_SUPPORTED,
+
 	/* When this quirk is set, the LE states reported through the
 	 * HCI_LE_READ_SUPPORTED_STATES are invalid/broken.
 	 *
@@ -448,6 +455,7 @@ enum {
 	HCI_WIDEBAND_SPEECH_ENABLED,
 	HCI_EVENT_FILTER_CONFIGURED,
 	HCI_PA_SYNC,
+	HCI_SCO_FLOWCTL,
 
 	HCI_DUT_MODE,
 	HCI_VENDOR_DIAG,
@@ -1544,6 +1552,11 @@ struct hci_rp_read_tx_power {
 	__s8     tx_power;
 } __packed;
 
+#define HCI_OP_WRITE_SYNC_FLOWCTL	0x0c2f
+struct hci_cp_write_sync_flowctl {
+	__u8     enable;
+} __packed;
+
 #define HCI_OP_READ_PAGE_SCAN_TYPE	0x0c46
 struct hci_rp_read_page_scan_type {
 	__u8     status;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 8649ad17408bb..f0b49aad519eb 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1858,6 +1858,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define lmp_hold_capable(dev)      ((dev)->features[0][0] & LMP_HOLD)
 #define lmp_sniff_capable(dev)     ((dev)->features[0][0] & LMP_SNIFF)
 #define lmp_park_capable(dev)      ((dev)->features[0][1] & LMP_PARK)
+#define lmp_sco_capable(dev)       ((dev)->features[0][1] & LMP_SCO)
 #define lmp_inq_rssi_capable(dev)  ((dev)->features[0][3] & LMP_RSSI_INQ)
 #define lmp_esco_capable(dev)      ((dev)->features[0][3] & LMP_ESCO)
 #define lmp_bredr_capable(dev)     (!((dev)->features[0][4] & LMP_NO_BREDR))
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 012fc107901a6..94d9147612daf 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3552,42 +3552,27 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 }
 
 /* Schedule SCO */
-static void hci_sched_sco(struct hci_dev *hdev)
+static void hci_sched_sco(struct hci_dev *hdev, __u8 type)
 {
 	struct hci_conn *conn;
 	struct sk_buff *skb;
-	int quote;
+	int quote, *cnt;
+	unsigned int pkts = hdev->sco_pkts;
 
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "type %u", type);
 
-	if (!hci_conn_num(hdev, SCO_LINK))
+	if (!hci_conn_num(hdev, type) || !pkts)
 		return;
 
-	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
-		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
-			BT_DBG("skb %p len %d", skb, skb->len);
-			hci_send_frame(hdev, skb);
-
-			conn->sent++;
-			if (conn->sent == ~0)
-				conn->sent = 0;
-		}
-	}
-}
-
-static void hci_sched_esco(struct hci_dev *hdev)
-{
-	struct hci_conn *conn;
-	struct sk_buff *skb;
-	int quote;
-
-	BT_DBG("%s", hdev->name);
-
-	if (!hci_conn_num(hdev, ESCO_LINK))
-		return;
+	/* Use sco_pkts if flow control has not been enabled which will limit
+	 * the amount of buffer sent in a row.
+	 */
+	if (!hci_dev_test_flag(hdev, HCI_SCO_FLOWCTL))
+		cnt = &pkts;
+	else
+		cnt = &hdev->sco_cnt;
 
-	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
-						     &quote))) {
+	while (*cnt && (conn = hci_low_sent(hdev, type, &quote))) {
 		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
 			BT_DBG("skb %p len %d", skb, skb->len);
 			hci_send_frame(hdev, skb);
@@ -3595,8 +3580,17 @@ static void hci_sched_esco(struct hci_dev *hdev)
 			conn->sent++;
 			if (conn->sent == ~0)
 				conn->sent = 0;
+			(*cnt)--;
 		}
 	}
+
+	/* Rescheduled if all packets were sent and flow control is not enabled
+	 * as there could be more packets queued that could not be sent and
+	 * since no HCI_EV_NUM_COMP_PKTS event will be generated the reschedule
+	 * needs to be forced.
+	 */
+	if (!pkts && !hci_dev_test_flag(hdev, HCI_SCO_FLOWCTL))
+		queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
@@ -3632,8 +3626,8 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev);
-			hci_sched_esco(hdev);
+			hci_sched_sco(hdev, SCO_LINK);
+			hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3688,8 +3682,8 @@ static void hci_sched_le(struct hci_dev *hdev)
 			chan->conn->sent++;
 
 			/* Send pending SCO packets right away */
-			hci_sched_sco(hdev);
-			hci_sched_esco(hdev);
+			hci_sched_sco(hdev, SCO_LINK);
+			hci_sched_sco(hdev, ESCO_LINK);
 		}
 	}
 
@@ -3734,8 +3728,8 @@ static void hci_tx_work(struct work_struct *work)
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
 		/* Schedule queues and send stuff to HCI driver */
-		hci_sched_sco(hdev);
-		hci_sched_esco(hdev);
+		hci_sched_sco(hdev, SCO_LINK);
+		hci_sched_sco(hdev, ESCO_LINK);
 		hci_sched_iso(hdev);
 		hci_sched_acl(hdev);
 		hci_sched_le(hdev);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 903b0b52692aa..ab95e49f042ea 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4442,9 +4442,11 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, void *data,
 			break;
 
 		case SCO_LINK:
+		case ESCO_LINK:
 			hdev->sco_cnt += count;
 			if (hdev->sco_cnt > hdev->sco_pkts)
 				hdev->sco_cnt = hdev->sco_pkts;
+
 			break;
 
 		case ISO_LINK:
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index cf60a8da943a5..14c3ee5c6a1e8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3769,6 +3769,28 @@ static int hci_write_ca_timeout_sync(struct hci_dev *hdev)
 				     sizeof(param), &param, HCI_CMD_TIMEOUT);
 }
 
+/* Enable SCO flow control if supported */
+static int hci_write_sync_flowctl_sync(struct hci_dev *hdev)
+{
+	struct hci_cp_write_sync_flowctl cp;
+	int err;
+
+	/* Check if the controller supports SCO and HCI_OP_WRITE_SYNC_FLOWCTL */
+	if (!lmp_sco_capable(hdev) || !(hdev->commands[10] & BIT(4)) ||
+	    !test_bit(HCI_QUIRK_SYNC_FLOWCTL_SUPPORTED, &hdev->quirks))
+		return 0;
+
+	memset(&cp, 0, sizeof(cp));
+	cp.enable = 0x01;
+
+	err = __hci_cmd_sync_status(hdev, HCI_OP_WRITE_SYNC_FLOWCTL,
+				    sizeof(cp), &cp, HCI_CMD_TIMEOUT);
+	if (!err)
+		hci_dev_set_flag(hdev, HCI_SCO_FLOWCTL);
+
+	return err;
+}
+
 /* BR Controller init stage 2 command sequence */
 static const struct hci_init_stage br_init2[] = {
 	/* HCI_OP_READ_BUFFER_SIZE */
@@ -3787,6 +3809,8 @@ static const struct hci_init_stage br_init2[] = {
 	HCI_INIT(hci_clear_event_filter_sync),
 	/* HCI_OP_WRITE_CA_TIMEOUT */
 	HCI_INIT(hci_write_ca_timeout_sync),
+	/* HCI_OP_WRITE_SYNC_FLOWCTL */
+	HCI_INIT(hci_write_sync_flowctl_sync),
 	{}
 };
 
-- 
2.39.5



