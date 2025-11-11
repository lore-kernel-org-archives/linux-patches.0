Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E72533F378;
	Tue, 11 Nov 2025 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825345; cv=none; b=sn24MitT5PXFoB5wW6IxuN6cjbt28yBXUR6rBOjchTdnEMsJLg99pJnnzi6sHc2xgMV7ZdFFzPXi16NGKsW58crokt/dnB8ZyaSXelFYeTY0hus3zbHNH/dC53lM0w5KVkhH9ASNUvSLkuDvieBliONviZCwO8puc1iFR5Zrm/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825345; c=relaxed/simple;
	bh=CDxnsUYVy2784On+9WKKV5DTDjSyHrHQudhZir9sKXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVE4b6BGpTCRmVEKAPnQ9W5Qsm7aFGcrCdrFAbAKAdoOBeafw7wdoYU5GToI2/M45bEiDm8p8d+Pa65WaIH8CxJZevgC5uu0crPyRIeBULMKYDPNMvD9mkrd0VDzPHxcJlBPBAfp8ct0ZJQnovRFafP/AyV+CTO++bQCCal/v7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czb+XFd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czb+XFd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A84C19421;
	Tue, 11 Nov 2025 01:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825345;
	bh=CDxnsUYVy2784On+9WKKV5DTDjSyHrHQudhZir9sKXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czb+XFd7g2Rs97HhU30ss3iP0Ab/iLvejDT8rwyzoeOcHa8FjluBJ7mAAcBZvbt4w
	 Bjy3NRwM5ym0R0WCcbLYvQod0QnWw5eZUIJc+iPEEPjZjTc9d0LbuEStDwuDOAtBSO
	 jcEGY/n+y5G0nzVHAMmNCou+T3+KfSGv7tfXHVmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 756/849] Bluetooth: hci_event: validate skb length for unknown CC opcode
Date: Tue, 11 Nov 2025 09:45:26 +0900
Message-ID: <20251111004554.709504826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 429f5a858a14b..7ee8bc7ac5a2a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4218,6 +4218,13 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
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



