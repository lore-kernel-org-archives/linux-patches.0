Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB131C6AB;
	Mon,  4 Mar 2024 21:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589285; cv=none; b=JWd+XetD3h+6YSDHDN9loqVpY0y+XNyuN/DItT4AOa++9TwVZRafoMSwGKmt7J4fatkc5vas3y2mtENEZq3TtUspo33TnCXRStBPXFPxoAFT1Ptkg366kxamyqEbLe8PoAsyaLYopZnaQuOi+u7o3iALYU1R/I6UDXl0XQYdOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589285; c=relaxed/simple;
	bh=obIPPpPoMMtqQHJgE+QgNxjGlngAetdlPMzxXZweF1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz2gzFZYGRXhoTTBSu1GGYYLRv8OAnuHXouhJ+oG7rmJMT/pX1s1mLWWH5uQoNJheqWJueT2Ns6CJZR84tUoJKreqL6L8UHM9oVaoTuFaWsFQmO0W5vrKahh0GIQ+d4i2hXO7qnswcWPRMXda/+Mtrp6/oFAltlkoyedDx6tNi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUmffyxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUmffyxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A9BC43390;
	Mon,  4 Mar 2024 21:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589285;
	bh=obIPPpPoMMtqQHJgE+QgNxjGlngAetdlPMzxXZweF1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUmffyxJPQBJyFYL2qQlmBQJYrXLeTGJgr02CObIti6xvI+gYamJ404MxHR+ghtS1
	 pIyAmH88tkc9qnXx3eXxAsiS1FSHAQLR7doUlTl8RwTSHl2BN3RsItYkMTyVOkeKC2
	 zCFNqcpZOe0aWR+3337fO+asj4FD1tdqfvIN4zOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/84] Bluetooth: hci_event: Fix wrongly recorded wakeup BD_ADDR
Date: Mon,  4 Mar 2024 21:23:49 +0000
Message-ID: <20240304211542.881729927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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
index 2ad2f4647847c..c4a35d4612b05 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6272,10 +6272,10 @@ static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
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



