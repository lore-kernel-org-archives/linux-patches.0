Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B08313298;
	Mon, 13 Apr 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099075; cv=none; b=G7h8/9IuiqxBa4+kHFLdYtUXK4ULMoWvsKgg7YvcFslW5PGTNhMfitBAAInq1awcWkaw3JiVFrrCRTS3h6T8uEo5YOzwl+IfLsw51B1JVTraATy1mwxrmpCOigi2G0APcKGdHzCzCfw7axBFEGl0w/KpVA54kn29R6A4RrGrU/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099075; c=relaxed/simple;
	bh=XMGdH1tlr2C5pIR7II/aciCnFxTu5JGUj1k3jh3Mfe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBK2uNYk1IYz9d1seqoS/jdbq607I2avmPio70Nwgl0rz4UWQqHOIgJyrMEXssEJjtrve3i+2DvqZja9dU8Lrbe3YWRzZ+NBuKR23CqRylfGfaB1htiwW7j2EsOxZvB/uERjws+K6rRVGELO1LzsvzKRtLiyazHyytGn+JJOGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWCC+2BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWCC+2BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8D4C2BCAF;
	Mon, 13 Apr 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099075;
	bh=XMGdH1tlr2C5pIR7II/aciCnFxTu5JGUj1k3jh3Mfe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWCC+2BHIzQNUAKfLa/C99wtokMKnIMdkDpiN3ot8Omd76gDEYuz+UUkI0xoQ0BVu
	 sbef8mNm2b/agN3OntC0KG+saDK4J/h749E7Z6C9Dx3lFa7Ualz+ZJZRgxpkymT2mO
	 +XK9f1HCH1hdNQvK/AeJQFIirNX247zB39BY4RNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/491] Bluetooth: LE L2CAP: Disconnect if received packets SDU exceeds IMTU
Date: Mon, 13 Apr 2026 17:57:25 +0200
Message-ID: <20260413155826.560404512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bac2abce4bd78..9c1d68b1e83b5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7639,8 +7639,10 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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
 
@@ -7665,7 +7667,9 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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



