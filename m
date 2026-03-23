Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D733C07A;
	Mon, 23 Mar 2026 14:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274838; cv=none; b=tW9Ivc4+/hyUrADoxmfj+OVjRxKWkdBZ9fq1v0qr9TX7UHQKHYD6sZwdcn9S46a1vKbJTWV9bU6eNnmDUMg98c2ecTzTrM3c1DNJlkSGa1gwE9hoUOEVJgr3whaIwR/q0Y/CyYwvGBmtVZikhizs28QULaTC8JMKgingSAuUun8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274838; c=relaxed/simple;
	bh=I1QJvUr4J14ZoegnuhP+Myy11veGfaX8oULfnFduPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvgYMHvJ8/yUG2hANjQGhy3m4Hh5XPFcpOcbIqRmwphINn9MfIT3k2gxidTGiOJq/PiafBQDeQmYuPwd5JuL2WiHmRM8KeAl/MiyY/fs+BnI5eXdHzqBbKpUZLPDIp1XMj5fbJGX5ybOwcRFwfHuKBxZY8pCM/v7jCBo+H81R3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C40LDhfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C40LDhfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96634C4CEF7;
	Mon, 23 Mar 2026 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274837;
	bh=I1QJvUr4J14ZoegnuhP+Myy11veGfaX8oULfnFduPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C40LDhfSuGymT5X+dDa4qKTcmkmg1OMzpdBuhAwNws4Nxgdv1YHaEjHrBsy91HCUD
	 JPy9dCE6vDRERqgTgvDp+qZQKxB1KrGWHdtftsnQxZ8ip3cD9zwUPr8f6a1U+s0npb
	 hTIcWx+MCM0m8eJDRs+q5T5N9P0pNivIb/bX1Vc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/212] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 23 Mar 2026 14:45:44 +0100
Message-ID: <20260323134507.654107457@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1618fe98dce71..05acc2e98f58f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6721,6 +6721,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



