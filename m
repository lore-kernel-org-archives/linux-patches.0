Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACBE418368;
	Wed, 23 Sep 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173338; cv=none; b=h75lq5gIQN2awjCBRaPoeUSdWdoMHxQlR3Dopvrc9HviVrMG0p33pEOQF4B1/bIH8Ijcw3R8unLjYM605FKRzUQ6oGa5mkrmVuDOJZpj/UX8f4AOryZx+zYDEvuRVXgvI7EXQzNTwqtXsqlurI92AqcSkOKjKUprAS2IEa1L1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173338; c=relaxed/simple;
	bh=gj1LwumjIHmNktlSfF+r9gmHqlMlPDYGKDUKW0Y0NFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvcoDTvz8EDusBVYL17n2ZEsVJeblVqL0C9nXr7jZaoDWkS2aj6lVM5L/A5HCd8Mb7twNLyKJHuJQ0m8xdGS2P9clAV+NT23DWNJBVmge/pGDQetHWkkSNzvDnUthfViluAnhYj686IPVfs240NRhPjZOqH1aSHBubIcLKaCIww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6zucOT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6zucOT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EA51F000FF;
	Wed, 23 Sep 2026 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173336;
	bh=QNNyM4DY1TOlWC9HOi+FQAXSXZ9UA7lkvw0LQJhEsDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6zucOT41zEs4bcSCm8VCVrEa6kHaVSiLBQzsEzu/4vNBz2dzW7vIEcd8XsVop1lV
	 RrrLt8mVWtdOZklhcgTrWRaM1NDinzNT1EdUQTTH+vCT7f/u+MkU1uv67JK95hFXFa
	 /85oeD67cG4E435sXrQzscBUR4Pgn/f1nng/7NbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 213/438] net: ethernet: cortina: Ack RX overrun interrupt correctly
Date: Wed, 23 Sep 2026 16:03:54 +0200
Message-ID: <20260923140650.280234501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

[ Upstream commit 1dd85662fee6e2ac580b1c4f9a0c0a7ae6e31f0e ]

The RX overrun interrupt is reported in interrupt status register 4, but
gmac_irq() acknowledges it using the RX descriptor error bit from status
register 0. For GMAC0 this writes the GMAC1 overrun bit, while for GMAC1
the shift leaves no bit in the 32-bit register.

Acknowledge the same per-port RX overrun bit that was detected.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260914-b4-gemini-ethernet-fixes-2-v2-1-5ab39a047b90@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index f08de623e6f7c..2dd2fa801829c 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1798,7 +1798,7 @@ static irqreturn_t gmac_irq(int irq, void *data)
 
 	if (val & (GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8))) {
 		spin_lock(&geth->irq_lock);
-		writel(GMAC0_RXDERR_INT_BIT << (netdev->dev_id * 8),
+		writel(GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8),
 		       geth->base + GLOBAL_INTERRUPT_STATUS_4_REG);
 		u64_stats_update_begin(&port->ir_stats_syncp);
 		++port->stats.rx_fifo_errors;
-- 
2.53.0



