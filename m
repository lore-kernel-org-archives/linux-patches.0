Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2023806BD;
	Thu, 30 Jul 2026 15:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425733; cv=none; b=JzKUGpyvtGP6h5KjmcRv4vOcLDUZ+XKojcp/aVN9Sjw9DIeytQXDF7nTVuzx6Tp9VvvRXRSrX6m5HxRqLLBye9bN4Oxo7C5zcZHZgUDCm3fQk35n1uiKN+BENDWX/kSMi9aHhKoM1F59TAakpDDtdXH9Yb8j1fd3Uk7zqV5alTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425733; c=relaxed/simple;
	bh=cZ9sP6VupIlBpNF9QMm/PKMchsTuOS8EsVFMXjWcG6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4AJFsCBSa5/yi3EQtHTjV7ZES2Kax3m98pfXQHfM/h+zt9hQtwRAb34b+bMQPLymvV/FVqo+Src3ehm9ZcsOySL4bUVEKOoiBe5J3gVsiX+SxXjUnDTfepN+eYpEUuhs0g7NfN5W7ZEdDSQ+2GEV5MhedN9j03Qfbe2TSW85As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hs/Lrp/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hs/Lrp/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9771F000E9;
	Thu, 30 Jul 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425732;
	bh=FoVCRPKVr7rwttmqHPp6EyQJKWPQ5OJk6MIkC5kZwEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hs/Lrp/QRYDEYgO+78Ee3OdeG37hnYSm4zo/MVVG2TuYOmCjgtAtIrLubfDP0xjN6
	 IoQVQyoq9Dz+fe099nyMtqdLFHaAQjA2T3egLbtHOrmaRbKw1pHPeHEcm46KzwZ37s
	 dK+Ma+yo+uBlfYOxJEAxptJNEWiLClCl3H48XRLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/602] Bluetooth: btusb: validate Realtek vendor event length
Date: Thu, 30 Jul 2026 16:09:23 +0200
Message-ID: <20260730141439.564158797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 903d43380d038f..aadbda2fd5a20a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2707,7 +2707,9 @@ static int btusb_setup_realtek(struct hci_dev *hdev)
 
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



