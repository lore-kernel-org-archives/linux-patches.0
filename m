Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0291F387B02;
	Tue, 16 Dec 2025 12:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888286; cv=none; b=dYHBsgZUsnM9g6ONhnNOOyta7Rvdh1MD0Zyj5gseVBkiTgIk23E58557nkV3YKM4HChQawAVjAWaaBligNZS1yrW1+QxlJh2OWQaOOE1kEt8maz3KOYaHHbhNLAQNB24XqslErRJc0YhKO3MT5SVJEeH0Q5u4nfkzCl1/q9DpkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888286; c=relaxed/simple;
	bh=FIGCN32s25vrVG5KIwkB3aevETDKh9Cf8xR0gjVK8i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8mnh1z50qvhsEG54GtR2p5wuUetWHrwhv7ap98ik0tJ+izKB8BQ8hS8maWSlf0IOd+mmNbI2+tTgAQhzBMJOczVFjVoPshg3fhZKJWzh9xkUX2/b0STnc+FuF+koiYB3raQhOUdRSCA8ePfwCoAGR1U1kGIrQbb4TCO59wze+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOuXzbS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOuXzbS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C90C4CEF1;
	Tue, 16 Dec 2025 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888285;
	bh=FIGCN32s25vrVG5KIwkB3aevETDKh9Cf8xR0gjVK8i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOuXzbS41tOU73JEu06ksV6TNU0XxwjL7nTkwzGSKW4qK/ZW8RFZheAarxY04wCN7
	 dowmN8gg9Q2u+EEex0vdNR5EXsIA0PEKk4vlMYyux7aUwHPYo5iZIGGpt/HBdsHAEY
	 WInfFk13u2iaBjH1ab7Y+VS9Ry6w3sPPrkA/WceY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 487/614] mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
Date: Tue, 16 Dec 2025 12:14:14 +0100
Message-ID: <20251216111419.015112417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index ac8c1b80d7be9..201dd62b99905 100644
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



