Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1D61459EC;
	Thu, 13 Jun 2024 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281381; cv=none; b=ZC2bsY6nJPbsxGln/FXwl6HZtmIAEFsr3FRJ1jfnHMw6HVh1GoeqfRG/PubPrF4VG4wCT8Lh+sOy+oyDj3ztu4TTrdtvpoXVKGJN8JcO3ryix4vRyFdBdlyqZJt58qznnGVU2m3E9d7WsgWe9CCLHLKI0/xGSvs/svrPTEbWzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281381; c=relaxed/simple;
	bh=wt+/bdMRJybTvPfQdzntDt2VcaVs+6KTsVrBm+ocSdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHuRjhS2BdAcBmEQL55L/oeBFUlpg2zWzpIgIwbatFK4sQULofCYlMbdKYREUcmv7IvBUdIdeC0TY3XSgC1Lbb8sHW6sHloDPOIK6/TzpEpP/BKCWXKFN0mDhjkwyL+/8t9J9lgVNn5sNmEVc928kOIu+7rjP9YohWqJEGs7y+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxK7MLvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxK7MLvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FC0C2BBFC;
	Thu, 13 Jun 2024 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281380;
	bh=wt+/bdMRJybTvPfQdzntDt2VcaVs+6KTsVrBm+ocSdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxK7MLvUYK+Gd2Tptov5AoC22vb+1fD4z0OJkyXQcqBMQPOBusHmitYGB3HDDQymo
	 KOHu5u0QSNIdf74EzD6c2d8FpmHowSSjGUnaJ2BYVjPULle+KXpaUPau3/TAT6imWH
	 6EUSFWihU7Mu40h8Tjnn6aCKKloppjy95RgKox+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d7b4dc6cd50410152534@syzkaller.appspotmail.com
Subject: [PATCH 5.10 228/317] nfc: nci: Fix uninit-value in nci_rx_work
Date: Thu, 13 Jun 2024 13:34:06 +0200
Message-ID: <20240613113256.371860220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit e4a87abf588536d1cdfb128595e6e680af5cf3ed ]

syzbot reported the following uninit-value access issue [1]

nci_rx_work() parses received packet from ndev->rx_q. It should be
validated header size, payload size and total packet size before
processing the packet. If an invalid packet is detected, it should be
silently discarded.

Fixes: d24b03535e5e ("nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet")
Reported-and-tested-by: syzbot+d7b4dc6cd50410152534@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7b4dc6cd50410152534 [1]
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d8002065baaef..7b3f3d6285004 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1452,6 +1452,19 @@ int nci_core_ntf_packet(struct nci_dev *ndev, __u16 opcode,
 				 ndev->ops->n_core_ops);
 }
 
+static bool nci_valid_size(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(NCI_CTRL_HDR_SIZE != NCI_DATA_HDR_SIZE);
+	unsigned int hdr_size = NCI_CTRL_HDR_SIZE;
+
+	if (skb->len < hdr_size ||
+	    !nci_plen(skb->data) ||
+	    skb->len < hdr_size + nci_plen(skb->data)) {
+		return false;
+	}
+	return true;
+}
+
 /* ---- NCI TX Data worker thread ---- */
 
 static void nci_tx_work(struct work_struct *work)
@@ -1502,7 +1515,7 @@ static void nci_rx_work(struct work_struct *work)
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
-		if (!nci_plen(skb->data)) {
+		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
 			break;
 		}
-- 
2.43.0



