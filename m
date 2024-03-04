Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA827C08B;
	Mon,  4 Mar 2024 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587628; cv=none; b=hgpoxol/dNa3S5qQkUkyB8pitD+kTN4ZxMbJG8k9w6uXKGZcj2x7wOPA49xWiZVP8qg6gScD8j+t5vTPksjUT3n5bTqgs6eQ2ekXW4//R6vX0q97tk+9clScKV1IPcra4+AKzUswxUoIhPWOwrTATZF5ctljuM10+V8MrXMhSFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587628; c=relaxed/simple;
	bh=8kgVeCBY9PloVqgO/TteUux6dd+2W88ZekvH2RZ9DdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjocuflmu2ZAmz54oWf7XGlnowoSKZeTWH0CvIFpjw5+JNL7sFuNXaGUDMSOumoXHFq0wihX8kAcg7woxqJ6lk+2ezp6mW39Y3wvUXFCWDkHu+TInvrfsJMLmwtsQ+Cg0XHAgWoXaxwRaCO62blqSfEIwGGWqmy/gaUYylFy/mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVKODyWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVKODyWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2343C433F1;
	Mon,  4 Mar 2024 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587628;
	bh=8kgVeCBY9PloVqgO/TteUux6dd+2W88ZekvH2RZ9DdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVKODyWz1jdvkiAYD418+9QCURvAVXVlXp3Pav6SQAjoBgmLZqBlQki+/XHoB7HqA
	 ImQFKM6QGUNBSwKFRaqS0QYWh7TlEE33SBq31oW6/k22itiASTmc+G1Q6PphWhD1Fm
	 RwHvsD44eBIcBMVpYqyReVGqzKCd2tNvh69+aFOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/162] Bluetooth: hci_event: Fix wrongly recorded wakeup BD_ADDR
Date: Mon,  4 Mar 2024 21:21:33 +0000
Message-ID: <20240304211552.738338940@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 61a5ab72edea7ebc3ad2c6beea29d966f528ebfb ]

hci_store_wake_reason() wrongly parses event HCI_Connection_Request
as HCI_Connection_Complete and HCI_Connection_Complete as
HCI_Connection_Request, so causes recording wakeup BD_ADDR error and
potential stability issue, fix it by using the correct field.

Fixes: 2f20216c1d6f ("Bluetooth: Emit controller suspend and resume events")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ef8c3bed73617..22b22c264c2a5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7420,10 +7420,10 @@ static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
 	 * keep track of the bdaddr of the connection event that woke us up.
 	 */
 	if (event == HCI_EV_CONN_REQUEST) {
-		bacpy(&hdev->wake_addr, &conn_complete->bdaddr);
+		bacpy(&hdev->wake_addr, &conn_request->bdaddr);
 		hdev->wake_addr_type = BDADDR_BREDR;
 	} else if (event == HCI_EV_CONN_COMPLETE) {
-		bacpy(&hdev->wake_addr, &conn_request->bdaddr);
+		bacpy(&hdev->wake_addr, &conn_complete->bdaddr);
 		hdev->wake_addr_type = BDADDR_BREDR;
 	} else if (event == HCI_EV_LE_META) {
 		struct hci_ev_le_meta *le_ev = (void *)skb->data;
-- 
2.43.0



