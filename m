Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF3377AA1;
	Sat, 12 Sep 2026 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219104; cv=none; b=m9SBJmzSdkXMhm/wWEm7gPeM8HmoU4lST7ruN5RAA0DQREdsQ95TsmAxccGvsTHYm0GyzyE7f4XkB9aSsWqCZJMIRBaqXTMig1qOnbWnqCn/zak8pO8Cwc8nN9MrkVzoQvnpP2l3GRgo7cdBPIfLV0Scv6wjr0IrCm44Fb95v3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219104; c=relaxed/simple;
	bh=ztVanzeERMYljHW2NR5PfeJblE3JOEnuJGdnkPEhrRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8SieblI246yQmdWl4IXy0JIDUacc+ChDTtysbdeACwV04Kkb7ONYA+99+FqxgBLFGFM8AzYk7rHQfNz/7daxGxmlEyuFGpmT9beO8tNMhchodIGB3P1YPcN86AyI6OEDPmOJR51oQ2S/ZKVAofjyT9Q/NSTVv7jSoyuC0rLFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnoD8IQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnoD8IQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC581F000FF;
	Sat, 12 Sep 2026 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219102;
	bh=B2OfMWRvF3NwBpzsEMJZ2CSzBPjxWE3WbciKfsgzVHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnoD8IQYH5sMHM6DvygDfgxQsMeeh5IAGvzdWK7bpl6a3WYv7ww9BqLJGZGfOpFe8
	 RJG9Bh2F3f7uRnWt3Y9Oo0pMlRRdheyTKEV/f2QUXjs2dLegD+aeYTml7UkSgKsKAa
	 duiDzvSNycjD0foSDmELAdWqCbb7i/uJTh01s3+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1281/1376] Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX
Date: Sat, 12 Sep 2026 09:01:47 +0200
Message-ID: <20260912065636.089678213@linuxfoundation.org>
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
index ea976671983f5..d8b3f929b963d 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -274,13 +274,12 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
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



