Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543213BFAF7;
	Sat, 12 Sep 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225057; cv=none; b=s8egJjCraAQTCqble5dlDVinSn9gtYF7UEhOhoZ9ywPJuNZkU0Q2vzNd57Z8VvveKWQ3bxAZDs2jVRAbKO7++ru0rIuFH9/Jhun//Pg8z8zRURfu0q9B5s1heo89i2v5nT3xE8P0s/GNsIjQ+Y/SLf71VFfNWyh0vuwlrLjjWq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225057; c=relaxed/simple;
	bh=OMg7MDYHavFAbT7x8GcWyk1Zd2Nfbr6k5kRpcxVT1Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jx8O72bjnrEfn/Y2J0PTU8GFdik0uiVMY9jylGSkFfTliET8ZpK8kl0q3KqGDH16GUzcw9mOi8LBO5AZL+dr93tA6heRcvyNcPG8KeMNZoGJmZLsjpKbiQRYdK8bEYbwq4EHfGnqRLeT0U0WuBZMApiz2ph0hlg4iNdySpQmF4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci7dszOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci7dszOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BA11F000FF;
	Sat, 12 Sep 2026 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225054;
	bh=hz2C7BQ5YnyXPxWznNQ2sLDNQqPLodQ/i+ZFTw1JCC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci7dszOZr+EdUbhMsRFVkgtWvdOgzVqngYxJ+mMjFzlCGmrMl3JuMW7Ng1CuoaE1S
	 WUTOQLoAeD8XwFrOu7l0Nr466n5w9UxR8tIJ6aDfzpexmqEB5sEGbrWbf7sCerJhnC
	 XrFpPFiKmcQO0Qtb0BlwjOiUOthHwOOjOz8d1sBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1119/1424] Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()
Date: Sat, 12 Sep 2026 08:59:11 +0200
Message-ID: <20260912065632.361945582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit d0b15d812688d3f0f3fe1c4426e12814d0c294dc ]

btusb_set_bdaddr_wcn6855() sends the address without swapping byte
order for VSC 0xFC14, but the command expects the address in reversed
byte order compared to other HCI commands like HCI_Create_Connection,
resulting in a wrong BD_ADDR being set.

btmon log on WCN6855 shows VSC 0xFC14 is sent with swapped bytes
11 22 33 44 55 66, and Read BD ADDR returns the expected address
11:22:33:44:55:66:

  < HCI Command: Vendor (0x3f|0x0014) plen 6                  #3 [hci0]
          11 22 33 44 55 66
  > HCI Event: Command Complete (0x0e) plen 4                  #4 [hci0]
        Vendor (0x3f|0x0014) ncmd 1
          Status: Success (0x00)
  < HCI Command: Read BD ADDR (0x04|0x0009) plen 0            #11 [hci0]
  > HCI Event: Command Complete (0x0e) plen 10                #12 [hci0]
        Read BD ADDR (0x04|0x0009) ncmd 1
          Status: Success (0x00)
          Address: 11:22:33:44:55:66 (OUI 11-22-33)

Fix by swapping the input address before issuing the command.

Fixes: b40f58b97386 ("Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4f2dd32d39b04..d920981277133 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2876,14 +2876,15 @@ static int btusb_set_bdaddr_ath3012(struct hci_dev *hdev,
 static int btusb_set_bdaddr_wcn6855(struct hci_dev *hdev,
 				const bdaddr_t *bdaddr)
 {
+	bdaddr_t bdaddr_swapped;
 	struct sk_buff *skb;
-	u8 buf[6];
 	long ret;
 
-	memcpy(buf, bdaddr, sizeof(bdaddr_t));
+	baswap(&bdaddr_swapped, bdaddr);
 
-	skb = __hci_cmd_sync_ev(hdev, 0xfc14, sizeof(buf), buf,
-				HCI_EV_CMD_COMPLETE, HCI_INIT_TIMEOUT);
+	skb = __hci_cmd_sync_ev(hdev, 0xfc14, sizeof(bdaddr_swapped),
+				&bdaddr_swapped, HCI_EV_CMD_COMPLETE,
+				HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		ret = PTR_ERR(skb);
 		bt_dev_err(hdev, "Change address command failed (%ld)", ret);
-- 
2.53.0



