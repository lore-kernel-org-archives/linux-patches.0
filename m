Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049314;
	b=ZUyV4kSSCHFks6zQXThkH1owXMdqtFxMwhrNNW0TAolZF8VtMrzQiaSsoVA26IrRQXW0
	 donnnk1EwURMTIqmQ7gdIznV4OtVoFp+SCpz6C5rHjSME29hXkNOKDhA5kdNohrHrNAFD
	 Nw0GjdPL33hiSxBXKgL4Yob8Ie3uCqD7L3CpDFomZ5BpMfhbxIyZzCYeHGaDpONaz0IUX
	 FsnsBCoebc0Eybv7TNaUm9kWCAgs6niECWzQccNp1e1tYsku/xeoRU7c48Q6dDVVAblum
	 HA0e4LOcxloq+p12CmPIt/u4rDcpiWtAsBKuWOCU8laPtP0DeIQjIHSWRo7TQiGoxiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yhyvuCc3lAiSgr+9Eg9gEs6GV3fs5z0j/OLQxci8VZI=;
	b=KIvgRi2OYM6uaa/0lA7LstqRKTRg7MwrVuW5eqkRZ4cKeoEId5VNA9QlPV4FD38KP3t+
	 X74Rejtwl2jd0siXvxRB2NfPdOEVotausvIWRikNCK1SRpamcadDp4vAh7F79T0EZW2dA
	 PFXXeQjwXu98K11FgfelU/1qUCrkVgcilqqwDh6jY2X1Zj6I2c+N9n4qdlIR3MRqoQtvs
	 k1A5bN4IC5bexZbLViPevtTGgFrV2qp/tcbkf+1yYDdnzNFb+vS8/imdC01WBUz4vkGvQ
	 AonqKjmGrEFoK2XXfcqUFNvGIAvbDCq19sTxQ79vwjgbZkMjyuZBOh2LanZsxDTamLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPMUmeQK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C61606A337;
	Thu, 19 Nov 2026 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPMUmeQK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1141F000C4;
	Thu, 19 Nov 2026 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049313;
	bh=yhyvuCc3lAiSgr+9Eg9gEs6GV3fs5z0j/OLQxci8VZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPMUmeQKd9kRpalkvLE6SO5Kz53IN+NLTnopnNhwGmUKkq4sQw3hU7mIqH/aoRZ2x
	 YwSbF9SaFRD1IOTMWLJb56pTYaI8GnofJ3OKMIWWY84277jQp7ylsjNRka+dyJeK9P
	 oep86O/cixa8Lktmjsui1+PrK6LNUqLK8X/ZIvHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2306/2857] wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150324.520322548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f2d651d7adff4..6b26fbada6933 100644
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



