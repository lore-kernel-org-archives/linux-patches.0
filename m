Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D234F5E18;
	Wed, 30 Sep 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791538; cv=none; b=HxtfBKs9cx95FT4ZYh4VyEKVR05aXdLBbb1L40hKF7enqNH8iTqHJPSpCZle3pqHoYe/fdUkN/EBktrIP/ROZIDI59YyIVbNFp5nZMGvTUV2mvKxJ5bbSzbTVV9EDHyIDLSdx1z6RpOPRLFFonioFT2IUGLO1MVPQw6vV6+boL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791538; c=relaxed/simple;
	bh=jcdKiLzNDATJZi9yONeHNpxow/HpLf3cLEbmpk8A/ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjk9S52Z5iSAfmCjlVmzPwjQ5DUtJwDQZuZAD1gZ6rpz8TmYTnZDe4IGt+KPMqRtOZuHDsWbepNVw6nSVsWhRcHG85kavRnu2dkpKSgidz56u6Rx2tVbJMwWQIjJTVPW7sbdHXJRXuSz3c97L7UAtnVoiOr5qICdo1RWrBRmt5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKjml+V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKjml+V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E4B1F000FF;
	Wed, 30 Sep 2026 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791536;
	bh=96nR04XeFlTTC6XDCsHZ3oUdCOv9G/qg+DlOrxnop1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKjml+V++lzMnjkPme7Z23DwEfXqeSCZtg3R63s6qF2rJxGSk/sHThQroswRcO4nk
	 rynbLhRSTWkYJju0zimfvURcOnVAVauPEa2P7pSI5tdvqSxBZHHDL5UF2latFF6e7O
	 wPcIFtMIZ/xukgk6qfahiN5KmhcJhfB9tgT7KQvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/752] net: ethernet: cortina: Finish RX updates before NAPI completion
Date: Wed, 30 Sep 2026 17:23:27 +0200
Message-ID: <20260930152405.583434544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a09061ce8976..ea5f1df313d62 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1550,12 +1550,10 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
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
@@ -1563,7 +1561,9 @@ static int gmac_napi_poll(struct napi_struct *napi, int budget)
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



