Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8F116EB4B;
	Sun,  1 Sep 2024 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207741; cv=none; b=jtPBA3VZ05/TLdufE7YNfwcOw03Cq18LqX2z/WBINPzMvqTKUxBzzPSOEJ0/3DK28UAf0PYpYE53uT9kB5k0tYrEbHNDxjJkBFNXPgelLp3DCBkDUmQwAPbyF6pAABNXewfSvaZ5sQH2VP69Rl5N41N56PG6IOEZMhgusyj0FXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207741; c=relaxed/simple;
	bh=9nb111DVIdbO2wzndmZB3uqTiy1SLaozL11AKMWT85M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/O0vb4cgOKtd2BeIkRV4UqmWA8zDRvsgZfE24bMo1UbSyPB5yDhKe8x8DpnquP2hzxZd3cdg2htTYnD3phl5PJzwu3h+PuM9BkL0zsj1UBBhKCA7DOqqK8vrimGW4NWvxROAFtGggWxqgdDWQjv18m74fbzSQYbmNQcStJQt2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES5iJmcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES5iJmcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C366BC4CEC3;
	Sun,  1 Sep 2024 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207741;
	bh=9nb111DVIdbO2wzndmZB3uqTiy1SLaozL11AKMWT85M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES5iJmcbAOGn5QraDMWmQ3vZvVwLuHkDkQJrDWVzNwLVRkTtK43ZsLjU9VbG/aO4Y
	 upOfEJwVTm0WmOsG1QLKuwDGaSP2/mN2V5hAQCIvW5a4x2l5CJzrarPpGZ9CwepxYv
	 rkxJpv3GaijAY8oXAdi2Go7FHt79mQbzkFwMbT4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/98] Bluetooth: hci_core: Fix LE quote calculation
Date: Sun,  1 Sep 2024 18:16:26 +0200
Message-ID: <20240901160805.811360028@linuxfoundation.org>
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
index 3360ae1e4c8ce..bb89ca37decbc 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4121,19 +4121,19 @@ static void hci_sched_le(struct hci_dev *hdev)
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
@@ -4148,18 +4148,13 @@ static void hci_sched_le(struct hci_dev *hdev)
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



