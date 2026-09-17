Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDEA3A3E9A;
	Thu, 17 Sep 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659769; cv=none; b=rj5NS4a7J7fh969+gnX7Mx+N0p24dUneQHiYxiqC/0aIPNl4B7IWfvkzK351FaNM/KpR5Q6IXogXlwWJC86lyE1wlWiGov/N/9ShGCAf9DmGdvQedHsQ2uVjGjBQujE0Wtf1OYMrLBQ6ikhmT123idKMn7L+DKDjMVIeOMVRs9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659769; c=relaxed/simple;
	bh=4ksGttH9eVQK5Q+/YOJvc5hMxmhlIvdngsEAag2mSxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfue5/N9CenMGATEOkB08GRiRyAsiA4eYSnrhA3pRd+yFm7FeVzxdqgklAtfzlGpPMtWHCcCXOivSAFCW+RVEc75DEKSDopgaPsnyKTFH2z9KNpejDnalRpftu2rpQ319iGUAe0INEB6UYDFAIJ8Z9/FDtVLctyEZGHTF1Gzgj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeCdROSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeCdROSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F62B1F000FF;
	Thu, 17 Sep 2026 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659755;
	bh=uavdk2cJaaATdAgCmch8qp4DyNIQW9Xhvm5XW43qN+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeCdROSuw4ymp44TL8R+ymRKM70TpEl8ANNNh3MxMxSmo88nKqSe/zgxWcp4UZo67
	 dkCQOLDnyhyP2/iVTeh3LH5sVSrXi+4TEKvIjFQM4n8JOMO1goPZBdzZFactEk/iuu
	 AHr1Co158IdcRadgpUm4PaRMXGJy3PtvbGhyoLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 362/733] net: ethernet: cortina: Fix budget accounting
Date: Thu, 17 Sep 2026 16:11:10 +0100
Message-ID: <20260917151400.630286471@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit a0de06d0da78a3db53de65dfd7452cc6d111f703 ]

The gmac_rx() function returns the remaining NAPI budget, but its
caller treats the return value as the number of packets received. An
idle poll therefore reports a full budget and remains scheduled.

Return the number of received packets instead. Preserve the existing
free queue refill accounting by adding that count directly; continuing
to subtract it from the budget would invert the refill behavior.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Link: https://lore.kernel.org/r/20260509-gemini-ethernet-fixes-v1-4-6c5d20ddc35b@kernel.org
Link: https://lore.kernel.org/r/20260512131456.189452-1-pabeni@redhat.com
Assisted-by: LLM
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-1-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 4c762229ce420..1d9824d1716cf 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1450,6 +1450,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
 	struct gmac_queue_page *gpage;
+	unsigned int received = 0;
 	union gmac_rxdesc_0 word0;
 	union gmac_rxdesc_1 word1;
 	union gmac_rxdesc_3 word3;
@@ -1545,7 +1546,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			napi_gro_frags(&port->napi);
 			skb = NULL;
 			frag_nr = 0;
-			--budget;
+			budget--;
+			received++;
 		}
 		continue;
 
@@ -1565,7 +1567,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	port->rx_skb = skb;
 	port->rx_frag_nr = frag_nr;
 	writew(r, ptr_reg);
-	return budget;
+	return received;
 }
 
 static int gmac_napi_poll(struct napi_struct *napi, int budget)
@@ -1586,7 +1588,7 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 		++port->rx_napi_exits;
 	}
 
-	port->freeq_refill += (budget - received);
+	port->freeq_refill += received;
 	if (port->freeq_refill > freeq_threshold) {
 		port->freeq_refill -= freeq_threshold;
 		geth_fill_freeq(geth, true);
-- 
2.53.0



