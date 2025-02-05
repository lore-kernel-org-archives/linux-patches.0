Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4A8522A;
	Wed,  5 Feb 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765791; cv=none; b=OUMVFy0zsn8m+XiDMwRajoSmF9b01NXRyhkuzwZqTB0zDURYLgrZdF9TGUxmz2OxLqUPl5de9tZCm7oMEKUNhnJTjzcRYqU7QE2PcB2LdPvEQmd0HMR0Z9mkb5UOStR1kq26xpskP8shN509rNjTBp45SqeNDy8lwFT60Xv10W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765791; c=relaxed/simple;
	bh=rP1rvS7bPHdoa9xzMpcRUxsAdIQXexUZPgTWTv0HqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJUgT84uBPiVZe9tOdZyFPS8JkMUkvrY9eA59fgFBWz1Veal2zd33/jevPildSHANuRiDbMROeEVXp7vEn9gvxQJ8JWhZY1tLyTOcsOIWoh3QEAcGC7v98Sa2Eoxt7o6h6ire09uaBvJEPAWJnzKU60prOZbCgDaEzqIqRyxuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ikxhr8vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ikxhr8vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC66C4CED1;
	Wed,  5 Feb 2025 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765790;
	bh=rP1rvS7bPHdoa9xzMpcRUxsAdIQXexUZPgTWTv0HqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ikxhr8vs59RrqdPOhbUYprms7QUVVaQZtrbab6BQjlb3k+YOsan+ty4rPzot2HhQH
	 QSL7Ni5Qmz2BzG6dTFvZu7nXBnVKFvLulaFPrt27J828ERV8w0hLYfDry5z9XkQcp1
	 KNJDkicRoDcfyQbtHU54DQC1L4zFgy8Y6BVV9mOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Pedersen <lapeddk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/393] spi: omap2-mcspi: Correctly handle devm_clk_get_optional() errors
Date: Wed,  5 Feb 2025 14:43:19 +0100
Message-ID: <20250205134431.021584377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cfd262c1abc2..35ca8fda45aae 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1521,10 +1521,15 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
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



