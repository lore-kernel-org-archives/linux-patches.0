Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE239288B9;
	Sat, 12 Sep 2026 16:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231285; cv=none; b=WxqVtQVsNJiiUrUyyd4Pnm+XfWEFBHEPSO/9c2rx6ooVt2asXFRhZOJ2D/0jwM200yoNqE+frNQCM0WnJ3tJ3wAIVi/R/vM5rrSavPl1Ue+eIqoHAhr5bqrn8OEZLhu4gFaB8pYom13ORY95hdlVcFdyOshz8UDOywXud/7YM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231285; c=relaxed/simple;
	bh=T/d8uMaF6I1NIwIUfzIyTfe8K8rELSHReh8Azsk4OjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ61QtIJ5e94V9PHIKi5RBn1BvWc1kJ3l11zVIVspUQ1+ar8RGNK/oWlijY2OiJOQYmryDSsDLfxo5ly9d76n8nFKCEYMKrtBPsKDiSLhA89aq8hNqQRsMaAmLmMdwVf4QbVVSlgCEuXSyU2nLBNLb0u+2eTs7pYROzhX90MKoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqzGYuEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqzGYuEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF5C1F000FF;
	Sat, 12 Sep 2026 16:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231283;
	bh=79pA91MQ6R5Fc739zbXssEUo4lPhshYaKI8kJeZvCiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqzGYuEvaV6IB5OjZLDfDuOrPAS3O66371XeKMgFfXcP6kT6no07eGCPzSrdXfQhp
	 2MG4BEehycrnTF8WjYSJHDJFOFLrp0PIRs7R7qe0S2iEOOckOeMg9c1uQ+T5uTSr4m
	 AWQ2ITKDo1eyBfYeBM19C6NPqWOd8sZGHnsv31NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0924/1191] Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()
Date: Sat, 12 Sep 2026 09:00:52 +0200
Message-ID: <20260912065608.986234096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index fab5f7eb34362..acf58aaa551ef 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3218,14 +3218,15 @@ static int btusb_set_bdaddr_ath3012(struct hci_dev *hdev,
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



