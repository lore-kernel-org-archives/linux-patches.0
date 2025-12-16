Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDC434DB5F;
	Tue, 16 Dec 2025 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886295; cv=none; b=sCMNwlDJJN81SbNpYis4cHjx4ag6ikpez230SDw40Qtko5uQ76MKOCY1s7/8GhrFcmOI3ngS1eaXvoOJ2dpaFCNGpfDKgSImkcKOj6wquSg2kLXTfIeyNuSmeEHfxKAHyhePhllEloR2nTxRnAwCDfFD0Q2ugmEsOW+P37Zyi68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886295; c=relaxed/simple;
	bh=0wTn2h3gbvbuYtAbZexE2HRIdPrm1bpEAAJSmF5wo+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AExl5OzcKL2qtP38Bw51Cf6+cZP6Bw4zEpQvwar2ZnnFVcyV5XrSPk9Ss8MAjOhjGuSkooCb75+df89855pEB8nxli5muzHH8xRQDXgeRijGCG3tz6ubkIIiTah8ab2Hk6ux1HpkWSc5lhaED1v/zomDZlI0inq2fBg1pNwZvoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgjn/2VV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgjn/2VV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394EEC4CEF1;
	Tue, 16 Dec 2025 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886295;
	bh=0wTn2h3gbvbuYtAbZexE2HRIdPrm1bpEAAJSmF5wo+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgjn/2VVwqllYQG08SJh2JbC3lSiAS9ZGa/VsFU82c2B04/q7xuKnloTWHe1eu4Dl
	 S2284SXHUu1xO9BqumHP1mSQmO/b1whD2fVdjfwyzs7mrwxEiGOTUjwBvaWGzfor/K
	 eauxiYVNB4myWQ+YsPWNFbYFnlIQM9dzD6vdnckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 396/507] net: stmmac: fix rx limit check in stmmac_rx_zc()
Date: Tue, 16 Dec 2025 12:13:57 +0100
Message-ID: <20251216111359.799833467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 8048168df56e225c94e50b04cb7b0514135d7a1c ]

The extra "count >= limit" check in stmmac_rx_zc() is redundant and
has no effect because the value of "count" doesn't change after the
while condition at this point.

However, it can change after "read_again:" label:

        while (count < limit) {
            ...

            if (count >= limit)
                break;
    read_again:
            ...
            /* XSK pool expects RX frame 1:1 mapped to XSK buffer */
            if (likely(status & rx_not_ls)) {
                xsk_buff_free(buf->xdp);
                buf->xdp = NULL;
                dirty++;
                count++;
                goto read_again;
            }
            ...

This patch addresses the same issue previously resolved in stmmac_rx()
by commit fa02de9e7588 ("net: stmmac: fix rx budget limit check").
The fix is the same: move the check after the label to ensure that it
bounds the goto loop.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251126104327.175590-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7a375de2258c4..abbd83f4c70f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5349,10 +5349,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
-- 
2.51.0



