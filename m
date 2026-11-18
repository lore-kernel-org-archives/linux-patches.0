Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019590;
	b=YDLwuwu6HOi7C4pZT455P8tlOt41TGKssBNNeeNLcByxwM/IzbRp4y8NFv5jYDJGIIfJ
	 8yKXFR9jQ4O0jpiJQjOFl35mxtE1aW+sX6sBQ08Ye1VfH5aSrTq+M2vstI8hEC8llzcQ3
	 9fOLi0KJ+kNZ/OWrKWJMkSBy/pGUiWI8O/gkS2jUGv4P/qiK6ze+v9cMUsCGyg1HXazZY
	 ZkdpD56biHiF1smJtKMpVRtWkANjoT9qCvHzTd8iFWlpg98RjFr775wZbnaa2ctlaDnUi
	 Q4LXrjj28iHt/fjR6/KpEmQMMuTitzNollSnpx1LfTXr9LIT4jnWKe1aiDAv7d7AeRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RT6ntsWJZSAgTukH6h80q3T4OeNRL/MLDBguuL1a//0=;
	b=YKAI4zb3Kf2nBofw6TXYV06DPY5Bc6dmfqHR8jpbMiJt/KEfd72KFDebxV1LbhY45rvN
	 heH2Uh+KsJIap8vAjKUVRD7t0JdsTYoLUoUP1t7K2h2l+WaLoD9bLKR7dZEGxDhjXQzB1
	 5uiLfRpAWbqUE18bETsEB1/1zhnq3Er5DPNg35BUQjzkRXpivcNFxDHW0WHtMnwBcZB2d
	 3DSujxtUEAFQ9ykybBC7IEOmytKgnglsG7HBF4tkHSI3XMoA0JG05e3HFMjA4MVkdWNZY
	 Fa52EDcUCk33rD9jLttbygABe69obzKBEvHI76VwGJnycpenD9Q8qcKAeVAKYQ1+jdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfn51KG+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C7606A320;
	Wed, 18 Nov 2026 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfn51KG+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2546E1F000C8;
	Wed, 18 Nov 2026 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019590;
	bh=RT6ntsWJZSAgTukH6h80q3T4OeNRL/MLDBguuL1a//0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfn51KG+Wl7G7BiKRJgw45PFCsVG2W1Q1NocGQJk9vsxbD7EfFKymzEtQ0txk0D/8
	 tfLfLIURJO6gLZ7VoOERlYptQILolpsK/7jTauH6U/Z8Ut3Dzv+DDN0G6p+Ox1CQw5
	 s+QvsM1i2BADjcXj4mcO24ypB3z1nYMjgi+8Y9SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1649/2651] net: stmmac: set real_num_tx_queues to max(offset + count)
Date: Wed, 18 Nov 2026 15:48:09 +0100
Message-ID: <20261118150347.151983987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit d128212667593c548a3c67d30031063ed46c29b7 ]

tc_setup_dwmac510_mqprio() computes the number of real TX queues as the
sum of the per-TC queue counts. mqprio_validate_queue_counts() only
rejects out-of-bounds or overlapping ranges, so layouts with gaps or a
non-zero first offset are accepted, and in those cases the sum is smaller
than the highest queue referenced by the netdev TC map.

netif_set_real_num_tx_queues() then passes this too-small count to
netif_setup_tc(). However stmmac_set_ndev_tcs() has already zeroed
dev->prio_tc_map() through netdev_reset_tc(), so when netif_setup_tc()
runs every priority maps to TC0 and only the TC0 range is checked. A
layout whose TC0 range fits but where a later TC references a queue
beyond the new real_num_tx_queues is left with num_tc set and its TC map
pointing at queues that are no longer real, without any warning; only
when TC0 itself is out of range is the mapping disabled. The real
prio_tc_map is programmed later by the qdisc, after this call, so the
driver cannot rely on netif_setup_tc() to catch those cases.

Compute num_tx_queues as the maximum of offset[i] + count[i] instead of
the sum of the counts, so real_num_tx_queues always covers the highest
queue referenced by the TC map. This is a no-op for the contiguous
channel-mode layouts where offset[i] == i and count[i] == 1.

The issue has been reported by sashiko and the patch has been tested on
Qualcomm RB3-Gen2 board.

Fixes: 195e4f409a40 ("net: stmmac: support fp parameter of tc-mqprio")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261006-stmmac-mqprio-prio-offload-v5-1-d7da93419784@oss.qualcomm.com
Tested-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 42a00446e9b41..1aa80d51ab33a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1303,7 +1303,8 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 			.count = qopt->count[i],
 			.offset = qopt->offset[i],
 		};
-		num_tx_queues += qopt->count[i];
+		num_tx_queues = max(num_tx_queues,
+				    qopt->offset[i] + qopt->count[i]);
 	}
 
 	err = stmmac_set_ndev_tcs(ndev, qopt->num_tc, tc_to_txq);
-- 
2.53.0



