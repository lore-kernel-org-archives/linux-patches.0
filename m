Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061369;
	b=UTbxjy3OC5pPICFrL/kv+vm4Ww68ts/eJC3uM2Mz6kmuAMkwCusecjwwnSG4749chJLk
	 beeDz877EbrOAC3yub/ZdpuO+1UxAWiHljpl6lEh8LUTdpPtybeGvH+lBXsWof48xhSXY
	 x7SrZG5aTwp4ZpnH6hiWOl9vbjrrLM2nd7ofFHlW5CY0UTuwD22VwfP8yi4nUiA8VqQBZ
	 Wf6vTCRyRQxY493+AJr1nR4cVFqSJlDiE9ZKC86m/S/BNOAKq5peppNtSD+7aX5PXnvpA
	 Dh80iBiK+fYoIjKTeYvVBKXaJgmGvEyVL/hG0vGrZdZAnbOJU79SJ1YQlJI7tbddbug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IkWrr2CgTv+jCTKo4bDP1b+jIP3C0MZLHjOPlCMC98Y=;
	b=uLxpabZw8NGxR5N6eSgRsZlQiP96V/P+Ia9tz3Ktl3oMRXQNWqJFelG7GQ+2OUp4cXEu
	 DGZAerGaU+HUNX4ZId1mg/Gr6RbyJT3MH82vlgXAwXgXIb5qRTs2q57HoMPBYyXV8Ldu0
	 Ol9PVelnQnKoOmXb7AumLJmEkikwXSC9O+0spYniuoEH1qd+RPhSLaH40N0z7jzR2BZ/+
	 IK+v6Us+zVeMbUHpCRShxRw9AhbIxIoLndyPD67CYV1tzHsXcafjGhUmg1stfjeiRsXU/
	 t8ZKMOi9N3RIZu+ZZn+Dxid3W/+2ypQzUVLMe+TvDml7X9HtvgP2Ps2lK1J7HmUBpJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmYiArKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E51606A320;
	Thu, 19 Nov 2026 04:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmYiArKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B581F000C4;
	Thu, 19 Nov 2026 04:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061369;
	bh=IkWrr2CgTv+jCTKo4bDP1b+jIP3C0MZLHjOPlCMC98Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmYiArKtP5E8q3Dw1ZTVmqlWL3d8vU14zdr7pyE6gQhUtpE3mN2wj5RLkBAC/GeSp
	 zmiW/2wGfy7LrNM5otw9BpQZxgaGw+k+fr5bbqXxDX+ZpN/U82Iudrkk/pB3xPttIC
	 F8B6B+2BP+JjLQPJS4EZK2fCNHt7b44lUBCjMt1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1528/1848] wifi: mt76: usb: fix source overread in mt76u_copy
Date: Wed, 18 Nov 2026 15:59:26 +0100
Message-ID: <20261118150023.365349698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07a563df6d6d3..2ab1582f947ba 100644
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



