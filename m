Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D42336EDA;
	Fri,  9 Jan 2026 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961998; cv=none; b=X+VtHgDtVO9fBIdMtpCDbYpd+8BqP971k9xFXZMGlWWpJ6diPqXbtiH8tNjJUdVhISz2ygbAJAbHHaXLgwqkSxpQ7LxLgA1xMnAa2k1bQAT+4/et25zhVjnyDR95CRw8SuEHfjiiAlFJp/nsaJMwRuKbEB6v9ueJ/5ayOuBe+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961998; c=relaxed/simple;
	bh=FGiAEFmn6YLYCMEam9VtwqbXIf30N9XOI+fx1VktlLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5GWdWbjKe2BnjKzZZNw8/JE0oYmiMyvTnzIBy2PgrUDy3HLqzTzpIhggeaXWGfq9KFgv++j7SpqPWskSuDA9ipaEGvAKFGoDoDOvgUyMczN8bl3OSza3IjWD0ZLgQ+xTb+FtVj99pdDYMvhEJ3HrmLXCUv1d/DFwwQIvAFBEXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wl9YyxSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wl9YyxSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C3C4CEF1;
	Fri,  9 Jan 2026 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961998;
	bh=FGiAEFmn6YLYCMEam9VtwqbXIf30N9XOI+fx1VktlLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wl9YyxSnatcPSSzv3L+3yXT2gUbJ/MTe5ryTDro3WLwUBiJozIMYSe9V1qZO1Cv0S
	 v+umD0RoVLuoJOXKjSOuPL+G/bOAJkGVa5COW5WKpT/5MyORB/qvgtu9K2zi6Q95Di
	 3VXmvlbhRB7mSzUOoN8kfHoidJgskqZbMRMlzLXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/634] mtd: rawnand: renesas: Handle devm_pm_runtime_enable() errors
Date: Fri,  9 Jan 2026 12:37:35 +0100
Message-ID: <20260109112124.104219436@linuxfoundation.org>
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
index 3b6b0ada597ac..d57fd44e830d3 100644
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



