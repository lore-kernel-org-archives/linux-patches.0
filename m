Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DB26CE32;
	Mon, 13 Apr 2026 16:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097728; cv=none; b=odVNJ11V/ZKyP0QRqCcgOt+nA4OH2y/MzR5PmIv5xrnkusN79i6xhO51Tt1u99s0ZFNBRWD185VxWtJ5XYq1yFNtIdEzgb/6guNRvxLfTI2j1KSzSd3/mvC7iVpFBUqWdi+MpksD2T+7/LKF2pGrjgbD3xfpeBk3QA2FJdfwWz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097728; c=relaxed/simple;
	bh=W8RzWa1+2AFvTkRebMuGx07N15OyMQ8Zj07+oTIBHKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEhxbHh+PXrbpjjW2pLsaD925nWR3P3Ll8P/+HQoSKYN+K0FbPymStLvnL+IOCYSo/Ba40/khy4C5Gfw+XfDO/5JlzyN48vnc48B7m4zFwrZosJFEDhVqMUADDC7gQVOmJbOTXDnjYcF56KzSOWVaozDvbZpDWvTRaXOFjhyX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJF/fwlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJF/fwlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4225C2BCAF;
	Mon, 13 Apr 2026 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097728;
	bh=W8RzWa1+2AFvTkRebMuGx07N15OyMQ8Zj07+oTIBHKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJF/fwlDXRLk1RbyCxDJVIQS0RThcPpqWruBF/xSd/pec36tVrEpt9QkJJz0TR9mQ
	 cUZd/0eauJluYzBkJUPsjViv5I2w4HGNwGaikL1uL5eBnTwzYP+9K/gxolQg1j2L9i
	 1jj/cTZI0L+oCfCpqi2xGl7Vpxepjq3G5u5Mlvvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/570] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 13 Apr 2026 17:56:20 +0200
Message-ID: <20260413155839.794303662@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit b6a2bf43aa37670432843bc73ae2a6288ba4d6f8 ]

Core 6.0, Vol 3, Part A, 3.4.3:
"... If the sum of the payload sizes for the K-frames exceeds the
specified SDU length, the receiver shall disconnect the channel."

This fixes L2CAP/LE/CFC/BV-27-C (running together with 'l2test -r -P
0x0027 -V le_public').

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 601a4d9e4cdde..5010c200b2c41 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7695,6 +7695,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



