Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA05372B57;
	Sat, 12 Sep 2026 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217657; cv=none; b=gM2ZpXdNehJ4HvvqPKB9v8UjRjpeiwR6WQBjrFoCRd01ZjoVnTSEqfGgRheTCCJTtcBCXhieEp0j72DgIF+lLUb6u5U9/VSv+gZ+fDpzTsIqAwm99J1Avjv1fk6O2vTkoToZ6JtTjuUDvHMPX+9gSS2o3O3WKXAL7oLR72tSUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217657; c=relaxed/simple;
	bh=L1lk7mG1L9p1h3+WnPG7JvgpTemy/a2CaeK2f3buRI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSHUZUUNV/PljEjU95A5jhgVKGchc38vuGRMJPYrkr7D/lV7C1epkem9zIQ4dkkRkBmX1tPN5cmCnv2LJqaCLEMn4OGztDt4S0nNkt2fHLvhaXVAesbiLcnQiMnYqXHBVHU2Hli7GwoFkQn9oJHFZ3LsbJpY9QG8Y5hTKiVxz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0HM4bkr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0HM4bkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6B91F000FF;
	Sat, 12 Sep 2026 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217656;
	bh=87Sntdz6+0JW6fL23QOdUw3ViKTmfllJXP/Mq4xT7co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0HM4bkrhVsx34loSewI0SgK5wQYJkRxtJvy/ufIvWNV6a+0C+rVZRpFxG9IDW4T/
	 HgkHC1NwGNwk3NVQpc9HJs7zYAVQ3dy/ARggURAFy+mmJmC7V1T/CE8JQd9B7X7HPJ
	 lGoRIs/xVGJodOicPMf3tIpniDsjjGdu/F6MOIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0985/1376] Bluetooth: virtio_bt: avoid OOB read of build info string
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065629.520953356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 0a602f4cbccc0..f9b124fe109ba 100644
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



