Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED245560F;
	Mon, 31 Aug 2026 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183635; cv=none; b=aBgSZr7YvyBttEqnBm3NYodhF9aZsTHhXf7/urJvz7Y6VkdciFecTr1I6rC7NhQ9zLDR33/+lVs45ThbIs6BD/Tlmt/0BvIEnFUrWeQuuz/mx8WeUab3yGrjhpXMmi9x5fUysysydWCY5w6ePswxB3ymS5qD3B9VuUiT1P7LCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183635; c=relaxed/simple;
	bh=zCiHXOd1LD+AjfHp05fNRiv7SOt2KSCRwbVXbbcAMd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8MtBbkeYXe+4NAjpcFxE3hodgVkmsR4yRvYFu5At3iaGOygZByCUSCVPifsEl9hPDrEjJDPSEvhi2Ysc4je4u+3sY41ZWO/zJ1tAUiQcNXKOqmz9mQhlMPePST6pHwsZBM1TYjXSUwp7bTNNN22GLF7l9eACDSnlquMSkOqNCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGgbL68k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGgbL68k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2FE1F00ACF;
	Mon, 31 Aug 2026 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183633;
	bh=iKsSeNKVyL3SwSg+t7MgLcjrlPQYJJOPY8s/xCjy++I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGgbL68kZFYDRCtjONjvVekYOhQ9WBsgRvPyfFcOpYLOD0oDLc99Z0QrAushL/gYp
	 +omCJq5yDncYlrLjVB02hJNo0Ts5h//yApUcmmWNTpw/q+L/Z3+X9y2bfnyYKGVYAx
	 UIPgy96NUCs42PY0ysFH9RqNqAXNIOLuuuanLs79xBAgqwppEjnlmVqb2o+FUqsTKQ
	 RY3MVtTt6eWHfZv6r3qwB7aJ59bWDnLPWzSsgrJZMDNMmSfTIGInvIReBPcctO1PQG
	 WwrPfi1TU4HNuzuGZ7i6M0xllyscgtFX0WzRN783J75phZaggW/Ei3CfKHGjGQmCNo
	 7AuHt4bm6qskA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: stmmac: xgmac2: disable RBUE in default RX interrupt mask
Date: Mon, 31 Aug 2026 09:23:58 -0400
Message-ID: <20260831133314.4125787-210-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit d3265c19b35d036bba327b36b5366bee76b0157c ]

Enabling the RX Buffer Unavailable (RBUE) interrupt is counterproductive
and can trigger a MAC interrupt storm under heavy RX pressure. When the
DMA runs out of RX descriptors it fires RBUE continuously until software
refills the ring.

However, RBUE is redundant: the normal RX completion interrupt (RIE)
already triggers NAPI, which processes completed descriptors and refills
the ring, causing the DMA to resume. The RBUE handler itself only sets
handle_rx - the same outcome as RIE.

On Agilex5 under heavy RX pressure, the MAC interrupt (which includes
RBUE) was observed firing 1,821,811,555 times against only 2,618,627
actual RX completions - a ~695x ratio - confirming the severity of the
storm.

RBUE does not provide OOM recovery. If page_pool is exhausted,
stmmac_rx_refill() cannot advance the DMA tail pointer, the DMA stays
suspended, and RBUE fires again on the next NAPI completion - a storm
with no forward progress. This patch trades that storm for a clean
stall with the same RX outcome. Proper OOM recovery is a pre-existing
gap outside the scope of this fix.

Note: as a consequence of disabling RBUE, the rx_buf_unav_irq ethtool
counter will always read 0 on XGMAC2 devices. This behaviour is already
inconsistent across DWMAC core versions.

Remove RBUE from XGMAC_DMA_INT_DEFAULT_EN and XGMAC_DMA_INT_DEFAULT_RX
to prevent the interrupt storm while keeping normal RX handling intact.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260609121703.9736-1-muhammad.nazim.amirul.nazle.asmade@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both background git searches finished successfully, but returned no
matches on the current `linux-6.18.y` checkout — expected, since the fix
isn’t in stable yet.

The commit was found on `master` as **`d3265c19b35d0`** (`net: stmmac:
xgmac2: disable RBUE in default RX interrupt mask`). That confirmed the
buggy RBUE masks are still present in 6.18.44 and the analysis
conclusion stands: **YES** for stable backport.

 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 67e2d539c3385..301e5e8993e37 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -385,9 +385,9 @@
 #define XGMAC_RIE			BIT(6)
 #define XGMAC_TBUE			BIT(2)
 #define XGMAC_TIE			BIT(0)
-#define XGMAC_DMA_INT_DEFAULT_EN	(XGMAC_NIE | XGMAC_AIE | XGMAC_RBUE | \
+#define XGMAC_DMA_INT_DEFAULT_EN	(XGMAC_NIE | XGMAC_AIE | \
 					XGMAC_RIE | XGMAC_TIE)
-#define XGMAC_DMA_INT_DEFAULT_RX	(XGMAC_RBUE | XGMAC_RIE)
+#define XGMAC_DMA_INT_DEFAULT_RX	(XGMAC_RIE)
 #define XGMAC_DMA_INT_DEFAULT_TX	(XGMAC_TIE)
 #define XGMAC_DMA_CH_Rx_WATCHDOG(x)	(0x0000313c + (0x80 * (x)))
 #define XGMAC_RWT			GENMASK(7, 0)
-- 
2.53.0

