Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED85B24DFF3;
	Mon, 23 Mar 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277297; cv=none; b=o9Sujn+1CLCTRHQlHPWkJd5+EH9eV6IwBj1uC8P2hCW7M3g6SepcUuUMc1Vyo9g6LNahoGc/3Jz32eswkDMkz1Os2pss/+BeKufp+dkCiZTGX/TeSgxWKultN6NOzgGfz5XEDKk74bW1D2VHNZISwcEnG1TFjVTW8qnrv+fGCIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277297; c=relaxed/simple;
	bh=fWfBNHPb5p8Lb+U+P4vUYyQJO7Qp7VDEidVLOCA21Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcQ9/cj2wodtsHP1QHi3sbbiV4vxm3U0sJ+0nVp04ON8P1g9TJw8A3IqqniKeI1WIZr/iU85PXxrixfOF0hc5hIhwFwVaD1tLjZWXYupvRYZ1m90MQNNnwWiP7PQ86ZFtjv+k4s2D83Ycecp1p/Te2s0hYuhEgbFaoOcnVTw4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPqRvqBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPqRvqBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76895C4CEF7;
	Mon, 23 Mar 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277296;
	bh=fWfBNHPb5p8Lb+U+P4vUYyQJO7Qp7VDEidVLOCA21Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPqRvqBaBLpI4p+GPCSf0CTWN7yDv6CvPM9ZgU3D5wJSZ89CKRZN7bnbWl153IU+l
	 soYdwqnzy+HRoxVuxY5t3UOobnq8cz253yl2GetlxCEnowbjV2nW/EJWy6FNCzxnhB
	 5PdfWE23ko6lm12V+plv0AZz42WbZcEV0RNg2u9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/460] Bluetooth: LE L2CAP: Disconnect if received packets SDU exceeds IMTU
Date: Mon, 23 Mar 2026 14:46:16 +0100
Message-ID: <20260323134535.908169454@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a95949bc36b2a..de8e18fe50557 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6619,8 +6619,10 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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
 
@@ -6646,7 +6648,9 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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



