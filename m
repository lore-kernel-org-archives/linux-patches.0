Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78D54EFFBE;
	Thu, 17 Sep 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659767; cv=none; b=f1iyuNTO8JdYmvhYrqoPfP/m/jsaoHiP2RVXpcTlokMd/glum/2j+lh4tXILN5Qu3T6a0dCEBNWpia1Kpe0UiNETbBpXiY5d60Z9QiazVwxKO1dppFkhuUKjj5LXh/fnELOP+HTASGLoHk8Auu6TYuW3Zwa3DawBZ1paTYsYBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659767; c=relaxed/simple;
	bh=fUmfU24zlZgMTUyvFc3e7WIGAS7g2I4bH7cqkC2tLhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2jAB2QAtm/ABp6xS04q+bDi/en1JNmjhdSGjWwGP7z6feMUa0QjJ2lkrK2EfIBvtyAaNLgukjP2XLrmp42tnGAemWTIv4qBsTDJcLMwmbOPNECwDWsXDZ/0/QV4rELwoUgZYw6HmyLeUoK3jrjL9D14igdWKfP1dbnEEwxS0OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjNfSSht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjNfSSht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359FF1F00898;
	Thu, 17 Sep 2026 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659758;
	bh=gWO4pwWvl0N1psbeHpCaQgcw/O/GUX1Xc3w0sAex87E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjNfSShtZJfsZ+vdZZjRYp/sEnwtUu7sd/lioQn1iojn28xBJHntwY0i7CID9X6D4
	 z5b3o4o2djCFK+bBsbmwE3qqsMC6l/XW0z5Djg0b0sJywpKjBERIL07y97FbHCgTWI
	 ceIsCgIKK/rYmFbSwPBs1JxUZzA38YknaVIT0N5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 363/733] net: ethernet: cortina: Finish RX updates before NAPI completion
Date: Thu, 17 Sep 2026 16:11:11 +0100
Message-ID: <20260917151400.657753512@linuxfoundation.org>
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
index 1d9824d1716cf..6502220362cbd 100644
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



