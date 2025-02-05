Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3089E33993;
	Wed,  5 Feb 2025 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767696; cv=none; b=NpbXnpvrE6zyQ0HENVWhl8Z48U7p8v63uWEyAdxo/I0gxG8GjkHbj3Zx8+zgpICV2SAhqFogIDpArc2Seym2jGaM/I4+CHJKV5maQoDWFqhmkG7c3WN5dlaLXtFb9UfGN2sp/ekgwEW6b9mUvpRbtbLA/Ca5E2ibCMm+V0T9W6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767696; c=relaxed/simple;
	bh=h2+z3sBBRVmXjAUTZdZTq5+ouknO2W/JsKM3qjJsIuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPiTCkk1kkjU8HUR4YBpI+yMW0iSCkmalSDpGRXL8YXT4kbqNR+uya/+vNPpFHchpXerUCRLyYHURwmSOZRoZKgHKEBR9jMuhCCf39IKGkUrf1krEUJeN7+pfXJKw1iTxrYeje5yezuAH3n7gy29ErGwSLplDJbIbq5DkROllpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGAxkXeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGAxkXeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912FEC4CED1;
	Wed,  5 Feb 2025 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767696;
	bh=h2+z3sBBRVmXjAUTZdZTq5+ouknO2W/JsKM3qjJsIuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGAxkXeMIoyA2SLGhrIyXWD8eu3bG/GSADiWaJ4d4VbLt4cbcN9e0e8EQhl3NRFnl
	 4+suKBP8JCxIfZV9W1lvsCBvM1qf3PK4nySPHIVxUA5NEwlX5PYmYxdTDHEDHOrArT
	 VpvTTOvwyH3BOiil35+iLrZf8tQ4db6ogHpq+2fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Pedersen <lapeddk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 440/623] spi: omap2-mcspi: Correctly handle devm_clk_get_optional() errors
Date: Wed,  5 Feb 2025 14:43:02 +0100
Message-ID: <20250205134513.050588959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a07eb4f67ed085f32002a1af2b6073546d67de3f ]

devm_clk_get_optional() returns NULL for missing clocks and a PTR_ERR()
if there is a clock but we fail to get it, but currently we only handle
the latter case and do so as though the clock was missing.  If we get an
error back we should handle that as an error since the clock exists but
we failed to get it, if we get NULL then the clock doesn't exist and we
should handle that.

Fixes: 4c6ac5446d06 ("spi: omap2-mcspi: Fix the IS_ERR() bug for devm_clk_get_optional_enabled()")
Reported-by: Lars Pedersen <lapeddk@gmail.com>
Link: https://patch.msgid.link/20250117-spi-fix-omap2-optional-v1-1-e77d4ac6db6e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Lars Pedersen <lapeddk@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index add6247d34819..29c616e2c408c 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1561,10 +1561,15 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	}
 
 	mcspi->ref_clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
-	if (IS_ERR(mcspi->ref_clk))
-		mcspi->ref_clk_hz = OMAP2_MCSPI_MAX_FREQ;
-	else
+	if (IS_ERR(mcspi->ref_clk)) {
+		status = PTR_ERR(mcspi->ref_clk);
+		dev_err_probe(&pdev->dev, status, "Failed to get ref_clk");
+		goto free_ctlr;
+	}
+	if (mcspi->ref_clk)
 		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
+	else
+		mcspi->ref_clk_hz = OMAP2_MCSPI_MAX_FREQ;
 	ctlr->max_speed_hz = mcspi->ref_clk_hz;
 	ctlr->min_speed_hz = mcspi->ref_clk_hz >> 15;
 
-- 
2.39.5



