Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EFF274FE3;
	Thu, 15 Jan 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498995; cv=none; b=begQFM/tu4D3kcxdy85ISVpBCmrzXWqd0TCkeEObcLOnLSE5fVz2du+DbKgWEJqBiMZ0wRq39ctAONQuOj1G6yzZtZcOF++KPlOFssoAmFWxpAjE4oCLVqmZYGvKWPO6qaVhmDKOb7+h14DDMjNQGE6lHlnrLJX9ozqOa9nhNDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498995; c=relaxed/simple;
	bh=RzTjk9N36NV9HZHTFluwx9XwY/OFYHVyzNAx6zpu55c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNKPvD7nUIEZxIRpmQrv5JrEDWS9DE9aGsillW0NJyfbYowS9yeW68gNjX7nBjdmVmmGssZD4xFhkwgxRXMLIZxbbBM/0ZFM1Wd0J4WVG/UD4fK6bPVBfuw/vBGQloR21WxLZyJvdwLXYcD0i0mA/j52V9j1mJMRNUkfB+GesNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZPZZlu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZPZZlu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BB3C116D0;
	Thu, 15 Jan 2026 17:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498995;
	bh=RzTjk9N36NV9HZHTFluwx9XwY/OFYHVyzNAx6zpu55c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZPZZlu9MfR+H6NXCHTDo1SnD/5+2u9OHbQx0ZLSaD7nriGXxNAE5C1eHarezK7cv
	 LUbp2El1F2cCBx3hSfqymZbdJDkN/JPhw7TL2U+U+Lxmh3Uwqo8FqLBTYS6k/GCpTd
	 lDD/7mPXy6sK4AWd4LRoB1nPOOX5Hb602+a6UgpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/451] clk: renesas: r9a06g032: Fix memory leak in error path
Date: Thu, 15 Jan 2026 17:44:32 +0100
Message-ID: <20260115164233.469112540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b3fd97615fc4c..9807fd0adb6c3 100644
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



