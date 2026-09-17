Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0974398F5;
	Thu, 17 Sep 2026 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670638; cv=none; b=qk/f3SPYTstEido4g9HuOKBggVhuJgQvocHFs5HB5myvFRDvCKzvUfw93UZNf6KzTOKVYGup05ICcK/3BUIWkRk+4oiqWc8y/kTr8CZ3HBYjYmueZxuL6qbZnwLj+8Dy1f4N945Ei+mPrpzeJqWSCanDnZHlJz39aCVhU98v2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670638; c=relaxed/simple;
	bh=XZPKGoHOQ3N3n5OIdh04GycViA/8Y4xyupmB5MAJAxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XF5uq1/XthkrojPmZddk8qe2AeONOdX6FPPcoXcpM72OiV0l+s2gqmEp78zXdAufDsFwbczbHuyA1i6Zn25uJpkztUR/0iE/u34lOw8ANZK0YMs0hpNN7YRyK4lI4fAYcLji3aKnYyVBe1lHb2rae2He6HbRqUzSP5onXJXrd1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GE2Zkc15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GE2Zkc15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13D51F000FF;
	Thu, 17 Sep 2026 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670637;
	bh=H37QuzCA3mImExHQsPlLRHYlsqgMPBdxevkHt6nN1d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE2Zkc156qiuFSR5epxmr3BBoyn/7guZaY4UIlORZgv1nRF10d1dboDvqtLM1J8Tp
	 d6cyrPSx/Vu5vqbklwnc6UUR22J0rpYlUQzXO7Q5eJlbi4HnOheg2GBrrk2NBd4+62
	 RQHkAwZANb88u9mO6hi8+NQJ99UxAIg73cdKxkO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0726/1102] net: ethernet: cortina: Finish RX updates before NAPI completion
Date: Thu, 17 Sep 2026 16:11:09 +0100
Message-ID: <20260917151558.593808770@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit baa26841cb9a2cdc7e0e99d6854a4e3359bf7393 ]

napi_complete_done() releases ownership of the NAPI instance, but the
Gemini poll keeps the RX statistics writer section open and updates the
free queue after calling it. A new poll can therefore start while the old
writer is still active.

Finish the statistics and free queue updates before releasing ownership.
Only re-enable RX interrupts when napi_complete_done() reports successful
completion.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Suggested-by: Joe Damato <joe@dama.to>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260903-gemini-ethernet-fixes-v2-2-2bbbd598ca6e@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 627e4221ba396..353530b4091ae 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1581,12 +1581,10 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 	u64_stats_update_begin(&port->rx_stats_syncp);
 
 	received = gmac_rx(napi->dev, budget);
-	if (received < budget) {
-		napi_gro_flush(napi, false);
-		napi_complete_done(napi, received);
-		gmac_enable_rx_irq(napi->dev, 1);
+	if (received < budget)
 		++port->rx_napi_exits;
-	}
+
+	u64_stats_update_end(&port->rx_stats_syncp);
 
 	port->freeq_refill += received;
 	if (port->freeq_refill > freeq_threshold) {
@@ -1594,7 +1592,9 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
 		geth_fill_freeq(geth, true);
 	}
 
-	u64_stats_update_end(&port->rx_stats_syncp);
+	if (received < budget && napi_complete_done(napi, received))
+		gmac_enable_rx_irq(napi->dev, 1);
+
 	return received;
 }
 
-- 
2.53.0



