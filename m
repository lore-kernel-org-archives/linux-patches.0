Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DDD43DA4B;
	Thu, 30 Jul 2026 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421946; cv=none; b=qrCnKXu9+KksfbF+KqLk6sDT2/Fb3PSZ6IS9Gr8H1de3QQwKkauKc6hm/YClosQMnvEb4VgLalDs3A23I6unarprnlEmbkxqxa6pGi29RyKuwwHxRLy+1cXbdzMsaxGMWt+lytUkIUXyFUBOKEyapDw0Vjov+VvDRq1UZbjSFg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421946; c=relaxed/simple;
	bh=sRjw2EuguAx0fCk05Pybr64pVW4Ch4MZ0xtM8r6f5oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYhlCb28r8NGw7mk7sweIeZYVKLisF3XhjcjgXO33AM/R8kxTFjfU3zmWhXTdyAhzRF0+z3kXFItNmSCgqVk0uhOkesX8EPeSDKdREiObqPX/JQGAx1oGfUY/sNPoXWffSCxCkmOv846rVbb81eFFwIUp4lVwtwuQ4qFX/oBBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jj/Ltlan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jj/Ltlan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AB41F00A3A;
	Thu, 30 Jul 2026 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421943;
	bh=iyzu0uLNdn8jXAl/Zx8Xpmrxjkw5e+gj9JcNeOFH1WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jj/Ltlan63EfK7W6Rczz+S7sB7T/bk5GQ8gICDQoT+26op12cpwr9iDFY17aiPbDj
	 I/4zqJmgPPCv5YuDU46KLoOPBnDFrzAYk9DL9ohfuekStsYBLJMZ/73HfCIdzOe9Is
	 YaLEJfG74/CdidSZstcmev8t08I/6Kwj1EAXSiWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 228/744] Bluetooth: btusb: validate Realtek vendor event length
Date: Thu, 30 Jul 2026 16:08:21 +0200
Message-ID: <20260730141449.136526554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cc6392f8d98cd2..7f66e7c6e77ad4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2765,7 +2765,9 @@ static int btusb_setup_realtek(struct hci_dev *hdev)
 
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



