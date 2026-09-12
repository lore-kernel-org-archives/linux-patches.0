Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8B3A2E12;
	Sat, 12 Sep 2026 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243423; cv=none; b=h3Q7irv/Kh0y1eD7ErKOljiL80D4g07BrtPhcUjIWD09gKSyafbeZvO6RfY6YDTecJIcWrBi+ktjBipyXBCxqOlgKNcO967YnlevXaSLZCXjb5UJKGoeFEkG8z+vQpXX5maj+3swu+8+sCKhIr4udLkyFSfKmREYlFS09JdQ3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243423; c=relaxed/simple;
	bh=NvRQugPdt9XoPz39U3rmqIyBtaSmsp3Ub48fJohVm2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVdErvEcIt3iwxi3Et7J6HwuShNzZ21e/6/Nu2Eqxe18Z36653YI2Z0E4EvDz8OdJfw6HaXpbjszBovtrmaykGLq9QAQOTURrQcGsj6iWaTIuQI4W0N48jt4dQtWpuVWjCVTgahb1SBhNmmJCFVgiVk63jTYConhQ8oK6qWZQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxZu06yn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxZu06yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211DE1F000FF;
	Sat, 12 Sep 2026 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243421;
	bh=nPIUfufwo5xKkvZWu6LCPg+DslhHv43VVd4J4xAJpDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxZu06ynTHG1ddRWgP6lOUa6RvXYY8IMC4CRM+XpQ+3GVSoUQ1ivGgTMuNsMXbFoH
	 Th5fytlvfqzlbEtEiY4GgiQcikGke0exC+VV5P4DzVNf55cyPdb0m8EKuCOaoN5fXE
	 ewu0JjX75wN/YPj+M30wk2QfHqi2uHNvqOB7CvO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 751/798] Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX
Date: Sat, 12 Sep 2026 09:06:19 +0200
Message-ID: <20260912065534.282291850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c41560be39fb6..971e9f6c36bbe 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -263,13 +263,12 @@ static int btmtksdio_tx_packet(struct btmtksdio_dev *bdev,
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



