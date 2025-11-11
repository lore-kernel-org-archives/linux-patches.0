Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712072EB5CE;
	Tue, 11 Nov 2025 01:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824745; cv=none; b=Cna2ttYPvrWr6egtMDXLXvJySSWpMG/O6OVcs+PmXB05sEbDfjv75vdhQtc2iraebf5FGGqPyEZjnVgdoraSj3mPveh+GyS9FKc3GAu+DTmv6FynbquuO3YON5JN0FL+eJT3FyDob8FATtB40R/xJpj9tYrVqlKx6OCDokdXSXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824745; c=relaxed/simple;
	bh=vYcE9JyLlGN4jwwEjgzPEkhNHDRpXTCnrQxO7WdFfkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdRplS1F2DR8M9SqrdoFSnx2QToG+3FRS6P21mC3X0Irw5oy2/30yWWtSrWu///ANUUZ7Gi5dAEgYqTsGgMnJKjQTjws2fea/tezxmX9Ry0ZN8afexNnppdDylMNuDkLwgggnjJ/RGuwHjKbecR9oO8EHPbUOQhIDI5diY3zIMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvoMqbiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvoMqbiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C9FC4CEFB;
	Tue, 11 Nov 2025 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824745;
	bh=vYcE9JyLlGN4jwwEjgzPEkhNHDRpXTCnrQxO7WdFfkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvoMqbiNUwE10HDMWaxJ26jYQmkU5WuxWY/ZPOBG34SYLKcQSBHU+Twu0zkq49X1F
	 GDgsR03fXCf2cOTaEYlr7IjnJP4/v/utPhK/ObQOgRJfTHm3+dqSmcHVXO1ZfGhf1m
	 BGp8D5hcYGjaJeGOhjj5i2eC8HAtOPHTFb5zKGzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/565] Bluetooth: hci_event: validate skb length for unknown CC opcode
Date: Tue, 11 Nov 2025 09:46:05 +0900
Message-ID: <20251111004538.403786977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>

[ Upstream commit 5c5f1f64681cc889d9b13e4a61285e9e029d6ab5 ]

In hci_cmd_complete_evt(), if the command complete event has an unknown
opcode, we assume the first byte of the remaining skb->data contains the
return status. However, parameter data has previously been pulled in
hci_event_func(), which may leave the skb empty. If so, using skb->data[0]
for the return status uses un-init memory.

The fix is to check skb->len before using skb->data.

Reported-by: syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a9a4bedfca6aa9d7fa24
Tested-by: syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com
Fixes: afcb3369f46ed ("Bluetooth: hci_event: Fix vendor (unknown) opcode status handling")
Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ccc73742de356..498b7e4c76d59 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4210,6 +4210,13 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
 	}
 
 	if (i == ARRAY_SIZE(hci_cc_table)) {
+		if (!skb->len) {
+			bt_dev_err(hdev, "Unexpected cc 0x%4.4x with no status",
+				   *opcode);
+			*status = HCI_ERROR_UNSPECIFIED;
+			return;
+		}
+
 		/* Unknown opcode, assume byte 0 contains the status, so
 		 * that e.g. __hci_cmd_sync() properly returns errors
 		 * for vendor specific commands send by HCI drivers.
-- 
2.51.0



