Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75B24C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3564C433C1;
	Mon, 14 Nov 2022 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430112;
	bh=D/3VIy+oz+ggmtGWhGlLqjWtvSbXGm2R9zUvy6ChjAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtS2MoAlXQ3Z5Lrv7v1ledcA4stCkv/dhN90ueljOWemS62aAKoDEhlbJqWZ/zJvW
	 xazXd3pSb+LLcWIPiZBqI+wnxPF5zKpqJojfUWfqu4RxAipKfZU90e20oafW2M+fss
	 M1gnqr99byJG9a/7B18L2YUnXHFaByshF+yLZ/+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/95] net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
Date: Mon, 14 Nov 2022 13:45:24 +0100
Message-Id: <20221114124443.795566400@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
index 752658ec7bee..50ef68497bce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -261,11 +261,9 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
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
 
 static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
-- 
2.35.1



