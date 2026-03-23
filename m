Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D543B3BE5;
	Mon, 23 Mar 2026 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283113; cv=none; b=QhUpQeXnQjSL2FDEdNA+JBdh3zJ5v5q270q+ClQmRTXia983ziejWUsnX1uB82uHBPNOkEweg8v+ICOXK/+3CQ2siN5h9cTsG5C24oyefpdAPyWFs0ej6vYjXgNPVopasJUaD9sGG7ARLnwPJgJOCY37+zGiQtXt4/rkuw3hj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283113; c=relaxed/simple;
	bh=QJZe3QMmiIkWSPY6RiVr0KMc66d5lv48orwttDBcwaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5l8oMEPz0m1GcWxhFWmo0I1KNxDq2KEgwLRzd8gqKN2oqRguZbeljG88Ybkahj8mcxIJSY05D2rDPKCDg0r7hptVOD45TI4mu8Cfx4o8DsDrSEDts8fCYu/Bu8Sj5AJYj/QL1b6LBO9Js1pozJuz3klggq3uUG0dJ+ghskTj8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doV+UWZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doV+UWZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CD2C2BC9E;
	Mon, 23 Mar 2026 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283112;
	bh=QJZe3QMmiIkWSPY6RiVr0KMc66d5lv48orwttDBcwaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doV+UWZaes+LQuzMMKN0dEzMq3EolyAqdfhsGgUrd6k/Dyb7SzyweYIkx9EXCn3Ul
	 I4a3pSFOC1CmOKK9t8Fu/qIV+ep2iV6tlrynsn83Pe4Pq/Qczr6+fvFBNHUUTMvbOC
	 eymNnkhzpimAGo2Ny5iWyCHb6M0hRkte7TWrmlXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/481] Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU
Date: Mon, 23 Mar 2026 14:46:27 +0100
Message-ID: <20260323134535.045765626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db62b4f2c5210..e2ca5d95c96be 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7745,6 +7745,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 	if (chan->sdu->len + skb->len > chan->sdu_len) {
 		BT_ERR("Too much LE L2CAP data received");
+		l2cap_send_disconn_req(chan, ECONNRESET);
 		err = -EINVAL;
 		goto failed;
 	}
-- 
2.51.0



