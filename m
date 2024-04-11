Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697A145B1E;
	Thu, 11 Apr 2024 10:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829929; cv=none; b=JkP3IwErLT76xGbroYgzuEvo1ENnHOBqUtVEpgtXhFUBSoAkGJs7HSBqsk8YsDm87gq26J1j14+mtFFvs0AEYtRsFge0fA9mS0ieMIBSu0Ir/hBd6wsSUZhdrlADCpIwTnKzOg6VInqVQdXfwU7EZD6fxQ0hz/xrDNuJIYGoHCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829929; c=relaxed/simple;
	bh=Yx5B5ch0+fYgmeln9Rpy1zGu20BMgPmZ3h8g0ZrR17Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjDAm81w3WFwhBbpRzIOLdAz9uE3RGXCF1+AWVRZOB6P4uS1ryf/FmliIyL51N38ZKY6TAsr+dSe5DD7jRUjQqpKZ+wLaVSLIMVLEBciGhs0F+NZ0ES6NbBP1B/yzS0w+aPP1bxS0eS1yMOs/yuJqMYYk5FNmE8nwuvT8W3owME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2CaixDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2CaixDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E7AC433C7;
	Thu, 11 Apr 2024 10:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829929;
	bh=Yx5B5ch0+fYgmeln9Rpy1zGu20BMgPmZ3h8g0ZrR17Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2CaixDoQ/6ClZoW1/snxI2fZScAdHYYN4j7Lrth6JSQnqtJjwyMAxJGcgp9CfWo5
	 q9mMFK3KGGzqObIIuTHhjq/RBKi4Efd0V2Wapu8a3fZGc9Kn8lbNJ/12cChyIL+L4L
	 qRtoxcj8XgjwSWyKwQgirr7BOnY63VW2Svpbdi5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 4.19 152/175] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:56:15 +0200
Message-ID: <20240411095424.138276946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5270d55132015..6a3c0ad9f10ce 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -355,7 +355,7 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb)) {
+	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
-- 
2.43.0



