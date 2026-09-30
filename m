Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1E23CAA55;
	Wed, 30 Sep 2026 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795212; cv=none; b=NtoXY0xEMlOMuEpndflJ4qa0BSpGgQ6g7/voullX+Yyd/MTV5h0Sr3EnN7J5/IU6di20JsWcHLQtgQOX0MgX4UC0t7I4YM/5YEqc0NC4204WH0+p9YRcHctjm9e8R8TEApXrNFbJoeHXZZ4v0vrnYvQdGIv4C5W2D+H/TOLYrls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795212; c=relaxed/simple;
	bh=aGWQzARbXr5iM07NfsMvmMV2pRl1cE8wJhWonLccgwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSrW8Xo6l0tZ9LIwpzNXiFQHC6tZq60Bx9gXmtkOxtS+mbDkmcJK/q8VO+FskZWxzzZAhnXimxrPRN5dzq0fJwJhtq18mX4Yf24EZMDY+S8VyslNCMyE/FUPZG1TusCTydRFw0SlTIR1mIM+e+uHaN3XgDBfy6YQFaPt7pb4mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRknequp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRknequp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8985F1F000FF;
	Wed, 30 Sep 2026 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795211;
	bh=IR4bFOkACm7h1+PZ1Ya8q675gZhPzxhw10fHq1h00YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRknequpksi9L4QN/o5Uclz+b7fL0QDc577ITTnrFvG8UbRR8V7N0I1m6xkJFos8/
	 ZRgrVmGVLBBU3nCpGNxwUulOomc43ixRi0nOIYaCONxMzeZnFcionI4ECIOzV+NDW+
	 WiKKYbbeo7sPm1tYVxhl4QjZzcyM0oZEDmxnOw6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0483/1193] net: bcmasp: clear txcb->last before writing each descriptor
Date: Wed, 30 Sep 2026 17:19:27 +0200
Message-ID: <20260930152444.888617018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 3127f335e0b7b..7ed034389815b 100644
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



