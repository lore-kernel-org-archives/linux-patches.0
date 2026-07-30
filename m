Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4572E9EC7;
	Thu, 30 Jul 2026 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427364; cv=none; b=E7itzC6pGkdoIvCI3dF2bahTzQmCsZoWktRrTbOVQV6MN25mkPnvzsCCEJcw6XRhWaesR74bWA7dkmZZkS1YUJhZEvyqDjTqmkDOQQTLcu3ALf4GynrFWDObohIFxCJACwfMa5UtPKflNyUgiD400gLRuJBpCXE6I/IuvkZSypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427364; c=relaxed/simple;
	bh=wYHHRtncY0fxOfVR849Fy11mZOyfVfloQQwl9A/lVfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/PLW4NCQrd6sA1xb9/KQ/x3MdxIil8mD0aS6hISX3y53RIzEmEs/7L39iA6jyUa+MiVAM0iW+tiCXZL2LuPBtZqVm7RUlakx22EIH5xV0s4T1RGUc3AMzDsaWZt4DUOnAZchKD9qCzdY/3rwcXn6cyna1l5BYYQJSzaXoboj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjWRAjmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjWRAjmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E831F000E9;
	Thu, 30 Jul 2026 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427363;
	bh=bsmnAHxRzoMCeyN057AZR/x5yhXagws9xUwmPY16+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjWRAjmCRfgOPRe4absjuThJeBgXco6Mv8NxI7r6BWsCrR7uEXWXz/lW2770103qi
	 AmbX9ePBaTRoUJM/QzjBWRoeOReqrGrnURx6UjSDnEifeNsexePiBNczVaYnsSwRxQ
	 xflxawaA22A5mEqLgQe6B/D77SQ3R2Cs9nVTgVZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/484] Bluetooth: btusb: validate Realtek vendor event length
Date: Thu, 30 Jul 2026 16:10:42 +0200
Message-ID: <20260730141426.612316634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit df541cd485ff80a5ddc579d99687bc7506df9851 ]

btusb_recv_event_realtek() reads the event code at data[0] and the Realtek
subevent code at data[2] before deciding whether to consume a vendor event
as a coredump.

For example, the two-byte event ff 00 contains a complete vendor-event
header declaring zero parameters. The old classifier still reads a
nonexistent third byte and can misclassify the event as a coredump if the
adjacent byte is 0x34.

Require the HCI event header and first parameter to be present before
inspecting the Realtek subevent code. Short events continue through the
normal HCI receive path, which owns their protocol validation.

Fixes: 044014ce85a1 ("Bluetooth: btrtl: Add Realtek devcoredump support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c3eb668c39943d..08b01d93b86c7f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2671,7 +2671,9 @@ static int btusb_setup_realtek(struct hci_dev *hdev)
 
 static int btusb_recv_event_realtek(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	if (skb->data[0] == HCI_VENDOR_PKT && skb->data[2] == RTK_SUB_EVENT_CODE_COREDUMP) {
+	if (skb->len >= HCI_EVENT_HDR_SIZE + 1 &&
+	    skb->data[0] == HCI_VENDOR_PKT &&
+	    skb->data[2] == RTK_SUB_EVENT_CODE_COREDUMP) {
 		struct rtk_dev_coredump_hdr hdr = {
 			.code = RTK_DEVCOREDUMP_CODE_MEMDUMP,
 		};
-- 
2.53.0



