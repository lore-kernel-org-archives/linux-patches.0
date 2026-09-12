Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E432242D65;
	Sat, 12 Sep 2026 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212230; cv=none; b=khSEXTY2/MNJDK5sDcsYJ+aSTEnXPEwFOvnaiELZGvXfiTjuALMBnZAaIlZqqSKGJ7+b5dEEdXR/KQz5NJDghS0uHi42BLRl/Ou6r0MIL8j4HR3DjFwFED5bQSD7ZG2qt6FKPk+yUnRB3mL+7Bbfy5k8ajNYo1QC2ijuTguuM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212230; c=relaxed/simple;
	bh=se2PjAM6zniF7zCeNFWvIaQgQ/cx2H4FT/+7sd+kJgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrl55foWYfwuLNoZiKKAfgeIsKxJ/el7O0r+rzA2wF+d4h38Mk/+KKFP4eTGE68p6QkZshCUGe8nZfg5s09czqVTT04inMFNaplR/6rGoTWQJMKXNC7aIqAszMyFUZNEqkac59/Y8ICiRYI5w2GPMyWZjmW6AQ+REhpVBgNiscI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTd4xqKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTd4xqKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A223B1F000FF;
	Sat, 12 Sep 2026 11:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212229;
	bh=ByK+5qtn6Dh2i+QwbK9GvpJmaK1scCgy+qnn82Fk4vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTd4xqKg5yqEIOopHUKkl5WT3RD9ecVjedQ7RDLKh9N2/PRO++i0BKES2HjoZwGqv
	 b220BWKyLf/rOrm5OiSJu2aNkNJ4Y7ba5rFWMCgLknYqUadSWmlmGgPkONY9tKvnvy
	 uSHp/HnkhkHnBW+4RalMUbzfWX0y9jf/k1kEl/wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1395/1518] Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065655.105540049@linuxfoundation.org>
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
index 516e086fc5c01..f7dcabc11b859 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -272,6 +272,7 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
 			       struct sk_buff *skb)
 {
 	struct mtkbtsdio_hdr *sdio_hdr;
+	unsigned int len, pad_len;
 	int err;
 
 	/* Make sure that the data buffer is not shared with anyone else and
@@ -281,6 +282,18 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
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
 
@@ -289,19 +302,22 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
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



