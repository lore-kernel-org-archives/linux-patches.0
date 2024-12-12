Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385C21576E;
	Thu, 12 Dec 2024 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018805; cv=none; b=PchOAnqwx7GOo3QMxwNFD7G7ybgR0ShCj5FRtwRmb6KicrXfQWr3vXqSriSFD+/o9bWCerN4tKHrzJ7q7rEbXo9KSIfwd0QAtPc0f2zBTQm0BedlijZeM3Ko/ySN0kByXiuSqQg+cJN7Qy1E2DsGarAm1Gv4spoNFboe7WrAOF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018805; c=relaxed/simple;
	bh=ViOI00JDkvoDsA0G7ptylRfxwmHhvHf6SJEUMF9SCGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpe3xgd3pgfh8PnQKuUJR3DYqjC1YyR8yNyi4kOrL2Xn3RW2cQYR8EEWAZmmCw09Z6yc0rXY1RP0h//SAFYWMyL7Ec1yERD4iDrcYhf34rE8UIaBUroQy8ND7fK1g+LAEmByTJKH4ZgXOFx01yh5wmrWYQmiE8fqOLL9WLXvsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcz8vQEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcz8vQEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A081C4CECE;
	Thu, 12 Dec 2024 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018805;
	bh=ViOI00JDkvoDsA0G7ptylRfxwmHhvHf6SJEUMF9SCGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcz8vQEA+aE/vebWCAAFHnUEzHdw9+zXMmg2OGXraPE37j9/gzok/B/iv8obAvBNj
	 eP5/+hpJp6XHr4TaFOZ6WX4CoIfPN8+u0UMXBmhjwPLJbHI9+0u2xprqX1HiAHYlyp
	 ypn7HGV9eqHpXDQ11fkzbAyu4eI5uRT8EqwdFcLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jiaymao <quic_jiaymao@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/772] Bluetooth: MGMT: Fix possible crash on mgmt_index_removed
Date: Thu, 12 Dec 2024 15:49:44 +0100
Message-ID: <20241212144351.553920247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f53e1c9c726d83092167f2226f32bd3b73f26c21 ]

If mgmt_index_removed is called while there are commands queued on
cmd_sync it could lead to crashes like the bellow trace:

0x0000053D: __list_del_entry_valid_or_report+0x98/0xdc
0x0000053D: mgmt_pending_remove+0x18/0x58 [bluetooth]
0x0000053E: mgmt_remove_adv_monitor_complete+0x80/0x108 [bluetooth]
0x0000053E: hci_cmd_sync_work+0xbc/0x164 [bluetooth]

So while handling mgmt_index_removed this attempts to dequeue
commands passed as user_data to cmd_sync.

Fixes: 7cf5c2978f23 ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
Reported-by: jiaymao <quic_jiaymao@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[Xiangyu: BP to fix CVE: CVE-2024-49951, Minor conflict resolution]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5a1015ccc0635..82edd9981ab07 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1457,10 +1457,15 @@ static void cmd_status_rsp(struct mgmt_pending_cmd *cmd, void *data)
 
 static void cmd_complete_rsp(struct mgmt_pending_cmd *cmd, void *data)
 {
-	if (cmd->cmd_complete) {
-		u8 *status = data;
+	struct cmd_lookup *match = data;
+
+	/* dequeue cmd_sync entries using cmd as data as that is about to be
+	 * removed/freed.
+	 */
+	hci_cmd_sync_dequeue(match->hdev, NULL, cmd, NULL);
 
-		cmd->cmd_complete(cmd, *status);
+	if (cmd->cmd_complete) {
+		cmd->cmd_complete(cmd, match->mgmt_status);
 		mgmt_pending_remove(cmd);
 
 		return;
@@ -9424,14 +9429,14 @@ void mgmt_index_added(struct hci_dev *hdev)
 void mgmt_index_removed(struct hci_dev *hdev)
 {
 	struct mgmt_ev_ext_index ev;
-	u8 status = MGMT_STATUS_INVALID_INDEX;
+	struct cmd_lookup match = { NULL, hdev, MGMT_STATUS_INVALID_INDEX };
 
 	if (test_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks))
 		return;
 
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		mgmt_pending_foreach(0, hdev, cmd_complete_rsp, &status);
+		mgmt_pending_foreach(0, hdev, cmd_complete_rsp, &match);
 
 		if (hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
 			mgmt_index_event(MGMT_EV_UNCONF_INDEX_REMOVED, hdev,
@@ -9489,7 +9494,7 @@ void mgmt_power_on(struct hci_dev *hdev, int err)
 void __mgmt_power_off(struct hci_dev *hdev)
 {
 	struct cmd_lookup match = { NULL, hdev };
-	u8 status, zero_cod[] = { 0, 0, 0 };
+	u8 zero_cod[] = { 0, 0, 0 };
 
 	mgmt_pending_foreach(MGMT_OP_SET_POWERED, hdev, settings_rsp, &match);
 
@@ -9501,11 +9506,11 @@ void __mgmt_power_off(struct hci_dev *hdev)
 	 * status responses.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
-		status = MGMT_STATUS_INVALID_INDEX;
+		match.mgmt_status = MGMT_STATUS_INVALID_INDEX;
 	else
-		status = MGMT_STATUS_NOT_POWERED;
+		match.mgmt_status = MGMT_STATUS_NOT_POWERED;
 
-	mgmt_pending_foreach(0, hdev, cmd_complete_rsp, &status);
+	mgmt_pending_foreach(0, hdev, cmd_complete_rsp, &match);
 
 	if (memcmp(hdev->dev_class, zero_cod, sizeof(zero_cod)) != 0) {
 		mgmt_limited_event(MGMT_EV_CLASS_OF_DEV_CHANGED, hdev,
-- 
2.43.0



