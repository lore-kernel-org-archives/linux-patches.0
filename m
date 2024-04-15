Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFBB7FBB2;
	Mon, 15 Apr 2024 14:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191224; cv=none; b=vAjaU7n8d3owBnADZimg2tWiLCCDZoVdtimpzygU0fj11VCNagsOlYPYJxaaT7O9BOs2BtwYM0ieGhzhcfa+jMW4VJ9Re/vg6awxChhj9UuYBN1720uUOnWhWndlAHHAlut6xGubX3U32++MhlTwH0PTXwxviGZj6qEkn8mH+vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191224; c=relaxed/simple;
	bh=l6ub+yZ8ukEHARdDLa7qhaLZLdmfsR6W00sPecuDHfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8ZmTASn87wbVfru+fH05c7kzDhJst3uVtlufYq75f8Op4NoNO5/f+uPtB4XEnmzVwS5Mo+LgKaWG1h+5eg7kixd2lN5RnJA+XDqYpsgEkRnUy9W5eA4mXO5ATn06HK18adpBeIs1qRgmZo7SE+usC9SlW1iLaPHS+0F9Ux4vm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulZOs6l/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulZOs6l/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FBFC113CC;
	Mon, 15 Apr 2024 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191224;
	bh=l6ub+yZ8ukEHARdDLa7qhaLZLdmfsR6W00sPecuDHfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulZOs6l/NJK61al8HocjIZm/bVJIt7UQ9mIRNyo5C0MG5xZy/uyHofYk2f/r18NbE
	 zydFh1zfIs/XgEs7GR5cih/ak2svsIC618/pbK6k+v4mXG7Q+hJfGF7s7vhwBAtzLK
	 3iiFjSNIIsQ5q+2TkhIXQlRXuF4NwtiwtGMkGzXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/172] Bluetooth: hci_sync: Use QoS to determine which PHY to scan
Date: Mon, 15 Apr 2024 16:19:32 +0200
Message-ID: <20240415142002.622421284@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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
index 824ce03bb361b..89bd1c1a3e0e8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2611,6 +2611,14 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
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
@@ -2618,7 +2626,7 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 	struct hci_cp_le_set_ext_scan_params *cp;
 	struct hci_cp_le_scan_phy_params *phy;
 	u8 data[sizeof(*cp) + sizeof(*phy) * 2];
-	u8 num_phy = 0;
+	u8 num_phy = 0x00;
 
 	cp = (void *)data;
 	phy = (void *)cp->data;
@@ -2628,28 +2636,64 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
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



