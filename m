Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032556;
	b=yiWjZUJ7VS5JcbioKv27zW/cIAXpaBDobZHZCP3Poj9T1oLsqDlvp2nnp5H84QKw4sv4
	 3qOmVY/+MNZj8hfKex31KW+DuKC13G5MoM3phV4fIGvSzCayRm0Fr+OytWq63pw+9VKKe
	 aQUy3HZ6a60ONhnEot2Q6J7PxoE66VQeZdK7zttcd5KBNeFD1LCxhGwg4E2ilK76f2B0a
	 Io5leKOzCe6wFsXQoh6YYAAcuOyFrEZgLbRwcQtVz/vMWWRnQKToO8KBAt9vy0QspLRv/
	 tSb9Wamc/5CYnOgJmilvWHEldiDM/YcnC2io12JLLS0G5HH11vIQm7tBnw9uAQlffCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LN7q8En7WDX+2wUJu9mX2xM/tB4LWHJCeQZiSEnkZR8=;
	b=YqcM0foEAFXhwoHgScPnQZmOZZmWzi480EvNoBFouqYLcEdD11tsnD3yEipMkApTftW6
	 7/J6aw1HStZOKbqeSN/Gs0WoUKU8ViKuvv9OmOC9hn9Nj34IC0YN6bJIrgjQA1xIb3yD8
	 ohjRe+ZQHwQuqaretILokaWNbT63FijdZrCfBcepmtgNJd9fzBhEROsdNB56Xx+HuLmzm
	 qK8H3EGXmRulyWWxaNEN9zpRMrOJLoJRJDOij0LKZrMZA1O+jaaRyiryR6phIVJQ7EoAw
	 fWs/qI+HgZaJ4ko7y+bh4avrSW+ARMcwj6OfVaMcyfX4dBTYru3tg4MuSxh+N313p2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7lyGj63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C65606A33F;
	Wed, 18 Nov 2026 20:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7lyGj63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4501F000C4;
	Wed, 18 Nov 2026 20:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032556;
	bh=LN7q8En7WDX+2wUJu9mX2xM/tB4LWHJCeQZiSEnkZR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7lyGj63qr/PquM9ZxlNQSUGg2crSjxvkG22iMQV+U3mNBZowDOZhFOdBO/s5TwDD
	 qn10WjcCC5e90/iN9EuIKF+aAA9VhMr4O+Mn4onK+tibt7m3E+FGtCnBOLOc7xV7Tw
	 o8hmWxNVEVcakWill2bT7XXA8yP9H6rS0zy8u8zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1452/1756] net: bcmasp: unmap previous DMA mappings on TX map failure
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150106.904079501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a3cf9877558ab2c51182af558815dde64fc17cb9 ]

When mapping an skb with fragments for transmission in bcmasp_xmit(),
if mapping fails on fragment i > 0, the error handler calls
bcmasp_clean_txcb() for previous iterations j < i. However,
bcmasp_clean_txcb() only zeroes the control block fields without
unmapping the DMA buffers, leaking the DMA mappings allocated for the
head and earlier fragments.

Call dma_unmap_single() before calling bcmasp_clean_txcb() in the error
cleanup loop.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-3-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index c87baf249c5f6..a67205cf9647f 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -317,6 +317,11 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 			intf->mib.tx_dma_failed++;
 			spb_index = intf->tx_spb_index;
 			for (j = 0; j < i; j++) {
+				txcb = &intf->tx_cbs[spb_index];
+				dma_unmap_single(kdev,
+						 dma_unmap_addr(txcb, dma_addr),
+						 dma_unmap_len(txcb, dma_len),
+						 DMA_TO_DEVICE);
 				bcmasp_clean_txcb(intf, spb_index);
 				spb_index = incr_ring(spb_index,
 						      DESC_RING_COUNT);
-- 
2.53.0



