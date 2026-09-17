Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F4C59B67F;
	Thu, 17 Sep 2026 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659548; cv=none; b=dJRlSpp1/PnRf8VqV6Hw/r7DK0vuX/6GnjPcnVrjez9lXmvtqmQHzo9KwJdWULX6AFAJGcvOQ9micpkE8QH5en9ob4rZaHDZQWe/rtBTpWHQngcAiyI73OQ8sMg2t7N+hJKC9ZJJesFXS36UV1wjKKcVsNKfw83kZBL6q2f+tlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659548; c=relaxed/simple;
	bh=qyIr4tcB43LE6RpY9y1Nc0DRZAvO4p4357ko70C07dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qThrUFmszQFKWSnk13NkERU1tQE82QK/R0cpxfUdIngAaptd0ziM7mqDrRfOFyk0pcI7bKGVxXfdl1VanlfFaOwzqczdmnTRCQebNs277o9xCVcdim0S7P9yms1avKWYMIOWsuI0Dqbqbs6yT1G72KrDc6nR0eskReViD6o11R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4fQR6QZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4fQR6QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A201F00898;
	Thu, 17 Sep 2026 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659543;
	bh=T17SJsAf2uJmBX7VterJr0fubWpdkb8gLh8GcDa6bmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4fQR6QZEqbNEUkayoFwjzyOnKFaQAyfVXa9vaPylcw8kxt0SjJrsH8fuFaT1mOkv
	 pKs4GEOyfbDknkfVbAKj0iPcvwsC8m2jRmeZyO6mdzHA17kMGwBUHHw+iDfY0N5oxg
	 twu7uES/g1YShlkQqktfq4EjLSzxKpQqM9lo8aiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 244/733] net: bcmasp: clear txcb->last before writing each descriptor
Date: Thu, 17 Sep 2026 16:09:12 +0100
Message-ID: <20260917151357.355915728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ed0977832ce4f..2bd035f74fa24 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -301,6 +301,7 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 		txcb->bytes_sent = total_bytes;
 		dma_unmap_addr_set(txcb, dma_addr, mapping);
 		dma_unmap_len_set(txcb, dma_len, size);
+		txcb->last = false;
 		if (!i) {
 			desc->flags |= DESC_SOF;
 			if (csum_hw)
-- 
2.53.0



