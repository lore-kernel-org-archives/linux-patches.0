Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692CE1C68C;
	Sun,  1 Sep 2024 16:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208928; cv=none; b=auL2VfMlo+mLK3N4T7xgLN4PFy5/a+/uPHSR6KueoGcwFSYYEGZ74SHVFV3cM0LGhRPKfUgKJTLNqUtc4ewis9uAI2qasyY/KUoi+nQdEvysk17eNFfPHJNhvMs+90k7g8v7Ds0Jlj0sYq/64WZ06ZJ9/f7oVMdTNxR6DT5gIs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208928; c=relaxed/simple;
	bh=kCp2z2s7gWkz8I549ukfWwUI2Iv8sCDoEJiBZH6jgaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8IWeaUcXziUSvDIG6UxXYxRPZALD6I0ZAhF4o/fsLQKiNYfkjowxZRUJ3vTSibRQboEpdlHZTs7PhQzU4DeTGzT9SoaGTB3lAmL+HrXF9wqAdTbF3QZVefIMfNtXY9C/K5IYmXCV+rRKq1LgFfemCZl11xtvSTYiJ1cnK+2ZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwdo0xKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwdo0xKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44AEC4CEC3;
	Sun,  1 Sep 2024 16:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208928;
	bh=kCp2z2s7gWkz8I549ukfWwUI2Iv8sCDoEJiBZH6jgaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwdo0xKWAt4PD6k22zdSADnSYTzADEbXrd4Dxw4sTKDM7rndrawEF/WBOomAD5i1Z
	 EXYVes9e0ZRi2vJpiQ5G/7BpDHykfpyo1GQe/cRdGiFQpWc/VI9dmLkooZSF4ZtTNJ
	 9vwJl++vrgq3Jx+N9rN8W7FYBFGwCdF0DdvV/dx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/134] Bluetooth: hci_core: Fix LE quote calculation
Date: Sun,  1 Sep 2024 18:17:08 +0200
Message-ID: <20240901160813.184769409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 932021a11805b9da4bd6abf66fe233cccd59fe0e ]

Function hci_sched_le needs to update the respective counter variable
inplace other the likes of hci_quote_sent would attempt to use the
possible outdated value of conn->{le_cnt,acl_cnt}.

Link: https://github.com/bluez/bluez/issues/915
Fixes: 73d80deb7bdf ("Bluetooth: prioritizing data over HCI")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b6243cb97e8ec..f1e8bda97c106 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4245,19 +4245,19 @@ static void hci_sched_le(struct hci_dev *hdev)
 {
 	struct hci_chan *chan;
 	struct sk_buff *skb;
-	int quote, cnt, tmp;
+	int quote, *cnt, tmp;
 
 	BT_DBG("%s", hdev->name);
 
 	if (!hci_conn_num(hdev, LE_LINK))
 		return;
 
-	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
+	cnt = hdev->le_pkts ? &hdev->le_cnt : &hdev->acl_cnt;
 
-	__check_timeout(hdev, cnt, LE_LINK);
+	__check_timeout(hdev, *cnt, LE_LINK);
 
-	tmp = cnt;
-	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
+	tmp = *cnt;
+	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
 		while (quote-- && (skb = skb_peek(&chan->data_q))) {
 			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
@@ -4272,18 +4272,13 @@ static void hci_sched_le(struct hci_dev *hdev)
 			hci_send_frame(hdev, skb);
 			hdev->le_last_tx = jiffies;
 
-			cnt--;
+			(*cnt)--;
 			chan->sent++;
 			chan->conn->sent++;
 		}
 	}
 
-	if (hdev->le_pkts)
-		hdev->le_cnt = cnt;
-	else
-		hdev->acl_cnt = cnt;
-
-	if (cnt != tmp)
+	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
 }
 
-- 
2.43.0



