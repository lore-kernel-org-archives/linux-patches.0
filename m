Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1507F46EF8D;
	Sat, 12 Sep 2026 10:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210243; cv=none; b=Z86wZvA6zGGw0s8VLiZQWavQ6NzyfbiKyHdaltW5KIVofRAtMMlvuvWGjQxRzZMP4O+BnB0b969Uuexju9LPWZ7vNgAdm0TCt6e2UDuQq/mk9sdqRMWZzN6wpUvA4xEzvjOVQLEXpDEvZ5RqeNMyVWQqzEZzC9yT/GtPjhUzWls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210243; c=relaxed/simple;
	bh=1ZTLBc7RvoOwvK6JmyCtlsGLDv5ACvTzWEWgpr0845U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jphdkIre8wK1IioME3h9a53GS5M0ykj8e9WoVi3H3sgrRgibj54j1hgiIf0pYPeKZ8oNlBi4nN4hK0D26JKYFh379U0qvNnKiBgFyigP8ngM1+JRhV4LMgrgN3sScQvVznTCnh8lgHSLLY9ig488qCtDv91CYy03JrpNG+6z654=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfZyTQtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfZyTQtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F731F000FF;
	Sat, 12 Sep 2026 10:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210241;
	bh=k33LKYcYvDRshvNUxo4ZRBmhF6bD7eYFBQLHjyeF4pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfZyTQtQAMklfbHV7OKU0Qy+brLq6Vx8zRDoeFtyfYMOXUE+gIcmoqx7LtGCW7WRf
	 OX22/QxVvw7Dgqc1F2HaC5K2Vfn+Yksl0CZwtw4NhPybV+p0Pma9plNC6C400y/qb9
	 lcbC7EViLcVpm0mvTkhZxGYWDZWTZ/BRZ6DSKeuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0986/1518] Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()
Date: Sat, 12 Sep 2026 08:52:35 +0200
Message-ID: <20260912065645.763956232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index a869fd15bc896..cc972ddd09785 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3006,14 +3006,15 @@ static int btusb_set_bdaddr_ath3012(struct hci_dev *hdev,
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



