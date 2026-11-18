Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028210;
	b=vxFMIemSVkkaCZe8m8QHo4TJC9KVK1mTLVPtZjZgtXZgbnkL3zLelUF1XDyXrdZCHTM/
	 2NadiNFzmiBJr/KSQEHGOTiqL+0XxJR4Obvqn2vXQAWGH89batH25zjmvHEnNOR5ZBgdv
	 c1CrgDNj2Rfzib+Nq+PzmXCYbwH6+vQXCzXDEYdfuvyEVm3vqOxn4LWKx7yEWjSkMcp5b
	 pAmcGA8NtqRjEPazsaoLLZfzDJGQbMqYzL9hrg9/b3OulTYOYJT7whrEJNyN7UuzuYkcm
	 3wjCuHlQJn7VCOh1udr3KJ6x32rx/MVvJbSVio1YG+CmkiZDZH9cWsulvz9JdWxTtKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5T0N5o7Nm5qqjIMRiNksC+ZMJIw2pJz8cie+UFkLi4=;
	b=ulPnarM5p0+0tN1uX4CTH1KaLUeidxZvjYrPKcXgTU06YuAmiscZVrjRyty4owq0B9xB
	 278KhSaSIW26p3fWqtD0VS93KBQb+lgJhSJQ9twH+1hJIt5LeMWosBsSfwlj6uAdDoM0V
	 cNvqJN/79hFXGZ5X2ceQyKfScGVYvSTKCRHX/TBU4AhDkPK46OFPGjHI74u/llGDYU/5B
	 s6ayi4qIPRWGaIX0CzMI/YnvbNHdMDf/kE61PLvRaiPjsk8uTlogczwfguzZOJmGlxlti
	 0kxhn6LKGfAqAisJ4a7Qt/XpUhotc8Jre4NphDI3vFi8QvcOKDxMLuKa+AEW38047lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbUjtEmP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D91F606A31C;
	Wed, 18 Nov 2026 18:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbUjtEmP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841D51F000C4;
	Wed, 18 Nov 2026 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028210;
	bh=u5T0N5o7Nm5qqjIMRiNksC+ZMJIw2pJz8cie+UFkLi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbUjtEmPeFFI1VIu6t2ehhp3kGNQWe8jBLfk65nHACmkK29ZMgZFh84IAf9IQdwd0
	 yFUusSGFv6PwAQS8E7ptPg8fv8XSPe0Z4kFNdmMxi9JuRyMWsCBKclqEiCqEkv7tEM
	 peynZnqP85S9arWdTwY3hJlMpA5Ky9XSneExg5r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2064/2151] octeontx2-pf: fix skb use-after-free on ipsec transmit drop
Date: Wed, 18 Nov 2026 16:03:19 +0100
Message-ID: <20261118150236.906018006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 14d01ff1a4952198abae713a4ad428e07819b4aa ]

When an SA is removed while packets for it are still queued, the
transmit path frees the packet but reports the queue as busy. The stack
then requeues the freed skb, and the DMA mappings leak.

Fixes: 6a77a158848a ("cn10k-ipsec: Process outbound ipsec crypto offload")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20261027-nb-otx2-ipsec-tx-fixes-net-v1-1-2114c4f10c36@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
index 77543d472345e..3920cd0985831 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
@@ -1037,6 +1037,9 @@ bool cn10k_ipsec_transmit(struct otx2_nic *pf, struct netdev_queue *txq,
 	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
 	return true;
 drop:
+	otx2_dma_unmap_skb_frags(pf, &sq->sg[sq->head]);
+	sq->sg[sq->head].skb = (u64)NULL;
+	atomic_long_inc(&pf->hw.dev_stats.tx_discards);
 	dev_kfree_skb_any(skb);
-	return false;
+	return true;
 }
-- 
2.53.0



