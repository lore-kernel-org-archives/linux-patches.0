Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80BF19E7CA;
	Thu,  6 Jun 2024 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683518; cv=none; b=H9yYGjiBxL1eN4ZridT2KHFHuWcenzmDOSe8NgazvyZ8YYcONBMvEDPSpcHAGakbId2XKuy6XgLNteBR6b5hTeKIgcSy8WGUmB0lXrhEWCRuYBa2wlxXWKpK7J8cg0ZN05gN3qqFX/zBJgHunUZ4EA+zgrg1VQmK76WfwD7h3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683518; c=relaxed/simple;
	bh=LVciXXxiKA3QmoA2KaeQgHf3HfhFG5glNwWPav3Zdx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D95bQtfJdDNXoZ9DCvqfOTQPOiTtHL1IR5PvXGA/9n5qjEK6ge6r263LdE8uQCuFpfiO7auKyidz1/Cvg4zS6Ub0CMIX23tvUatST88qXGthWQC49q/3uGAa0xUcBS1K684a/UWwUOIuG4WOFzeuEEIK0q5QVj2p88g0hBTYnG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYkosLdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYkosLdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F73C2BD10;
	Thu,  6 Jun 2024 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683518;
	bh=LVciXXxiKA3QmoA2KaeQgHf3HfhFG5glNwWPav3Zdx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYkosLdXobMLjXvA6+3ncksJrvEo5Tj4aSRSR81a86eFfZLJ6HAF5QO7HWGYFORy3
	 tNYr49kK7CtJqz1165Gxlx2nmCTUyboBhtd32/yZKOAXhcmesyrHSVOY8ZchnDmeXh
	 9ErM5No3zdlZ6kmQEMfM27A7sollYleqAbLKYtiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d7b4dc6cd50410152534@syzkaller.appspotmail.com
Subject: [PATCH 6.1 405/473] nfc: nci: Fix uninit-value in nci_rx_work
Date: Thu,  6 Jun 2024 16:05:34 +0200
Message-ID: <20240606131713.199533611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index f76a2d8060340..6a1d1e1f9a7cc 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1462,6 +1462,19 @@ int nci_core_ntf_packet(struct nci_dev *ndev, __u16 opcode,
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
@@ -1512,7 +1525,7 @@ static void nci_rx_work(struct work_struct *work)
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
-		if (!nci_plen(skb->data)) {
+		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
 			break;
 		}
-- 
2.43.0



