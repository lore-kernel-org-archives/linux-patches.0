Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5361E48E;
	Thu, 11 Apr 2024 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832714; cv=none; b=b7vjYvzQ8wKF0YP2KJvsC3TGDlgdBpJ/mlXsvC6tsxNo3p+pFRoNcWMDfCF2XD5zLa0RuQqH42862l87PntosNxD3cFCYlAspPmR4tAf4+RqrJf6UR/BgFJdrvq42PCqsloxgOhEutA8aJpSNQ6DEz/9Nb3ToZBWNVVNmzJFtTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832714; c=relaxed/simple;
	bh=sOsRpGnugiFiKbA7c2SiJjuDTrWUrT/ReJGJg+IlsyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOHEzVKuDeXFhF2PINclLGgF8VhHJl4a8fx0FxpsxkLz6ugJ6szMw8/r7UMGFKIAS3Z9wyGI0K3AirfO1bkOGKwpjG5L4QXopgeedyn1HVU7Q8z9OvlgU4pJHIJhN0bvV2cGjD/y+LwtC/mAnb8yagOzPEnn4KULgeLJLBb8FgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJOZgqMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJOZgqMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509D1C433C7;
	Thu, 11 Apr 2024 10:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832714;
	bh=sOsRpGnugiFiKbA7c2SiJjuDTrWUrT/ReJGJg+IlsyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJOZgqMVkAg7/pPqCDHBdZsy55UQfnxhJbgsxsIuwB2SGXY4cmnY1IwXdtPvmW5GB
	 h2y2JDZp2v77J7ZuYpBfe7C8CFAJgDMr8+lkvT5BuyP1dnxLPzHalskEA3jeVgd2nO
	 rkEQ19VP+4WUDeYyiZxMkGyOh1n0Kxz10kHegyZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 5.15 19/57] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:57:27 +0200
Message-ID: <20240411095408.576972138@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit b79e040910101b020931ba0c9a6b77e81ab7f645 ]

If hci_cmd_sync_complete() is triggered and skb is NULL, then
hdev->req_skb is NULL, which will cause this issue.

Reported-and-tested-by: syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 2a4cc5d8c2d40..75623302d00e7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -405,7 +405,7 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb)) {
+	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
-- 
2.43.0



