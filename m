Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC62A59;
	Thu, 13 Jun 2024 12:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282557; cv=none; b=oF4lNgoheVsdlwEgeGWv6BzWiH1MZCjtDZqEnrNHzbgv3oUMzIYK0hh1TeloKcqortqs0YvLsotoxrUZ/dm05N2Pczl5i6cBXJcAB/z5vPShmKd0iyY8dGJnaX09AQCQUluvnRVwVx045oTmQOXPbAV0hDwa0Ei8qHReFp32HoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282557; c=relaxed/simple;
	bh=QHrpHnBt/O/fTbwPwBAjUMcleCn7VdjVdPK8cvzkJ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky5bMVbH+O/Fu2yOyujNkvvSbWN6/4YKW1ebUiVSFgwRNL9RZvOBWpxTmf1WQzhse8NTl91Tzol/0qyz2oC8oXKh8paHkJugbWuuEAd56AGMely5TYmxHN+56K0Zx1jo4BzW1oZmR4CD8NmUgbsY8xHkSsp1A6RYR+UD4I9gyGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0Xz1Hxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0Xz1Hxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C1BC2BBFC;
	Thu, 13 Jun 2024 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282557;
	bh=QHrpHnBt/O/fTbwPwBAjUMcleCn7VdjVdPK8cvzkJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0Xz1HxxicSzzcGpwisUZcQjfDkHRlhScEGRtwIqmR7W3gTs4bSPnGc8u/1VCJXW9
	 okEdeBBTux8WovGr8JNx6BtlLgZTEE2Rx+f0Xa6zZSL84RCiN2mTQJl+sDFBXPNpsV
	 jlxbbQLrS8H1pZcDFOwVcu9Ikco7rqeAqKk7oZwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d7b4dc6cd50410152534@syzkaller.appspotmail.com
Subject: [PATCH 5.15 286/402] nfc: nci: Fix uninit-value in nci_rx_work
Date: Thu, 13 Jun 2024 13:34:03 +0200
Message-ID: <20240613113313.309189124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 net/nfc/nci/core.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1466,6 +1466,19 @@ int nci_core_ntf_packet(struct nci_dev *
 				 ndev->ops->n_core_ops);
 }
 
+static bool nci_valid_size(struct sk_buff *skb)
+{
+	unsigned int hdr_size = NCI_CTRL_HDR_SIZE;
+	BUILD_BUG_ON(NCI_CTRL_HDR_SIZE != NCI_DATA_HDR_SIZE);
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
@@ -1516,7 +1529,7 @@ static void nci_rx_work(struct work_stru
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
-		if (!nci_plen(skb->data)) {
+		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
 			break;
 		}


