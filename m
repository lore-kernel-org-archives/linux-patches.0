Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C1E41A55B;
	Sat, 12 Sep 2026 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219109; cv=none; b=D1gC0/MpTHyR3gClgG28RqA8jUuT36ba/RhsnT3hnVQG4lBei5r2Pli5Kuyg1j1xBpNKhsSBJg9bPp+gXJwwI8TqgxfaozfLHQdPs5SXbx2DAbKXzjDrYlq4JtpFUNdQllgYIrm+iuB4DQRqjjpjQXQOdYaArAUJizCtXK4hVig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219109; c=relaxed/simple;
	bh=2DHXInD0a2bLXamH17xDVCzQOci4jxzaK1FqezP8OE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEiC/PFSXhO8Pd1mo+T3xMgYRNQsLZ1iqvTTGcVzkdtQr3bPNc0mSbT2s5afh/BdSVmP+IZMF0udEHpPxmmZfKo5KTV9uO5KVqkcaA6xRn39+mm1CgqUs4C65/ZrzcZGVGOcuw7cnqkZA+PZafJBy9fOMKtScHNXIxKC/gQblUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nE60h6XW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nE60h6XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950AF1F000FF;
	Sat, 12 Sep 2026 13:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219107;
	bh=trWFGmgk98gFxRnYLAkJVvzt7v20McnBtkbGSDyUOR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nE60h6XWNkskbc8kjKga1HzcTdC9HQi7PIFM/mmx2jOCghcmKSH/gNmXQG1KYXXxD
	 xIpes/94rNTQiVyCqfDDEyxdG9N7dmt3j4o96WTLOI7oNwj9bVV2c4jbB5EvMGlMvl
	 5qzrgRZ8IzP6ROzdJsLK65JXUVb8Q4WIA9U3xA+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1282/1376] Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path
Date: Sat, 12 Sep 2026 09:01:48 +0200
Message-ID: <20260912065636.111962912@linuxfoundation.org>
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
index d8b3f929b963d..0e8fb01981432 100644
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



