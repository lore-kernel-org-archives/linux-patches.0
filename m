Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025824;
	b=yNIw5Ga4WjXTpWRiijU4vsP+ErfH18lHIJnHxwcEWrlYtQfUJmprPxu7GMiWRoENn2et
	 ZCxVyPAP/lkQX3jrJhKOtKGtSQq6jKeXoUAb3tVAupgI0b7KAHzf0+8980bwJeNryzbwE
	 osOL5qhhbNP1dmFfhQkKHx1DjwN3uQ0LatyRD589k8YNpW578vFZvgLwbaWrZXia/37MC
	 QU4yGts1Q4fzIurbgQBgeZ39jtKgpAmyyRMDVhhW5n7xlyfvdMExccx7M+uE8qUj5c9BD
	 EjG/Sp5Bhu95KzWbZa4WpXgxMbs8BM2bJv81bVKT9NVyYpMyuytGHjeLLqsgSqtBClQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DvmR9QcHsisOho0jQPGZhx2O2UxrARMZLrfJu/jrEnY=;
	b=QSiQreFmwsHxZOwhnWpjI29h0u7e3dVHq0V6wTO+6mH1TKxNAld0NmK6uIwdxWquizZQ
	 NJLbbfbzWbKCApKvknd3+TFr72ot/MeDAT8lEf905bhsUksHJdg5IVPjLUi3rKizpS4gM
	 zRofi2xGGMH1tRyh7Gze4IIAzcw0O9dzZNfp3XoPZ+/lIQljcQrGVZYyqTwqgevDgcwfO
	 5uc5GQBy5C/sU/UNit60uTtjLT65LW9cyAfyr7pKFGFfCG3uo6Oke13dbhLZq11inPUrM
	 /QhWFbjp8Kej2NP1AimHoELOpN1RaODmx3ebEAe5mwieuyWCFSKC/bXpV2fg5aeMn/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cesvlapK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E447A606A31C;
	Wed, 18 Nov 2026 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cesvlapK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A6B1F000C6;
	Wed, 18 Nov 2026 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025823;
	bh=DvmR9QcHsisOho0jQPGZhx2O2UxrARMZLrfJu/jrEnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cesvlapK2+Hhb8/pZtJy/KxBwMoUDN9taxE11jmLaT0+ezrYlkmXLYKzJvQh75y7J
	 zqJhLdOXOew3Ns1Wn/9Jhbzeqpdim2OmlSeae03FLoEC+3rbpURP3Zqc4gazyKw8Ay
	 rlnYdaDwGv/i7a8yi6Y4G9Cgja9pOWLKzTgxmZ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1216/2151] wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
Date: Wed, 18 Nov 2026 15:49:11 +0100
Message-ID: <20261118150206.496944618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 0c2fcb5225361f71905697ef9db287b24bcc67cf ]

mt7663u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 6cb596ba84e3 ("mt76: usb: introduce __mt76u_init utility routine")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925150556.2304003-3-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index d96e06b4fee18..a64ddd82b2164 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -58,15 +58,22 @@ static void mt7663u_copy(struct mt76_dev *dev, u32 offset,
 			 const void *data, int len)
 {
 	struct mt76_usb *usb = &dev->usb;
-	int ret, i = 0, batch_len;
 	const u8 *val = data;
+	int len_aligned;
+	int batch_len;
+	int copy_len;
+	int ret;
+	int i = 0;
 
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		batch_len = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, batch_len);
+	while (i < len_aligned) {
+		batch_len = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, batch_len, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < batch_len)
+			memset(usb->data + copy_len, 0, batch_len - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_WRITE_EXT,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     (offset + i) >> 16, offset + i,
-- 
2.53.0



