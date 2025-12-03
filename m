Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D335F8AF;
	Wed,  3 Dec 2025 16:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779596; cv=none; b=D7UH/Qunh4jP2LTjPYmwmwko02/DKLxxBFpZOsqT4DmG0tkY12FRA+Gb8d/ubmdz6uXMiS7crGZLRLHlmMu1w7dcyw/Jul0HrETqY8fc7FlGZ1Wvxlp+9oGRCRXJKtlm67+bgMmz0ICrZOkF+4R3z7b5tD8A/QOKDm5m3x8kaVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779596; c=relaxed/simple;
	bh=oLU+g9or5BvxVtCSlG/mPSsloLvC9Sh3+PwlS8Qzf9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooY5yZwrFUw+24Zd2i9JNBg5r486bQBGPN7SriQg3We0iFYp0q8dXOEBNrWwNedF4neGJ7O3p7abalojycKkIFZwetbuAviyeh5TnbGsPWP+8bCzqhzwCf5TYBrShIZKHUi0KcEgWnRR9iwEE0WxQFox6jsXZ4D/vrLZ/txgtIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhlAHu1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhlAHu1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57844C4CEF5;
	Wed,  3 Dec 2025 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779595;
	bh=oLU+g9or5BvxVtCSlG/mPSsloLvC9Sh3+PwlS8Qzf9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhlAHu1OGT+HuQdtLK/OucHMyG2BnypX/sjMBk3k9/ymHKKgFRYT0NaZlM75fBfX3
	 7FUGYefm4pCREwmTS28Ijc2wVtmAGUdWtPv+VBguRn3/X5JWnrjR8rP3gnsGcdBeDa
	 GPS9nk04RmSWPyhFbwjncSUv43CE1w9E6qzwWM1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/568] Bluetooth: hci_event: validate skb length for unknown CC opcode
Date: Wed,  3 Dec 2025 16:25:06 +0100
Message-ID: <20251203152451.839967737@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index e516b169b12fb..f713a9a27e934 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4224,6 +4224,13 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
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



