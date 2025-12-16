Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F3033F374;
	Tue, 16 Dec 2025 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884690; cv=none; b=IuPbcTuEhLkxOfqKsXsMLBCUYufWG/L2YeiH2lqVxEUv5v2aTecQIR4Hvk6RXYm48Y0mZhwTrZn9S6+g3bD3r2CxKGPOnnTWqXnSFDZjEBxdT50S8hVASG0gMA77l6gDjCPYtU5yG/fHCK5LY3sQ5t5jpBBjX67aPqQhuIajHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884690; c=relaxed/simple;
	bh=T7vjcAX/D0BRFVfu0QpJhIywVsnbr1yczI9GmNZM+cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaMEgymfMwcVz5FDEWHE9GwAEEzLH4d8mkbQrc2/wwlSA6F5hm2BJr7lk9hFYPcXxx+fgn4J15G/jH1xnXGZ/Y5xdCx4r5HTh8aVCq2ZCinVowGuSxysrcQYPH2zmRD+Km5j8odrc/C2ioO/rfmNpDyCd6O3vPTfWAZVta6XGS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YizocMin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YizocMin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BADBC4CEF1;
	Tue, 16 Dec 2025 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884689;
	bh=T7vjcAX/D0BRFVfu0QpJhIywVsnbr1yczI9GmNZM+cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YizocMinJo2XiShVNa2WGkskHjBBxL9W6+qGPc46G+lgXJ3LHlccMt0lSbC24u8Pa
	 4JlCTHICz+iFh6uwm0lmMAffEWPJSZ6brOllG5qfjO7YXKAe80fGO502MspGXLqlyd
	 +vVq0DJnbyETfChjSuqoFAYQsxp4lJ2PuX1pLlys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/354] mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
Date: Tue, 16 Dec 2025 12:13:56 +0100
Message-ID: <20251216111330.662189396@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit a3623e1ae1ed6be4d49b2ccb9996a9d2b65c1828 ]

devm_pm_runtime_enable() can fail due to memory allocation failures.
The current code ignores its return value and proceeds with
pm_runtime_resume_and_get(), which may operate on incorrectly
initialized runtime PM state.

Check the return value of devm_pm_runtime_enable() and return the
error code if it fails.

Fixes: 6a2277a0ebe7 ("mtd: rawnand: renesas: Use runtime PM instead of the raw clock API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/renesas-nand-controller.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/renesas-nand-controller.c b/drivers/mtd/nand/raw/renesas-nand-controller.c
index ed45d0add3e96..efb19cc298ade 100644
--- a/drivers/mtd/nand/raw/renesas-nand-controller.c
+++ b/drivers/mtd/nand/raw/renesas-nand-controller.c
@@ -1336,7 +1336,10 @@ static int rnandc_probe(struct platform_device *pdev)
 	if (IS_ERR(rnandc->regs))
 		return PTR_ERR(rnandc->regs);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
+
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.51.0



