Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43162737EE;
	Fri,  9 Jan 2026 12:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961705; cv=none; b=YZlj5TVVgrKS24ciloZrJdoSbsNPkJ6pRl1fynpzj2ku/XJS7qYMFnz7WIg1plnw5abqAEcYwIiZRALO4iX0ZiAo6iiRE6JRYlHOzOvcqZvUh8wL3+sMCnWfoEBySANgbrqvH4gTgy4Voli1dEbyAsBbLP09tZbVwZqDVnCNDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961705; c=relaxed/simple;
	bh=yg7lUKuFgTeqqbLsJbmrdiiREmzWlXvwF/tBkhC+f/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrGfvsBs0mm5kGc58Zm5U+kbaawL9M9jfXYlfOBkwn7xcIBPzi6T0+Hx2h2IloKmsetpmH+MICaijztdgat3ic0yz4KeoKEOuB91g0vmLXuADTRm53hPIR3T2eGVfxjuLkAkvaI/Ab0OgEEOXgxrzsvqdDRM8MSdxnyBrTu97OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl1ak89o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl1ak89o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E55BC4CEF1;
	Fri,  9 Jan 2026 12:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961705;
	bh=yg7lUKuFgTeqqbLsJbmrdiiREmzWlXvwF/tBkhC+f/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dl1ak89ojUWnVgjPksFMJj8f6jkZ44E+BexcNRvMaYtPdZScaYWEkOsCwIPxKZGBE
	 djLYKKTcNeEFoGFYCax1S8c5sH2Rlv/FFTG1WunsTVG1QZsvISxQmUMVsa9evWsovG
	 oKDIX4lptLS/AtAYwA9rYlEs9+vdvISo8AsFqjiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/634] clk: renesas: r9a06g032: Fix memory leak in error path
Date: Fri,  9 Jan 2026 12:36:26 +0100
Message-ID: <20260109112121.497865870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit f8def051bbcf8677f64701e9699bf6d11e2780cd ]

The current code uses of_iomap() to map registers but never calls
iounmap() on any error path after the mapping. This causes a memory
leak when probe fails after successful ioremap, for example when
of_clk_add_provider() or r9a06g032_add_clk_domain() fails.

Replace of_iomap() with devm_of_iomap() to automatically unmap the
region on probe failure. Update the error check accordingly to use
IS_ERR() and PTR_ERR() since devm_of_iomap() returns ERR_PTR on error.

Fixes: 4c3d88526eba ("clk: renesas: Renesas R9A06G032 clock driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251030061603.1954-1-vulab@iscas.ac.cn
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a06g032-clocks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/r9a06g032-clocks.c b/drivers/clk/renesas/r9a06g032-clocks.c
index 087146f2ee068..4f9a11609a631 100644
--- a/drivers/clk/renesas/r9a06g032-clocks.c
+++ b/drivers/clk/renesas/r9a06g032-clocks.c
@@ -969,9 +969,9 @@ static int __init r9a06g032_clocks_probe(struct platform_device *pdev)
 	if (IS_ERR(mclk))
 		return PTR_ERR(mclk);
 
-	clocks->reg = of_iomap(np, 0);
-	if (WARN_ON(!clocks->reg))
-		return -ENOMEM;
+	clocks->reg = devm_of_iomap(dev, np, 0, NULL);
+	if (IS_ERR(clocks->reg))
+		return PTR_ERR(clocks->reg);
 
 	r9a06g032_init_h2mode(clocks);
 
-- 
2.51.0



