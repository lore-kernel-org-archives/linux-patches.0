Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E01728CF5E;
	Tue, 16 Dec 2025 11:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886299; cv=none; b=FJdM4nTvdqLDGe9jWXzVTJD9thuOPDsVvd03LjbVdt7NTztGMQMk3dpqO53lXPu5c4uesqXnMnaE3d+rde6p8YLl0ZfsX0AXxknONx5aRt1s7bUrbB6zfN0H0VFyD3H2dfENPUJc3gw/oJW+XoFmzPz0jhRcrYC8IRCBDPxDkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886299; c=relaxed/simple;
	bh=zsb9Rze3uScWubT7VssUk5+HRl/NgjPyMLG49KCOJAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSoomXh64JQJixFdy1V5Q/yOEQsS3dE/sKWdCoUOs0CGOJ/zLKl4izWz/QSz3UXlx7kvNejS5TLPIEjqnVj7C+gZ4tcdLiy7oU68CVvrsXfkp2+HDlbyO7ETChFpHvWBC80vKnW2b87gJeTLScdSzMv+VLZyx4upR75jXzULGcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj1K+qc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj1K+qc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF20FC4CEF1;
	Tue, 16 Dec 2025 11:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886299;
	bh=zsb9Rze3uScWubT7VssUk5+HRl/NgjPyMLG49KCOJAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj1K+qc3ZgJ+x9weTAhHGWLN8uBeKx1K6m7QyQ2K1LvYm/MBRte9kNY0yWBzc3JNT
	 uNfobOXdPYLicHkez7GL/mL5xbuMI3wObcZgj8X5UAdaWmSqq1Ah9rNxUOJdhZsxBo
	 R/nEnDHzapOVayJp40SkWksfQXeFXiL06kBD/NjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 397/507] mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
Date: Tue, 16 Dec 2025 12:13:58 +0100
Message-ID: <20251216111359.835720392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



