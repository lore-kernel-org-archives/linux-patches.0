Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341529B78F;
	Sat, 12 Sep 2026 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217623; cv=none; b=IrK0wSDPZLj1y87sSfPT+O+gvAgLkIyuaxp1cyu+f0+uB5vgNCzD4+HzkNkPlikghyEfnFqUSM5zl069CXh0Ch2t/1sWdkuU0TzKDSMBdDbrygg7qLmsaZz+rmZFF+A2a0Pb7pBch6mbZBFv0oy9sXKVIm+f9wQNuB+EKBMkEcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217623; c=relaxed/simple;
	bh=InsT9UIT00uThdU60Lm0Lck0Q41XNyoskvLsVvnsIrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0fSGrbhanNHfOw9/ZZVfP1PfLlw2su9VY8X+PYjij45hU19676P74E9rYE2W45gN0yQnvDC0kguVF3tRQWLEHL/MDCfSUZcynl7V5N7qoF7JB5TJoxihcCHempLV8uyDYwnEwuBXl8AqNLSRGvqSlrWBGwgBiBrQsOZtIJDMTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBGjKagb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBGjKagb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125C51F000FF;
	Sat, 12 Sep 2026 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217622;
	bh=3cdmE17BuYuFkFEFlgbHUYO6WF4vszjuQqKvWc+gIl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBGjKagbvkwfsIgGZsln/tu57NHlyk9Ss4Z96GtE0zHV0SY2EjgXGzCUuzgqHVglU
	 X6nuruz4zjxJ+DvbZ4Jb97HkcE6KTr8pfRJ7eOBVtCxj9Aiy/hq5xBVg1W6OlNaKFG
	 gg2cJndp/uyeM3i32V9R6bj9nbuPpdkxWAaZKEMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0969/1376] Bluetooth: btqca: Fix qca_set_bdaddr() waiting for wrong HCI event
Date: Sat, 12 Sep 2026 08:56:35 +0200
Message-ID: <20260912065629.160663144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 083a599eec74d..c6709791d59cc 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -996,8 +996,7 @@ int qca_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
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



