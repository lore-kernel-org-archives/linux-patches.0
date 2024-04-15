Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D37AE43;
	Mon, 15 Apr 2024 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191794; cv=none; b=I+WKp8Bh4W1xHiQOsoU6frD8k0x2S8bUmi1e7o+1SvU8+Vth/ctNg7Rtjn63rGTEM3giof7ZZCbx3GH522bUJJV1jmZQ/l+RWSMr7HW+RdiQnVjBOFmuUBnDPy1l35livr0hVeRD81dVpKd6F0PfDTuvQ4dZl/YaRbPAxHeFiXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191794; c=relaxed/simple;
	bh=lzRfgOpWHSyavQZNJZKZwbT0Mv0nKh8YlBUEBNIH4qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUIZKSA//BeULLsX3O5QhCYrWXJsbD6wxH+EF3Bom2jX8K8+hh+xcSwDO7b69UCLoCmUBFAtXe8GQ0K+a+v1VuuIpJiqVofPC/aWVt5LS8tC1n/MTPhl40mo364RDutUfhkD+T6OnhG573XT12m7lDklMYO3D1yafZtLvDiLiJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXbFvAh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXbFvAh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4576C113CC;
	Mon, 15 Apr 2024 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191794;
	bh=lzRfgOpWHSyavQZNJZKZwbT0Mv0nKh8YlBUEBNIH4qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXbFvAh7hM5mlGCdGAXyTDqnb9MJc3+GLxV2fTvrgT8miak10xGotOmGFyT58dkni
	 1CSHN9ok7kc+yTEMVD2SnPFR5eS2aOdetbo5DtlGNmTgB5xhg0DnOPfbpAWVT7roMp
	 ZTtgbHl7X+/heRsy+lWV9G1AyEDTO67nbehF8uwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/122] Bluetooth: hci_sync: Use QoS to determine which PHY to scan
Date: Mon, 15 Apr 2024 16:20:15 +0200
Message-ID: <20240415141954.874385823@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 22cbf4f84c00da64196eb15034feee868e63eef0 ]

This used the hci_conn QoS to determine which PHY to scan when creating
a PA Sync.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 53cb4197e63a ("Bluetooth: hci_sync: Fix using the same interval and window for Coded PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 66 +++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d6c0633bfe5bf..f462e3fb5af05 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2679,6 +2679,14 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	return filter_policy;
 }
 
+static void hci_le_scan_phy_params(struct hci_cp_le_scan_phy_params *cp,
+				   u8 type, u16 interval, u16 window)
+{
+	cp->type = type;
+	cp->interval = cpu_to_le16(interval);
+	cp->window = cpu_to_le16(window);
+}
+
 static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 					  u16 interval, u16 window,
 					  u8 own_addr_type, u8 filter_policy)
@@ -2686,7 +2694,7 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 	struct hci_cp_le_set_ext_scan_params *cp;
 	struct hci_cp_le_scan_phy_params *phy;
 	u8 data[sizeof(*cp) + sizeof(*phy) * 2];
-	u8 num_phy = 0;
+	u8 num_phy = 0x00;
 
 	cp = (void *)data;
 	phy = (void *)cp->data;
@@ -2696,28 +2704,64 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 	cp->own_addr_type = own_addr_type;
 	cp->filter_policy = filter_policy;
 
+	/* Check if PA Sync is in progress then select the PHY based on the
+	 * hci_conn.iso_qos.
+	 */
+	if (hci_dev_test_flag(hdev, HCI_PA_SYNC)) {
+		struct hci_cp_le_add_to_accept_list *sent;
+
+		sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_ACCEPT_LIST);
+		if (sent) {
+			struct hci_conn *conn;
+
+			conn = hci_conn_hash_lookup_ba(hdev, ISO_LINK,
+						       &sent->bdaddr);
+			if (conn) {
+				struct bt_iso_qos *qos = &conn->iso_qos;
+
+				if (qos->bcast.in.phy & BT_ISO_PHY_1M ||
+				    qos->bcast.in.phy & BT_ISO_PHY_2M) {
+					cp->scanning_phys |= LE_SCAN_PHY_1M;
+					hci_le_scan_phy_params(phy, type,
+							       interval,
+							       window);
+					num_phy++;
+					phy++;
+				}
+
+				if (qos->bcast.in.phy & BT_ISO_PHY_CODED) {
+					cp->scanning_phys |= LE_SCAN_PHY_CODED;
+					hci_le_scan_phy_params(phy, type,
+							       interval,
+							       window);
+					num_phy++;
+					phy++;
+				}
+
+				if (num_phy)
+					goto done;
+			}
+		}
+	}
+
 	if (scan_1m(hdev) || scan_2m(hdev)) {
 		cp->scanning_phys |= LE_SCAN_PHY_1M;
-
-		phy->type = type;
-		phy->interval = cpu_to_le16(interval);
-		phy->window = cpu_to_le16(window);
-
+		hci_le_scan_phy_params(phy, type, interval, window);
 		num_phy++;
 		phy++;
 	}
 
 	if (scan_coded(hdev)) {
 		cp->scanning_phys |= LE_SCAN_PHY_CODED;
-
-		phy->type = type;
-		phy->interval = cpu_to_le16(interval);
-		phy->window = cpu_to_le16(window);
-
+		hci_le_scan_phy_params(phy, type, interval, window);
 		num_phy++;
 		phy++;
 	}
 
+done:
+	if (!num_phy)
+		return -EINVAL;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_SCAN_PARAMS,
 				     sizeof(*cp) + sizeof(*phy) * num_phy,
 				     data, HCI_CMD_TIMEOUT);
-- 
2.43.0



