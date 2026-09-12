Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0EB3749FA;
	Sat, 12 Sep 2026 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231299; cv=none; b=F0l/aqoZxEeIiQGFz46Uf424oof1r4YInct2rO0J58wX2Qbuab3exJS4n8FELjmuZgG7ZaDl8KnMVg/71DQJqSLvpMO0kZ2nN9qyNlt0HTQ3Xo4mn1yiQxqGykUwdgAHSu4YtUS8WclfnRzFhRoohWA0vdsYiJr6Rms+kPfhnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231299; c=relaxed/simple;
	bh=NTGTqSf61JgBdobL9GFN8Sm5eRLR0jKShHEIn9oSYrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKyF4pgB0XGGEMVKEugqnZC2VMFQOA9V+tRhA3yG0BK2aFY+D6WCZiFg+hy0CKfPDIfWCApM16r+eZ/kPHGuk8bEPxqJNbUpmsqdu+lsU/G+Q31DXgzirzQMKdvyXAmNsGz9uYEKSH/hY7nQaymUZBNo+7VwTTvnCHegIp/J5OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfkMC/+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfkMC/+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F163B1F000FF;
	Sat, 12 Sep 2026 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231298;
	bh=rbclUscVM682MaGATk1aqjsXaudDQ1BbtIqlW3QJYGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfkMC/+IfO1iOy4mbDfdXWNoSaZIZXWKXL3NTARAyRK6Y5prTSY8pgKg+yY2cqHVY
	 BdqaAryLwKG1ARN2IemMTChfE12R2xUMNQTzYMbURw7kBTx5dDaNVgHJ9SJ4mavlOP
	 VsSEf2fIsqXViCasMBeOQwIXZy8ke1xRcdGgW7GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0927/1191] Bluetooth: virtio_bt: avoid OOB read of build info string
Date: Sat, 12 Sep 2026 09:00:55 +0200
Message-ID: <20260912065609.051080130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index e543196a91518..f7438735884ab 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -112,9 +112,13 @@ static int virtbt_setup_zephyr(struct hci_dev *hdev)
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



