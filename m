Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D613F3438BE;
	Sat, 12 Sep 2026 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226163; cv=none; b=LTBHOF51/Xd1dLGOEaLhqDgYwTtcuVg7eNSWF1tYflhdoo4G5Bzfyuho4WiFJ/MsrZUqLPUJ2WdQX/zkBcv652Y14zTt0/D+kjD9SM2b2MqEFrYUUvUnhOLPc9wFp0Ga2TVYOR9SuPspVfqLpQ8rcwcpDS0nr6KV7zCG62jJpVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226163; c=relaxed/simple;
	bh=CFf0yb57GxSWUSynAeDWu9lJTmbkOTyBmpwvCfy+HXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GingcyE8DDFYqg4CYGA0OfVXYfIc48FRpp1oGgbAT5CcKXaTbrQMaGzFB8I61NFiNj9DZToKypdnsHGnZLhIiiRZxE8NRa58YRVMs+w4vkDIrqqGv/UbJJFa8CQBLpT3rhmJJzcM/EN41udseMhxnav+LkygOFwh2B1lgxubtTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/LViCOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/LViCOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F5A1F000FF;
	Sat, 12 Sep 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226161;
	bh=HBQc7Xr4BqbavCoT9ktM81u7xvxlA3RLWOVaD2qxg0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/LViCOQlmo90/+kK9XF6IfUilQcLn28lnnw424NIcVbR3RZdm+F1U1IyqtNoXmTj
	 SqqL79r3daQj6MH/K1RhaPJZ8CcIl0Fy98RQX14vGXscxYZrYf//kHpTuAIwg2w8C/
	 lDhaEUJ/jARH7BW7fpg5JAc0XNKTeX5i3TNjzQHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1346/1424] Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX
Date: Sat, 12 Sep 2026 09:02:58 +0200
Message-ID: <20260912065637.403333482@linuxfoundation.org>
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

[ Upstream commit 155e3003d1e614f85566b636973df7118e1b4851 ]

btmtksdio_tx_packet() prepends the MediaTek SDIO header with skb_push()
and writes into that space after only checking the headroom size. On a
cloned SKB that headroom belongs to a buffer shared with the other owner,
which the driver has no right to write to.

Cloned SKBs do reach this path: hci_send_cmd_sync() keeps a clone of every
HCI command in hdev->sent_cmd before handing the SKB to the driver, and
l2cap_ertm_send() clones SKBs for retransmission.

Replace the open-coded headroom check with skb_cow_head(), which both
guarantees the headroom and reallocates a private buffer when the SKB is
cloned. The cost is one reallocation and copy per cloned packet, the usual
price of this pattern in network drivers.

This has no observable effect on its own, as the driver only writes in
front of skb->data where no other owner looks. It is a prerequisite for
"Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path", which
writes padding behind skb->tail, and carries the same Fixes: tag so that
both are backported together.

Fixes: 9aebfd4a2200 ("Bluetooth: mediatek: add support for MediaTek MT7663S and MT7668S SDIO devices")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 019cf85d3c076..2978360dc5182 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -260,13 +260,12 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
 	struct mtkbtsdio_hdr *sdio_hdr;
 	int err;
 
-	/* Make sure that there are enough rooms for SDIO header */
-	if (unlikely(skb_headroom(skb) < sizeof(*sdio_hdr))) {
-		err = pskb_expand_head(skb, sizeof(*sdio_hdr), 0,
-				       GFP_ATOMIC);
-		if (err < 0)
-			return err;
-	}
+	/* Make sure that the data buffer is not shared with anyone else and
+	 * that there is enough room for the SDIO header
+	 */
+	err = skb_cow_head(skb, sizeof(*sdio_hdr));
+	if (err < 0)
+		return err;
 
 	/* Prepend MediaTek SDIO Specific Header */
 	skb_push(skb, sizeof(*sdio_hdr));
-- 
2.53.0



