Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931273B2FC1;
	Mon, 23 Mar 2026 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274835; cv=none; b=YR+Cx6cK9iRhh/jDoXPN3f+yiwgjtX/KteCImSFRSH3SBO7kX/QUe8KeIku4Vofa9fDy8oux+q+A3RHaQICFTCuTbmHZgloeWZS5/BvsImbOY5+N3fAuIjtUMPlUoQ/mnTVK140yysj0IfPTLeUgUIRr1ohjYRO6pDEeb7BYf94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274835; c=relaxed/simple;
	bh=EoJToR9SnxbCKQVUK/Ey/OIv4Tt09t/xstUl4o8t3Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sigr4vTNudNrP4buH1TN+XiEk8Ql/Z4WQP9QqfIQK2RZI/vbzcGz0EziGHwIS8hB8lJPlZmVMfSmvkwl2dLr8z/nC1p+DLf0+eTjXZUYOM602joNiIcp3OvE4m+F2zF8IPxLKfjU+YqUq0MdEvRsvvwwCmfv/ivJzqsBtLmbXIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBt2iTml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBt2iTml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F37C4CEF7;
	Mon, 23 Mar 2026 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274835;
	bh=EoJToR9SnxbCKQVUK/Ey/OIv4Tt09t/xstUl4o8t3Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBt2iTml1AoC0RH9rHSGQvxhM4C9eJSqKQxnDT2/C6XHEloz812EMIxk90vdbZRKf
	 +/RQR2HObPX79hXslrKdc5+ZiP/UJx8nNIN6yhrm3/tzRoAA9CcgnKYNlWe+K0F0S4
	 ZhP7ePG6LMIocB094wzLNxuJTVlGkGWOB1fvXkKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/212] Bluetooth: LE L2CAP: Disconnect if received packets SDU exceeds IMTU
Date: Mon, 23 Mar 2026 14:45:43 +0100
Message-ID: <20260323134507.625539787@linuxfoundation.org>
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

[ Upstream commit e1d9a66889867c232657a9b6f25d451d7c3ab96f ]

Core 6.0, Vol 3, Part A, 3.4.3:
"If the SDU length field value exceeds the receiver's MTU, the receiver
shall disconnect the channel..."

This fixes L2CAP/LE/CFC/BV-26-C (running together with 'l2test -r -P
0x0027 -V le_public -I 100').

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 319c87bd795d5..1618fe98dce71 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6654,8 +6654,10 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 		return -ENOBUFS;
 	}
 
-	if (chan->imtu < skb->len) {
-		BT_ERR("Too big LE L2CAP PDU");
+	if (skb->len > chan->imtu) {
+		BT_ERR("Too big LE L2CAP PDU: len %u > %u", skb->len,
+		       chan->imtu);
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		return -ENOBUFS;
 	}
 
@@ -6681,7 +6683,9 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 		       sdu_len, skb->len, chan->imtu);
 
 		if (sdu_len > chan->imtu) {
-			BT_ERR("Too big LE L2CAP SDU length received");
+			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
+			       skb->len, sdu_len);
+			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
 		}
-- 
2.51.0



