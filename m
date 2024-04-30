Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8641E50A;
	Tue, 30 Apr 2024 11:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475338; cv=none; b=YWW6XiQphRdzRtUXta9ZG/LdTZiRPnfleOK/UAYGKAk58X4MTtizjfuDLq793sa+dhJzfE776CRPCANcavTMn57CdBUreYH2vZiqY+g1x0YWoL8pc5V7ZuHW0BS8hToCd5gDgqRWNWg58/yadf/vOotoLc7qsdSvMPSlwOr2Qfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475338; c=relaxed/simple;
	bh=X16JHhIvIM4aEs2f2OQVqGS5SE8jqtimzoKzEJKQf0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJXT0/bMs/bn96qK3Qai0AaNwe6h110RmX/Ll5l2et0LDZn3k2N9+Pekn7oq7JYPoU2mDCGk/7JyQ8s6rqCkBS8CGCEo5ITxC2zHywf2Sm4PzfsUvOQHjzx3RxgJAxZVaq7JOTj2mHDuq4txiC0qHoB1vAf7TaNL93fFRSopAVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W397aLvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W397aLvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9CEC2BBFC;
	Tue, 30 Apr 2024 11:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475338;
	bh=X16JHhIvIM4aEs2f2OQVqGS5SE8jqtimzoKzEJKQf0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W397aLvywMeogf3RooHoX9tML1pMlzQqYBqL7QtC2WptgG0klV8+yPqjjVZdaefs9
	 zEptid/dauK5ctknI2cqw/7bU/0vBlbIqs4HG+gl5awsRBXp/wHI9MZ46fFAz8WIUa
	 87+ajG8L0TxpJI/VvqHRX2oCR+eIH0dRfD4WFmTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/186] Bluetooth: btusb: Fix triggering coredump implementation for QCA
Date: Tue, 30 Apr 2024 12:38:38 +0200
Message-ID: <20240430103059.954218233@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1976593bc804e..02f38417aae3d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3457,13 +3457,12 @@ static void btusb_dump_hdr_qca(struct hci_dev *hdev, struct sk_buff *skb)
 
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



