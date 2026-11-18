Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019032;
	b=MyNLOORFtaI8duDCN2fHRcwarna7JMkO2hKAsJY3WLbLWT0FxSWwMdmA/q7qR2i65gzo
	 lnKU2Lq8rjg4a159wZbBB4KsKDr+L1NDEsZfNnidzGTeB7XOVHg+8PnuMBy7KBSVtVpfv
	 /vZ1Yl0fNf65yWfj4977otHGuPRXVBxwwnkswUX5cg9tl/7IyA9/Jod0SM5xljyk0tiGA
	 JJB+xptEcYqv4TQPXadoFfa6y5+1FhqSlPpyO2HLLKas+hvMxX1sZsafx2LXu9Px+lMk5
	 8zM4TbuyTwYNkPq8Fu89VBXtiZR0uFW0RrVit0QYivfrKYKeZlOsm7pnnwpIFvhIfTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gvUhB0JpaV6/axzk0BWKlBRNfvRdS4InJO0hPvduVmo=;
	b=YA3/uxB7aGDAi2AcjB3uVtfvDgdqQ36PeLJQyHGlkQlJYrv1Pd7AYogs04ClOfQPE+pe
	 lfvOKopjp5P+2t6OG+XhIxQB/93GlnXIg3YBgLzLA5Xes4AnUwwmCDRZDlUIRFlJmFILD
	 O4z7yiW/Yzj+pdZrSkh3masSvKCYf9Nn37KvffOQ9JTI2l2gQcH8WmdK9w6B2nZoNOz2O
	 hxn5Rir89eSp+JtFHg5+dsJvTgewb/8YA9PtYQKSztBeWHiWMgueeV/DWv9Uvhh+APc7a
	 hPajKoBY0ZvJXagKz0GYjxQQmkMhqr5vPJRl8msAxxa2rCBBNXOUcIgs9layMHEn4Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMJROiPD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150BA606A320;
	Wed, 18 Nov 2026 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMJROiPD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFEC1F000C4;
	Wed, 18 Nov 2026 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019031;
	bh=gvUhB0JpaV6/axzk0BWKlBRNfvRdS4InJO0hPvduVmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMJROiPDLKrsZRb4ZXLxD++1keqiuAf8QNHO0hK/mbS1sJdHTKRDt4UJYQEAAQH+J
	 ZUN6UQRUSkBJYNA58v+k09VIkUZW2WkasTcslpzJ+ySEvX+can70yX9xnP/v80QGgF
	 UnsX35pG0GoDPEFmG4VuvRoS/GYgjpIXvoLZzqdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1452/2651] wifi: mt76: usb: fix source overread in mt76u_copy
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118150340.312787597@linuxfoundation.org>
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

[ Upstream commit d435130cdd064b901d8ce5ada0322298e6a86a49 ]

mt76u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 9446248669968 ("mt76: speed up usb bulk copy")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925150556.2304003-2-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index dfc12f6944a74..be48a88a3ad02 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -171,8 +171,10 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 {
 	struct mt76_usb *usb = &dev->usb;
 	const u8 *val = data;
-	int ret;
 	int current_batch_size;
+	int len_aligned;
+	int copy_len;
+	int ret;
 	int i = 0;
 
 	/* Assure that always a multiple of 4 bytes are copied,
@@ -180,12 +182,16 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 	 * See: "mt76: round up length on mt76_wr_copy"
 	 * Commit 850e8f6fbd5d0003b0
 	 */
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		current_batch_size = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, current_batch_size);
+	while (i < len_aligned) {
+		current_batch_size = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, current_batch_size, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < current_batch_size)
+			memset(usb->data + copy_len, 0,
+			       current_batch_size - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     0, offset + i, usb->data,
-- 
2.53.0



