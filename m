Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055898;
	b=hok6YnCljot2fze6C1lCj8NLcKi6z0E8L9RZPH1uDVj12Gt/mAhlVQPBUOxPhyajlMOm
	 DQ/8KT+hDG6U//0fvjOjZWvc1n7xIz4+sjdQKWT/Yg8wTOM8iawvX/hS1M6te12uTGoZM
	 O6zteHtNzxTVg2xx7VukNDIGHYVZZvpsBi9VP1GpOdt1Ta+XFjZq7/anQsoP6RxeWUnvO
	 7LOzQgD1Cyy8EtqbSB0atIBfA7M9TwD6Of8gPBWQ5TAXkxHiT1QBzBwYoOPLZUomGo04E
	 vQjZXtq7+bZ2ETgjVqkzghUopx30ocTDLD6E5XFh+62UtiY6PRebN5oKSlJhHnOHN6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3JgPKsByswZdtiBLRVNCNIdEz2hTsAq8K6qDquV67NE=;
	b=a0+1oSiSI9WQeKst/HtXemxEq/WjyjixQCHQL4qeI8OHSCUVvbYGuUaSdkjOzfGSjQlX
	 B31/+O80HNX7NSdpvcfT2AvhWUx48mK7+QS5OeVsPjEcFiUPVtLpdjRA43L5BFPXuERDQ
	 vUv8Ph0LjwAmUlPBPTv8+1KhOHiyQPmm3sigPTBE269SeyO7luBgBAPq3eKgFhKcmyMEK
	 5Wlo0LsOEfK5UO2/GUTbNMEWmeCqjxzUcGxCG93XfiVzXaHMxt4lnFfzbUeq79xPQDrlG
	 w4LRd1zAQJPLbcsKHTMetK8VFrZa+gzTjB6OdzM91VZJuJnp4aXChFEQab7XM13mKBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEHjFLpZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E2606A320;
	Thu, 19 Nov 2026 02:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEHjFLpZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2011F000C4;
	Thu, 19 Nov 2026 02:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055898;
	bh=3JgPKsByswZdtiBLRVNCNIdEz2hTsAq8K6qDquV67NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEHjFLpZvSPP/vd08aauFgqnkJYNAtWcAzpJCDEhkhuGmZ2CL9iUKkr5fnZ4EWrOi
	 vGv217DQpD8qOp+F32LjhAVjzSPzENZwxSyW5uN0Asj8OLg9mVDoTmMMWPUGV8LbbX
	 QJ7d73kcu3SjWaBHxwEAHDfUKq3s7/KhOmwx3ABs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1795/2214] wifi: mt76: usb: fix source overread in mt76u_copy
Date: Wed, 18 Nov 2026 15:57:51 +0100
Message-ID: <20261118150123.309695141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8510be7f95a98..4cddfc7fd33b1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -189,8 +189,10 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
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
@@ -198,12 +200,16 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
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



