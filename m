Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D3349CF0;
	Tue, 16 Jun 2026 19:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636706; cv=none; b=J2KDEXINkVIsGOdeqYpmEIUPiAJjqDGC0cOt5zZV5pihcpDWJH9hjLYv40wA0S95ZuGWH1ONPmCyg0ONrSly58mTAF6vwc841nrZLXG9zmivc5HHlgYA71OnF8SHFMY3S33reR9B+6bx04VF8KQ+gxcofWj+4PLCl+8QphKI+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636706; c=relaxed/simple;
	bh=S/JQyNfHUuZluEvDzymWATH/o3QFVmQJiyJjkjt7T6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+KBWxX088TKz7/NX2Z48IUhze7aXk8bfYQwbd49MZzFgOVq959BdJwyNpYRJq+TuBnXWfQ/IGG21gJYIs0d/lNH8fyzmIaLrEAEIYIS+D4qh36lbxRsz8Nvjmcpw5lg9gH/91VCqNRZ0HRz7JX8yLOsgH2KvpCNn8smQlzfROA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuOQt/DX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuOQt/DX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F01F000E9;
	Tue, 16 Jun 2026 19:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636705;
	bh=2WVtIZbyiQzfjAhC3EPLucbfKlRah58ig8rutE1VOd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuOQt/DX1ZaH70idaJ2NlZWMUe4CZQPvaefCP5+sBt3fv48JU69Z+kQZDBOWyaLVc
	 88Hmj7Pq3xX9qOMdnzvhcMJTnKqqQJXOqfhe5V3a4cVkoNMkHsCI6c9IEdBSqxfwIe
	 Pf/4fltAgxSoNlWPo7LOXUAry0+znu0rn4w0f2Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/342] spi: sun4i: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:13 +0530
Message-ID: <20260616145100.226511318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 42108a2f03e0fdeabe9d02d085bdb058baa1189f ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b5f6517948cc ("spi: sunxi: Add Allwinner A10 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed `host`/`spi_controller` to `master`/`spi_master` and kept `int` return type with `return 0` in remove ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun4i.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -503,7 +503,7 @@ static int sun4i_spi_probe(struct platfo
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI master\n");
 		goto err_pm_disable;
@@ -521,8 +521,16 @@ err_free_master:
 
 static int sun4i_spi_remove(struct platform_device *pdev)
 {
+	struct spi_master *master = platform_get_drvdata(pdev);
+
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


