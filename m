Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED1116EB4B;
	Sun,  1 Sep 2024 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207852; cv=none; b=DM/Tfevu+eoicz+Zyfyp+F3c0Z/BoqSuNdqd9F69AM7Z2Jd3oSCbCmDJImrcMcVq9eNTURenbIwfA7mUAULZzU0HFcH5Z32I7Ub71vx3gou252IrsqgQ86Z3v9mmYANAKdm2ZcbQBDrcy0b4TwupV9S7mj2sWQI/krSE+Nz2Oys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207852; c=relaxed/simple;
	bh=B+yBR1QlVA9Jjnrl9McYd4+bUUR2xn6hC7zg4potL6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFoLIca/Tu2CKbPSo4Hns0XOVLuMKolFuVNcRFA/X+0FgJmx3ilObF5tj7q+nLaUBjYUJvknK6LWiwaH/bMdzGMFmjOf50oug6MqfaJopzjw0Ca4ZZkQdGs7EhgA3sXl4xoOJa0PPKVcFdy7ZhmYb9pR2eyEEI0/sGMB5tNr5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8PCbNL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8PCbNL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEFBC4CEC3;
	Sun,  1 Sep 2024 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207851;
	bh=B+yBR1QlVA9Jjnrl9McYd4+bUUR2xn6hC7zg4potL6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8PCbNL9uPXvSlkQe5GSBwHtTJtcdTK2liAZ5XTvGgpFs4oj5lc6fPmlk/AcDbSZ/
	 KLpbIlhLTtqzaLmB5mgHFd+Qpn0IAqQwGMDE5bQ8qYyFoEN4hzn7qA9QoHB8SeBagy
	 88sG4QFKFnhEpNs7OYKT4tfnyCgDkMBFHFoggKgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	David Beinder <david@beinder.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/98] Bluetooth: hci_core: Fix not handling link timeouts propertly
Date: Sun,  1 Sep 2024 18:16:25 +0200
Message-ID: <20240901160805.774420695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 116523c8fac05d1d26f748fee7919a4ec5df67ea ]

Change that introduced the use of __check_timeout did not account for
link types properly, it always assumes ACL_LINK is used thus causing
hdev->acl_last_tx to be used even in case of LE_LINK and then again
uses ACL_LINK with hci_link_tx_to.

To fix this __check_timeout now takes the link type as parameter and
then procedure to use the right last_tx based on the link type and pass
it to hci_link_tx_to.

Fixes: 1b1d29e51499 ("Bluetooth: Make use of __check_timeout on hci_sched_le")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: David Beinder <david@beinder.at>
Stable-dep-of: 932021a11805 ("Bluetooth: hci_core: Fix LE quote calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0221aa5785052..3360ae1e4c8ce 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3931,15 +3931,27 @@ static inline int __get_blocks(struct hci_dev *hdev, struct sk_buff *skb)
 	return DIV_ROUND_UP(skb->len - HCI_ACL_HDR_SIZE, hdev->block_len);
 }
 
-static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
+static void __check_timeout(struct hci_dev *hdev, unsigned int cnt, u8 type)
 {
-	if (!hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
-		/* ACL tx timeout must be longer than maximum
-		 * link supervision timeout (40.9 seconds) */
-		if (!cnt && time_after(jiffies, hdev->acl_last_tx +
-				       HCI_ACL_TX_TIMEOUT))
-			hci_link_tx_to(hdev, ACL_LINK);
+	unsigned long last_tx;
+
+	if (hci_dev_test_flag(hdev, HCI_UNCONFIGURED))
+		return;
+
+	switch (type) {
+	case LE_LINK:
+		last_tx = hdev->le_last_tx;
+		break;
+	default:
+		last_tx = hdev->acl_last_tx;
+		break;
 	}
+
+	/* tx timeout must be longer than maximum link supervision timeout
+	 * (40.9 seconds)
+	 */
+	if (!cnt && time_after(jiffies, last_tx + HCI_ACL_TX_TIMEOUT))
+		hci_link_tx_to(hdev, type);
 }
 
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
@@ -3949,7 +3961,7 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 	struct sk_buff *skb;
 	int quote;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, ACL_LINK);
 
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
@@ -3988,8 +4000,6 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	int quote;
 	u8 type;
 
-	__check_timeout(hdev, cnt);
-
 	BT_DBG("%s", hdev->name);
 
 	if (hdev->dev_type == HCI_AMP)
@@ -3997,6 +4007,8 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	else
 		type = ACL_LINK;
 
+	__check_timeout(hdev, cnt, type);
+
 	while (hdev->block_cnt > 0 &&
 	       (chan = hci_chan_sent(hdev, type, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4118,7 +4130,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
 
-	__check_timeout(hdev, cnt);
+	__check_timeout(hdev, cnt, LE_LINK);
 
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
-- 
2.43.0



