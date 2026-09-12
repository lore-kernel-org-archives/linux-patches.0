Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9490A2DC792;
	Sat, 12 Sep 2026 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211870; cv=none; b=B04hwQxJV7TSPeTEFLyB2H2MqRmlGiIKWFcmh0nWE+P9dF4xaICGfgEktFojTQUx25lfYCL2KET2J+4WIcAksTfhsI/ziajXJ/BuN7uU2nu4tVPTfoUDX3HCM0yhkeLi2z8BX1DdeXx0JZHaKBWXN8NhW6OR4ZC1amnkpMlYZLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211870; c=relaxed/simple;
	bh=1lyS96OIcHAJ56beEAWd4L1QR39E41kQ2w+2ysu6D5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhkXPDHzUx1uSSO0haBBDivt6LW/DX9CrMvCDi0H/wA4Yd+gBhhmVc+dTmSHF08hlCE7gS2feACc0EK5UfoFUsYzdcxsQY8uDeceLlIp3lOdbpTOwMplkHsQyYGmyNNpqDFJ/+yuW344IQbvpkEM0VB8o7LMPkjIiIkqyud0FO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saKe4DRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saKe4DRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986081F000FF;
	Sat, 12 Sep 2026 11:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211869;
	bh=ftVj2F76T1Rxv1gsjYhvml3JUronEAzwHYjlb0VsOGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saKe4DRn6Da2I/nF1ZQMDC1P99v3gBSkA/buvzlF1RlTY+ZODJ0tXI2Rr/Ry3WLwM
	 yLfAy6Ea2Hbq/oBrWf1X4grKDoRynyopqGfgE+r7stcaBY1punA+5CEPpbC6HjvI+A
	 l8hcDco1gKtWGN9ASFGwzWpc5w66+sd0zOPkIBMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1319/1518] spi: amlogic-spisg: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:58:08 +0200
Message-ID: <20260912065653.367092991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b2702908ee23ef31bfcf241a2e07ace0eb76bd71 ]

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

aml_spisg_clk_init() fills in init.parent_data, and assumes that
init.parent_names is NULL.  However, the latter in uninitialized, and
thus may cause a crash.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: cef9991e04aed330 ("spi: Add Amlogic SPISG driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/9fb35ae0aedb7a6db0db6c78a8193c7602dd9d44.1787165329.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index 970fddbb25857..8ddb7a1a40567 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -640,7 +640,7 @@ static int aml_spisg_target_abort(struct spi_controller *ctlr)
 static int aml_spisg_clk_init(struct spisg_device *spisg, void __iomem *base)
 {
 	struct device *dev = &spisg->pdev->dev;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_divider *div;
 	struct clk_div_table *tbl;
 	char name[32];
-- 
2.53.0



