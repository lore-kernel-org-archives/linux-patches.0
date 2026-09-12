Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4CD455181;
	Sat, 12 Sep 2026 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210419; cv=none; b=kMXAdcMa9o+oEow4ZtQ0Kw3ykbbE+uKRghqM3dCXhMdfiyhNKfA/4BNqQZbeWWfidLMAytiC/A5aojbd6XsxNmVGmjMry3kn+SX+rCIvFllnx61l4nUoclCnyqiAKVkXKefIbpApGyqDKeYxwT9jm3TyuynifS5BW27LhnpxZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210419; c=relaxed/simple;
	bh=zm1XlSJvNZSKYOBKOxBhl5P3SWV8NuDVBAu0UK/Zd7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8WwG2e+EMT2s+/WcXb7ujMnmnWSdXrwrWI//FHRq5CvtFnDhQHpUjJnBs+T9f5Qsv3DBWFN6im3VQrEaBVgHeAaHdQhGX1pYF+heZ/Ur6GinZvxYET6ShxIlM+DTufwX2HbiAFT0xmQVLi8SMug6TJc7OstNsBb0VoZ1/p2CZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZUakZvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZUakZvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CEF1F000FF;
	Sat, 12 Sep 2026 10:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210418;
	bh=RA9DnbxVTzNl5vbnwAVb9IQS2LTmsxyH0ejJvakxnkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZUakZvkpTadJmBTS6rWY0PdJL1IuXY6JLO+VHwTnBuHx4aAq+AGjoCpKSMKIu0sn
	 WH7X83yPTqnS7lYgMpz1vFM+i6053p2jDedJRkjaP8gYA5rP5sH6sfpuz0JxtcqixJ
	 BPZ/NjMETiWzy/uKjjOnHqA6chewagI5RUXsQJoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1023/1518] Bluetooth: virtio_bt: avoid OOB read of build info string
Date: Sat, 12 Sep 2026 08:53:12 +0200
Message-ID: <20260912065646.592540019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 502adc06ba76dee19c292ae4a07d74d202fe734d ]

The virtbt_setup_zephyr() sends the Zephyr vendor command 0xfc08 (Read
Build Information) and hands the response to bt_dev_info() and
hci_set_fw_info() as a "%s" string starting at skb->data + 1, without
checking the length. A backend that answers with status only leaves that
pointer past the end of the received data, so the walk reads adjacent
slab memory until it meets a NUL. Those bytes reach the kernel log and
the firmware-info debugfs file.

To fix this, print the string with a bounded "%.*s" limited to
skb->len - 1. A short or unterminated response then prints as much as
arrived instead of failing setup.

This mirrors commit dd068ef04412 ("Bluetooth: bpa10x: avoid OOB read of
revision string in bpa10x_setup()"), which fixed the identical pattern.

Fixes: afd2daa26c7a ("Bluetooth: Add support for virtio transport driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/virtio_bt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 9341c5eed5b53..152432cc2260c 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -120,9 +120,13 @@ static int virtbt_setup_zephyr(struct hci_dev *hdev)
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	bt_dev_info(hdev, "%s", (char *)(skb->data + 1));
+	/* Bounded print: the backend controls skb->len. */
+	if (skb->len > 1) {
+		int len = skb->len - 1;
 
-	hci_set_fw_info(hdev, "%s", skb->data + 1);
+		bt_dev_info(hdev, "%.*s", len, (char *)(skb->data + 1));
+		hci_set_fw_info(hdev, "%.*s", len, skb->data + 1);
+	}
 
 	kfree_skb(skb);
 	return 0;
-- 
2.53.0



