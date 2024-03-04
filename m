Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBD110A35;
	Mon,  4 Mar 2024 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588717; cv=none; b=IdOkeab/CbwaLkOBkRifxE3Fv7e8M6DkJJHU4PSJMi0p2OAHLvVVOSPIr+HqY9JCWtoAsPEuFuocx+CV8AIsuswaelytWeQB/kWdYQ3Rqn5+tqai0uXLJ37g89Gfze/yjP3N8ZVGoSaVjDeLLhf53Voniqc4UYALDri5NntnxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588717; c=relaxed/simple;
	bh=4le4qJs1eI7cacttloYPRkQKGIBljAoHKJwPxp6x7a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcpFfaojRIUiK3QyOexjZbesTrZxyDykQs3SFKWDSaD1zQIPB90Y+fRkywQWOcY2Q8qe+p2WfAfrp1tWmC28rmkL+hfmVdXCY47bGQv9Y409dWaGkvZf4AU9acdjED56rsiRydQKSk4ETIMCbpUFeCsUeWY1isiDXOepy1CdzYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+CTOEoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+CTOEoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA1BC433C7;
	Mon,  4 Mar 2024 21:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588717;
	bh=4le4qJs1eI7cacttloYPRkQKGIBljAoHKJwPxp6x7a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+CTOEoo49xujMEQKcwmmXdgaelOAO8A7vcpMyqFua/vLJ9Owrv6cUQbwNBmIa6ok
	 VkkJThHDZqHxASZRP/76DV7Jxxs2ZSE+XzTl3FCodNhXILUn1qQGgHEUvjPXlzSUxn
	 MFkWfeIro923SuoQ3KZ2QJbSSbXEMTiCo52DfdDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/215] Bluetooth: hci_event: Fix wrongly recorded wakeup BD_ADDR
Date: Mon,  4 Mar 2024 21:21:48 +0000
Message-ID: <20240304211558.430138433@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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
index 56ecc5f97b916..b18f5e5df8ad0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7245,10 +7245,10 @@ static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
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



