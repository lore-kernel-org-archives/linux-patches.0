Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5BB64CC0;
	Thu, 11 Apr 2024 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832186; cv=none; b=OIXgvRMzvMVpws0mKpo3K3nYaVdSBq0YXoRB08kHw/QxxdazOzTxiYE5Rk46XJ130LROXYp7qMM75dn0SIoecYEzDx/1iNF2UDdK3vi1aThD4WdpMU1ebhCmUS+OUIZK8nocRvOwXFZIXA22FAkWqds22XcQuZdq+MJyVNqfXGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832186; c=relaxed/simple;
	bh=9lwNW/4Cc3uwJ3RGysPBbavd4GFrNEVbncNlTXJPpws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE8Pol5GFjXRHpUA2DXGk8UA4YYPBvnj5/PupD0VNvkDYLMlAary8WQaQfr7ddhS4tEgMqiu5JD7ltbM4B2fh2FX9QsnrFdu6gMfVTvTufe6k6+4bHFmqD7XeFJ4qREaOfMU5wP6koKIwDk3TJZtIx/ODD/vRS2LGyetzhtp6TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjH6Fajc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjH6Fajc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04D3C433C7;
	Thu, 11 Apr 2024 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832186;
	bh=9lwNW/4Cc3uwJ3RGysPBbavd4GFrNEVbncNlTXJPpws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjH6FajcUVkETsLlfNzfPcEfCiG3XywOrKoJK7IYYIbbXTAxYC3Uw4TtXquuNfu8Y
	 YgohJUQgsTKqau628HMR/KXSDI8FcA0nJ/0ZnueS9qcw0+KRaZl0jTpR1Nc8G4JTKA
	 sNn7IS/7Zk3uj3FM6fA4i01WRqLiaZr6FXT2EGeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 5.10 257/294] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:57:00 +0200
Message-ID: <20240411095443.300424600@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88ce5f0ffc4ba..e1daf6ebd3ada 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -344,7 +344,7 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb)) {
+	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
-- 
2.43.0



