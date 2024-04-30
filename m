Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA612C49E;
	Tue, 30 Apr 2024 10:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474202; cv=none; b=iQjljQrUgdWnJulXtOrEQeBDal2IRZ5PFBUtgzxnARCa8Mbx+DJ6m7jhhnd07Xq1RK3D3EdN+87NnaOgYk1iOVVA3+awmr9huSRW7fwYhxH3Bt/TKFvsiW1MLlVl09EwKT4byTo23h8wg9ImfLLAEmWgmN9B3n8NDSlfqyfKwQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474202; c=relaxed/simple;
	bh=XEjVfg+Vw2DiYZg/SBqVwQlY7bd+Y8uH3NBhPmzUmwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szRtVqZodZK1qNs9CW9wcKten8CummMUh7R3OdP/6npWJzDOpNtgdqh6DeHukgIQrsKUF7+WWFbmxM7bo/kGLCM6IQ602P3Ap2K/ZXpVdBc7nLJwTtodo+0FLMOOtLv41qydDK2bBzxTxGJm58WW9dLDPzfLdh8htGqFPX1tu94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1kEhk8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1kEhk8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85022C2BBFC;
	Tue, 30 Apr 2024 10:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474201;
	bh=XEjVfg+Vw2DiYZg/SBqVwQlY7bd+Y8uH3NBhPmzUmwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1kEhk8MqEkA2jjgXK0cmrH+Zvrfm7261rXVf+Aj2zP7kOW6aWqKGGF25s2L9+1M2
	 Z4Ka3NQAnbxp0I+2+MFv0tTbb2GkzTUVyluQyK+FVY547O852G6Wu/oHr89+UrmqY4
	 6TuwSB1HI/d2ptZRXwaDOe8hVmekyyzygMYB5oV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/228] Bluetooth: btusb: Fix triggering coredump implementation for QCA
Date: Tue, 30 Apr 2024 12:37:44 +0200
Message-ID: <20240430103106.284111763@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit b23d98d46d2858dcc0fd016caff165cbdc24e70a ]

btusb_coredump_qca() uses __hci_cmd_sync() to send a vendor-specific
command to trigger firmware coredump, but the command does not
have any event as its sync response, so it is not suitable to use
__hci_cmd_sync(), fixed by using __hci_cmd_send().

Fixes: 20981ce2d5a5 ("Bluetooth: btusb: Add WCN6855 devcoredump support")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f684108dc2f1c..58faada874f5c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3463,13 +3463,12 @@ static void btusb_dump_hdr_qca(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void btusb_coredump_qca(struct hci_dev *hdev)
 {
+	int err;
 	static const u8 param[] = { 0x26 };
-	struct sk_buff *skb;
 
-	skb = __hci_cmd_sync(hdev, 0xfc0c, 1, param, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb))
-		bt_dev_err(hdev, "%s: triggle crash failed (%ld)", __func__, PTR_ERR(skb));
-	kfree_skb(skb);
+	err = __hci_cmd_send(hdev, 0xfc0c, 1, param);
+	if (err < 0)
+		bt_dev_err(hdev, "%s: triggle crash failed (%d)", __func__, err);
 }
 
 /*
-- 
2.43.0



