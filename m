Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF5078B4C;
	Mon,  4 Mar 2024 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588237; cv=none; b=Q6AxGXnt+IGMeUmuc79MrrNBke+cV5XCxZ5zOjxURAanSN4zidex+LMyT0Qs7DBzI0XD7UKPDP9A2LDi1gLpHPd4nW8/9VXn7CRstZAbGDGp2AwBoAVkG/qgwY6yMPJW7LLOCoQjwz83hSrUP1gECzWLJAcY2/iTMmuian6I6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588237; c=relaxed/simple;
	bh=MkkW+cAjKMkO0xU08hgbqcjqVsimlvbMSXFiWX43Mmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KicaIUDsWbvwZgSmktCHCq0X9c3qSqIZdqfn0ypwuxGtV+usF0bcbQqGsmZrGoKZY+iShrNfaYxt9GO3W3P3clbhHKzkqWciTQDHHEJLQBXz5nY7ixcJR1qd0osaORpfKVub/j90he5/Sm5t5V/Q7I+vM45HSiTcYYGtaHdAAXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0aPMrBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0aPMrBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F07C433C7;
	Mon,  4 Mar 2024 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588237;
	bh=MkkW+cAjKMkO0xU08hgbqcjqVsimlvbMSXFiWX43Mmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0aPMrBIqseOhmuLFTRc41U3IwFg0O4CI+B+M1cbja1y7iLNIVuhUIFGBuLdGppUI
	 5+yqq28IsGPYkci2tuVUlsE0yCmXotuTonJjPF262WhjRvPQ6cEO84RyfIx224wYyu
	 09qsmOKu7fU3OT99qYwby82g7olqehgnVcwPGwYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/143] Bluetooth: qca: Fix triggering coredump implementation
Date: Mon,  4 Mar 2024 21:22:31 +0000
Message-ID: <20240304211550.937333810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

[ Upstream commit 6abf9dd26bb1699c17d601b9a292577d01827c0e ]

hci_coredump_qca() uses __hci_cmd_sync() to send a vendor-specific command
to trigger firmware coredump, but the command does not have any event as
its sync response, so it is not suitable to use __hci_cmd_sync(), fixed by
using __hci_cmd_send().

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f3fe4deee78da..f9abcc13b4bcd 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1807,13 +1807,12 @@ static int qca_power_on(struct hci_dev *hdev)
 
 static void hci_coredump_qca(struct hci_dev *hdev)
 {
+	int err;
 	static const u8 param[] = { 0x26 };
-	struct sk_buff *skb;
 
-	skb = __hci_cmd_sync(hdev, 0xfc0c, 1, param, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb))
-		bt_dev_err(hdev, "%s: trigger crash failed (%ld)", __func__, PTR_ERR(skb));
-	kfree_skb(skb);
+	err = __hci_cmd_send(hdev, 0xfc0c, 1, param);
+	if (err < 0)
+		bt_dev_err(hdev, "%s: trigger crash failed (%d)", __func__, err);
 }
 
 static int qca_setup(struct hci_uart *hu)
-- 
2.43.0



