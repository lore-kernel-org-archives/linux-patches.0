Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F5E411689;
	Thu, 30 Jul 2026 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423923; cv=none; b=qFEUsBrBXCjWMcnOaSxt7C3aZAfZXQQV2hwWHyjyL1Hvc8peC/BiitRqBWm8IFKFqUpo+Y/b25LsK9qfMRBnDReFNi+GnEZhBZrcZcusNbCHkjLP4Cmw+2P3ibnuLnJDFr3e+AgcgnNeBGwBJXuHWjcDyuXsF09JxrRdYeR5slY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423923; c=relaxed/simple;
	bh=p1J/c8FVrIjr1P+H6bwBT7K1PyY/nRiAnN6IEglX1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NklouZhPPpbVNvuYdX+e+EEq73Gb3NoneLveZwVph8sSycBpdBemyyePc9SbOHso+OshVYipOsbmvIpDCrHWe00lT4RQ04oJx4Xsd61oqnLVaffoz0XJUsK9ODtZ3n1pjUlJR01e0Ig/KXzUFQZso9SOz5L9Q2UCfTY6C8yvnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuLgLuXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuLgLuXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7DF1F000E9;
	Thu, 30 Jul 2026 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423921;
	bh=LCJpjAA7iMyoUkUP0kvKDCX2M6vE4OAZUFJrZhdwKro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuLgLuXPvvg/ktpfCQ/BIL+BLpk6iywjCBMREvaaV9n3ZJCK1Jhe1kjov8eZyvUEw
	 ci8CpwZgcxWLYb6OpMi14sAHOzshBMmSJ5uIH58azwCAtSFRiYMqNqtnoq5B2gblLZ
	 6biFI7DsenkyVO94O9+QBFyy7Gsp3+S/pCAWwBZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/675] Bluetooth: btusb: validate Realtek vendor event length
Date: Thu, 30 Jul 2026 16:09:01 +0200
Message-ID: <20260730141449.628226882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b9e5adecfed609..fea3cb502a4e03 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2716,7 +2716,9 @@ static int btusb_setup_realtek(struct hci_dev *hdev)
 
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



