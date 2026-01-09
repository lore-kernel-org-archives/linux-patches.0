Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED133ADB8;
	Fri,  9 Jan 2026 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959987; cv=none; b=HzKPi5f4kRXtiUU++EfUxtyeUCo6/081sxnBfGfZaPcFbF1FYzqe3ceMXYYkDdXVGeSW9glfvTN6hdlAIpr/LDsoqz55UPwqKZXT6A8Y3XOmM8iz+QokuS0JnGHl9B3cB+2TGhQmNSuSiTLdYQY3LTLyMPlsAhtO+N9Odv4d8lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959987; c=relaxed/simple;
	bh=E/iLuCnwoj9/h5gXE02oRnfc1PZ+s7oO9bbDXqlYTn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RenW6nFtYQIJiQcPtuVLfCrms4CDI0InITBjVDYt3FVabfUSHfahJTlURkCXDv5MfgOSpyLIhfwB8jy1JsyxTyiqikspNfiD/iog9xHwFWvWc8p8IdbN5jRivj4nv9yLq4erkAC+RDurVEWxtt4KcSD8AUyNmiF+gOR294hfMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0WYpVnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0WYpVnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5581C4CEF1;
	Fri,  9 Jan 2026 11:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959987;
	bh=E/iLuCnwoj9/h5gXE02oRnfc1PZ+s7oO9bbDXqlYTn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0WYpVnY1tc8Yb1ZLfg5BAhwDs3dI2tPSBsoQDFBdpu5Y3p2CBIcvjmaBJ8xviUe/
	 5qsuZTI0yhYo7e+cUnQq8pbJe+OjNfO/ccawFumaJQDuWU7fmzNon97FIPapHlKbx/
	 bpHM5bnF4VYK7Yk2iO4/Dt9IGm91mC8js+2pk8B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/737] mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
Date: Fri,  9 Jan 2026 12:36:23 +0100
Message-ID: <20260109112143.174289748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a9e79f0acbe2a..46af7666b3c96 100644
--- a/drivers/mtd/nand/raw/renesas-nand-controller.c
+++ b/drivers/mtd/nand/raw/renesas-nand-controller.c
@@ -1342,7 +1342,10 @@ static int rnandc_probe(struct platform_device *pdev)
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



