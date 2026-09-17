Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D224E06F5;
	Thu, 17 Sep 2026 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670401; cv=none; b=LXVEdDQs65ZREvWIEYz+lMZneUnMiCN4NDDpOdjgErv8Iu8q8xJywyKMm6PK2zOTsBUYA7E0Fj67+5mk/Tx/sBGHUjrM81dI+layl8/v/R6VWbXwysfpGcBcEFx6lzbi8txJ3+dMQ72OdcgPuqFICvhEIL6FQBPAcNd7wVEugaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670401; c=relaxed/simple;
	bh=q8YBEEU+IqYOvumXjE2+p5JSdzlExCeyR5KjT77io4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCnBZn7+nOHbQxnwpoaqQI3QUCWdWFv+xH987OFvZmT+JbJ3e+QxhYU0c+FqsgIjLA8q35Bo0dbUY+XrzMLlgnGAuGAxWl2PHCV/FE4JsYKyvIwWA0WL3Gsj2Xg3SUPs1Ng1UaSBvjHbgXh4ppkOCUS7SjaisGdTb9vqHWvaFso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNdrZr+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNdrZr+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0871F000FF;
	Thu, 17 Sep 2026 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670399;
	bh=X5Piy9H6xG/BaWB4lqLnRm3vy/fdQA0YfkDsqJ7H0I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNdrZr+yeKELVnClJ//65SIIq0R9haEBZNgBu5MRbkWQ5LDwzGIjV7mAnSzYUDfQB
	 g6HE2KUeTHGJFt+jlb+/97elyZLqitixi9/fHkTs9jbTUz24y/VzO8XXJDuln6kYyR
	 ANSmvBVQoBcy3tAt6pyGkrE0Jth1gPWkJxXztuAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0652/1102] net: bcmasp: clear txcb->last before writing each descriptor
Date: Thu, 17 Sep 2026 16:09:55 +0100
Message-ID: <20260917151556.534426576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 18e5e0ec0e9282c897e2aa81a3e43ccaee03b003 ]

bcmasp_xmit() only wrote txcb->last = true for the final fragment
of an SKB; non-final fragments left the field untouched.  If a
descriptor slot was reused while it still held a stale true from
a previous SKB (possible when tx_spb_ring_full() underreported
fullness), bcmasp_tx_reclaim() would see last == true mid-SKB and
call dev_consume_skb_any() prematurely, freeing the sk_buff while
its remaining fragments were still in flight.

Unconditionally clear txcb->last before the conditional set so every
descriptor slot starts from a known false state regardless of what a
prior transmission left behind.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260831184235.4133351-2-danesh.petigara@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 5ab4be83122d9..6232dc6c6c6ba 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -333,6 +333,7 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 		txcb->bytes_sent = total_bytes;
 		dma_unmap_addr_set(txcb, dma_addr, mapping);
 		dma_unmap_len_set(txcb, dma_len, size);
+		txcb->last = false;
 		if (!i) {
 			desc->flags |= DESC_SOF;
 			if (csum_hw)
-- 
2.53.0



