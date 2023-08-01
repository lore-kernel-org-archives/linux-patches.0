Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E81F1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22CCC433C8;
	Tue,  1 Aug 2023 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882427;
	bh=632GqK/UiWvngfr67lbiE69pzQWD7kLvqmkvz0XaLJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1X2xWLub1c907cH/x/fbmClNHtUuCCwIROfed44aVMQQn3Y2eCGgCtlWtahe94+tw
	 KA9sIBuJsfOqVgzaxYUk17i8YfqZZC0PColNBSHXhjy7ZiAsojlvSUV8VB7a6+rAju
	 pQKRRe8dylG52UfuVnvvP3Ua0/0ZNjM5mOi9Ddek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/228] net: stmmac: Apply redundant write work around on 4.xx too
Date: Tue,  1 Aug 2023 11:19:19 +0200
Message-ID: <20230801091926.467145387@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 284779dbf4e98753458708783af8c35630674a21 ]

commit a3a57bf07de23fe1ff779e0fdf710aa581c3ff73 ("net: stmmac: work
around sporadic tx issue on link-up") worked around a problem with TX
sometimes not working after a link-up by avoiding a redundant write to
MAC_CTRL_REG (aka GMAC_CONFIG), since the IP appeared to have problems
with handling multiple writes to that register in some cases.

That commit however only added the work around to dwmac_lib.c (apart
from the common code in stmmac_main.c), but my systems with version
4.21a of the IP exhibit the same problem, so add the work around to
dwmac4_lib.c too.

Fixes: a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230721-stmmac-tx-workaround-v1-1-9411cbd5ee07@axis.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index d1c605777985f..7c26394f665e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -207,13 +207,15 @@ void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 void stmmac_dwmac4_set_mac(void __iomem *ioaddr, bool enable)
 {
 	u32 value = readl(ioaddr + GMAC_CONFIG);
+	u32 old_val = value;
 
 	if (enable)
 		value |= GMAC_CONFIG_RE | GMAC_CONFIG_TE;
 	else
 		value &= ~(GMAC_CONFIG_TE | GMAC_CONFIG_RE);
 
-	writel(value, ioaddr + GMAC_CONFIG);
+	if (value != old_val)
+		writel(value, ioaddr + GMAC_CONFIG);
 }
 
 void stmmac_dwmac4_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
-- 
2.39.2



