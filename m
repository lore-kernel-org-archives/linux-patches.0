Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91424C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EB9C433C1;
	Mon, 14 Nov 2022 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430494;
	bh=jwzlcZRhl7zGGPKMJhkJO/qA4JZjlu8zmxVw8I0T50g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0OCdnRkCYbPFOvW/3+yezT3rkP1FSVZd8yYZXGPXlzUdRjkTTiPx/UO7dtWhL9e0
	 meZWbZhR5Mt1eROHaCsR8NAByP+pqDuqYbMVEJulPBfCsoCSJ54tzik4TbUeORLheY
	 7S5W6cuX1wzNFll7MdBEkIneb1IfXBK+ZY+3xc8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/131] net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
Date: Mon, 14 Nov 2022 13:45:14 +0100
Message-Id: <20221114124450.641692916@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit ed4314f7729714d788698ade4f9905ee5378ebc0 ]

There are two problems with meson8b_devm_clk_prepare_enable(),
introduced in commit a54dc4a49045 ("net: stmmac: dwmac-meson8b:
Make the clock enabling code re-usable"):

- It doesn't pass the clk argument, but instead always the
  rgmii_tx_clk of the device.

- It silently ignores the return value of devm_add_action_or_reset().

The former didn't become an actual bug until another user showed up in
the next commit 9308c47640d5 ("net: stmmac: dwmac-meson8b: add support
for the RX delay configuration"). The latter means the callers could
end up with the clock not actually prepared/enabled.

Fixes: a54dc4a49045 ("net: stmmac: dwmac-meson8b: Make the clock enabling code re-usable")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20221104083004.2212520-1-linux@rasmusvillemoes.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index c7a6588d9398..e8b507f88fbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -272,11 +272,9 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 	if (ret)
 		return ret;
 
-	devm_add_action_or_reset(dwmac->dev,
-				 (void(*)(void *))clk_disable_unprepare,
-				 dwmac->rgmii_tx_clk);
-
-	return 0;
+	return devm_add_action_or_reset(dwmac->dev,
+					(void(*)(void *))clk_disable_unprepare,
+					clk);
 }
 
 static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)
-- 
2.35.1



