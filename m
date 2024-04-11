Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF6F145353;
	Thu, 11 Apr 2024 10:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830821; cv=none; b=KwSczxIk4m44SYe38fgVjGFJFybKRlJLt6NAs2VdgIC48S5887pkB0MZHL9OHbs2FPHsM7omXN8o6YYV5py3GIRugXxdLeix71N5RTp3WV4+K4+3/JecbQvlSISdYzAKa8hpDpJXlfHxc742hz/KKNMATg+oHRxleY9ra4DW/x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830821; c=relaxed/simple;
	bh=ZTBGl2/xDGXqy/33shPqfJAw7xmIWFY6NbpdSfKYpkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCF43Tvh2730xp+y7t1H8po4iXwvc3x34c8qeRCr1z+8yD2dvUJt8UcNFuR60QBqBAA47lAk5N2SCX64HnG6sWx/4g30I+W5GfaZ7CHp+3pRyHhMzk4XOO5zAzfDanCJG6cDRxDzJMtwXjsVVkJuwWHq8NFFX4YVjEBgzDzo/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsF3+acS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsF3+acS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE5EC43390;
	Thu, 11 Apr 2024 10:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830821;
	bh=ZTBGl2/xDGXqy/33shPqfJAw7xmIWFY6NbpdSfKYpkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsF3+acS/rXu0FwlFL4ETOHzJiq/LEkQmShS/wshfAuDBJ7/YKK3Z0nQ2+ZDgbu/R
	 t4GWqiFGdCq5V+y+EW/FUCTtpdOcojIWOSMOvIZwV8SV38RdX1aDh0jtSNGeakt5OW
	 rMbcYHveHitIV5s4NcPLxffQj5kqQOtqAtJkzKM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Jeremy Cline <jeremy@jcline.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com,
	syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Subject: [PATCH 5.4 129/215] nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet
Date: Thu, 11 Apr 2024 11:55:38 +0200
Message-ID: <20240411095428.774042015@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit d24b03535e5eb82e025219c2f632b485409c898f ]

syzbot reported the following uninit-value access issue [1][2]:

nci_rx_work() parses and processes received packet. When the payload
length is zero, each message type handler reads uninitialized payload
and KMSAN detects this issue. The receipt of a packet with a zero-size
payload is considered unexpected, and therefore, such packets should be
silently discarded.

This patch resolved this issue by checking payload size before calling
each message type handler codes.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reported-and-tested-by: syzbot+7ea9413ea6749baf5574@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+29b5ca705d2e0f4a44d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7ea9413ea6749baf5574 [1]
Closes: https://syzkaller.appspot.com/bug?extid=29b5ca705d2e0f4a44d2 [2]
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Jeremy Cline <jeremy@jcline.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index cb2193dec7129..701c3752bda09 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1499,6 +1499,11 @@ static void nci_rx_work(struct work_struct *work)
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
 				     RAW_PAYLOAD_NCI, NFC_DIRECTION_RX);
 
+		if (!nci_plen(skb->data)) {
+			kfree_skb(skb);
+			break;
+		}
+
 		/* Process frame */
 		switch (nci_mt(skb->data)) {
 		case NCI_MT_RSP_PKT:
-- 
2.43.0



