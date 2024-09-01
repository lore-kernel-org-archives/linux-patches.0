Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4491116B391;
	Sun,  1 Sep 2024 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209599; cv=none; b=XwQbIFmRf5ggq84cGVZRSA28JVlavzgSz0jgUEycEOF/xfrMZ98YMutzIr9oFpbcPsvUE5jfj7zAK2h1jzdaMI9E2uqC2RNKWQ5OXqsaYirnJM1ZwPdPS/97teOlGPsodzyfO1PcqAnS83cYc+7S2/g2/XqnedrAPc70RYh1JXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209599; c=relaxed/simple;
	bh=7dZJwIecKSgIpEp0uz9HjYKlct5uIzKUY5qxJcxaRow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3PD9M+sJVG5t647Bu27Zp+HU1iYo70rLzoRYyrbyobV27JlqXUwrGKqNEMEVxDNlOpUbYTYWb8UlWbio42HAv+QG24Aq6e39+G5O93LOl+C3+bsYnEKPJ24hnFz6IcE/bkcoJfVf/DoXZQRvC2nPVAdaqIRiowIyaIDacBJPcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkZvc9HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkZvc9HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CC4C4CEC3;
	Sun,  1 Sep 2024 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209598;
	bh=7dZJwIecKSgIpEp0uz9HjYKlct5uIzKUY5qxJcxaRow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkZvc9HUqbmOzvW2bDWBw4p0xeDARkn2B43l/1hnNqw1T7+nebswLJpnL8MbKrc3y
	 dwJyN+PlAfQvIl7K/NkKjR2JkQsviHmsCTgxCGOGzYRzAyyHSu92NpERGNN4wKiiHM
	 JHm0CYFpsRW14O85nckZWIFYLdvUOAoA5oONPONw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/151] Bluetooth: hci_core: Fix LE quote calculation
Date: Sun,  1 Sep 2024 18:17:26 +0200
Message-ID: <20240901160817.354106793@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c8c1cd55c0eb0..9787a4c551138 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4685,19 +4685,19 @@ static void hci_sched_le(struct hci_dev *hdev)
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
@@ -4712,7 +4712,7 @@ static void hci_sched_le(struct hci_dev *hdev)
 			hci_send_frame(hdev, skb);
 			hdev->le_last_tx = jiffies;
 
-			cnt--;
+			(*cnt)--;
 			chan->sent++;
 			chan->conn->sent++;
 
@@ -4722,12 +4722,7 @@ static void hci_sched_le(struct hci_dev *hdev)
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



