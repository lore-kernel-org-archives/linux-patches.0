Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D103624CC;
	Sat, 12 Sep 2026 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225052; cv=none; b=YyOB4WZUBGbwzn/GypYz36GKaOdm5O3k3c0ym4zJnS3xXeMvN5vnn35vAjCC19zW/cUYoyLMQTtipsSouf0xhNrzQt//RneLHkLz3UX4xzJ30V7WNIAs5x9ORR0L/K+aAmqpSXNkLYBcpmE2IUErEAERWrEPMK7p/xT9KNYSp2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225052; c=relaxed/simple;
	bh=8fvZm7wEksSbuWj6MsuT06n1HfD1SK36ncsl501QR1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDrIK4+PQWZUXS8s3nB77odMlL6sZsybclbjwRFWyLrUycj9qHdIeEiFpvUMAUzM9+TP0/2z2W79mn5Pd5PpyN9aW8Cof8/N8xIidWdH3yuOKFrvubiRPhBUxQ6wx7eX70wlTG7Zx6os0gQOx6bb6YGb1YpJuxeQn6K5A+LXq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqr9m39z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqr9m39z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA971F000FF;
	Sat, 12 Sep 2026 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225049;
	bh=Rw0+/3T9OJ4hzl/YjAcdwTcs60Ijt+frPSUOTCsL1I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqr9m39z4Sn2sytJEbmikPLGWtPo9c2K2droLKTllzIjnExwOM2fo5Ey1eWPSiwhm
	 Qo3cKIh1Q3v9o4lyYnS/WQNX2iG7tTfdn0yzDDcLvgvG2ZcrMWcYzZ3rG0C8uO8UMb
	 mRXNNRfEOz2FfYemMx3QhnqRs0BxWBhUHGwXA92E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1118/1424] Bluetooth: btqca: Fix qca_set_bdaddr() waiting for wrong HCI event
Date: Sat, 12 Sep 2026 08:59:10 +0200
Message-ID: <20260912065632.339199371@linuxfoundation.org>
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

[ Upstream commit cf81f0a3db2a5c34ee6e4ea379c631fab6d13e01 ]

qca_set_bdaddr() waits for HCI_EV_VENDOR when sending
EDL_WRITE_BD_ADDR_OPCODE (0xFC14), but the controller responds with
Command Complete event as confirmed by btmon on WCN7850:

  < HCI Command: Vendor (0x3f|0x0014) plen 6                    #3 [hci0]
          11 22 33 44 55 66
  > HCI Event: Command Complete (0x0e) plen 4                    #4 [hci0]
        Vendor (0x3f|0x0014) ncmd 1
          Status: Success (0x00)

Fix by passing 0 as the event parameter to __hci_cmd_sync_ev() to
wait for the command complete event instead.

Fixes: 5c0a1001c8be ("Bluetooth: hci_qca: Add helper to set device address")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 09ef7df5c231b..a5f80e4aa0e26 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -1018,8 +1018,7 @@ int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
 	baswap(&bdaddr_swapped, bdaddr);
 
 	skb = __hci_cmd_sync_ev(hdev, EDL_WRITE_BD_ADDR_OPCODE, 6,
-				&bdaddr_swapped, HCI_EV_VENDOR,
-				HCI_INIT_TIMEOUT);
+				&bdaddr_swapped, 0, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		err = PTR_ERR(skb);
 		bt_dev_err(hdev, "QCA Change address cmd failed (%d)", err);
-- 
2.53.0



