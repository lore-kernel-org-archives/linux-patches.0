Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8351B36C9D2;
	Wed, 20 May 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297781; cv=none; b=nfW2x/FCPWHBB1CJT/72xlv45V0Wb85EUnd+BMbmr/K+esBqdWWurwZnLvReRXSdzCI5JYCKTJkjUsn1RwguTOFVuN6D19MIorYWqBnxPf9LCsv4czqNISPbvjf6ssZsC1k2savqSffXZRDAIxYsmjL7sbiunJQHRZKaiJGa7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297781; c=relaxed/simple;
	bh=ONBrOlu26rfKAd6FltexNaFBojxIlo5nWR7s50zt6s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6SR/5Yrcr+IeJmn09qg/Thv9cB97QSq10ne2aSp4ANv4uxxNOd+CivjN0SuvixjgvaqQPOIKOTTPTwnmmRFtpBEphZo64QjPehvp40xRQSTA0TcgPV/HVY7KEZmRXM3hDwrK0Sgi6E2rlXgbSmXtiUf5N4/+d59N4TGegdEYHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOOJhCAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOOJhCAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7A71F000E9;
	Wed, 20 May 2026 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297780;
	bh=naJLJAv39kmYva0CT3tgxfqPPR+Zx4AgtWgdHfLDhNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOOJhCApJTrZuz+nAM2TNFSLNRSHcSjWrqhfqQrYUhsExAmi4XcCzyTssFnfVyMPZ
	 1tWaWzGWNueybxCM8NtHOBYT5NpOk49vjSP/ZrRnELCdaEk1m3MZMuVBZ3LbWRGBiC
	 QevlAJ2WBkbgB0kaw2fkcOteZIG9kvTQTDNnjOSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/957] net: airoha: Add missing RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue()
Date: Wed, 20 May 2026 18:10:43 +0200
Message-ID: <20260520162138.019766611@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 656121b155030086b01cfce9bd31b0c925ee6860 ]

When the descriptor index written in REG_RX_CPU_IDX() is equal to the one
stored in REG_RX_DMA_IDX(), the hw will stop since the QDMA RX ring is
empty.
Add missing REG_RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue
routine during QDMA RX ring cleanup.

Fixes: 514aac359987 ("net: airoha: Add missing cleanup bits in airoha_qdma_cleanup_rx_queue()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260408-airoha-cpu-idx-airoha_qdma_cleanup_rx_queue-v1-1-8efa64844308@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 132a32e9e633a..cbf21e15df6dd 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -844,6 +844,11 @@ static void airoha_qdma_cleanup_rx_queue(struct airoha_queue *q)
 	}
 
 	q->head = q->tail;
+	/* Set RX_DMA_IDX to RX_CPU_IDX to notify the hw the QDMA RX ring is
+	 * empty.
+	 */
+	airoha_qdma_rmw(qdma, REG_RX_CPU_IDX(qid), RX_RING_CPU_IDX_MASK,
+			FIELD_PREP(RX_RING_CPU_IDX_MASK, q->head));
 	airoha_qdma_rmw(qdma, REG_RX_DMA_IDX(qid), RX_RING_DMA_IDX_MASK,
 			FIELD_PREP(RX_RING_DMA_IDX_MASK, q->tail));
 }
-- 
2.53.0



