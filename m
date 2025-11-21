Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95AD34DB70;
	Fri, 21 Nov 2025 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733058; cv=none; b=LiiuIs39QU9wZig3bx5Jq0h8vUr9MO+V/IPGviIENCP8b1JxU+7SrJWJWSmHWq0r7NYnCpYklIwPKuT2Kf0pcLnYULF5Yuej7859e7ds5MxNDhLQ63j+p0+YAPDFYCrFO56haQP1Nkpu8gyR+TcJSU3FirwGGDLBW6kmlgk3nbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733058; c=relaxed/simple;
	bh=lNsxBDUjn2pkyyUtxT7B+jHAXiwO/w8+xAgfeVrY7I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwsqEPxTOVJefstsvus3vPN9wHWsW9KBPNsCIqmbgBTAl8S0nWmj1K72nF84dBCMsrL6JEeavd03/UfL1lQ7gvhJqZDvNLWLV4RGB4ue5wsm6VKZQEZUHWX5tLZiFYz+T8Z0YCdt12T+BsDv0GgmH4RZjTiMDoqLdgsz6CBZgGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRWhKrUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRWhKrUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4621CC4CEF1;
	Fri, 21 Nov 2025 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733058;
	bh=lNsxBDUjn2pkyyUtxT7B+jHAXiwO/w8+xAgfeVrY7I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRWhKrUIDXjjG/W8e7KXm/0YHO1gAid1ydQW+EftYOivKZEFv50fEW2L7zFvOambS
	 +g+d+xd4AjWD+NolTYalYPjkoLgoKk5l9uOIkVgAeYLCuLZldYHegvqxUTMR/uz0CR
	 3G6PyV7/wOOxwkSsagL0Cu2MIjPKJSn/dXvoV2Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9a4bedfca6aa9d7fa24@syzkaller.appspotmail.com,
	Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/529] Bluetooth: hci_event: validate skb length for unknown CC opcode
Date: Fri, 21 Nov 2025 14:10:35 +0100
Message-ID: <20251121130242.986169715@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e70b85647035..4aa445e7f56bc 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4208,6 +4208,13 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
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



