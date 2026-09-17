Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CCB522EE7;
	Thu, 17 Sep 2026 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665927; cv=none; b=Pqds20FRpHgX6HyX4l13CNRBL63IISFi+hHEEO9syLR850Bx89NitWNXX6hiSELf3CXa/zQR5V8V2WDYn+9rr6UA9eM4t2aYM8kldCKdjbGFYLR6oicVsy2OSmR3QA5k08UoujrTf3vrwTTmVCR7Rtshlce2UQJP9JJef0OgzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665927; c=relaxed/simple;
	bh=FlcSYx7G4Un3L40V2TyxRcY02rHEkr3fw9B0PqCiCu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnBfoYqsVI78UIpm0x6mWi05IeDZ36ey3QaSlDFOSnV4u2d+Xs+A7OmAQF3Gl9KBva9mapAgBWHM+bENfaLE3BTgdVDwjyL5O2qTGA8HDNfFrju6DbfPofyqenhT6lEa1CRqELF1ffsjjDCR59ovP8osKisMg1cLToTORQLO2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLHj0Ttt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLHj0Ttt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9B61F000FF;
	Thu, 17 Sep 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665925;
	bh=6MEL8lcIQjwdm2OyPg0XtrfS2FUXSx0WqmfkqKv5sKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLHj0Ttt8HD79BjNoRIVnV53SvUE759gQ407Snc7PLXlwPaASvqA0pN22dvMT+Mc7
	 jDsQGWrQQgCsMGo/42wwRjXsix0VFXw+9Ilg+an60MIpSEjDFO0S2MT4ln7iKnFxps
	 yQ/PwTgFKqkvws0uKeBCJZQKAr93+Jh+cOzQu3SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0867/1250] net: ethernet: cortina: Fix budget accounting
Date: Thu, 17 Sep 2026 16:11:02 +0100
Message-ID: <20260917151615.474150625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 40bec34f06a7b..aee5cdbf62afb 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1451,6 +1451,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	unsigned int frame_len, frag_len;
 	struct gmac_rxdesc *rx = NULL;
 	struct gmac_queue_page *gpage;
+	unsigned int received = 0;
 	union gmac_rxdesc_0 word0;
 	union gmac_rxdesc_1 word1;
 	union gmac_rxdesc_3 word3;
@@ -1546,7 +1547,8 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 			napi_gro_frags(&port->napi);
 			skb = NULL;
 			frag_nr = 0;
-			--budget;
+			budget--;
+			received++;
 		}
 		continue;
 
@@ -1566,7 +1568,7 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	port->rx_skb = skb;
 	port->rx_frag_nr = frag_nr;
 	writew(r, ptr_reg);
-	return budget;
+	return received;
 }
 
 static int gmac_napi_poll(struct napi_struct *napi, int budget)
@@ -1587,7 +1589,7 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 		++port->rx_napi_exits;
 	}
 
-	port->freeq_refill += (budget - received);
+	port->freeq_refill += received;
 	if (port->freeq_refill > freeq_threshold) {
 		port->freeq_refill -= freeq_threshold;
 		geth_fill_freeq(geth, true);
-- 
2.53.0



