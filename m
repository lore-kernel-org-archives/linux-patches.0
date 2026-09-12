Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F183F7877;
	Sat, 12 Sep 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226168; cv=none; b=qjHcLR4IouRh1Q4sLa3/sEYfv1T1pT9QYTicDQKOz7eWmOIUVh93x1+LQnHu/ZkN6gsU4AJWyik6trwg24pE65IWhMnvHbzotse9Engm3kcNiBC8wpllICMXeA+Wv5g1dnUaR/Br8oo50gkUmJP2FIlFWVrmI+OaehYDarfdAlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226168; c=relaxed/simple;
	bh=8+Cavxou2tX3v9aIuP+zK3EpbHpU/CUg/HA6kDbyJ2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjkNp8SY66VhUXwgV+cgFYZvKwxYZEhZTZz90K1HXdgEYruuzS2QIId57Y3GGYEu9oz7eDzOmf0H10vO4CfSNIPpAS9Npa4RtLEjEsYbXBzsPtyj5EeN1a6xJ+MbROA8ILstkH7192r9FaX04ufHUtmI1g+cVR4brPhElljFZbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuQb0vy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuQb0vy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764AC1F000FF;
	Sat, 12 Sep 2026 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226166;
	bh=TYhuMY5M7Q1gsbrnXnL4BdrLofcN9K7pf9nGCxNYA6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuQb0vy9kiXzLgV0AfRv3eAOuYuF9ct9UU+qPhILQVJ3hAo4sLRV2dQBb7BK/93cy
	 tBXWEsQ7YeAfL51JEoisGFjAqIyhPKmaEcXXC0DDhbYK+S4e0A3Zs2NgmzVSCmiv/Y
	 JqwTPSV2R1pe6a9/KHF88b2b7N7sJkqyLn0zsa2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1347/1424] Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path
Date: Sat, 12 Sep 2026 09:02:59 +0200
Message-ID: <20260912065637.425208816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit fa0ad2d277c7adead61d1c22411c55cea6990c2a ]

btmtksdio_tx_packet() rounds the transfer size up to the SDIO block size
of 256 bytes, but hands the host controller the SKB buffer as is:

	err = sdio_writesb(bdev->func, MTK_REG_CTDR, skb->data,
			   round_up(skb->len, MTK_SDIO_BLOCK_SIZE));

Only skb->len bytes hold packet data, so the controller reads up to 255
bytes of uninitialised memory and sends it to the device over the SDIO
bus. Depending on how much tailroom slack the SKB allocation happens to
carry, that read can also extend past the end of the buffer.

Compute the padded length up front, ensure the SKB has tailroom for it,
and zero-fill the padding with skb_put_zero(). skb->len then covers the
padding, so sdio_writesb() no longer needs to round up. byte_tx keeps
counting the header and the payload only, and the error path restores the
SKB so that the caller can requeue it.

Writing behind skb->tail is only safe because the driver owns the buffer,
which "Bluetooth: btmtksdio: Take exclusive ownership of the SKB before
TX" ensures.

Fixes: 9aebfd4a2200 ("Bluetooth: mediatek: add support for MediaTek MT7663S and MT7668S SDIO devices")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 2978360dc5182..cd3275bc3ce08 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -258,6 +258,7 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
 			       struct sk_buff *skb)
 {
 	struct mtkbtsdio_hdr *sdio_hdr;
+	unsigned int len, pad_len;
 	int err;
 
 	/* Make sure that the data buffer is not shared with anyone else and
@@ -267,6 +268,18 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
 	if (err < 0)
 		return err;
 
+	/* The transfer is rounded up to the SDIO block size, so the buffer
+	 * has to provide tailroom for the padding as well
+	 */
+	len = skb->len + sizeof(*sdio_hdr);
+	pad_len = round_up(len, MTK_SDIO_BLOCK_SIZE) - len;
+
+	if (unlikely(skb_tailroom(skb) < pad_len)) {
+		err = pskb_expand_head(skb, 0, pad_len, GFP_ATOMIC);
+		if (err < 0)
+			return err;
+	}
+
 	/* Prepend MediaTek SDIO Specific Header */
 	skb_push(skb, sizeof(*sdio_hdr));
 
@@ -275,19 +288,22 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
 	sdio_hdr->reserved = cpu_to_le16(0);
 	sdio_hdr->bt_type = hci_skb_pkt_type(skb);
 
+	/* Zero the padding so that no uninitialised memory is sent out */
+	skb_put_zero(skb, pad_len);
+
 	clear_bit(BTMTKSDIO_HW_TX_READY, &bdev->tx_state);
-	err = sdio_writesb(bdev->func, MTK_REG_CTDR, skb->data,
-			   round_up(skb->len, MTK_SDIO_BLOCK_SIZE));
+	err = sdio_writesb(bdev->func, MTK_REG_CTDR, skb->data, skb->len);
 	if (err < 0)
-		goto err_skb_pull;
+		goto err_skb_restore;
 
-	bdev->hdev->stat.byte_tx += skb->len;
+	bdev->hdev->stat.byte_tx += len;
 
 	kfree_skb(skb);
 
 	return 0;
 
-err_skb_pull:
+err_skb_restore:
+	skb_trim(skb, len);
 	skb_pull(skb, sizeof(*sdio_hdr));
 
 	return err;
-- 
2.53.0



