Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D5D1A5B6
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 23:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldO8y0aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3424CC433CB;
	Wed,  6 Dec 2023 23:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701904656;
	bh=8uz7AK/6yHawqaJPcw4bg1vliKDTq/KL8xQPTh+RBhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldO8y0aaCAI30pGHZ+jGi3ri+gv6J7mHp87soVwGOCnw7hGcQgtXzAK6BzELZoYXT
	 EkEFX2BuYSZfAhST/kM4KnpgfrUHGV4vAsB7+Ouh4jfVeliyoFM5Qhy/H7rOju9C5n
	 fW2tyyccaFPGkmXsN/rlupyXFxMt0EKFplWPVCQy/CmqxlalQSkr7GtccdcDSbvVNR
	 3wy2y6YX/LW2rtq8M5iliwsM/Fx8Pg4+Ge8xxfSFebR//VvU94kwwBFAKUZaoVgj79
	 MUX+xlMD1xRnCl2NeZL2/zAlrXEnZasnuLWe3loDsHzSUMGaKwJFLs9qgItr2iDKaP
	 ESqXecPm63nDg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fei Shao <fshao@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5/8] spmi: mtk-pmif: Reorder driver remove sequence
Date: Wed,  6 Dec 2023 15:17:28 -0800
Message-ID: <20231206231733.4031901-6-sboyd@kernel.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231206231733.4031901-1-sboyd@kernel.org>
References: <20231206231733.4031901-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fei Shao <fshao@chromium.org>

This driver enables clocks and then adds SPMI controller in probing, so
we expect the reversed sequence in removal.
Fix the order in the remove callback.

Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20230824104101.4083400-4-fshao@chromium.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-mtk-pmif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi-mtk-pmif.c b/drivers/spmi/spmi-mtk-pmif.c
index 6ebc6901490a..cc660da6a037 100644
--- a/drivers/spmi/spmi-mtk-pmif.c
+++ b/drivers/spmi/spmi-mtk-pmif.c
@@ -515,9 +515,9 @@ static void mtk_spmi_remove(struct platform_device *pdev)
 	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
 	struct pmif *arb = spmi_controller_get_drvdata(ctrl);
 
+	spmi_controller_remove(ctrl);
 	clk_bulk_disable_unprepare(arb->nclks, arb->clks);
 	clk_bulk_put(arb->nclks, arb->clks);
-	spmi_controller_remove(ctrl);
 }
 
 static const struct of_device_id mtk_spmi_match_table[] = {
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

