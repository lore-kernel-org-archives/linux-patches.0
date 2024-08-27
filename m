Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372851A0B13;
	Tue, 27 Aug 2024 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770481; cv=none; b=L5BjIAPI4PkwsPOpEhk3++4yAH0xb2hsl8bKmwBtxKlbbZu0Noi3WcDLGtQ2GXF2y1WlY9kIy35mEgda7SLIZ6jgnP0LyH7hvPswRF71pfooxG4+UpLNOyOjw2rkXloDb3UXLfUjEGLFWKVNleKinQluuCRoom95ZVGocKl28j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770481; c=relaxed/simple;
	bh=X0LRK+7eGajU0xinLto5PvrR0JKGdmYogflO97ayhEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwH90Dr5K1tO8w1KwmDdvZbm/+LYIQhCNK5KJeOQ2xcW0eARgVS6bsYuLPLLEBNG/wtyVeiwM9GYO9frc7wQy4tKvUVwacrQgKDlpe4ocBzNzKKjolMniXBgOo3w+HP4Hqwj3YTkMl0TbOtqJXGfLeuQzMAVdLQqRaZYLbK51pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbDfoj04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbDfoj04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC6EC4E679;
	Tue, 27 Aug 2024 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770481;
	bh=X0LRK+7eGajU0xinLto5PvrR0JKGdmYogflO97ayhEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbDfoj04pFRHSnRV+4dtgnFJ5H2AFhmNDS8EYCMLbFks+2Yj/j34XyV/1vYVcgyEA
	 VvMEeQxXqVqe3i/bZfiqWrrYpeVGTmhYZt7woppLpMmFVUVJm5o2seCUItNUPLm5xA
	 uLGSd2S6IjuZwjxXXkuEGSWmDQLN1MkKSqPZ1OSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/341] Bluetooth: hci_core: Fix LE quote calculation
Date: Tue, 27 Aug 2024 16:37:52 +0200
Message-ID: <20240827143852.579094939@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index c137f85a7fed7..e660b3d661dae 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3637,19 +3637,19 @@ static void hci_sched_le(struct hci_dev *hdev)
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
@@ -3664,7 +3664,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 			hci_send_frame(hdev, skb);
 			hdev->le_last_tx = jiffies;
 
-			cnt--;
+			(*cnt)--;
 			chan->sent++;
 			chan->conn->sent++;
 
@@ -3674,12 +3674,7 @@ static void hci_sched_le(struct hci_dev *hdev)
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



