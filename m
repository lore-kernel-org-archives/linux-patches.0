Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019035;
	b=aec6v399XWjkYrS+FTFeswcAYAVhO9P0SNk//j9g34mF+P77w56Oxnk6ousec9N0NAEN
	 9nnV9bkknH67gKsnqTXJ/nNmL9jzvuAa30cQviVd7qpWlh0tS5QLd1hos5FyafqreYwsw
	 gCNYSCgcs/WgMvR+7vo3Ie2OCQOKXFKd3WHZXYpUuvf3HdELMAOOkflMac7Cr51pFqlEH
	 2zkeTGnEQ1kNffxCmanSiT2l6IjQ/RCfbdGBAWZ09SgK+/i9XvNdqE1dB4EwI4LEOSy7S
	 NXF5o4tv7haLn3uM/1tUfS05NitxkINj6Llou2rMtdCWac9b6n05rCUk5kLy4dfsbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GIXnmew2F067nuSuHhGA995PCyg0Chhco0imfge+1VQ=;
	b=oNh+e/S/wmYVCTIh2UKpntRbp6CO+isfoS3ff/gjWHJzk+4E1xe8eEmC/aqVi0xW19pn
	 AWW4ZlQqwz9eDNML0yw67iZG6jHot0oEtM9uUZnGhii3oW6W+1pQ/cMYBqlNu5faoTFeT
	 xQWyfrVdo5yjogULB3/HlHzz2HE0EeyxWUBnMBUgUAsIui6mV3EXFu/Nazv9qCG/I8XTw
	 2lLnnnn1zspNTJzvQ/ZLVEOKIm8q4pmGLhUcz2dz/hL3cXKJePBY8d3ueDgbQeASi+bmJ
	 UzcMBKBmB2Mwrd2uKvc0nqzuc67JhD6v8tPPWC4ofp1XwqEJh0TDAdqCGt/xkHRsIjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAo11elM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0AD606A31C;
	Wed, 18 Nov 2026 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAo11elM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E0C1F000C4;
	Wed, 18 Nov 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019034;
	bh=GIXnmew2F067nuSuHhGA995PCyg0Chhco0imfge+1VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAo11elMXCadj2EF768TxX5E9GjW2L8zO2qnZfrXiS8NbGfa7u7eFo+fBhZrGU0gu
	 93VNuK6874hJ69W9C+rcNWlgjIgkeSqiDNeBvh8lDmDJ7hnnREPaXsE3BaGuhx886U
	 LfhYQdTMujGFD16iARUBIAWymX7AxvR5q1WtNa0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1453/2651] wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150340.347969551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bab7b91f14bec..3629e3d9bf479 100644
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



